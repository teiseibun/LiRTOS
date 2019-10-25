#include <string.h>
#include "stm32f4xx.h"
#include "stm32f4xx_gpio.h"
#include "rtos.h"
#include "test_drivers.h"

void SysTick_Handler(void)
{
	GPIO_ToggleBits(GPIOD, GPIO_Pin_12);
	GPIO_ToggleBits(GPIOD, GPIO_Pin_13);	
	GPIO_ToggleBits(GPIOD, GPIO_Pin_14);
	GPIO_ToggleBits(GPIOD, GPIO_Pin_15);
}

int main(void)
{
	gpio_init();
	uart3_init();

	SysTick_Config(168000000 / 50);

	while(1);

	return 0;
}
