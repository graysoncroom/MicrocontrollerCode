/*
 * file: f4_vector.S
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

#  .global  g_pfnVectors

/**
 * @brief  This is the code that gets called when the processor receives an 
 *         unexpected interrupt.  This simply enters an infinite loop, preserving
 *         the system state for examination by a debugger.
 * @param  None     
 * @retval None       
*/

FUNCTION Default_Handler

  Infinite_Loop:
    b  Infinite_Loop

ENDFUNC Default_Handler

/******************************************************************************
*
* The minimal vector table for a Cortex M3. Note that the proper constructs
* must be placed on this to ensure that it ends up at physical address
* 0x0000.0000.
* 
*******************************************************************************/
   .section  .isr_vector,"a",%progbits
  .type  g_pfnVectors, %object
  .size  g_pfnVectors, .-g_pfnVectors
    
g_pfnVectors:
  ISR_VECTOR  __StackTop
  ISR_VECTOR  Reset_Handler, Default_Handler
  ISR_VECTOR  NMI_Handler, Default_Handler
  ISR_VECTOR  HardFault_Handler, Default_Handler
  ISR_VECTOR  MemManage_Handler, Default_Handler
  ISR_VECTOR  BusFault_Handler, Default_Handler
  ISR_VECTOR  UsageFault_Handler,Default_Handler
  ISR_VECTOR  0
  ISR_VECTOR  0
  ISR_VECTOR  0
  ISR_VECTOR  0
  ISR_VECTOR  SVC_Handler,Default_Handler
  ISR_VECTOR  DebugMon_Handler,Default_Handler
  ISR_VECTOR  0
  ISR_VECTOR  PendSV_Handler,Default_Handler
  ISR_VECTOR  SysTick_Handler,Default_Handler
  
  /* External Interrupts */
  ISR_VECTOR  WWDG_IRQHandler,Default_Handler                /* Window WatchDog                              */                                        
  ISR_VECTOR  PVD_IRQHandler,Default_Handler                 /* PVD through EXTI Line detection              */                        
  ISR_VECTOR  TAMP_STAMP_IRQHandler,Default_Handler          /* Tamper and TimeStamps through the EXTI line  */            
  ISR_VECTOR  RTC_WKUP_IRQHandler,Default_Handler            /* RTC Wakeup through the EXTI line             */                      
  ISR_VECTOR  FLASH_IRQHandler,Default_Handler               /* FLASH                                        */                                          
  ISR_VECTOR  RCC_IRQHandler,Default_Handler                 /* RCC                                          */                                            
  ISR_VECTOR  EXTI0_IRQHandler,Default_Handler               /* EXTI Line0                                   */                        
  ISR_VECTOR  EXTI1_IRQHandler,Default_Handler               /* EXTI Line1                                   */                          
  ISR_VECTOR  EXTI2_IRQHandler,Default_Handler               /* EXTI Line2                                   */                          
  ISR_VECTOR  EXTI3_IRQHandler,Default_Handler               /* EXTI Line3                                   */                          
  ISR_VECTOR  EXTI4_IRQHandler,Default_Handler               /* EXTI Line4                                   */                          
  ISR_VECTOR  DMA1_Stream0_IRQHandler,Default_Handler        /* DMA1 Stream 0                                */                  
  ISR_VECTOR  DMA1_Stream1_IRQHandler,Default_Handler        /* DMA1 Stream 1                                */                  
  ISR_VECTOR  DMA1_Stream2_IRQHandler,Default_Handler        /* DMA1 Stream 2                                */                   
  ISR_VECTOR  DMA1_Stream3_IRQHandler,Default_Handler        /* DMA1 Stream 3                                */                   
  ISR_VECTOR  DMA1_Stream4_IRQHandler,Default_Handler        /* DMA1 Stream 4                                */                   
  ISR_VECTOR  DMA1_Stream5_IRQHandler,Default_Handler        /* DMA1 Stream 5                                */                   
  ISR_VECTOR  DMA1_Stream6_IRQHandler,Default_Handler        /* DMA1 Stream 6                                */                   
  ISR_VECTOR  ADC_IRQHandler,Default_Handler                 /* ADC1, ADC2 and ADC3s                         */                   
  ISR_VECTOR  CAN1_TX_IRQHandler,Default_Handler             /* CAN1 TX                                      */                         
  ISR_VECTOR  CAN1_RX0_IRQHandler,Default_Handler            /* CAN1 RX0                                     */                          
  ISR_VECTOR  CAN1_RX1_IRQHandler,Default_Handler            /* CAN1 RX1                                     */                          
  ISR_VECTOR  CAN1_SCE_IRQHandler,Default_Handler            /* CAN1 SCE                                     */                          
  ISR_VECTOR  EXTI9_5_IRQHandler,Default_Handler             /* External Line[9:5]s                          */                          
  ISR_VECTOR  TIM1_BRK_TIM9_IRQHandler,Default_Handler       /* TIM1 Break and TIM9                          */         
  ISR_VECTOR  TIM1_UP_TIM10_IRQHandler,Default_Handler       /* TIM1 Update and TIM10                        */         
  ISR_VECTOR  TIM1_TRG_COM_TIM11_IRQHandler,Default_Handler  /* TIM1 Trigger and Commutation and TIM11       */
  ISR_VECTOR  TIM1_CC_IRQHandler,Default_Handler             /* TIM1 Capture Compare                         */                          
  ISR_VECTOR  TIM2_IRQHandler,Default_Handler                /* TIM2                                         */                   
  ISR_VECTOR  TIM3_IRQHandler,Default_Handler                /* TIM3                                         */                   
  ISR_VECTOR  TIM4_IRQHandler,Default_Handler                /* TIM4                                         */                   
  ISR_VECTOR  I2C1_EV_IRQHandler,Default_Handler             /* I2C1 Event                                   */                          
  ISR_VECTOR  I2C1_ER_IRQHandler,Default_Handler             /* I2C1 Error                                   */                          
  ISR_VECTOR  I2C2_EV_IRQHandler,Default_Handler             /* I2C2 Event                                   */                          
  ISR_VECTOR  I2C2_ER_IRQHandler,Default_Handler             /* I2C2 Error                                   */                            
  ISR_VECTOR  SPI1_IRQHandler,Default_Handler                /* SPI1                                         */                   
  ISR_VECTOR  SPI2_IRQHandler,Default_Handler                /* SPI2                                         */                   
  ISR_VECTOR  USART1_IRQHandler,Default_Handler              /* USART1                                       */                   
  ISR_VECTOR  USART2_IRQHandler,Default_Handler              /* USART2                                       */                   
  ISR_VECTOR  USART3_IRQHandler,Default_Handler              /* USART3                                       */                   
  ISR_VECTOR  EXTI15_10_IRQHandler,Default_Handler           /* External Line[15:10]s                        */                          
  ISR_VECTOR  RTC_Alarm_IRQHandler,Default_Handler           /* RTC Alarm (A and B) through EXTI Line        */                 
  ISR_VECTOR  OTG_FS_WKUP_IRQHandler,Default_Handler         /* USB OTG FS Wakeup through EXTI line          */                       
  ISR_VECTOR  TIM8_BRK_TIM12_IRQHandler,Default_Handler      /* TIM8 Break and TIM12                         */         
  ISR_VECTOR  TIM8_UP_TIM13_IRQHandler,Default_Handler       /* TIM8 Update and TIM13                        */         
  ISR_VECTOR  TIM8_TRG_COM_TIM14_IRQHandler,Default_Handler  /* TIM8 Trigger and Commutation and TIM14       */
  ISR_VECTOR  TIM8_CC_IRQHandler,Default_Handler             /* TIM8 Capture Compare                         */                          
  ISR_VECTOR  DMA1_Stream7_IRQHandler,Default_Handler        /* DMA1 Stream7                                 */                          
  ISR_VECTOR  FSMC_IRQHandler,Default_Handler                /* FSMC                                         */                   
  ISR_VECTOR  SDIO_IRQHandler,Default_Handler                /* SDIO                                         */                   
  ISR_VECTOR  TIM5_IRQHandler,Default_Handler                /* TIM5                                         */                   
  ISR_VECTOR  SPI3_IRQHandler,Default_Handler                /* SPI3                                         */                   
  ISR_VECTOR  UART4_IRQHandler,Default_Handler               /* UART4                                        */                   
  ISR_VECTOR  UART5_IRQHandler,Default_Handler               /* UART5                                        */                   
  ISR_VECTOR  TIM6_DAC_IRQHandler,Default_Handler            /* TIM6 and DAC1&2 underrun errors              */                   
  ISR_VECTOR  TIM7_IRQHandler,Default_Handler                /* TIM7                                         */
  ISR_VECTOR  DMA2_Stream0_IRQHandler,Default_Handler        /* DMA2 Stream 0                                */                   
  ISR_VECTOR  DMA2_Stream1_IRQHandler,Default_Handler        /* DMA2 Stream 1                                */                   
  ISR_VECTOR  DMA2_Stream2_IRQHandler,Default_Handler        /* DMA2 Stream 2                                */                   
  ISR_VECTOR  DMA2_Stream3_IRQHandler,Default_Handler        /* DMA2 Stream 3                                */                   
  ISR_VECTOR  DMA2_Stream4_IRQHandler,Default_Handler        /* DMA2 Stream 4                                */                   
  ISR_VECTOR  ETH_IRQHandler,Default_Handler                 /* Ethernet                                     */                   
  ISR_VECTOR  ETH_WKUP_IRQHandler,Default_Handler            /* Ethernet Wakeup through EXTI line            */                     
  ISR_VECTOR  CAN2_TX_IRQHandler,Default_Handler             /* CAN2 TX                                      */                          
  ISR_VECTOR  CAN2_RX0_IRQHandler,Default_Handler            /* CAN2 RX0                                     */                          
  ISR_VECTOR  CAN2_RX1_IRQHandler,Default_Handler            /* CAN2 RX1                                     */                          
  ISR_VECTOR  CAN2_SCE_IRQHandler,Default_Handler            /* CAN2 SCE                                     */                          
  ISR_VECTOR  OTG_FS_IRQHandler,Default_Handler              /* USB OTG FS                                   */                   
  ISR_VECTOR  DMA2_Stream5_IRQHandler,Default_Handler        /* DMA2 Stream 5                                */                   
  ISR_VECTOR  DMA2_Stream6_IRQHandler,Default_Handler        /* DMA2 Stream 6                                */                   
  ISR_VECTOR  DMA2_Stream7_IRQHandler,Default_Handler        /* DMA2 Stream 7                                */                   
  ISR_VECTOR  USART6_IRQHandler,Default_Handler              /* USART6                                       */                    
  ISR_VECTOR  I2C3_EV_IRQHandler,Default_Handler             /* I2C3 event                                   */                          
  ISR_VECTOR  I2C3_ER_IRQHandler,Default_Handler             /* I2C3 error                                   */                          
  ISR_VECTOR  OTG_HS_EP1_OUT_IRQHandler,Default_Handler      /* USB OTG HS End Point 1 Out                   */                   
  ISR_VECTOR  OTG_HS_EP1_IN_IRQHandler,Default_Handler       /* USB OTG HS End Point 1 In                    */                   
  ISR_VECTOR  OTG_HS_WKUP_IRQHandler,Default_Handler         /* USB OTG HS Wakeup through EXTI               */                         
  ISR_VECTOR  OTG_HS_IRQHandler,Default_Handler              /* USB OTG HS                                   */                   
  ISR_VECTOR  DCMI_IRQHandler,Default_Handler                /* DCMI                                         */                   
  ISR_VECTOR  CRYP_IRQHandler,Default_Handler                /* CRYP crypto                                  */                   
  ISR_VECTOR  HASH_RNG_IRQHandler,Default_Handler            /* Hash and Rng                                 */
  ISR_VECTOR  FPU_IRQHandler,Default_Handler                 /* FPU                                          */

  .end
  