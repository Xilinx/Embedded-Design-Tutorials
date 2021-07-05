/*# Copyright 2020 Xilinx Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.*/

#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>

int main()
{
    int valuefd, exportfd, directionfd;

    printf("GPIO test running...\n");

    exportfd = open("/sys/class/gpio/export", O_WRONLY);
    if (exportfd < 0)
    {
        printf("Cannot open GPIO to export it\n");
        exit(1);
    }

    write(exportfd, "500", 4);
    close(exportfd);

    printf("GPIO exported successfully\n");
	// Update the direction of the GPIO to be an output

    directionfd = open("/sys/class/gpio/gpio500/direction", O_RDWR);
    if (directionfd < 0)
    {
        printf("Cannot open GPIO direction it\n");
        exit(1);
    }

    write(directionfd, "in", 4);
    close(directionfd);

    printf("GPIO direction successfully\n");
   // Get the GPIO value ready to be toggled

    valuefd = open("/sys/class/gpio/gpio500/value", O_RDWR);
    if (valuefd < 0)
    {
        printf("Cannot open GPIO value\n");
        exit(1);
    }

    printf("GPIO value opened, now toggling...\n");

    // toggle the GPIO as fast a possible forever, a control c is needed
    // to stop it

    while (1)
    {
        write(valuefd,"1", 2);
        write(valuefd,"0", 2);
    }
}
