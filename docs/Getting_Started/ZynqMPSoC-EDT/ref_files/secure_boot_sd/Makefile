# Copyright (C) 2025, Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: MIT
#*****************************************************************************************


.PHONY: all clean rsa_keygen aes_keygen image_files

IMAGE_FILES = keys/pmufw.elf keys/edt_zcu102_wrapper.bit keys/bl31.elf keys/tmr_psled_r5.elf keys/image.ub keys/fsbl_a53.elf keys/u-boot.elf
RSA_KEY_FILES_PEM = keys/psk0.pem  keys/ssk0.pem 
RSA_KEY_FILES_SHA3 = keys/ppk0_digest.txt
RSA1_KEY_FILES_PEM = keys/psk1.pem  keys/ssk1.pem 
RSA1_KEY_FILES_SHA3 = keys/ppk1_digest.txt
AES_KEY_FILES = keys/edt_zcu102_wrapper.nky keys/fsbl_a53.nky keys/pmufw.nky keys/pmufw.1.nky keys/pmufw.2.nky keys/tmr_psled_r5.nky keys/tmr_psled_r5.1.nky

define RSA_KEYGEN_PEM_BODY
the_ROM_image:
{
[pskfile]psk0.pem [sskfile]ssk0.pem
[auth_params]spk_id = 0; ppk_select = 0 [fsbl_config]a53_x64
[bootloader]fsbl_a53.elf [destination_cpu = pmu]pmufw.elf
[destination_device = pl]edt_zcu102_wrapper.bit
[destination_cpu = a53-0, exception_level = el-3, trustzone] bl31.elf
[destination_cpu = r5-0]tmr_psled_r5.elf
[destination_cpu = a53-0, exception_level = el-2]u-boot.elf 
[load = 0x1000000, destination_cpu = a53-0]image.ub
}
endef
export RSA_KEYGEN_PEM_BODY

define RSA_KEYGEN_SHA3_BODY
the_ROM_image:
{
[pskfile]psk0.pem [sskfile]ssk0.pem
[auth_params]spk_id = 0; ppk_select = 0 [fsbl_config]a53_x64
[bootloader, authentication = rsa]fsbl_a53.elf 
[destination_cpu = pmu,authentication = rsa]pmufw.elf
[destination_device = pl, authentication = rsa]edt_zcu102_wrapper.bit
[destination_cpu = a53-0, exception_level = el-3, trustzone,authentication = rsa]bl31.elf
[destination_cpu = r5-0, authentication = rsa]tmr_psled_r5.elf
[destination_cpu = a53-0, exception_level = el-2, authentication = rsa]u-boot.elf
[load = 0x1000000, destination_cpu = a53-0, authentication = rsa]image.ub
}
endef
export RSA_KEYGEN_SHA3_BODY

define RSA1_KEYGEN_PEM_BODY
the_ROM_image:
{
[pskfile]psk1.pem 
[sskfile]ssk1.pem
[auth_params]spk_id = 1; ppk_select = 1 [fsbl_config]a53_x64
[bootloader]fsbl_a53.elf [destination_cpu = pmu]pmufw.elf
[destination_device = pl]edt_zcu102_wrapper.bit
[destination_cpu = a53-0, exception_level = el-3, trustzone]bl31.elf
[destination_cpu = r5-0]tmr_psled_r5.elf
[destination_cpu = a53-0, exception_level = el-2]u-boot.elf [load = 0x1000000, destination_cpu = a53-0]image.ub
}
endef
export RSA1_KEYGEN_PEM_BODY

define RSA1_KEYGEN_SHA3_BODY
the_ROM_image:
{
[pskfile]psk1.pem 
[sskfile]ssk1.pem
[auth_params]spk_id = 1; ppk_select = 1 
[fsbl_config]a53_x64
[bootloader, authentication = rsa]fsbl_a53.elf
[destination_cpu = pmu, authentication = rsa]pmufw.elf
[destination_device = pl, authentication = rsa]edt_zcu102_wrapper.bit
[destination_cpu = a53-0, exception_level = el-3, trustzone, authentication = rsa]bl31.elf
[destination_cpu = r5-0, authentication = rsa]tmr_psled_r5.elf
[destination_cpu = a53-0, exception_level = el-2, authentication = rsa]u-boot.elf 
[load = 0x1000000, destination_cpu = a53-0, authentication = rsa]image.ub
}
endef
export RSA1_KEYGEN_SHA3_BODY

