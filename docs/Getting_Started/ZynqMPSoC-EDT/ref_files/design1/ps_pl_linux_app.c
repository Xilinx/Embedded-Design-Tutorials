/*
# Copyright 2021 Xilinx Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
*/

#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <errno.h>
#include <sys/ioctl.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <pthread.h>
#include <string.h>
#include <stdlib.h>
#include <netdb.h>
#include <unistd.h>

#define GPIO_ROOT "/sys/class/gpio"
pthread_t thread;
pthread_t service_thread1,service_thread2;
int nchannel;
void *PL_switch(void);
void *PS_switch(void);
void PL_switch_LED(int);
void PS_switch_LED(int);
static int count=0;

static int get_gpio_value(int gpio_base, int nchannel)
{
	char gpio_val_file[128];
	int val_fd=0;
	int gpio_max;
	char val_str[2];
	int value = 0;
	int c;

	gpio_max = gpio_base + nchannel;

	for(c = gpio_max-1; c >= gpio_base; c--) {
		sprintf(gpio_val_file, "/sys/class/gpio/gpio%d/value",c);
		val_fd=open(gpio_val_file, O_RDWR);
		if (val_fd < 0) {
			fprintf(stderr, "Cannot open GPIO to export %d\n", c);
			return -1;
		}
		read(val_fd, val_str, sizeof(val_str));
		value=atoi(val_str);
		close(val_fd);
	}
	return value;
}

int main()
{
    printf("\nPress SW17 or SW19 on the board\r\n");
    printf("\nSW17 is PL Push Button :: SW19 is PS Push Button\r\n");

    int result = 0;

   system("echo 507 > /sys/class/gpio/export");	//SW15
   system("echo in > /sys/class/gpio/gpio507/direction");
   system("echo 508 > /sys/class/gpio/export");	//SW14
   system("echo in > /sys/class/gpio/gpio508/direction");
   system("echo 509 > /sys/class/gpio/export");	//SW16
   system("echo in > /sys/class/gpio/gpio509/direction");
   system("echo 510 > /sys/class/gpio/export");	//SW17
   system("echo in > /sys/class/gpio/gpio510/direction");
   system("echo 511 > /sys/class/gpio/export");	//SW18
   system("echo in > /sys/class/gpio/gpio511/direction");
   system("echo 347 > /sys/class/gpio/export");	//SW19 - PS switch
   system("echo in > /sys/class/gpio/gpio347/direction");

   system("echo 499 > /sys/class/gpio/export");	//LED0
   system("echo out > /sys/class/gpio/gpio499/direction");
   system("echo 500 > /sys/class/gpio/export");	//LED1
   system("echo out > /sys/class/gpio/gpio500/direction");
   system("echo 501 > /sys/class/gpio/export");	//LED2
   system("echo out > /sys/class/gpio/gpio501/direction");
   system("echo 502 > /sys/class/gpio/export");	//LED3
   system("echo out > /sys/class/gpio/gpio502/direction");
   system("echo 503 > /sys/class/gpio/export");	//LED4
   system("echo out > /sys/class/gpio/gpio503/direction");
   system("echo 504 > /sys/class/gpio/export");	//LED5
   system("echo out > /sys/class/gpio/gpio504/direction");
   system("echo 505 > /sys/class/gpio/export");	//LED6
   system("echo out > /sys/class/gpio/gpio505/direction");
   system("echo 506 > /sys/class/gpio/export");	//LED7
   system("echo out > /sys/class/gpio/gpio506/direction");

   system("echo 0 > /sys/class/gpio/gpio499/value");
   system("echo 0 > /sys/class/gpio/gpio500/value");
   system("echo 0 > /sys/class/gpio/gpio501/value");
   system("echo 0 > /sys/class/gpio/gpio502/value");
   system("echo 0 > /sys/class/gpio/gpio503/value");
   system("echo 0 > /sys/class/gpio/gpio504/value");
   system("echo 0 > /sys/class/gpio/gpio505/value");
   system("echo 0 > /sys/class/gpio/gpio506/value");

   result = pthread_create(&service_thread1, NULL, PL_switch, NULL);
   if(result != 0)
   {
	   fprintf(stderr, "Could not create thread!\n");
	   exit(1);
   }
   result = pthread_create(&service_thread2, NULL, PS_switch, NULL);
   if(result != 0)
   {
	   fprintf(stderr, "Could not create thread!\n");
	   exit(1);
   }
   /*----------------------------------*/
   /*  wait till the threads are done  */
   /*----------------------------------*/

   pthread_join(service_thread1, NULL);
   pthread_join(service_thread2, NULL);

    return 0;
}

