# file: main_asm.s

  SET_TARGET

  .include "macros.inc"
  
  .text
  
  FUNCTION main,global

    .warning "You did not define a main function"
  
    push {r4,r5,r6,r7,lr}

    nop
    
    pop {r4,r5,r6,r7,lr}
    
    bx lr
  
  ENDFUNC main

  .end