define AES_KEYGEN_BODY
the_ROM_image:
{
[pskfile]psk0.pem
[sskfile]ssk0.pem
[auth_params]spk_id = 0; ppk_select = 0
[keysrc_encryption]bbram_red_key
[fsbl_config]a53_x64, bh_auth_enable, opt_key
[bootloader, authentication = rsa, encryption = aes, aeskeyfile = fsbl_a53.nky, blocks = 1728(*)]fsbl_a53.elf
[destination_cpu = pmu, authentication = rsa, encryption = aes,aeskeyfile = pmufw.nky, blocks = 1728(*)]pmufw.elf
[destination_device = pl, authentication = rsa, encryption = aes,aeskeyfile = edt_zcu102_wrapper.nky, blocks = 1728(*)]edt_zcu102_wrapper.bit
[destination_cpu = a53-0, exception_level = el-3, trustzone, authentication = rsa]bl31.elf
[destination_cpu = r5-0, authentication = rsa, encryption = aes, aeskeyfile = tmr_psled_r5.nky, blocks = 1728(*)]tmr_psled_r5.elf
[destination_cpu = a53-0, exception_level = el-2, authentication = rsa]u-boot.elf
[load = 0x1000000, destination_cpu = a53-0, authentication = rsa]image.ub
}
endef
export AES_KEYGEN_BODY

all: rsa_keygen aes_keygen

rsa_keygen:$(RSA_KEY_FILES_PEM) $(RSA_KEY_FILES_SHA3) $(RSA1_KEY_FILES_PEM) $(RSA1_KEY_FILES_SHA3)
aes_keygen: $(AES_KEY_FILES)

image_files: $(IMAGE_FILES)

$(IMAGE_FILES): 
	mkdir -p keys && \
	cp ../design1/build/vivado/myproj/project_1.runs/impl_1/edt_zcu102_wrapper.bit keys/ && \
	cp ../design1/build/xilinx-zcu102/images/linux/pmufw.elf keys/ && \
	cp ../design1/build/xilinx-zcu102/images/linux/bl31.elf keys/ && \
	cp ../design1/build/xilinx-zcu102/images/linux/image.ub keys/ && \
	cp ../design1/build/xilinx-zcu102/images/linux/u-boot.elf keys/ && \
	cp ../design1/build/xilinx-zcu102/images/linux/zynqmp_fsbl.elf keys/fsbl_a53.elf && \
	cp ../design1/build/ws/tmr_psled_r5/Debug/tmr_psled_r5.elf keys/ 
	echo "These files are copied to ./keys directory"
	ls -l keys
	

$(RSA_KEY_FILES_PEM): $(IMAGE_FILES)
	mkdir -p keys && echo "$$RSA_KEYGEN_PEM_BODY" > ./keys/key_generation.bif
	cd keys && \
	bootgen -p zu9eg -arch zynqmp -generate_keys auth pem -image key_generation.bif
	ls -l $(RSA_KEY_FILES_PEM)

$(RSA_KEY_FILES_SHA3): $(IMAGE_FILES) $(RSA_KEY_FILES_PEM)
	mkdir -p keys && echo "$$RSA_KEYGEN_SHA3_BODY" > ./keys/key_generation.bif
	cd keys && \
	bootgen -p zcu9eg -arch zynqmp -efuseppkbits ppk0_digest.txt -image key_generation.bif
	ls -l $(RSA_KEY_FILES_SHA3)

$(RSA1_KEY_FILES_PEM): $(IMAGE_FILES)
	mkdir -p keys && echo "$$RSA1_KEYGEN_PEM_BODY" > ./keys/key_generation_1.bif
	cd keys && \
	bootgen -p zu9eg -arch zynqmp -generate_keys auth pem -image key_generation_1.bif
	ls -l $(RSA1_KEY_FILES_PEM)

$(RSA1_KEY_FILES_SHA3): $(IMAGE_FILES) $(RSA1_KEY_FILES_PEM)
	mkdir -p keys && echo "$$RSA1_KEYGEN_SHA3_BODY" > ./keys/key_generation_1.bif
	cd keys && \
	bootgen -p zcu9eg -arch zynqmp -efuseppkbits ppk1_digest.txt -image key_generation_1.bif
	ls -l $(RSA1_KEY_FILES_SHA3)

$(AES_KEY_FILES): $(IMAGE_FILES)
	mkdir -p keys && echo "$$AES_KEYGEN_BODY" > ./keys/key_generation.bif
	cd keys && \
	bootgen -p zcu9eg -arch zynqmp -image key_generation.bif
	ls -l $(AES_KEY_FILES)

clean:
	rm -rf keys