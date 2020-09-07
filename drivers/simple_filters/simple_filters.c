#include <linux/kernel.h>
#include <linux/module.h>
#include <asm/segment.h>
#include <asm/uaccess.h> /* Needed for copy_from_user */
#include <asm/io.h> /* Needed for IO Read/Write Functions */
#include <linux/proc_fs.h> /* Needed for Proc File System Functions */
#include <linux/seq_file.h> /* Needed for Sequence File Operations */
#include <linux/platform_device.h> /* Needed for Platform Driver Functions */
#include <linux/delay.h>	/* Needed for udelay function */
#include <linux/fs.h>
#include <linux/proc_fs.h> /* Needed for Proc File System Functions */
#include <linux/buffer_head.h>
#include <linux/signal.h>
#include <linux/slab.h> /* Needed for kmalloc and kfree */

/* Define Driver Name */
#define DRIVER_NAME "simple_filters"

/* reason for minimizing the maximum array size is that ist is not allowed to transfer more than than 1 KByte via write/read from device driver*/
//#define IMAGE_SIZE_MAX 3750	/* Maximum Imgae resolution is 75 * 50 */
#define IMAGE_SIZE_MAX 50000

//unsigned long *base_addr;	/* Vitual Base Address */
unsigned long *image_addr_write;	
unsigned long *image_addr_read;
struct resource *res;		/* Device Resource Structure */
unsigned long remap_size;	/* Device Memory Size */

static u32 size_image;
static u32 image_data_write[IMAGE_SIZE_MAX];
static u32 image_data_read[IMAGE_SIZE_MAX];

static u8 input[4 * IMAGE_SIZE_MAX];
static u8 output[4 * IMAGE_SIZE_MAX];

static struct file *filp = NULL;
//static uint32_t filesize = 0;
//static uint32_t bytes_sent = 0;

