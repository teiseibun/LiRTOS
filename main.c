#include <string.h>
#include "stm32f4xx.h"
#include "stm32f4xx_gpio.h"
#include "rtos.h"
#include "test_drivers.h"

void SysTick_Handler(void)
{
}

void delay(uint32_t count)
{
	while(count--);
}

void led_blink_task(void)
{
	int state = 1;

	while(1) {
		GPIO_WriteBit(GPIOD, GPIO_Pin_12, state);
		delay(10000000L);
		GPIO_WriteBit(GPIOD, GPIO_Pin_13, state);
		delay(10000000L);
		GPIO_WriteBit(GPIOD, GPIO_Pin_14, state);
		delay(10000000L);
		GPIO_WriteBit(GPIOD, GPIO_Pin_15, state);
		delay(10000000L);

		state = (state + 1) % 2;
        }
}

int main(void)
{
	gpio_init();
	uart3_init();

	rtos_create_task(led_blink_task, "led task", 0);
	rtos_start();

	return 0;
}
