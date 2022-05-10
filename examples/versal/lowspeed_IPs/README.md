# VCK190_LowSpeed IP v2022.1

  This repository contains VCK190 design files for PS and PL based LowSpeed IPs.

  There are few available designs:
  
   - **axi_can**      - AXI CAN IP design subsytem with CIPS

   - **axi_can_fd**   - AXI CAN FD design subsystem with CIPS
   
   - **axi_i2c**      - AXI IIC IP design subsytem with CIPS

   - **ps_i2c**       - PS IIC design only

   - **ps_can_fd**    - PS CAN FD design only
   
   - **axi_uartlite** - AXI UARTLite IP design subsytem with CIPS
   
   - **ps_sbsa_uart** - PS UART IP design only
    

# What to Expect

 Each design directory contains the following general structure:

       <design>
        ├── Hardware
            | └── <design>.xsa
        │   └── constraints
        │       └── <design>.xdc
        ├── README.md
        ├── Scripts
        │   ├── <design>_bd.tcl
        │   └── <design>_wrapper RTL file
        └── Software
            ├── Vitis
            └── PetaLinux
        
        
Each design's README.md will provide:

   -**Design Summary** - Brief summary of the design.

   -**Required Hardware** - Listing of required hardware

   -**Build Instructions** - Instructions on how to re-build the designs

   -**Validation** - Setup and results of validation tests run against the design

   -**Known Issues** - Current known issues with the design and/or workarounds for these issues.
   
   
# Troubleshooting / Assistance
   If you find you are having difficulty bringing up one of the designs, or need some additional assistance, please reach out on the [Xilinx Community Forums](https://forums.xilinx.com/).

   Be sure to [search](https://forums.xilinx.com/t5/forums/searchpage/tab/message?advanced=false&allow_punctuation=false&inactive=false) the forums first before posting, as someone may already have the solution!
