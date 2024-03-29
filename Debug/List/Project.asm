
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega32
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega32
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x085F
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _ch01=R5
	.DEF _ch10=R4
	.DEF _count=R6
	.DEF _count_msb=R7
	.DEF _n1=R8
	.DEF _n1_msb=R9
	.DEF _n2=R10
	.DEF _n2_msb=R11
	.DEF _n3=R12
	.DEF _n3_msb=R13

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  _my_inter0
	JMP  _my_inter1
	JMP  _my_inter2
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0xFF,0xFF

_0x3:
	.DB  0x39,0x37,0x38,0x41,0x36,0x34,0x35,0x42
	.DB  0x33,0x31,0x32,0x43,0x45,0x46,0x30,0x44
_0x4:
	.DB  0x9,0x0,0x7,0x0,0x8,0x0,0xA,0x0
	.DB  0x6,0x0,0x4,0x0,0x5,0x0,0xB,0x0
	.DB  0x3,0x0,0x1,0x0,0x2,0x0,0xC,0x0
	.DB  0xE,0x0,0xF,0x0,0x0,0x0,0xD
_0x5:
	.DB  0xF
_0x6:
	.DB  0x1E
_0x7:
	.DB  0xFF
_0x8:
	.DB  0xFF,0xFF
_0x9:
	.DB  0xFF,0xFF
_0x0:
	.DB  0x4E,0x6F,0x6E,0x65,0x0
_0x20003:
	.DB  0x3F,0x0,0x6,0x0,0x5B,0x0,0x4F,0x0
	.DB  0x66,0x0,0x6D,0x0,0x7D,0x0,0x7,0x0
	.DB  0x7F,0x0,0x6F,0x0,0x77,0x0,0x7C,0x0
	.DB  0x39,0x0,0x5E,0x0,0x79,0x0,0x71
_0x20004:
	.DB  0x70,0x0,0xB0,0x0,0xD0,0x0,0xE0
_0x2000003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x02
	.DW  0x06
	.DW  __REG_VARS*2

	.DW  0x10
	.DW  _ch
	.DW  _0x3*2

	.DW  0x1F
	.DW  _nu
	.DW  _0x4*2

	.DW  0x01
	.DW  _ZF
	.DW  _0x5*2

	.DW  0x01
	.DW  _FZ
	.DW  _0x6*2

	.DW  0x01
	.DW  _MIN
	.DW  _0x7*2

	.DW  0x02
	.DW  _i
	.DW  _0x8*2

	.DW  0x02
	.DW  _j
	.DW  _0x9*2

	.DW  0x05
	.DW  _0x4D
	.DW  _0x0*2

	.DW  0x05
	.DW  _0x4D+5
	.DW  _0x0*2

	.DW  0x1F
	.DW  _numbers
	.DW  _0x20003*2

	.DW  0x07
	.DW  _digit
	.DW  _0x20004*2

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x260

	.CSEG
;#include "LCD.h"
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include "MPX4.h"
;#include "Keypad.h"
;
;char ch[]="978A645B312CEF0D",ch01,ch10;

	.DSEG
