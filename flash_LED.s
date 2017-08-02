.include "macros.inc"

    SET_TARGET

/* Data {{{ */
.data

.equ GPIOA_BASE , 0x40020000
.equ GPIOB_BASE , 0x40020400
.equ GPIOC_BASE , 0x40020800
.equ GPIOD_BASE , 0x40020c00

.equ GPIO_MODER , 0x00
.equ GPIO_ODR   , 0x14

.equ GREEN_LED  , 12
.equ ORANGE_LED , 13
.equ RED_LED    , 14
.equ BLUE_LED   , 15
/* }}} */
/* Text {{{ */
.text

FUNCTION main,global
    push {r4, r5, r6, lr}

    ldr r0, =GPIOD_BASE
    ldr r1, =GREEN_LED
    bl  gpio_enable_output

    ldr r0, =GPIOD_BASE
    ldr r1, =ORANGE_LED
    bl  gpio_enable_output

    ldr r0, =GPIOD_BASE
    ldr r1, =RED_LED
    bl  gpio_enable_output

    ldr r0, =GPIOD_BASE
    ldr r1, =BLUE_LED
    bl  gpio_enable_output

    infinite_loop:
        ldr r0, =GPIOD_BASE
        ldr r1, =GREEN_LED
        bl gpio_toggle_pin

        ldr r0, =(1<<19)
        bl  sleep

        ldr r0, =GPIOD_BASE
        ldr r1, =ORANGE_LED
        bl gpio_toggle_pin

        ldr r0, =(1<<19)
        bl  sleep

        ldr r0, =GPIOD_BASE
        ldr r1, =RED_LED
        bl  gpio_toggle_pin

        ldr r0, =(1<<19)
        bl  sleep

        ldr r0, =GPIOD_BASE
        ldr r1, =BLUE_LED
        bl  gpio_toggle_pin

        ldr r0, =(1<<19)
        bl  sleep

        b infinite_loop

    pop {r4, r5, r6, lr}
    bx  lr
ENDFUNC main

    /* sleep {{{
        r0: Time Delay */
    FUNCTION sleep
        push {lr}
        my_loop:
            cbz r0, end_my_loop
            sub r0, 1
            b my_loop
        end_my_loop:
        pop {lr}
        bx  lr
    ENDFUNC sleep /*}}}*/
    /* gpio_enable_output {{{
        r0: Port address
        r1: Bit number */
    FUNCTION gpio_enable_output
        push {r4, lr}

        /* R1 <- (R1 * 2)
           R2 <- 1<<R2 */
        lsl r1, 1
        ldr r2, =1
        lsl r2, r1

        /* R4 <- Mode Register Current Value
           R4 <- R2 | R4
           R4 -> Mode Register */
        ldr r4, [r0, GPIO_MODER]
        orr r4, r2
        str r4, [r0, GPIO_MODER]

        pop {r4, lr}
        bx  lr
    ENDFUNC gpio_enable_output /*}}}*/
    /* gpio_set_pin {{{
        r0: Port address
        r1: Bit number */
    FUNCTION gpio_set_pin
        push {r4, lr}

        /* R2 <- 1<<R2 */
        ldr r2, =1
        lsl r2, r1

        /* R4 <- Mode Register Current Value
           R4 <- R2 | R4
           R4 -> Mode Register */
        ldr r4, [r0, GPIO_ODR]
        orr r4, r2
        str r4, [r0, GPIO_ODR]

        pop {r4, lr}
        bx  lr
    ENDFUNC gpio_set_pin /*}}}*/
    /* gpio_toggle_pin {{{
    r0: Port address
    r1: Bit number */
    FUNCTION gpio_toggle_pin
        push {r4, lr}

        /* R2 <- 1<<R2 */
        ldr r2, =1
        lsl r2, r1

        /* R4 <- Mode Register Current Value
           R4 <- R2 | R4
           R4 -> Mode Register */
        ldr r4, [r0, GPIO_ODR]
        eor r4, r2
        str r4, [r0, GPIO_ODR]

        pop {r4, lr}
        bx  lr
    ENDFUNC gpio_toggle_pin /*}}}*/
/*}}}*/
.end

