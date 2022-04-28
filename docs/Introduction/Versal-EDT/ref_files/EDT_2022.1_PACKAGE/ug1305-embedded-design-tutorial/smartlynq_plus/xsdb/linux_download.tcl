# Gather everything needed
if {$argc == 3} {
  set hostName   [lindex $argv 0]
  set imagesPath [lindex $argv 1]
  set commPath   [lindex $argv 2]
}

if {![info exists hostName] || ![info exists imagesPath] || ![info exists commPath]} {
     puts "WARNING: Please specify hostName, imagesPath and communication path before running."
    set thisFile [file normalize [info script]]
    puts "If running in non-interactive mode, use: xsdb $thisFile <hostName> <imagesPath> <commPath>"
    return
}

connect -host $hostName -port 3121
puts "Connected to vck190"
if {$commPath eq "FTDI-JTAG"} {
  jtag targets -set -nocase -filter {name =~ "*FT4232H*"}
  set jtag_frequency [jtag frequency 30000000]
} else {
  jtag targets -set -nocase -filter {name =~ "*Smart JTAG Cable*"}
  set jtag_frequency [jtag frequency 75000000]
}
puts "JTAG frequency = $jtag_frequency"
targets -set -nocase -filter {name =~ "*Versal*"}
puts "Programming BOOT.BIN through JTAG"
device program "$imagesPath/BOOT.BIN"
after 5000
stop

# Select communication path to download linux images
if {($commPath eq "PC4-JTAG") || ($commPath eq "FTDI-JTAG")} {
    targets -set -nocase -filter {name =~ "*APU*"}
} elseif {$commPath eq "HSDP"} {
    targets -set -nocase -filter {name =~ "*DPC*"}
} else {
    puts "ERROR: Communication path argument - $commPath is not valid."
}

# Download image files
puts "Downloading linux images"
set start_time [clock microseconds]

## For maximum performance, use mwr with exact byte size specified.
## For versatility, comment mwr command out and use 'dow' in each of these commands.

# Download Linux Image
#mwr -size b -force -bin -file "$imagesPath/Image" 0x200000 21180928
dow -data -force "$imagesPath/Image" 0x200000

after 2000

# Download RootFS
#mwr -size b -force -bin -file "$imagesPath/rootfs.cpio.gz.u-boot" 0x4000000 52811673
dow -data -force "$imagesPath/rootfs.cpio.gz.u-boot" 0x4000000 

after 2000

# Download boot.scr
#mwr -size b -force -bin -file "$imagesPath/boot.scr" 0x20000000 2594
dow -data -force "$imagesPath/boot.scr" 0x20000000

set end_time [clock microseconds]
after 2000
# Resume Versal processors
targets -set -nocase -filter {name =~ "*Versal*"}
con

# Calculate time required to download linux images
set time_delta [expr {$end_time - $start_time}]
set download_time [expr {$time_delta - 4000000}]
puts "Amount of time to download linux images - $download_time microseconds"
