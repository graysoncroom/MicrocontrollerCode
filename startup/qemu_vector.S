/*
 * file: qemu_vector.S
 */

  .include "macros.inc"

  .macro ISR_VECTOR handler:req,def_handler:vararg
    .word	\handler
    .ifnb	\def_handler
      .weak		\handler
      .thumb_set	\handler,\def_handler
    .endif
  .endm

  SET_TARGET

  .section .isr_vector
  .align	2
  .globl	__isr_vector
__isr_vector:

  ISR_VECTOR __StackTop				/* Top of Stack */
  ISR_VECTOR Reset_Handler,Default_Handler	/* Reset Handler */
  ISR_VECTOR NMI_Handler,Default_Handler		/* NMI Handler */
  ISR_VECTOR HardFault_Handler,Default_Handler	/* Hard Fault Handler */
  ISR_VECTOR MemManage_Handler,Default_Handler	/* MPU Fault Handler */
  ISR_VECTOR BusFault_Handler,Default_Handler	/* Bus Fault Handler */
  ISR_VECTOR UsageFault_Handler,Default_Handler	/* Usage Fault Handler */
  ISR_VECTOR 0					/* Reserved */
  ISR_VECTOR 0					/* Reserved */
  ISR_VECTOR 0					/* Reserved */
  ISR_VECTOR 0					/* Reserved */
  ISR_VECTOR SVC_Handler,Default_Handler		/* SVCall Handler */
  ISR_VECTOR DebugMon_Handler,Default_Handler	/* Debug Monitor Handler */
  ISR_VECTOR 0					/* Reserved */
  ISR_VECTOR PendSV_Handler,Default_Handler	/* PendSV Handler */
  ISR_VECTOR SysTick_Handler,Default_Handler	/* SysTick Handler */

  /* External interrupts */
  ISR_VECTOR DEF_IRQHandler,Default_Handler

  .size	__isr_vector, . - __isr_vector

FUNCTION Default_Handler

  b	.
  
ENDFUNC Default_Handler

  .end
