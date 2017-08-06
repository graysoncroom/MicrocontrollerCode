# file: main_asm.s

.include "macros.inc"

SET_TARGET

/* Data {{{ */
.data

    /* GPIO {{{ */
    .equ GPIOA_BASE , 0x40020000
    .equ GPIOB_BASE , 0x40020400
    .equ GPIOC_BASE , 0x40020800
    .equ GPIOD_BASE , 0x40020c00
    .equ GPIOE_BASE , 0x40021000
    .equ GPIOF_BASE , 0x40021400
    .equ GPIOG_BASE , 0x40021800
    .equ GPIOH_BASE , 0x40021c00
    .equ GPIOI_BASE , 0x40022000
    .equ GPIOJ_BASE , 0x40022400
    .equ GPIOK_BASE , 0x40022800

    .equ GPIO_MODER   , 0x00
    .equ GPIO_OTYPER  , 0x04
    .equ GPIO_OSPEEDR , 0x08
    .equ GPIO_PUPDR   , 0x0c
    .equ GPIO_IDR     , 0x10
    .equ GPIO_ODR     , 0x14
    .equ GPIO_BSRR    , 0x18
    .equ GPIO_LCKR    , 0x1c
    .equ GPIO_AFRL    , 0x20
    .equ GPIO_AFRH    , 0x24

    /* GPIOD */
    .equ GREEN_LED  , 12
    .equ ORANGE_LED , 13
    .equ RED_LED    , 14
    .equ BLUE_LED   , 15

    /* GPIOA */
    .equ USER_BUTTON , 0
    /* }}} */

.equ SYST_CSR , 0xE00E010
.equ SYST_RVR , 0xE00E014
.equ SYST_CVR , 0xE00E018
.equ SYST_CALIB , 0xE00E01C


/* }}} */
/* Text {{{ */
.text

FUNCTION main,global
    push {r4, lr}

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

    ldr r0, =GPIOA_BASE
    ldr r1, =USER_BUTTON
    bl gpio_enable_input

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

        ldr r0, =GPIOA_BASE
        ldr r1, =USER_BUTTON
        bl  gpio_get_pin
        cbz r0, end_flashing_led_loop

        ldr r4, =20
        flash_loop:
            cbz r4, end_flashing_led_loop
            sub r4, 1
            ldr r0, =GPIOD_BASE
            ldr r1, =GREEN_LED
            bl  gpio_toggle_pin
            ldr r0, =GPIOD_BASE
            ldr r1, =ORANGE_LED
            bl  gpio_toggle_pin
            ldr r0, =GPIOD_BASE
            ldr r1, =RED_LED
            bl  gpio_toggle_pin
            ldr r0, =GPIOD_BASE
            ldr r1, =BLUE_LED
            bl  gpio_toggle_pin

            ldr r0, =(1<<20)
            bl sleep

            b flash_loop
        end_flashing_led_loop:

        button_is_not_pressed:

        ldr r0, =(1<<19)
        bl  sleep

        b infinite_loop

    pop {r4, lr}
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
    /* gpio_enable_input {{{
        r0: Port address
        r1: Bit number */
    FUNCTION gpio_enable_input
        push {r4, lr}

        /* R1 <- (R1 * 2)
           R2 <- 10<<R2 */
        lsl r1, 1
        ldr r2, =0
        lsl r2, r1

        /* R4 <- Mode Register Current Value
           R4 <- R2 | R4
           R4 -> Mode Register */
        ldr r4, [r0, GPIO_MODER]
        orr r4, r2
        str r4, [r0, GPIO_MODER]

        pop {r4, lr}
        bx  lr
    ENDFUNC gpio_enable_input /*}}}*/
    /* gpio_set_pin {{{
        r0: Port address
        r1: Bit number */
    FUNCTION gpio_set_pin
        push {r4, lr}

        /* R2 <- 1<<R2 */
        ldr r2, =1
        lsl r2, r1

        /* R4 <- Output Data Register Current Value
           R4 <- R2 | R4
           R4 -> Output Data Register */
        ldr r4, [r0, GPIO_ODR]
        orr r4, r2
        str r4, [r0, GPIO_ODR]

        pop {r4, lr}
        bx  lr
    ENDFUNC gpio_set_pin /*}}}*/
    /* gpio_get_pin {{{
        r0: Port address
        r1: Bit number
        Return r0: Value at pin */
    FUNCTION gpio_get_pin
        push {lr}

        ldr r2, =1
        lsl r2, r1

        /* R0 <- (Input Data Register Current Value >> Bit number) */
        ldr r0, [r0, GPIO_IDR]
        and r0,r2
        lsr r0, r1

        pop {lr}
        bx  lr
    ENDFUNC gpio_get_pin
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

