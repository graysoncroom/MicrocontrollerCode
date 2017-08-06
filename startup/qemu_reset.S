/*
 * file: qemu_reset.S
 */

  .include "macros.inc"
 
  SET_TARGET

  .text
  
  FUNCTION Reset_Handler,global

    ldr	r1, =__etext		// from start
    ldr	r2, =__data_start__	// to start
    ldr	r3, =__data_end__	// to end

    loop_data:
      cmp	r2, r3
      ittt	lt
      ldrlt	r0, [r1], #4
      strlt	r0, [r2], #4
      blt	loop_data

    movs    r0, #0
    ldr     r1, =__bss_start__
    ldr     r2, =__bss_end__

    bloop:
      cmp     r1, r2
      itt     lo
      strlo   r0, [r1], #4
      blo     bloop

    .weak SystemInit
    ldr	r0,=SystemInit
    cmp	r0,#0
    it	ne
    blxne	r0
    
    bl	_my_start

  ENDFUNC Reset_Handler

  .end
