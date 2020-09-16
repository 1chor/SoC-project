#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/interrupt.h>
#include <linux/irq.h>
#include <asm/segment.h>
#include <asm/uaccess.h> /* Needed for copy_from_user */
#include <linux/buffer_head.h>
#include <asm/io.h> /* Needed for IO Read/Write Functions */
#include <linux/fs.h>
#include <linux/proc_fs.h> /* Needed for Proc File System Functions */
#include <linux/seq_file.h> /* Needed for Sequence File Operations */
#include <linux/platform_device.h> /* Needed for Platform Driver Functions */
#include <linux/uaccess.h>
#include <linux/signal.h>
#include <linux/of.h>
#include <linux/of_device.h>
#include <linux/of_irq.h>
#include <linux/slab.h>

/* Define Driver Name */
#define DRIVER_NAME	"blake2b"
#define IRQ_NUM		92
#define SYSCALL_MAJOR	22

#define FLAG_SINK_READY	0x80000000
#define FLAG_HASH_READY 0x40000000
#define FLAG_READY	0x20000000

//unsigned long *base_addr;	/* Vitual Base Address */
unsigned long *task_reg_addr;
unsigned long *message_reg_addr;
unsigned long *status_reg_addr;
unsigned long *hash_reg_addr;
struct resource *res;		/* Device Resource Structure */
unsigned long remap_size;	/* Device Memory Size */

static struct file *filp = NULL;
static uint32_t filesize = 0;
static uint32_t bytes_sent = 0;

static uint32_t hash[16];
static int irq;

static irqreturn_t irq_handler(int irq, void* dev_id)
{
	uint32_t status;
	uint32_t size;
	//printk("Interrupt!\n");
	wmb();
	status = ioread32(status_reg_addr);

	if(status & FLAG_SINK_READY)
	{
		uint32_t data;
		mm_segment_t oldfs;
		int ret;

		//printk("WAITING FOR DATA (0x%x)\n", status);
		//printk("Sent %u, size is %u\n", bytes_sent, filesize);
		size = 4;
		if(bytes_sent + 4 > filesize)
		{
			size = filesize - bytes_sent;
		}
		//printk("Reading %u bytes\n", size);

		//read from file
		oldfs = get_fs();
		set_fs(get_ds());
		ret = kernel_read(filp, &data, size, &filp->f_pos);
		set_fs(oldfs);

		if(size != ret)
		{
			printk("Could only read %u bytes, need %u\n",ret,size);
		}

		iowrite32(data, message_reg_addr);

		bytes_sent += size;
	} else if (status & FLAG_HASH_READY)
	{
		int i;
		printk("HASH READY        (x%x)\n", status);
		filp_close(filp, 0);
		filp = NULL;
		for(i = 15; i >= 0; i--)
		{
			wmb();
			iowrite32(i,hash_reg_addr);
			wmb();
			hash[i] = ioread32(hash_reg_addr);
			printk("%08x", hash[i]);
		}
		printk("\n");
	} else {
		printk("STATUS           (0x%x)\n", status);
	}

	return IRQ_HANDLED;
}

/* Write operation for /proc/blake2b
* -----------------------------------
* When user cat a string to /proc/blake2b file, the string will be stored in
* const char __user *buf. The File in that path will be opened and the blake2b
* hash will be generated in the logic fabric.
*/
static ssize_t proc_blake2b_write(struct file *file, const char __user * buf, size_t count, loff_t * ppos)
{
	char filename[64];
	mm_segment_t oldfs;

	if(filp > 0 && !IS_ERR(filp))
	{
		printk("Blake2B Module busy");
		return -EFAULT;
	}

	if (count < 64) {
		if (copy_from_user(filename, buf, count))
			return -EFAULT;
		filename[count-1] = '\0';
	}

	oldfs = get_fs();
	set_fs(get_ds());
	filp = filp_open(filename, O_RDONLY, 0);

	if(IS_ERR(filp))
	{
		printk("File \"%s\" is invalid\n", filename);
		return -EFAULT;
	}

	set_fs(oldfs);

	filesize = vfs_llseek(filp, 0, SEEK_END);
	vfs_llseek(filp, 0, 0);
	printk("File %s is %u (0x%x) bytes long\n", filename, filesize, filesize);

	bytes_sent = 0;
	//Write file size to task_reg to start hashing
	wmb();
	iowrite32(filesize, task_reg_addr);
	return count;
}

/* Callback function when opening file /proc/blake2b
* ------------------------------------------------------
* Return the generated hash
*/

static int proc_blake2b_show(struct seq_file *p, void *v)
{
	int i;
	for(i = 15; i >= 0; i--)
	{
		wmb();
		iowrite32(i,hash_reg_addr);
		wmb();
		hash[i] = ioread32(hash_reg_addr);
		seq_printf(p, "%08x", hash[i]);
	}
	return 0;
}

/* Open function for /proc/blake2b
* ------------------------------------
* When user want to read /proc/blake2b (i.e. cat /proc/blake2b), the open function
* will be called first. In the open function, a seq_file will be prepared and the
* status of blake2b will be filled into the seq_file by proc_blake2b_show function.
*/
static int proc_blake2b_open(struct inode *inode, struct file *file)
{
	unsigned int size = 16;
	char *buf;
	struct seq_file *m;
	int res;
	buf = (char *)kmalloc(size * sizeof(char), GFP_KERNEL);
	if (!buf)
		return -ENOMEM;
	res = single_open(file, proc_blake2b_show, NULL);
	if (!res) {
		m = file->private_data;
		m->buf = buf;
		m->size = size;
	} else {
		kfree(buf);
	}
	return res;
}

