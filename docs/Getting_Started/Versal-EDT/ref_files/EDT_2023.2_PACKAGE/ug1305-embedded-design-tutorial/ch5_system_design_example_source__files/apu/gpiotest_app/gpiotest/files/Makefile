# Copyright (C) 2022 -2023, Advanced Micro Devices, Inc. All rights reserved.  
# SPDX-License-Identifier: MIT


APP = gpiotest

# Add any other object files to this list below
SRCS=$(wildcard *.c)
APP_OBJS = $(SRCS:.c=.o)

all: build

build: $(APP)

$(APP): $(APP_OBJS)
	$(CC) -o $@ $(APP_OBJS) $(LDFLAGS) $(LDLIBS)
clean:
	rm -f $(APP) *.o
	
	
	

