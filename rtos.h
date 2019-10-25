#ifndef __RTOS_H__
#define __RTOS_H__

#define TASK_STACK_SIZE 512
#define TASK_MAX_CNT 10

#include <stdint.h>

enum {TASK_READY = 0, TASK_RUNNING = 1} task_state;

typedef struct _rtos_tcb_t_ {
	uint8_t id;
	uint8_t status;
	uint8_t priority;
	char task_name[16];
	struct _rtos_tcb_t_ *next_task;

	uint32_t stack[TASK_STACK_SIZE];
} rtos_tcb_t;

#endif