/* File Operations for /proc/blake2b */
static const struct file_operations proc_blake2b_operations = {
	.open = proc_blake2b_open,
	.read = seq_read,
	.write = proc_blake2b_write,
	.llseek = seq_lseek,
	.release = single_release
};

/* Remove function for blake2b
* ----------------------------------
* When blake2b module is removed, release virtual address and the memory
* region requested.
*/
static int blake2b_remove(struct platform_device *pdev)
{
	/* Remove /proc/blake2b entry */
	remove_proc_entry(DRIVER_NAME, NULL);
	/* Release mapped virtual address */
	iounmap(task_reg_addr);
	iounmap(message_reg_addr);
	iounmap(status_reg_addr);
	iounmap(hash_reg_addr);
	/* Release the region */
	release_mem_region(res->start, remap_size);
	return 0;
}

/* Device Probe function for blake2b
* ------------------------------------
* Get the resource structure from the information in device tree.
* request the memory regioon needed for the controller, and map it into
* kernel virtual memory space. Create an entry under /proc file system
* and register file operations for that entry.
*/
static int blake2b_probe(struct platform_device *pdev)
{
	struct proc_dir_entry *blake2b_proc_entry;
	int ret = 0;
			
	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
	if (!res) {
		dev_err(&pdev->dev, "No memory resource\n");
		return -ENODEV;
	}
	remap_size = res->end - res->start + 1;
	if (!request_mem_region(res->start, remap_size, pdev->name)) {
		dev_err(&pdev->dev, "Cannot request IO\n");
	return -ENXIO;
	}
	printk("base_addr is at %#x, device is %#x bytes long\n", (unsigned int)res->start, (unsigned int)remap_size);
	task_reg_addr = ioremap_nocache(res->start, 0x4);
	message_reg_addr = ioremap_nocache(res->start+0x4, 0x4);
	status_reg_addr = ioremap_nocache(res->start+0x8, 0x4);
	hash_reg_addr = ioremap_nocache(res->start+0xC, 0x4);
	if (task_reg_addr == NULL || message_reg_addr == NULL || status_reg_addr == NULL || hash_reg_addr == NULL) {
		dev_err(&pdev->dev, "Couldn't ioremap memory at 0x%08lx\n",
		(unsigned long)res->start);
		ret = -ENOMEM;
		goto err_release_region;
	}
	blake2b_proc_entry = proc_create(DRIVER_NAME, 0, NULL,
	&proc_blake2b_operations);
	if (blake2b_proc_entry == NULL) {
		dev_err(&pdev->dev, "Couldn't create proc entry\n");
		ret = -ENOMEM;
		goto err_create_proc_entry;
	}
	printk(KERN_INFO DRIVER_NAME " probed at VA 0x%08lx\n",(unsigned long) task_reg_addr);
	
	printk("Registering IRQ\n");
	irq = irq_of_parse_and_map(pdev->dev.of_node, 0);
	if (request_irq(irq, irq_handler, IRQF_TRIGGER_RISING, DRIVER_NAME, &pdev->dev)) {
		ret = -EBUSY;
		goto err_register_irq;
	}
	printk("Registered IRQ\n");

	return 0;

err_register_irq:
	printk(KERN_ERR "Not Registered IRQ \n");
err_create_proc_entry:
	iounmap(task_reg_addr);
	iounmap(message_reg_addr);
	iounmap(status_reg_addr);
	iounmap(hash_reg_addr);
err_release_region:
	release_mem_region(res->start, remap_size);
	return ret;
}

/* -----------------------------------
* Before blake2b shutdown, turn-off all the leds
*/
static void blake2b_shutdown(struct platform_device *pdev)
{
	if(filp > 0)
		filp_close(filp, 0);
	//iowrite32(0, base_addr);
	free_irq(of_irq_get(pdev->dev.of_node, 0), &pdev->dev);			// unregister timer interrupt
	//unregister_chrdev(SYSCALL_MAJOR, "blake2b");	// unregister device
	printk("Exit blake2b Module. \n");	// print unload message
}

/* device match table to match with device node in device tree */
static const struct of_device_id blake2b_of_match[] = {
	{.compatible = "xlnx,blake2b-1.0"},
	{},
};

MODULE_DEVICE_TABLE(of, blake2b_of_match);

/* platform driver structure for blake2b driver */
static struct platform_driver blake2b_driver = {
	.probe = blake2b_probe,
	.remove = blake2b_remove,
	.driver = {
		.name = DRIVER_NAME,
		.owner = THIS_MODULE,
		.of_match_table = blake2b_of_match},
		.shutdown = blake2b_shutdown
};

/* Register blake2b platform driver */
module_platform_driver(blake2b_driver);

/* Module Infomations */
MODULE_AUTHOR("Benedikt Tutzer");
MODULE_LICENSE("GPL");
MODULE_DESCRIPTION(DRIVER_NAME ": Blake2B driver");
MODULE_ALIAS(DRIVER_NAME);
