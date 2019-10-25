EXECUTABLE=lirtos.elf
BIN_IMAGE=lirtos.bin

CC=arm-none-eabi-gcc
OBJCOPY=arm-none-eabi-objcopy
GDB=arm-none-eabi-gdb

CFLAGS=-g -mlittle-endian -mthumb \
	-mcpu=cortex-m4 \
	-mfpu=fpv4-sp-d16 -mfloat-abi=hard \
	--specs=nano.specs \
	--specs=nosys.specs
CFLAGS+=-D USE_STDPERIPH_DRIVER
CFLAGS+=-D STM32F4xx
CFLAGS+=-D __FPU_PRESENT=1 \
	-D __FPU_USED=1 \
        -D ARM_MATH_CM4

CFLAGS+=-Wl,-T,stm32_flash.ld

CFLAGS+=-I./lib/CMSIS/Include
CFLAGS+=-I./lib/CMSIS/ST/STM32F4xx/Include
CFLAGS+=-I./lib/STM32F4xx_StdPeriph_Driver/inc
CFLAGS+=-I./

SRC=./stm32_init.c

SRC+=./lib/STM32F4xx_StdPeriph_Driver/src/misc.c \
	./lib/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_rcc.c \
	./lib/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_dma.c \
	./lib/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_flash.c \
	./lib/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_gpio.c \
	./lib/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_usart.c \
	./lib/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_tim.c \
	./lib/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_spi.c \
	./lib/STM32F4xx_StdPeriph_Driver/src/stm32f4xx_i2c.c

SRC+=./kernel.c \
	./context_switch.s \
	./test_drivers.c \
	./main.c

STARTUP=./startup.s
STARTUP_OBJ = startup.o
OBJS=$(SRC:.c=.o)

$(EXECUTABLE): $(STARTUP_OBJ) $(OBJS)
	@echo "LD" $@
	@$(CC) $(CFLAGS) $(OBJS) $(STARTUP_OBJ) $(LDFLAGS) -o $@

%.o: %.s
	@echo "CC" $@
	@$(CC) $(CFLAGS) $^ $(LDFLAGS) -c $<

%.o: %.c
	@echo "CC" $@
	@$(CC) $(CFLAGS) -c $< $(LDFLAGS) -o $@

clean:
	rm -rf $(EXECUTABLE)
	rm -rf $(BIN_IMAGE)
	rm -rf $(STARTUP_OBJ) $(OBJS)

flash:
	openocd -f interface/stlink-v2.cfg \
	-f target/stm32f4x_stlink.cfg \
	-c "init" \
	-c "reset init" \
	-c "halt" \
	-c "flash write_image erase $(EXECUTABLE)" \
	-c "verify_image $(EXECUTABLE)" \
	-c "reset run" -c shutdown

openocd:
	openocd -s /opt/openocd/share/openocd/scripts/ -f ./gdb/openocd.cfg

gdbauto:
	cgdb -d $(GDB) -x ./gdb/openocd_gdb.gdb

.PHONY:all clean flash
