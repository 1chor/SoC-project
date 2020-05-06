open_project soc_project.xpr
file mkdir soc_project.sdk
write_sysdef -force -hwdef soc_project.runs/impl_1/zcu102_wrapper.hwdef -bitfile soc_project.runs/impl_1/zcu102_wrapper.bit soc_project.sdk/zcu102_wrapper.hdf
close_project
