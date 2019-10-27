#ifndef __RTOS_H__
#define __RTOS_H__

#define CPU_CLOCK 168000000
#define OS_SCHEDULER_FREQ 1000
#define TASK_STACK_SIZE 512
#define TASK_MAX_CNT 10

#include <stdint.h>

enum {TASK_READY = 0, TASK_RUNNING = 1} task_state;

typedef struct _rtos_tcb_t_ {
	uint32_t stack[TASK_STACK_SIZE];
	uint32_t *sp;

	uint8_t id;
	uint8_t status;
	uint8_t priority;
	char task_name[16];

	struct _rtos_tcb_t_ *next_task;
} rtos_tcb_t;

int rtos_create_task(void (*task_handler)(void), char *task_name, uint8_t priority);
void rtos_start(void);

void switch_user_task(uint32_t *stack);

#endif

