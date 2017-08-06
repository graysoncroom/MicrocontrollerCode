# file: macros.inc

  .nolist

  .macro	SET_TARGET
    .syntax unified
    .ifdef ctxm3
      .cpu cortex-m3
    .endif
    .ifdef ctxm4
      .cpu cortex-m4
    .endif
    .fpu softvfp
    .thumb  
  .endm

  .macro	FUNCTION name:req,scope:vararg
    .func		\name,\name
    .type		\name,%function
    .thumb_func
    .align	2
    .ifc \scope,global
      .global \name
    .endif
\name\():
  .endm
  
  .macro	ENDFUNC name
    .size	\name,.-\name
    .pool
    .endfunc
  .endm
  
  .list
