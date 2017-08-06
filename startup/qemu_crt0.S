/*
 * file: qemu_crt0.S
 */
 
  .include "macros.inc"
 
  SET_TARGET

  .text
  
  FUNCTION _my_start,global
  
/* Annotation for EABI unwinding tables.  */
  .fnstart

  /* Zero the memory in the .bss section.  */
  movs a2, #0			/* Second arg: fill value */
  mov  fp, a2			/* Null frame pointer */
  mov  r7, a2			/* Null frame pointer for Thumb */

  /* Some arm/elf targets use the .init and .fini sections
   to create constructors and destructors, and for these
   targets we need to call the _init function and arrange
   for _fini to be called at program exit.  */

  ldr	r0, .Lfini
  bl	atexit
.Lweak_atexit:
  bl	_init

  bl	main

  bl	exit		/* Should not return.  */

  .align 2

  /* Protect against unhandled exceptions.  */
  .cantunwind
  .fnend

.Lfini:
  .word	_fini

  ENDFUNC _my_start
    
  .end
