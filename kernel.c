#include <string.h>
#include "stm32f4xx.h"
#include "test_drivers.h"
#include "rtos.h"

rtos_tcb_t tasks[TASK_MAX_CNT];
uint8_t task_cnt = 0;

int rtos_create_task(void (*task_handler)(void), char *task_name, uint8_t priority)
{
	/* failed to create new task: task count reach maximum number */
	if(task_cnt >= 10) {
		return 1;
	}

	tasks[task_cnt].id = task_cnt;
	tasks[task_cnt].priority = priority;
	strcpy(tasks[task_cnt].task_name, task_name);

	*(tasks[task_cnt].stack) = (uint32_t)task_handler; //lr

	task_cnt++;

	return 0;	
}

void rtos_start(void)
{
	SysTick_Config(CPU_CLOCK / OS_SCHEDULER_FREQ);

	while(1) {
		char *s = "hello kernel\n\r";
		uart3_puts(s, strlen(s));
		switch_user_task(tasks[0].stack);
	}
}