/* Write operation for /proc/simple_filters
* -----------------------------------
* When user cat a string to /proc/simple_filters file, the string will be stored in
* const char __user *buf. This function will copy the string from user
* space into kernel space, and change it to an unsigned long value.
* It will then write the value to the register of myled controller,
* and turn on the corresponding LEDs eventually.
*/
static ssize_t proc_simple_filters_write(struct file *file, const char __user * buf, size_t count, loff_t * ppos)
{	
	char filename[64];
	mm_segment_t oldfs;
	int ret;
	u32 i;

	if(filp > 0 && !IS_ERR(filp))
	{
		printk("Simple Filters Module busy");
		return -EFAULT;
	}

	if (count < 64) {
		/*
		Copy data from user space to kernel space.
		Returns number of bytes that could not be copied. On success, this will be zero.
		*
		unsigned long copy_from_user(void *to,const void __user *from,unsigned long n);
		to	Destination address, in kernel space. 
		from	Source address, in user space. 
		n	Number of bytes to copy. 
		*/
		if (copy_from_user(filename, buf, count))
			return -EFAULT;
		filename[count-1] = '\0';
	}

	oldfs = get_fs();
	set_fs(get_ds());
	filp = filp_open(filename, O_RDWR, 0);

	if(IS_ERR(filp))
	{
		printk("File \"%s\" is invalid\n", filename);
		return -EFAULT;
	}

	set_fs(oldfs);

	size_image = vfs_llseek(filp, 0, SEEK_END);
	vfs_llseek(filp, 0, 0);
	printk("Image of File %s is %u (0x%x) bytes long\n", filename, size_image, size_image);
	
	set_fs(oldfs);

	if ((size_image/4) > IMAGE_SIZE_MAX)
	{
		printk("Size of the Image (%u bytes) is bigger than actual configured size (%u bytes) in device driver!\n", size_image, (IMAGE_SIZE_MAX*4));
	}

	//read from file
	oldfs = get_fs();
	set_fs(get_ds());
	ret = kernel_read(filp, &input, size_image, &filp->f_pos);
	set_fs(oldfs);

	if(size_image != ret)
	{
		printk("Could only read %u bytes, need %u\n",ret,size_image);
	}

	for (i = 0; i < (size_image/4); i++)
	{
		image_data_write[i] = (((u32)input[4*i]) << 24u) | (((u32)input[(4*i) + 1u]) << 16u) | (((u32)input[(4*i) + 2u]) << 8u) | (((u32)input[(4*i) + 3u])); 
	}

	for (i = 0; i < (size_image/4); i++)
	{
		wmb();
		iowrite32(image_data_write[i], image_addr_write);
		//udelay(10);
		wmb();
		image_data_read[i] = ioread32(image_addr_read);
		//udelay(10);
	}

	for (i = 0; i < (size_image/4); i++)
	{
		output[4*i] = (u8)(image_data_read[i] >> 24u);
		output[(4*i) + 1u] = (u8)(image_data_read[i] >> 16u);
		output[(4*i) + 2u] = (u8)(image_data_read[i] >> 8u);
		output[(4*i) + 3u] = (u8)(image_data_read[i]);
	}
	
	//got to begin of file
	vfs_llseek(filp, 0, 0);

	//wrtie to file
	oldfs = get_fs();
    set_fs(get_ds());
	ret = kernel_write(filp, &output, size_image, &filp->f_pos);
	set_fs(oldfs);

	//close file
	if(filp > 0)
		filp_close(filp, 0);
	filp = NULL;
	

	// old implementation:
	/*u32 i;

	size_image = count - 1;
	if (count <  (IMAGE_SIZE_MAX * 4))
	{
		
		//if (copy_from_user(image_data_write, buf, count))
		if (copy_from_user(input, buf, count))	 
			return -EFAULT;
	}
	
	for (i = 0; i < (count/4); i++)
	{
		image_data_write[i] = (((u32)input[4*i]) << 24u) | (((u32)input[(4*i) + 1u]) << 16u) | (((u32)input[(4*i) + 2u]) << 8u) | (((u32)input[(4*i) + 3u])); 
	}
	
	for (i = 0; i < (count/4); i++)
	{
		wmb();
		iowrite32(image_data_write[i], image_addr_write);
		//udelay(10);
		wmb();
		image_data_read[i] = ioread32(image_addr_read);
		//udelay(10);
	}

	for (i = 0; i < (count/4); i++)
	{
		output[4*i] = (u8)(image_data_read[i] >> 24u);
		output[(4*i) + 1u] = (u8)(image_data_read[i] >> 16u);
		output[(4*i) + 2u] = (u8)(image_data_read[i] >> 8u);
		output[(4*i) + 31] = (u8)(image_data_read[i]);
	}*/
	
	return count;	
}

/* Callback function when opening file /proc/simple_filters
* ------------------------------------------------------
* Read the register value of simple_filters controller, print the value to
* the sequence file struct seq_file *p. In file open operation for /proc/simple_filters
* this callback function will be called first to fill up the seq_file,
* and seq_read function will print whatever in seq_file to the terminal.
*/
static int proc_simple_filters_show(struct seq_file *p, void *v)
{
	u32 i;

	/*for (i = 0; i < (size_image/4); i++)
	{
		//seq_printf(p, "%x", i);
		seq_printf(p, "x%x", image_data_write[i]);
		seq_printf(p, "x%x", image_data_read[i]);
	}
	
	seq_printf(p, "i");
	for (i = 0; i < size_image; i++)
	{
		seq_printf(p, "%x", input[i]);
	}	

	seq_printf(p, "o");*/

	//seq_printf(p, "%xIIIIIIII", size_image);
	

	// old implementation:
	/*for (i = 0; i < size_image; i++)
	{
		seq_printf(p, "%x", output[i]);
	}*/

	for (i = 0; i < (size_image/4); i++)
	{
		seq_printf(p, "%x", image_data_read[i]);
	}	

	return 0;
}

