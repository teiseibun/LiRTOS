.syntax unified

.type SysTick_Handler, %function
.global SysTick_Handler
SysTick_Handler:
	/* save psp to current tcb */
	mrs r0, psp
	str r0, [ip]

	/* store user stack to psp */
	mrs r0, psp
	stmdb r0!, {r4, r5, r6, r7, r8, r9, r10, r11, lr}

	/* load kernel stack from msp */
	pop {r4, r5, r6, r7, r8, r9, r10, r11, ip, lr}
	msr psr_nzcvq, ip

	bx lr //back to the kernel

.type switch_user_task, %function
.global switch_user_task
switch_user_task:
	/* save kernel stack msp */
	mrs ip, psr //save psr to ip (r12)
	push {r4, r5, r6, r7, r8, r9, r10, r11, ip, lr} //save kernel stack to msp

	mov ip, r0
	ldr r1, [r0]
	mov r0, r1

	/* switch to psp */
	msr psp, r0
	mov r0, #3
	msr control, r0

	/* load stack and jump to user task */
	pop {r4, r5, r6, r7, r8, r9, r10, r11, lr} //pop from psp

	bx lr //task function pointer is stored in lr during the task initialization
