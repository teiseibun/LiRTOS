#include <stm32f4xx.h>
#include <stm32f4xx_gpio.h>

void SysTick_Handler(void)
{
	GPIO_ToggleBits(GPIOD, GPIO_Pin_12);
	GPIO_ToggleBits(GPIOD, GPIO_Pin_13);	
	GPIO_ToggleBits(GPIOD, GPIO_Pin_14);
	GPIO_ToggleBits(GPIOD, GPIO_Pin_15);
}

void gpio_init(void)
{
	GPIO_InitTypeDef GPIO_InitStruct = {
		.GPIO_Pin = GPIO_Pin_12 | GPIO_Pin_13 | GPIO_Pin_14 | GPIO_Pin_15,
		.GPIO_Mode = GPIO_Mode_OUT,
		.GPIO_Speed = GPIO_Speed_50MHz,
		.GPIO_OType =GPIO_OType_PP,
		.GPIO_PuPd = GPIO_PuPd_DOWN
	};

	RCC_AHB1PeriphClockCmd(RCC_AHB1Periph_GPIOD, ENABLE);

	GPIO_Init(GPIOD, &GPIO_InitStruct);
}

int main()
{
	gpio_init();
	SysTick_Config(16800000);

	while(1);

	return 0;
}
