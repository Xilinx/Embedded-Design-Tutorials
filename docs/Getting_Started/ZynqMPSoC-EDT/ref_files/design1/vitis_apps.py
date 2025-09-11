# Copyright (C) 2025, Advanced Micro Devices, Inc. All rights reserved.
# SPDX-License-Identifier: MIT
#*****************************************************************************************

import vitis

# Define reusable paths and names
workspace_path = "build/vitis"
platform_path = "$COMPONENT_LOCATION/../platform/export/platform/platform.xpfm"
hardware_design_path = "$COMPONENT_LOCATION/../../vivado/edt_zcu102_wrapper.xsa"
standalone_src_path = "$COMPONENT_LOCATION/../../../"
linux_src_path = "$COMPONENT_LOCATION/../../.."

# Define component names for easy reference
platform_name = "platform"
standalone_app_name = "tmr_psled_r5"
linux_app_name = "ps_pl_linux_app"

# Construct paths that depend on workspace and app names
linux_user_config_path = f"{workspace_path}/{linux_app_name}/UserConfig.cmake"

## Workaround function for CR-1219500
def remove_line_from_file(file_path, line_to_remove):
    """
    Removes a specific line from a file.

    Parameters:
        file_path (str): Path to the file.
        line_to_remove (str): Text to search for in lines to remove from file.
    """
    # Read the file and filter out the line to remove
    with open(file_path, "r") as file:
        lines = file.readlines()

    # Write back only the lines that do not contain the specified line
    with open(file_path, "w") as file:
        for line in lines:
            if line_to_remove not in line:
                file.write(line)
## End of Workaround Function

# Initialize Vitis client and set the workspace path
client = vitis.create_client()
client.set_workspace(path=workspace_path)

# Create a platform component with specified hardware and OS details
platform = client.create_platform_component(
    name=platform_name,
    hw_design=hardware_design_path,
    os="standalone",
    cpu="psu_cortexr5_0",
    domain_name="standalone_r5"
)

# Set configuration for standalone domain
domain = platform.get_domain(name="standalone_r5")
domain.set_config(option="os", param="standalone_stdin", value="psu_uart_1")
domain.set_config(option="os", param="standalone_stdout", value="psu_uart_1")

# Add Linux domain to the platform
linux_domain = platform.add_domain(
    cpu="psu_cortexa53",
    os="linux",
    name="linux",
    display_name="linux"
)

# Build the platform
platform.build()

# Create and configure a standalone application component
comp = client.create_app_component(
    name=standalone_app_name,
    platform=platform_path,
    domain="standalone_r5"
)

# Import source files into the component
comp = client.get_component(name=standalone_app_name)
comp.import_files(
    from_loc=standalone_src_path,
    files=["timer_psled_r5.c"],
    dest_dir_in_cmp="src"
)

# Define memory regions for the linker script
ld_file = comp.get_ld_script()
ld_file.add_memory_region(name='psu_ddr_1', base_address='0x100000', size='0x6fefffff')
ld_file.update_memory_region(name='psu_ddr_0', base_address='0x70000000', size='0x10000000')
ld_file.get_memory_regions()

# Build the standalone application component
comp.build()

# Create and configure a Linux application component
linux_app = client.create_app_component(
    name=linux_app_name,
    platform=platform_path,
    domain="linux"
)

# Import source files into the Linux component
linux_app = client.get_component(name=linux_app_name)
linux_app.import_files(
    from_loc=linux_src_path,
    files=["ps_pl_linux_app.c"],
    dest_dir_in_cmp="src"
)

# Remove unnecessary files and apply workaround function
linux_app.remove_files(files=["src/helloworld.c"])
remove_line_from_file(linux_user_config_path, '"src/helloworld.c"')

# Build the Linux application component
linux_app.build()