;int nu[16]={0x09,0x07,0x08,0x0A,0x06,0x04,0x05,0x0B,0x03,0x01,0x02,0x0C,0x0E,0x0F,0x00,0x0D};
;
;
;
;
;int count=-1,n1,n2,n3,n4;
;int tempZF_Z=0,tempZF_F=0,tempFZ_Z=0,tempFZ_F=0;
;int ZF=0x0F,FZ=0x1E,MAX=0x00,MIN=0xFF,flagFZ=0,flagZF=0;
;int b0=0,b1=0,b2=0;
;int i=-1,j=-1,flag,x=0,y=0,k=0;
;int r1=0,r0=0;
;int ra1=0,ra0=0,rf=0,t=0;
;int len=0,boo1=0;
;
;/////////////main///////////
;void main(void)
; 0000 0016 {

	.CSEG
_main:
; .FSTART _main
; 0000 0017 lcd_init(16);
	LDI  R26,LOW(16)
	CALL _lcd_init
; 0000 0018 GICR=(1<<INT0 | 1<<INT1 | 1<<INT2);
	LDI  R30,LOW(224)
	OUT  0x3B,R30
; 0000 0019 MCUCR=(1<<ISC00) | (1<<ISC01 | 1<<ISC10) | (1<<ISC11);
	LDI  R30,LOW(15)
	OUT  0x35,R30
; 0000 001A MCUSR=(1<<ISC2);
	LDI  R30,LOW(64)
	OUT  0x34,R30
; 0000 001B GIFR=(1<<INTF0 | 1<<INTF1 | 1<<INTF2);
	LDI  R30,LOW(224)
	OUT  0x3A,R30
; 0000 001C DDRA=0xff;
	LDI  R30,LOW(255)
	OUT  0x1A,R30
; 0000 001D DDRB.4=1;
	SBI  0x17,4
; 0000 001E DDRB.5=1;
	SBI  0x17,5
; 0000 001F DDRB.6=1;
	SBI  0x17,6
; 0000 0020 DDRB.7=1;
	SBI  0x17,7
; 0000 0021 DDRD=0B00110011;
	LDI  R30,LOW(51)
	OUT  0x11,R30
; 0000 0022 DDRC=0xff;
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0000 0023 PORTD.2=1;
	SBI  0x12,2
; 0000 0024 PORTD.3=1;
	SBI  0x12,3
; 0000 0025 PORTD.6=1;
	SBI  0x12,6
; 0000 0026 PORTD.7=1;
	SBI  0x12,7
; 0000 0027 #asm("sei")
	sei
; 0000 0028 
; 0000 0029     while (1)
_0x1A:
; 0000 002A     {
; 0000 002B         t+=1;
	LDS  R30,_t
	LDS  R31,_t+1
	ADIW R30,1
	STS  _t,R30
	STS  _t+1,R31
; 0000 002C         while(r1==0){
_0x1D:
	LDS  R30,_r1
	LDS  R31,_r1+1
	SBIW R30,0
	BRNE _0x1F
; 0000 002D             if (boo1==0){
	LDS  R30,_boo1
	LDS  R31,_boo1+1
	SBIW R30,0
	BRNE _0x20
; 0000 002E             count=start();
	CALL SUBOPT_0x0
; 0000 002F                 if(b1==1 || b0==1 || b2==1)
	BREQ _0x22
	CALL SUBOPT_0x1
	BREQ _0x22
	CALL SUBOPT_0x2
	BRNE _0x21
_0x22:
; 0000 0030                     Fch(count);
	MOVW R26,R6
	CALL _Fch
; 0000 0031                 if (i>=0){
_0x21:
	LDS  R26,_i+1
	TST  R26
	BRMI _0x24
; 0000 0032                     show(i);
	CALL SUBOPT_0x3
; 0000 0033                     ra1=nu[i];
	STS  _ra1,R30
	STS  _ra1+1,R31
; 0000 0034                     i=-1;
	CALL SUBOPT_0x4
; 0000 0035                     r1=1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _r1,R30
	STS  _r1+1,R31
; 0000 0036                 }
; 0000 0037                 count=-1;
_0x24:
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	MOVW R6,R30
; 0000 0038             }
; 0000 0039             else if (boo1==1){
	RJMP _0x25
_0x20:
	CALL SUBOPT_0x5
	SBIW R26,1
	BREQ _0x54
; 0000 003A             count=-1;
; 0000 003B             i=-1;
; 0000 003C             boo1=0;
; 0000 003D             }
; 0000 003E             else if (boo1==2){
	CALL SUBOPT_0x5
	SBIW R26,2
	BRNE _0x28
; 0000 003F             count=-1;
_0x54:
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	MOVW R6,R30
; 0000 0040             i=-1;
	CALL SUBOPT_0x4
; 0000 0041             boo1=0;
	LDI  R30,LOW(0)
	STS  _boo1,R30
	STS  _boo1+1,R30
; 0000 0042 
; 0000 0043             }
; 0000 0044         }
_0x28:
_0x25:
	RJMP _0x1D
_0x1F:
; 0000 0045        /////ragham 10
; 0000 0046        while(r0==0){
_0x29:
	LDS  R30,_r0
	LDS  R31,_r0+1
	SBIW R30,0
	BRNE _0x2B
; 0000 0047        count=start();
	CALL SUBOPT_0x0
; 0000 0048             if(b1==1 || b0==1 || b2==1)
	BREQ _0x2D
	CALL SUBOPT_0x1
	BREQ _0x2D
	CALL SUBOPT_0x2
	BRNE _0x2C
_0x2D:
; 0000 0049                 Fch(count);
	MOVW R26,R6
	CALL _Fch
; 0000 004A             if (i>=0){
_0x2C:
	LDS  R26,_i+1
	TST  R26
	BRMI _0x2F
; 0000 004B                 show(i);
	CALL SUBOPT_0x3
; 0000 004C                 ra0=nu[i];
	STS  _ra0,R30
	STS  _ra0+1,R31
; 0000 004D                 r0=1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _r0,R30
	STS  _r0+1,R31
; 0000 004E                 i=-1;
	CALL SUBOPT_0x4
; 0000 004F             }
; 0000 0050        count=-1;
_0x2F:
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	MOVW R6,R30
; 0000 0051        }
	RJMP _0x29
_0x2B:
; 0000 0052        //////ragham 01
; 0000 0053        if(r1==1 && r0==1){
	LDS  R26,_r1
	LDS  R27,_r1+1
	SBIW R26,1
	BRNE _0x31
	LDS  R26,_r0
	LDS  R27,_r0+1
	SBIW R26,1
	BREQ _0x32
_0x31:
	RJMP _0x30
_0x32:
; 0000 0054             tempZF_Z=ZF/16;
	LDS  R26,_ZF
	LDS  R27,_ZF+1
	CALL SUBOPT_0x6
	STS  _tempZF_Z,R30
	STS  _tempZF_Z+1,R31
; 0000 0055             tempZF_F=ZF%16;
	LDS  R30,_ZF
	LDS  R31,_ZF+1
	CALL SUBOPT_0x7
	STS  _tempZF_F,R30
	STS  _tempZF_F+1,R31
; 0000 0056             tempFZ_F=FZ/16;
	LDS  R26,_FZ
	LDS  R27,_FZ+1
	CALL SUBOPT_0x6
	STS  _tempFZ_F,R30
	STS  _tempFZ_F+1,R31
; 0000 0057             tempFZ_Z=FZ%16;
	LDS  R30,_FZ
	LDS  R31,_FZ+1
	CALL SUBOPT_0x7
	STS  _tempFZ_Z,R30
	STS  _tempFZ_Z+1,R31
; 0000 0058 
; 0000 0059             if (ra1 % 2 == 0 && ra1 >= tempZF_Z){
	CALL SUBOPT_0x8
	CALL SUBOPT_0x9
	SBIW R30,0
	BRNE _0x34
	LDS  R30,_tempZF_Z
	LDS  R31,_tempZF_Z+1
	CALL SUBOPT_0x8
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x35
_0x34:
	RJMP _0x33
_0x35:
; 0000 005A                 if (ra0 % 2 == 1 && ra0 <= tempZF_F){
	CALL SUBOPT_0xA
	CALL SUBOPT_0x9
	SBIW R30,1
	BRNE _0x37
	LDS  R30,_tempZF_F
	LDS  R31,_tempZF_F+1
	CALL SUBOPT_0xA
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x38
_0x37:
	RJMP _0x36
_0x38:
; 0000 005B                     rf=0;
	CALL SUBOPT_0xB
; 0000 005C                     rf=ra1*16;
; 0000 005D                     rf=rf + ra0;
; 0000 005E                     ZF=rf;
	STS  _ZF,R30
	STS  _ZF+1,R31
; 0000 005F                     flagZF=1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _flagZF,R30
	STS  _flagZF+1,R31
; 0000 0060 
; 0000 0061 
; 0000 0062                 }
; 0000 0063             }
_0x36:
; 0000 0064             else if (ra1 % 2 == 1 && ra1 >= tempFZ_F){
	RJMP _0x39
_0x33:
	CALL SUBOPT_0x8
	CALL SUBOPT_0x9
	SBIW R30,1
	BRNE _0x3B
	LDS  R30,_tempFZ_F
	LDS  R31,_tempFZ_F+1
	CALL SUBOPT_0x8
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x3C
_0x3B:
	RJMP _0x3A
_0x3C:
; 0000 0065                 if (ra0 % 2 == 0 && ra0 <= tempFZ_Z){
	CALL SUBOPT_0xA
	CALL SUBOPT_0x9
	SBIW R30,0
	BRNE _0x3E
	LDS  R30,_tempFZ_Z
	LDS  R31,_tempFZ_Z+1
	CALL SUBOPT_0xA
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x3F
_0x3E:
	RJMP _0x3D
_0x3F:
; 0000 0066                     rf=0;
	CALL SUBOPT_0xB
; 0000 0067                     rf=ra1*16;
; 0000 0068                     rf=rf+ra0;
; 0000 0069                     FZ=rf;
	STS  _FZ,R30
	STS  _FZ+1,R31
; 0000 006A                     flagFZ=1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _flagFZ,R30
	STS  _flagFZ+1,R31
; 0000 006B                 }
; 0000 006C             }
_0x3D:
; 0000 006D             rf=0;
_0x3A:
_0x39:
	LDI  R30,LOW(0)
	STS  _rf,R30
	STS  _rf+1,R30
; 0000 006E             rf=ra1*16;
	LDS  R30,_ra1
	LDS  R31,_ra1+1
	CALL __LSLW4
	STS  _rf,R30
	STS  _rf+1,R31
; 0000 006F             rf=rf+ra0;
	LDS  R30,_ra0
	LDS  R31,_ra0+1
	CALL SUBOPT_0xC
	ADD  R30,R26
	ADC  R31,R27
	STS  _rf,R30
	STS  _rf+1,R31
; 0000 0070             if (rf > MAX){
	LDS  R30,_MAX
	LDS  R31,_MAX+1
	CALL SUBOPT_0xC
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x40
; 0000 0071             MAX=rf;
	LDS  R30,_rf
	LDS  R31,_rf+1
	STS  _MAX,R30
	STS  _MAX+1,R31
; 0000 0072             }
; 0000 0073             if (rf<MIN){
_0x40:
	CALL SUBOPT_0xD
	CALL SUBOPT_0xC
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x41
; 0000 0074             MIN=rf;
	LDS  R30,_rf
	LDS  R31,_rf+1
	STS  _MIN,R30
	STS  _MIN+1,R31
; 0000 0075             }
; 0000 0076        }
_0x41:
; 0000 0077        ///////ZF & FZ & MAX & MIN
; 0000 0078        if(r1==1 && r0==1){
_0x30:
	LDS  R26,_r1
	LDS  R27,_r1+1
	SBIW R26,1
	BRNE _0x43
	LDS  R26,_r0
	LDS  R27,_r0+1
	SBIW R26,1
	BREQ _0x44
_0x43:
	RJMP _0x42
_0x44:
; 0000 0079             r1=0;
	LDI  R30,LOW(0)
	STS  _r1,R30
	STS  _r1+1,R30
; 0000 007A             r0=0;
	STS  _r0,R30
	STS  _r0+1,R30
; 0000 007B             lcd_gotoxy(x,y);
	CALL SUBOPT_0xE
; 0000 007C             lcd_putchar('-');
	LDI  R26,LOW(45)
	CALL _lcd_putchar
; 0000 007D             if (x==15 && y==1){
	CALL SUBOPT_0xF
	BRNE _0x46
	LDS  R26,_y
	LDS  R27,_y+1
	SBIW R26,1
	BREQ _0x47
_0x46:
	RJMP _0x45
_0x47:
; 0000 007E                 lcd_clear();
	CALL _lcd_clear
; 0000 007F                 y=-1;
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	CALL SUBOPT_0x10
; 0000 0080                 x=0;
	CALL SUBOPT_0x11
; 0000 0081             }
; 0000 0082             if (x==15){
_0x45:
	CALL SUBOPT_0xF
	BRNE _0x48
; 0000 0083                 x=-1;
	CALL SUBOPT_0x12
; 0000 0084                 y+=1;
	CALL SUBOPT_0x13
; 0000 0085             }
; 0000 0086             x++;
_0x48:
	CALL SUBOPT_0x14
; 0000 0087             delay_ms(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _delay_ms
; 0000 0088             }
; 0000 0089         if (t>=4)
_0x42:
	LDS  R26,_t
	LDS  R27,_t+1
	SBIW R26,4
	BRLT _0x49
; 0000 008A         delay_ms(300);
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	CALL _delay_ms
; 0000 008B         if (PIND.6==0){
_0x49:
	SBIC 0x10,6
	RJMP _0x4A
; 0000 008C             lcd_clear();
	CALL _lcd_clear
; 0000 008D             x=0;
	CALL SUBOPT_0x11
; 0000 008E             y=0;
	CALL SUBOPT_0x15
; 0000 008F             if(flagZF==1){
	LDS  R26,_flagZF
	LDS  R27,_flagZF+1
	SBIW R26,1
	BRNE _0x4B
; 0000 0090             sh_FZ(ZF);
	LDS  R26,_ZF
	LDS  R27,_ZF+1
	CALL _sh_FZ
; 0000 0091             x++;
	CALL SUBOPT_0x14
; 0000 0092             }
; 0000 0093             else{
	RJMP _0x4C
_0x4B:
; 0000 0094             lcd_gotoxy(x,y);
	CALL SUBOPT_0xE
; 0000 0095             lcd_puts("None");
	__POINTW2MN _0x4D,0
	CALL SUBOPT_0x16
; 0000 0096             x+=4;
; 0000 0097             }
_0x4C:
; 0000 0098             lcd_putchar('-');
	LDI  R26,LOW(45)
	CALL SUBOPT_0x17
; 0000 0099             x++;
; 0000 009A             if(flagFZ==1){
	LDS  R26,_flagFZ
	LDS  R27,_flagFZ+1
	SBIW R26,1
	BRNE _0x4E
; 0000 009B             sh_FZ(FZ);
	LDS  R26,_FZ
	LDS  R27,_FZ+1
	CALL _sh_FZ
; 0000 009C             x++;
	CALL SUBOPT_0x14
; 0000 009D             }
; 0000 009E             else{
	RJMP _0x4F
_0x4E:
; 0000 009F             lcd_gotoxy(x,y);
	CALL SUBOPT_0xE
; 0000 00A0             lcd_puts("None");
	__POINTW2MN _0x4D,5
	CALL SUBOPT_0x16
; 0000 00A1             x+=4;
; 0000 00A2             }
_0x4F:
; 0000 00A3             boo1=2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	STS  _boo1,R30
	STS  _boo1+1,R31
; 0000 00A4             lcd_gotoxy(x,y);
	CALL SUBOPT_0xE
; 0000 00A5             lcd_putchar('/');
	LDI  R26,LOW(47)
	CALL SUBOPT_0x17
; 0000 00A6             x++;
; 0000 00A7 
; 0000 00A8         }
; 0000 00A9         if (t>=4)
_0x4A:
	LDS  R26,_t
	LDS  R27,_t+1
	SBIW R26,4
	BRLT _0x50
; 0000 00AA         delay_ms(300);
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	CALL _delay_ms
; 0000 00AB         if(PIND.7==0){
_0x50:
	SBIC 0x10,7
	RJMP _0x51
; 0000 00AC 
; 0000 00AD             DDRC =0xff;
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0000 00AE             DDRB = 0XF0 ;
	LDI  R30,LOW(240)
	OUT  0x17,R30
; 0000 00AF             PORTB = 0;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 00B0 
; 0000 00B1             first_show(MIN,MAX);
	CALL SUBOPT_0x18
	RCALL _first_show
; 0000 00B2             counter(MIN,MAX);
	CALL SUBOPT_0x18
	RCALL _counter
; 0000 00B3 
; 0000 00B4             PORTB = 0XF4;
	LDI  R30,LOW(244)
	OUT  0x18,R30
; 0000 00B5             MIN=0XFF;
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	STS  _MIN,R30
	STS  _MIN+1,R31
; 0000 00B6             MAX=0X00;
	LDI  R30,LOW(0)
	STS  _MAX,R30
	STS  _MAX+1,R30
; 0000 00B7             lcd_clear();
	CALL _lcd_clear
; 0000 00B8             x=0;
	CALL SUBOPT_0x11
; 0000 00B9             y=0;
	CALL SUBOPT_0x15
; 0000 00BA             if(boo1!=2)
	CALL SUBOPT_0x5
	SBIW R26,2
	BREQ _0x52
; 0000 00BB             boo1=1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _boo1,R30
	STS  _boo1+1,R31
; 0000 00BC 
; 0000 00BD         }
_0x52:
; 0000 00BE 
; 0000 00BF 
; 0000 00C0     }
_0x51:
	RJMP _0x1A
; 0000 00C1 }
_0x53:
	RJMP _0x53
; .FEND

	.DSEG
_0x4D:
	.BYTE 0xA
;
;#include "MPX4.h"
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;
; int numbers[16]={
;                   0X3F , 0X06 , 0X5B , 0X4F ,
;                   0X66 , 0X6D , 0X7D , 0X07 ,
;                   0X7F , 0X6F , 0X77 , 0X7C ,
;                   0X39 , 0X5E , 0X79 , 0X71
;                 };

	.DSEG
;
;int digit[4]= {112,176,208,224};
;int i1,j1;
;
;/////////////////counter/////////////////////
;void counter(int first, int last)
; 0001 000F {

	.CSEG
_counter:
; .FSTART _counter
; 0001 0010 
; 0001 0011     for(i1 = first ; i1<=last ; i1++)
	ST   -Y,R27
	ST   -Y,R26
;	first -> Y+2
;	last -> Y+0
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	STS  _i1,R30
	STS  _i1+1,R31
_0x20006:
	LD   R30,Y
	LDD  R31,Y+1
	CALL SUBOPT_0x19
	CP   R30,R26
	CPC  R31,R27
	BRLT _0x20007
; 0001 0012     {  j1=0;
	LDI  R30,LOW(0)
	STS  _j1,R30
	STS  _j1+1,R30
; 0001 0013 
; 0001 0014        while(j1<25){
_0x20008:
	LDS  R26,_j1
	LDS  R27,_j1+1
	SBIW R26,25
	BRGE _0x2000A
; 0001 0015           j1++;
	CALL SUBOPT_0x1A
; 0001 0016           PORTB = digit[0];
	LDS  R30,_digit
	OUT  0x18,R30
; 0001 0017           PORTC=numbers[i1%16];
	LDS  R30,_i1
	LDS  R31,_i1+1
	CALL SUBOPT_0x7
	CALL SUBOPT_0x1B
; 0001 0018           delay_ms(2);
; 0001 0019 
; 0001 001A           PORTB = digit[1];
	__GETB1MN _digit,2
	OUT  0x18,R30
; 0001 001B           PORTC=numbers[i1/16];
	CALL SUBOPT_0x19
	CALL SUBOPT_0x6
	CALL SUBOPT_0x1B
; 0001 001C           delay_ms(2);
; 0001 001D          }
	RJMP _0x20008
_0x2000A:
; 0001 001E 
; 0001 001F     }
	CALL SUBOPT_0x1C
	RJMP _0x20006
_0x20007:
; 0001 0020 
; 0001 0021 }
	ADIW R28,4
	RET
; .FEND
;
;/////////////////first_show/////////////////////////
;void first_show(int first , int last)
; 0001 0025 {
_first_show:
; .FSTART _first_show
; 0001 0026   int show = last;
; 0001 0027   int a = 0;
; 0001 0028 
; 0001 0029     j1=0;
	ST   -Y,R27
	ST   -Y,R26
	CALL __SAVELOCR4
;	first -> Y+6
;	last -> Y+4
;	show -> R16,R17
;	a -> R18,R19
	__GETWRS 16,17,4
	__GETWRN 18,19,0
	LDI  R30,LOW(0)
	STS  _j1,R30
	STS  _j1+1,R30
; 0001 002A 
; 0001 002B     while(j1<40){
_0x2000B:
	LDS  R26,_j1
	LDS  R27,_j1+1
	SBIW R26,40
	BRLT PC+2
	RJMP _0x2000D
; 0001 002C        j1++;
	CALL SUBOPT_0x1A
; 0001 002D          for(i1=0 ; i1<4 ; i1++){
	LDI  R30,LOW(0)
	STS  _i1,R30
	STS  _i1+1,R30
_0x2000F:
	CALL SUBOPT_0x19
	SBIW R26,4
	BRGE _0x20010
; 0001 002E 
; 0001 002F             PORTB = digit[i1];
	LDS  R30,_i1
	LDS  R31,_i1+1
	LDI  R26,LOW(_digit)
	LDI  R27,HIGH(_digit)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	OUT  0x18,R30
; 0001 0030             PORTC=numbers[show%16];
	MOVW R30,R16
	CALL SUBOPT_0x7
	LDI  R26,LOW(_numbers)
	LDI  R27,HIGH(_numbers)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	OUT  0x15,R30
; 0001 0031             show/=16;
	MOVW R26,R16
	CALL SUBOPT_0x6
	MOVW R16,R30
; 0001 0032             delay_ms(2);
	LDI  R26,LOW(2)
	LDI  R27,0
	CALL _delay_ms
; 0001 0033 
; 0001 0034             if(show==0 && a)
	CLR  R0
	CP   R0,R16
	CPC  R0,R17
	BRNE _0x20012
	MOV  R0,R18
	OR   R0,R19
	BRNE _0x20013
_0x20012:
	RJMP _0x20011
_0x20013:
; 0001 0035             {
; 0001 0036               show=last;
	__GETWRS 16,17,4
; 0001 0037               a = 0;
	__GETWRN 18,19,0
; 0001 0038             }
; 0001 0039 
; 0001 003A             if(show==0 &&!a)
_0x20011:
	CLR  R0
	CP   R0,R16
	CPC  R0,R17
	BRNE _0x20015
	MOV  R0,R18
	OR   R0,R19
	BREQ _0x20016
_0x20015:
	RJMP _0x20014
_0x20016:
; 0001 003B             {
; 0001 003C               show=first;
	__GETWRS 16,17,6
; 0001 003D               a = 1;
	__GETWRN 18,19,1
; 0001 003E             }
; 0001 003F 
; 0001 0040          }
_0x20014:
	CALL SUBOPT_0x1C
	RJMP _0x2000F
_0x20010:
; 0001 0041     }
	RJMP _0x2000B
_0x2000D:
; 0001 0042 
; 0001 0043 }
	CALL __LOADLOCR4
	ADIW R28,8
	RET
; .FEND
;#include "Keypad.h"
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;
;extern int i,j,flag;
;extern int b0,b1,b2;
;extern char ch[];
;extern int nu[16];
;
;////////////////F1///////////////////
;char F1(int num){
; 0002 0009 char F1(int num){

	.CSEG
_F1:
; .FSTART _F1
; 0002 000A     for (i=0;i<16;i++){
	ST   -Y,R27
	ST   -Y,R26
;	num -> Y+0
	LDI  R30,LOW(0)
	STS  _i,R30
	STS  _i+1,R30
_0x40004:
	LDS  R26,_i
	LDS  R27,_i+1
	SBIW R26,16
	BRGE _0x40005
; 0002 000B         if (num==nu[i]){
	LDS  R30,_i
	LDS  R31,_i+1
	LDI  R26,LOW(_nu)
	LDI  R27,HIGH(_nu)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	LD   R26,Y
	LDD  R27,Y+1
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x40006
; 0002 000C             return ch[i];
	LDS  R30,_i
	LDS  R31,_i+1
	SUBI R30,LOW(-_ch)
	SBCI R31,HIGH(-_ch)
	LD   R30,Z
	JMP  _0x2020002
; 0002 000D         }
; 0002 000E     }
_0x40006:
	LDI  R26,LOW(_i)
	LDI  R27,HIGH(_i)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RJMP _0x40004
_0x40005:
; 0002 000F }
	JMP  _0x2020002
; .FEND
;
;
;////////////////start///////////////////
;int start(){
; 0002 0013 int start(){
_start:
; .FSTART _start
; 0002 0014         PORTD.0=0;
	CBI  0x12,0
; 0002 0015         PORTD.1=1;
	SBI  0x12,1
; 0002 0016         PORTD.4=1;
	SBI  0x12,4
; 0002 0017         PORTD.5=1;
	SBI  0x12,5
; 0002 0018         if (b0==1 || b1==1 || b2==1)
	CALL SUBOPT_0x1
	BREQ _0x40010
	CALL SUBOPT_0x1D
	BREQ _0x40010
	CALL SUBOPT_0x2
	BRNE _0x4000F
_0x40010:
; 0002 0019         return 14;
	LDI  R30,LOW(14)
	LDI  R31,HIGH(14)
	RET
; 0002 001A         //////--------------
; 0002 001B         PORTD.0=1;
_0x4000F:
	SBI  0x12,0
; 0002 001C         PORTD.1=0;
	CBI  0x12,1
; 0002 001D         PORTD.4=1;
	SBI  0x12,4
; 0002 001E         PORTD.5=1;
	SBI  0x12,5
; 0002 001F         if (b0==1 || b1==1 || b2==1)
	CALL SUBOPT_0x1
	BREQ _0x4001B
	CALL SUBOPT_0x1D
	BREQ _0x4001B
	CALL SUBOPT_0x2
	BRNE _0x4001A
_0x4001B:
; 0002 0020         return 13;
	LDI  R30,LOW(13)
	LDI  R31,HIGH(13)
	RET
; 0002 0021         //////--------------
; 0002 0022         PORTD.0=1;
_0x4001A:
	SBI  0x12,0
; 0002 0023         PORTD.1=1;
	SBI  0x12,1
; 0002 0024         PORTD.4=0;
	CBI  0x12,4
; 0002 0025         PORTD.5=1;
	SBI  0x12,5
; 0002 0026         if (b0==1 || b1==1 || b2==1)
	CALL SUBOPT_0x1
	BREQ _0x40026
	CALL SUBOPT_0x1D
	BREQ _0x40026
	CALL SUBOPT_0x2
	BRNE _0x40025
_0x40026:
; 0002 0027         return 11;
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	RET
; 0002 0028         //////--------------
; 0002 0029         PORTD.0=1;
_0x40025:
	SBI  0x12,0
; 0002 002A         PORTD.1=1;
	SBI  0x12,1
; 0002 002B         PORTD.4=1;
	SBI  0x12,4
; 0002 002C         PORTD.5=0;
	CBI  0x12,5
; 0002 002D         if (b0==1 || b1==1 || b2==1)
	CALL SUBOPT_0x1
	BREQ _0x40031
	CALL SUBOPT_0x1D
	BREQ _0x40031
	CALL SUBOPT_0x2
	BRNE _0x40030
_0x40031:
; 0002 002E         return 7;
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	RET
; 0002 002F 
; 0002 0030 
; 0002 0031 }
_0x40030:
	RET
; .FEND
;
;////////////////Fj///////////////////
;void Fj(int j){
; 0002 0034 void Fj(int j){
_Fj:
; .FSTART _Fj
; 0002 0035       if (j>=0){
	ST   -Y,R27
	ST   -Y,R26
;	j -> Y+0
	LDD  R26,Y+1
	TST  R26
	BRMI _0x40033
; 0002 0036             i=0;
	LDI  R30,LOW(0)
	STS  _i,R30
	STS  _i+1,R30
; 0002 0037             i=j;
	LD   R30,Y
	LDD  R31,Y+1
	STS  _i,R30
	STS  _i+1,R31
; 0002 0038             j=-1;
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   Y,R30
	STD  Y+1,R31
; 0002 0039       }
; 0002 003A       delay_ms(5);
_0x40033:
	LDI  R26,LOW(5)
	LDI  R27,0
	CALL _delay_ms
; 0002 003B }
	JMP  _0x2020002
; .FEND
;
;
;////////////////Fch///////////////////
;void Fch(int count){
; 0002 003F void Fch(int count){
_Fch:
; .FSTART _Fch
; 0002 0040         flag=0;
	ST   -Y,R27
	ST   -Y,R26
;	count -> Y+0
	LDI  R30,LOW(0)
	STS  _flag,R30
	STS  _flag+1,R30
; 0002 0041         if (count==14){
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,14
	BRNE _0x40034
; 0002 0042             if (b0==1 && b1==1){
	CALL SUBOPT_0x1
	BRNE _0x40036
	CALL SUBOPT_0x1D
	BREQ _0x40037
_0x40036:
	RJMP _0x40035
_0x40037:
; 0002 0043                 j=flag;
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x1F
; 0002 0044                 b0=0;
; 0002 0045                 b1=0;
	CALL SUBOPT_0x20
; 0002 0046                 Fj(j);
; 0002 0047                 return;
	JMP  _0x2020002
; 0002 0048             }
; 0002 0049             else if (b0==1){
_0x40035:
	CALL SUBOPT_0x1
	BRNE _0x40039
; 0002 004A                 j=flag+1;
	CALL SUBOPT_0x21
; 0002 004B                 b0=0;
; 0002 004C                 Fj(j);
	CALL SUBOPT_0x22
; 0002 004D                 return;
	JMP  _0x2020002
; 0002 004E             }
; 0002 004F             else if (b1==1){
_0x40039:
	CALL SUBOPT_0x1D
	BRNE _0x4003B
; 0002 0050                 j=flag+2;
	CALL SUBOPT_0x23
; 0002 0051                 b1=0;
; 0002 0052                 Fj(j);
; 0002 0053                 return;
	JMP  _0x2020002
; 0002 0054             }
; 0002 0055             else if (b2==1){
_0x4003B:
	CALL SUBOPT_0x2
	BRNE _0x4003D
; 0002 0056                 j=flag+3;
	CALL SUBOPT_0x24
; 0002 0057                 b2=0;
; 0002 0058                 Fj(j);
; 0002 0059                 return;
	JMP  _0x2020002
; 0002 005A             }
; 0002 005B         }
_0x4003D:
; 0002 005C 
; 0002 005D         else if (count==13){
	RJMP _0x4003E
_0x40034:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,13
	BRNE _0x4003F
; 0002 005E             flag=4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0x25
; 0002 005F             if (b0==1 && b1==1){
	BRNE _0x40041
	CALL SUBOPT_0x1D
	BREQ _0x40042
_0x40041:
	RJMP _0x40040
_0x40042:
; 0002 0060                 j=flag;
	CALL SUBOPT_0x26
; 0002 0061                 b0=0;
; 0002 0062                 b1=0;
	CALL SUBOPT_0x20
; 0002 0063                 Fj(j);
; 0002 0064                 return;
	JMP  _0x2020002
; 0002 0065             }
; 0002 0066             else if (b0==1){
_0x40040:
	CALL SUBOPT_0x1
	BRNE _0x40044
; 0002 0067                 j=flag+1;
	CALL SUBOPT_0x21
; 0002 0068                 b0=0;
; 0002 0069                 Fj(j);
	CALL SUBOPT_0x22
; 0002 006A                 return;
	JMP  _0x2020002
; 0002 006B             }
; 0002 006C             else if (b1==1){
_0x40044:
	CALL SUBOPT_0x1D
	BRNE _0x40046
; 0002 006D                 j=flag+2;
	CALL SUBOPT_0x23
; 0002 006E                 b1=0;
; 0002 006F                 Fj(j);
; 0002 0070                 return;
	JMP  _0x2020002
; 0002 0071             }
; 0002 0072             else if (b2==1){
_0x40046:
	CALL SUBOPT_0x2
	BRNE _0x40048
; 0002 0073                 j=flag+3;
	CALL SUBOPT_0x24
; 0002 0074                 b2=0;
; 0002 0075                 Fj(j);
; 0002 0076                 return;
	JMP  _0x2020002
; 0002 0077             }
; 0002 0078         }
_0x40048:
; 0002 0079         else if (count==11){
	RJMP _0x40049
_0x4003F:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,11
	BRNE _0x4004A
; 0002 007A             flag=8;
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL SUBOPT_0x25
; 0002 007B             if (b0==1 && b1==1){
	BRNE _0x4004C
	CALL SUBOPT_0x1D
	BREQ _0x4004D
_0x4004C:
	RJMP _0x4004B
_0x4004D:
; 0002 007C                 j=flag;
	CALL SUBOPT_0x26
; 0002 007D                 b0=0;
; 0002 007E                 b1=0;
	CALL SUBOPT_0x20
; 0002 007F                 Fj(j);
; 0002 0080                 return;
	JMP  _0x2020002
; 0002 0081             }
; 0002 0082             else if (b0==1){
_0x4004B:
	CALL SUBOPT_0x1
	BRNE _0x4004F
; 0002 0083                 j=flag+1;
	CALL SUBOPT_0x21
; 0002 0084                 b0=0;
; 0002 0085                 Fj(j);
	CALL SUBOPT_0x22
; 0002 0086                 return;
	JMP  _0x2020002
; 0002 0087             }
; 0002 0088             else if (b1==1){
_0x4004F:
	CALL SUBOPT_0x1D
	BRNE _0x40051
; 0002 0089                 j=flag+2;
	CALL SUBOPT_0x23
; 0002 008A                 b1=0;
; 0002 008B                 Fj(j);
; 0002 008C                 return;
	JMP  _0x2020002
; 0002 008D             }
; 0002 008E             else if (b2==1){
_0x40051:
	CALL SUBOPT_0x2
	BRNE _0x40053
; 0002 008F                 j=flag+3;
	CALL SUBOPT_0x24
; 0002 0090                 b2=0;
; 0002 0091                 Fj(j);
; 0002 0092                 return;
	JMP  _0x2020002
; 0002 0093             }
; 0002 0094         }
_0x40053:
; 0002 0095 
; 0002 0096         else if (count==7){
	RJMP _0x40054
_0x4004A:
	LD   R26,Y
	LDD  R27,Y+1
	SBIW R26,7
	BRNE _0x40055
; 0002 0097             flag=12;
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	CALL SUBOPT_0x25
; 0002 0098             if (b0==1 && b1==1){
	BRNE _0x40057
	CALL SUBOPT_0x1D
	BREQ _0x40058
_0x40057:
	RJMP _0x40056
_0x40058:
; 0002 0099                 j=flag;
	CALL SUBOPT_0x26
; 0002 009A                 b0=0;
; 0002 009B                 b1=0;
	CALL SUBOPT_0x20
; 0002 009C                 Fj(j);
; 0002 009D                 return;
	JMP  _0x2020002
; 0002 009E             }
; 0002 009F             else if (b0==1){
_0x40056:
	CALL SUBOPT_0x1
	BRNE _0x4005A
; 0002 00A0                 j=flag+1;
	CALL SUBOPT_0x21
; 0002 00A1                 b0=0;
; 0002 00A2                 Fj(j);
	CALL SUBOPT_0x22
; 0002 00A3                 return;
	JMP  _0x2020002
; 0002 00A4             }
; 0002 00A5             else if (b1==1){
_0x4005A:
	CALL SUBOPT_0x1D
	BRNE _0x4005C
; 0002 00A6                 j=flag+2;
	CALL SUBOPT_0x23
; 0002 00A7                 b1=0;
; 0002 00A8                 Fj(j);
; 0002 00A9                 return;
	JMP  _0x2020002
; 0002 00AA             }
; 0002 00AB             else if (b2==1){
_0x4005C:
	CALL SUBOPT_0x2
	BRNE _0x4005E
; 0002 00AC                 j=flag+3;
	CALL SUBOPT_0x24
; 0002 00AD                 b2=0;
; 0002 00AE                 Fj(j);
; 0002 00AF                 return;
	JMP  _0x2020002
; 0002 00B0             }
; 0002 00B1         }
_0x4005E:
; 0002 00B2 }
_0x40055:
_0x40054:
_0x40049:
_0x4003E:
	JMP  _0x2020002
; .FEND
;
;
;/////////////interrupt///////////////////
;interrupt [EXT_INT2] void my_inter2(void)
; 0002 00B7 {
_my_inter2:
; .FSTART _my_inter2
	CALL SUBOPT_0x27
; 0002 00B8      b2=1;
	STS  _b2,R30
	STS  _b2+1,R31
; 0002 00B9      delay_ms(50);
	RJMP _0x4005F
; 0002 00BA }
; .FEND
;interrupt [EXT_INT1] void my_inter1(void)
; 0002 00BC {
_my_inter1:
; .FSTART _my_inter1
	CALL SUBOPT_0x27
; 0002 00BD     b1=1;
	STS  _b1,R30
	STS  _b1+1,R31
; 0002 00BE     delay_ms(50);
	RJMP _0x4005F
; 0002 00BF 
; 0002 00C0 }
; .FEND
;
;
;interrupt [EXT_INT0] void my_inter0(void)
; 0002 00C4 {
_my_inter0:
; .FSTART _my_inter0
	CALL SUBOPT_0x27
; 0002 00C5     b0=1;
	STS  _b0,R30
	STS  _b0+1,R31
; 0002 00C6     delay_ms(50);
_0x4005F:
	LDI  R26,LOW(50)
	LDI  R27,0
	CALL _delay_ms
; 0002 00C7 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;#include "LCD.h"
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include "Keypad.h"
;
;extern int n1,n2,n3,n4;
;extern int x,y;
;extern char ch10 ,ch01 , ch[];
;
;////////////////sh_FZ///////////////////
;void sh_FZ(int num){
; 0003 0009 void sh_FZ(int num){

	.CSEG
_sh_FZ:
; .FSTART _sh_FZ
; 0003 000A             n1=num%16;
	ST   -Y,R27
	ST   -Y,R26
;	num -> Y+0
	LD   R30,Y
	LDD  R31,Y+1
	RCALL SUBOPT_0x7
	MOVW R8,R30
; 0003 000B             ch01=F1(n1);
	MOVW R26,R8
	RCALL _F1
	MOV  R5,R30
; 0003 000C             n2=num/16;
	LD   R26,Y
	LDD  R27,Y+1
	RCALL SUBOPT_0x6
	MOVW R10,R30
; 0003 000D             ch10=F1(n2);
	MOVW R26,R10
	RCALL _F1
	MOV  R4,R30
; 0003 000E             lcd_gotoxy(x,y);
	RCALL SUBOPT_0xE
; 0003 000F             lcd_putchar(ch10);
	MOV  R26,R4
	RCALL SUBOPT_0x17
; 0003 0010             x++;
; 0003 0011             lcd_putchar(ch01);
	MOV  R26,R5
	RCALL _lcd_putchar
; 0003 0012 }
	RJMP _0x2020002
; .FEND
;
;////////////////show///////////////////
;void show(int j){
; 0003 0015 void show(int j){
_show:
; .FSTART _show
; 0003 0016 
; 0003 0017     lcd_gotoxy(x,y);
	ST   -Y,R27
	ST   -Y,R26
;	j -> Y+0
	RCALL SUBOPT_0xE
; 0003 0018     lcd_putchar(ch[j]);
	LD   R30,Y
	LDD  R31,Y+1
	SUBI R30,LOW(-_ch)
	SBCI R31,HIGH(-_ch)
	LD   R26,Z
	RCALL _lcd_putchar
; 0003 0019     delay_ms(50);
	LDI  R26,LOW(50)
	LDI  R27,0
	CALL _delay_ms
; 0003 001A     j=-1;
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   Y,R30
	STD  Y+1,R31
; 0003 001B     if (x==15 && y==1){
	RCALL SUBOPT_0xF
	BRNE _0x60004
	LDS  R26,_y
	LDS  R27,_y+1
	SBIW R26,1
	BREQ _0x60005
_0x60004:
	RJMP _0x60003
_0x60005:
; 0003 001C         lcd_clear();
	RCALL _lcd_clear
; 0003 001D         x=-1;
	RCALL SUBOPT_0x12
; 0003 001E         y=0;
	RCALL SUBOPT_0x15
; 0003 001F     }
; 0003 0020         if (x==15){
_0x60003:
	RCALL SUBOPT_0xF
	BRNE _0x60006
; 0003 0021         x=-1;
	RCALL SUBOPT_0x12
; 0003 0022         y+=1;
	RCALL SUBOPT_0x13
; 0003 0023         }
; 0003 0024         x++;
_0x60006:
	RCALL SUBOPT_0x14
; 0003 0025 }
	RJMP _0x2020002
; .FEND
;
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G100:
; .FSTART __lcd_write_nibble_G100
	ST   -Y,R26
	IN   R30,0x1B
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x1B,R30
	__DELAY_USB 13
	SBI  0x1B,2
	__DELAY_USB 13
	CBI  0x1B,2
	__DELAY_USB 13
	RJMP _0x2020001
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
	__DELAY_USB 133
	RJMP _0x2020001
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
_0x2020002:
	ADIW R28,2
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	RCALL SUBOPT_0x28
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	RCALL SUBOPT_0x28
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2000005
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2000004
_0x2000005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R26,__lcd_y
	SUBI R26,-LOW(1)
	STS  __lcd_y,R26
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2000007
	RJMP _0x2020001
_0x2000007:
_0x2000004:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
	SBI  0x1B,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x1B,0
	RJMP _0x2020001
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2000008:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x200000A
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2000008
_0x200000A:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
	IN   R30,0x1A
	ORI  R30,LOW(0xF0)
	OUT  0x1A,R30
	SBI  0x1A,2
	SBI  0x1A,0
	SBI  0x1A,1
	CBI  0x1B,2
	CBI  0x1B,0
	CBI  0x1B,1
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	RCALL SUBOPT_0x29
	RCALL SUBOPT_0x29
	RCALL SUBOPT_0x29
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 200
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x2020001:
	ADIW R28,1
	RET
; .FEND

	.DSEG
_ch:
	.BYTE 0x11
_nu:
	.BYTE 0x20
_tempZF_Z:
	.BYTE 0x2
_tempZF_F:
	.BYTE 0x2
_tempFZ_Z:
	.BYTE 0x2
_tempFZ_F:
	.BYTE 0x2
_ZF:
	.BYTE 0x2
_FZ:
	.BYTE 0x2
_MAX:
	.BYTE 0x2
_MIN:
	.BYTE 0x2
_flagFZ:
	.BYTE 0x2
_flagZF:
	.BYTE 0x2
_b0:
	.BYTE 0x2
_b1:
	.BYTE 0x2
_b2:
	.BYTE 0x2
_i:
	.BYTE 0x2
_j:
	.BYTE 0x2
_flag:
	.BYTE 0x2
_x:
	.BYTE 0x2
_y:
	.BYTE 0x2
_r1:
	.BYTE 0x2
_r0:
	.BYTE 0x2
_ra1:
	.BYTE 0x2
_ra0:
	.BYTE 0x2
_rf:
	.BYTE 0x2
_t:
	.BYTE 0x2
_boo1:
	.BYTE 0x2
_numbers:
	.BYTE 0x20
_digit:
	.BYTE 0x8
_i1:
	.BYTE 0x2
_j1:
	.BYTE 0x2
__base_y_G100:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	CALL _start
	MOVW R6,R30
	LDS  R26,_b1
	LDS  R27,_b1+1
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:36 WORDS
SUBOPT_0x1:
	LDS  R26,_b0
	LDS  R27,_b0+1
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x2:
	LDS  R26,_b2
	LDS  R27,_b2+1
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x3:
	LDS  R26,_i
	LDS  R27,_i+1
	RCALL _show
	LDS  R30,_i
	LDS  R31,_i+1
	LDI  R26,LOW(_nu)
	LDI  R27,HIGH(_nu)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4:
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	STS  _i,R30
	STS  _i+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	LDS  R26,_boo1
	LDS  R27,_boo1+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	CALL __DIVW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x7:
	LDI  R26,LOW(15)
	LDI  R27,HIGH(15)
	CALL __MANDW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8:
	LDS  R26,_ra1
	LDS  R27,_ra1+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __MODW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA:
	LDS  R26,_ra0
	LDS  R27,_ra0+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:28 WORDS
SUBOPT_0xB:
	LDI  R30,LOW(0)
	STS  _rf,R30
	STS  _rf+1,R30
	LDS  R30,_ra1
	LDS  R31,_ra1+1
	CALL __LSLW4
	STS  _rf,R30
	STS  _rf+1,R31
	LDS  R30,_ra0
	LDS  R31,_ra0+1
	LDS  R26,_rf
	LDS  R27,_rf+1
	ADD  R30,R26
	ADC  R31,R27
	STS  _rf,R30
	STS  _rf+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	LDS  R26,_rf
	LDS  R27,_rf+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	LDS  R30,_MIN
	LDS  R31,_MIN+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0xE:
	LDS  R30,_x
	ST   -Y,R30
	LDS  R26,_y
	RJMP _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xF:
	LDS  R26,_x
	LDS  R27,_x+1
	SBIW R26,15
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10:
	STS  _y,R30
	STS  _y+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x11:
	LDI  R30,LOW(0)
	STS  _x,R30
	STS  _x+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x12:
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	STS  _x,R30
	STS  _x+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x13:
	LDS  R30,_y
	LDS  R31,_y+1
	ADIW R30,1
	RJMP SUBOPT_0x10

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x14:
	LDI  R26,LOW(_x)
	LDI  R27,HIGH(_x)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x15:
	LDI  R30,LOW(0)
	STS  _y,R30
	STS  _y+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x16:
	RCALL _lcd_puts
	LDS  R30,_x
	LDS  R31,_x+1
	ADIW R30,4
	STS  _x,R30
	STS  _x+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	RCALL _lcd_putchar
	RJMP SUBOPT_0x14

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x18:
	RCALL SUBOPT_0xD
	ST   -Y,R31
	ST   -Y,R30
	LDS  R26,_MAX
	LDS  R27,_MAX+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x19:
	LDS  R26,_i1
	LDS  R27,_i1+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1A:
	LDI  R26,LOW(_j1)
	LDI  R27,HIGH(_j1)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1B:
	LDI  R26,LOW(_numbers)
	LDI  R27,HIGH(_numbers)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	OUT  0x15,R30
	LDI  R26,LOW(2)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1C:
	LDI  R26,LOW(_i1)
	LDI  R27,HIGH(_i1)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:30 WORDS
SUBOPT_0x1D:
	LDS  R26,_b1
	LDS  R27,_b1+1
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x1E:
	LDS  R30,_flag
	LDS  R31,_flag+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:46 WORDS
SUBOPT_0x1F:
	STS  _j,R30
	STS  _j+1,R31
	LDI  R30,LOW(0)
	STS  _b0,R30
	STS  _b0+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:60 WORDS
SUBOPT_0x20:
	LDI  R30,LOW(0)
	STS  _b1,R30
	STS  _b1+1,R30
	LDS  R26,_j
	LDS  R27,_j+1
	JMP  _Fj

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x21:
	RCALL SUBOPT_0x1E
	ADIW R30,1
	RJMP SUBOPT_0x1F

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x22:
	LDS  R26,_j
	LDS  R27,_j+1
	JMP  _Fj

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x23:
	RCALL SUBOPT_0x1E
	ADIW R30,2
	STS  _j,R30
	STS  _j+1,R31
	RJMP SUBOPT_0x20

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x24:
	RCALL SUBOPT_0x1E
	ADIW R30,3
	STS  _j,R30
	STS  _j+1,R31
	LDI  R30,LOW(0)
	STS  _b2,R30
	STS  _b2+1,R30
	RJMP SUBOPT_0x22

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x25:
	STS  _flag,R30
	STS  _flag+1,R31
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x26:
	RCALL SUBOPT_0x1E
	RJMP SUBOPT_0x1F

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x27:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x28:
	RCALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x29:
	LDI  R26,LOW(48)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 200
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__LSLW4:
	LSL  R30
	ROL  R31
__LSLW3:
	LSL  R30
	ROL  R31
__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__MANDW12:
	CLT
	SBRS R31,7
	RJMP __MANDW121
	RCALL __ANEGW1
	SET
__MANDW121:
	AND  R30,R26
	AND  R31,R27
	BRTC __MANDW122
	RCALL __ANEGW1
__MANDW122:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
