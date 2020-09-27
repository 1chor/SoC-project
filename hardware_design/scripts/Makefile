VIVADO ?= vivado
VIVADOFLAGS ?= -nojournal -nolog -mode batch -notrace
XSDK ?= xsdk
XSDKFLAGS ?= -batch
XSCT ?= xsct

open:
	$(VIVADO) $(VIVADOFLAGS) -source scripts/open_project.tcl
	
create:
	$(VIVADO) $(VIVADOFLAGS) -source scripts/create_hw_project.tcl

bit:
	$(VIVADO) $(VIVADOFLAGS) -source scripts/generate_project.tcl

export:
	$(VIVADO) $(VIVADOFLAGS) -source scripts/export_hw.tcl
	
fsbl:
	$(XSDK) $(XSDKFLAGS) -source scripts/create_fsbl_project.tcl

pmufw:
	$(XSDK) $(XSDKFLAGS) -source scripts/create_pmufw_project.tcl
	
dts:
	$(RM) -r ./soc_project.sdk/device-tree
	$(XSCT) -eval "source ./scripts/create_devicetree_project.tcl; build_dts"	
include_dtsi:
	$(XSCT) -eval "source ./scripts/create_devicetree_project.tcl; include_dtsi $(DTSI_FILE)"
	
compile:
	$(RM) -r ./soc_project.sdk/device-tree/system-top.dtb
	gcc -I ./soc_project.sdk/device-tree -E -nostdinc -undef -D__DTS__ -x assembler-with-cpp -o ./soc_project.sdk/device-tree/system-top.dts.tmp ./soc_project.sdk/device-tree/system-top.dts
	./../mpsoc-linux-xlnx/scripts/dtc/dtc -I dts -O dtb -o ./soc_project.sdk/device-tree/system-top.dtb ./soc_project.sdk/device-tree/system-top.dts.tmp
	
clean:
	$(RM) -r ./soc_project.*
	$(RM) -r ./.Xil
	
