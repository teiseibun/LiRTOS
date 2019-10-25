.syntax unified

.type SysTick_Handler, %function
.global SysTick_Handler
SysTick_Handler:
	//store user stack to process stack pointer
	mrs r0, psp
	stmdb r0!, {r4, r5, r6, r7, r8, r9, r10, r11, lr}

	//load kernel stack from main stack pointer
	pop {r4, r5, r6, r7, r8, r9, r10, r11, ip, lr}
	msr psr_nzcvq, ip

	bx lr //back to the kernel

.type switch_user_task, %function
.global switch_user_task
switch_user_task:
	/* save kernel stack to main stack */
	mrs ip, psr //save psr to ip (r12)
	push {r4, r5, r6, r7, r8, r9, r10, r11, ip, lr} //save kernel stack to msp

	/* switch to use process stack pointer */
	msr psp, r0
	mov r0, #3
	msr control, r0

	/* load user stack and jump to user task function */
	pop {r4, r5, r6, r7, r8, r9, r10, r11, lr} //pop stack from psp
	bx lr //task function pointer is stored in lr during the task initialization