/* Open function for /proc/simple_filters
* ------------------------------------
* When user want to read /proc/simple_filters (i.e. cat /proc/simple_filters), the open function
* will be called first. In the open function, a seq_file will be prepared and the
* status of simple_filters will be filled into the seq_file by simple_filters function.
*/
static int proc_simple_filters_open(struct inode *inode, struct file *file)
{
	unsigned int size = 16;
	char *buf;
	struct seq_file *m;
	int res;
	buf = (char *)kmalloc(size * sizeof(char), GFP_KERNEL);
	if (!buf)
		return -ENOMEM;
	res = single_open(file, proc_simple_filters_show, NULL);
	if (!res) {
		m = file->private_data;
		m->buf = buf;
		m->size = size;
	} else {
		kfree(buf);
	}
	return res;
}

/* File Operations for /proc/simple_filters */
static const struct file_operations proc_simple_filters_operations = {
	.open = proc_simple_filters_open,
	.read = seq_read,
	.write = proc_simple_filters_write,
	.llseek = seq_lseek,
	.release = single_release
};

/* -----------------------------------
* simple_filters shutdown
*/
static void simple_filters_shutdown(struct platform_device *pdev)
{
	if(filp > 0)
		filp_close(filp, 0);
	printk("Exit simple_filters Module. \n");	// print unload message
}

/* Remove function for simple_filters
* ----------------------------------
* When simple_filters module is removed, release virtual address and the memory
* region requested.
*/
static int simple_filters_remove(struct platform_device *pdev)
{
	simple_filters_shutdown(pdev);
	/* Remove /proc/myled entry */
	remove_proc_entry(DRIVER_NAME, NULL);
	/* Release mapped virtual address */
	iounmap(image_addr_write);
	iounmap(image_addr_read);
	/* Release the region */
	release_mem_region(res->start, remap_size);
	return 0;
}

/* Device Probe function for simple_filters
* ------------------------------------
* Get the resource structure from the information in device tree.
* request the memory regioon needed for the controller, and map it into
* kernel virtual memory space. Create an entry under /proc file system
* and register file operations for that entry.
*/
static int simple_filters_probe(struct platform_device *pdev)
{
	struct proc_dir_entry *simple_filters_proc_entry;
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
	printk("base_addr is at %#x, device is %#x bytes long\n", (unsigned int)res->start,(unsigned int) remap_size);
	image_addr_write = ioremap_nocache(res->start, 0x4);
	image_addr_read = ioremap_nocache(res->start+0x4, 0x4);
	if ((image_addr_write == NULL) || (image_addr_read == NULL)) {
		dev_err(&pdev->dev, "Couldn't ioremap memory at 0x%08lx\n",
		(unsigned long)res->start);
		ret = -ENOMEM;
		goto err_release_region;
	}
	simple_filters_proc_entry = proc_create(DRIVER_NAME, 0, NULL,
	&proc_simple_filters_operations);
	if (simple_filters_proc_entry == NULL) {
		dev_err(&pdev->dev, "Couldn't create proc entry\n");
		ret = -ENOMEM;
		goto err_create_proc_entry;
	}
	printk(KERN_INFO DRIVER_NAME " probed at VA 0x%08lx\n",(unsigned long) image_addr_write);
	return 0;
	err_create_proc_entry:
iounmap(image_addr_write);
iounmap(image_addr_read);
	err_release_region:
release_mem_region(res->start, remap_size);
	return ret;
}

/* device match table to match with device node in device tree */
static const struct of_device_id simple_filters_of_match[] = {
	{.compatible = "xlnx,simple-filter-1.0"},
	{},
};

MODULE_DEVICE_TABLE(of, simple_filters_of_match);

/* platform driver structure for simple_filters driver */
static struct platform_driver simple_filters_driver = {
	.driver = {
		.name = DRIVER_NAME,
		.owner = THIS_MODULE,
		.of_match_table = simple_filters_of_match},
		.probe = simple_filters_probe,
		.remove = simple_filters_remove,
		.shutdown = simple_filters_shutdown
};

/* Register myled platform driver */
module_platform_driver(simple_filters_driver);

/* Module Infomations */
MODULE_AUTHOR("Florian Muttenthaler");
MODULE_LICENSE("GPL");
MODULE_DESCRIPTION(DRIVER_NAME ": Image Filtering driver for blue, green, red filter purpose");
MODULE_ALIAS(DRIVER_NAME);
