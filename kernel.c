#include <string.h>
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
	task_cnt++;

	return 0;	
}

void rtos_start(void)
{
	while(1) {
	}
}