void *PL_switch(void)
{
	int gpio_value;
	int pre_value=0;

	while(1)
	{
		gpio_value=get_gpio_value(510, 1);
		if((pre_value!=gpio_value))
		{
			pre_value=gpio_value;
			PL_switch_LED(gpio_value);
		}
	}//while
}

void *PS_switch(void)
{
	int gpio_value;
	int pre_value=0;
	while(1)
	{
		gpio_value=get_gpio_value(347,1);
		if(pre_value!=gpio_value)
		{
			pre_value=gpio_value;
			PS_switch_LED(gpio_value);
		}
	}//while
}

void PL_switch_LED(gpio_value)
{
	if(gpio_value==1)
	{
		printf("\n----PL Button pressed, observe PL LED [0:3]----\n\r");
		if(count==0)
		{
			system("echo 1 > /sys/class/gpio/gpio499/value");
			system("echo 0 > /sys/class/gpio/gpio500/value");
			system("echo 0 > /sys/class/gpio/gpio501/value");
			system("echo 0 > /sys/class/gpio/gpio502/value");
		}
		else if(count==1)
		{
			system("echo 1 > /sys/class/gpio/gpio500/value");
			system("echo 0 > /sys/class/gpio/gpio499/value");
			system("echo 0 > /sys/class/gpio/gpio501/value");
			system("echo 0 > /sys/class/gpio/gpio502/value");
		}
		else if(count==2)
		{
			system("echo 1 > /sys/class/gpio/gpio501/value");
			system("echo 0 > /sys/class/gpio/gpio499/value");
			system("echo 0 > /sys/class/gpio/gpio500/value");
			system("echo 0 > /sys/class/gpio/gpio502/value");
		}
		else if(count==3)
		{
			system("echo 1 > /sys/class/gpio/gpio502/value");
			system("echo 0 > /sys/class/gpio/gpio499/value");
			system("echo 0 > /sys/class/gpio/gpio500/value");
			system("echo 0 > /sys/class/gpio/gpio501/value");
		}
		count++;
		if(count==4)
			count=0;
	}
}

void PS_switch_LED(gpio_value)
{
	if(gpio_value==1)
	{
		printf("\nPS Button pressed, observe PL LED [4:7]\n\r");
		if(count==0)
		{
			system("echo 1 > /sys/class/gpio/gpio503/value");
			system("echo 0 > /sys/class/gpio/gpio504/value");
			system("echo 0 > /sys/class/gpio/gpio505/value");
			system("echo 0 > /sys/class/gpio/gpio506/value");
		}
		else if(count==1)
		{
			system("echo 1 > /sys/class/gpio/gpio504/value");
			system("echo 0 > /sys/class/gpio/gpio503/value");
			system("echo 0 > /sys/class/gpio/gpio505/value");
			system("echo 0 > /sys/class/gpio/gpio506/value");
		}
		else if(count==2)
		{
			system("echo 1 > /sys/class/gpio/gpio505/value");
			system("echo 0 > /sys/class/gpio/gpio503/value");
			system("echo 0 > /sys/class/gpio/gpio504/value");
			system("echo 0 > /sys/class/gpio/gpio506/value");
		}
		else if(count==3)
		{
			system("echo 1 > /sys/class/gpio/gpio506/value");
			system("echo 0 > /sys/class/gpio/gpio503/value");
			system("echo 0 > /sys/class/gpio/gpio504/value");
			system("echo 0 > /sys/class/gpio/gpio505/value");
		}
		count++;
		if(count==4)
			count=0;
	}

}
