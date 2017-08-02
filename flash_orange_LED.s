# file: main_asm.s

.include "macros.inc"

    SET_TARGET

    .text

    FUNCTION main,global

        push {r4,r5,r6,r7,lr}

        ldr r4,=GPIO_BASE
        ldr r2,=(0b01<<(2*13))
        str r2,[r4,GPIO_MODER]

        ldr r5,=0
        str r5,[r4,GPIO_ODR]
        ldr r6,=(1<<13)
        LOOP:
            str r6,[r4,GPIO_ODR]
            ldr r7,=(1<<15)
            LOOP_2:
                cbz r7,END_LOOP_2
                sub r7,r7,1
                ldr r1,=(1<<5)
                LOOP_2_NESTED:
                    cbz r1,END_LOOP_2_NESTED
                    sub r1,r1,1
                    b LOOP_2_NESTED
                END_LOOP_2_NESTED:
                b LOOP_2
            END_LOOP_2:
            str r5,[r4,GPIO_ODR]
            ldr r7,=(1<<15)
            LOOP_3:
                cbz r7,END_LOOP_3
                sub r7,r7,1
                ldr r1,=(1<<5)
                LOOP_3_NESTED:
                    cbz r1,END_LOOP_3_NESTED
                    sub r1,r1,1
                    b LOOP_3_NESTED
                END_LOOP_3_NESTED:
                b LOOP_3
            END_LOOP_3:
            b LOOP
        END_LOOP:

        all_done:
        pop {r4,r5,r6,r7,lr}
        bx lr

    ENDFUNC main

    .data

    .equ GPIO_BASE, 0x40020c00
    .equ GPIO_MODER,0x00
    .equ GPIO_ODR,0x14

    .end
