/* 
 * file: f4_reset.S
 */

  .include "macros.inc"
  
  SET_TARGET

  .text
  
  FUNCTION Reset_Handler,global

    /* Copy the data segment initializers from flash to SRAM */  
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
    
    bl __libc_init_array

    ldr	r0, .Lfini
    bl	atexit

    .weak SystemInit
    ldr	r0,=SystemInit
    cmp	r0,#0
    it	ne
    blxne	r0
    
    ldr	  r3,=0xe000ed14
    ldr   r2,=((1<<4) | (1<<3))
    str   r2,[r3]

    /*
     *  AP - Spring 2016
     *  Temporary code to support features for Labs
     *  Enable all gpio clocks
     */

      .equ RCC_BASE,0x40023800
      .equ RCC_AHB1ENR,0x30		/* AHB1 peripheral clock enable register */

      .equ RCC_AHB1ENR_GPIOA_EN,(1<<0)
      .equ RCC_AHB1ENR_GPIOB_EN,(1<<1)
      .equ RCC_AHB1ENR_GPIOC_EN,(1<<2)
      .equ RCC_AHB1ENR_GPIOD_EN,(1<<3)
      .equ RCC_AHB1ENR_GPIOE_EN,(1<<4)
     
    ldr r3,=RCC_BASE
    ldr r1,[r3, #RCC_AHB1ENR]
    mov r2,#0b11111			/* enable all clocks */
    orr r1,r2
    str r1,[r3, #RCC_AHB1ENR]
    
    bl  main
	
    bl  exit
	
    bx  lr

  .Lfini:  .word	_fini
      
  ENDFUNC Reset_Handler

  .end