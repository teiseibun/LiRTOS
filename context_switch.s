.syntax unified

.type SysTick_Handler, %function
.global SysTick_Handler
SysTick_Handler:
	/* store user stack to psp */
	mrs r0, psp
	stmdb r0!, {r4, r5, r6, r7, r8, r9, r10, r11, lr}
	str r0, [ip] //save psp to current tcb

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

	mov ip, r0 //save stack pointer of tcb to ip register
	ldr r1, [r0] //get sp value from tcb (we passed the pointer of tcb.sp into this function)

	/* switch to psp */
	msr psp, r1
	mov r1, #3
	msr control, r1

	/* load stack and jump to user task */
	pop {r4, r5, r6, r7, r8, r9, r10, r11, lr} //pop from psp

	bx lr //task function pointer is stored in lr during the task initialization
