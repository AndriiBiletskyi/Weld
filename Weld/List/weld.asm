
;CodeVisionAVR C Compiler V2.05.3 Standard
;(C) Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega64A
;Program type             : Application
;Clock frequency          : 16,000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 1024 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;Global 'const' stored in FLASH     : No
;Enhanced function parameter passing: Yes
;Enhanced core instructions         : On
;Smart register allocation          : On
;Automatic register allocation      : On

	#pragma AVRPART ADMIN PART_NAME ATmega64A
	#pragma AVRPART MEMORY PROG_FLASH 65536
	#pragma AVRPART MEMORY EEPROM 2048
	#pragma AVRPART MEMORY INT_SRAM SIZE 4351
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

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
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU XMCRA=0x6D
	.EQU XMCRB=0x6C

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

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x10FF
	.EQU __DSTACK_SIZE=0x0400
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
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
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
	.DEF _enable=R5

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _ext_int4_isr
	JMP  0x00
	JMP  _ext_int6_isr
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

_digit_G000:
	.DB  0x3F,0x6,0x5B,0x4F,0x66,0x6D,0x7D,0x7
	.DB  0x7F,0x6F

_0x1B:
	.DB  0x1
_0x2B:
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  _num_S0000001000
	.DW  _0x1B*2

	.DW  0x01
	.DW  0x05
	.DW  _0x2B*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30
	STS  XMCRB,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

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
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
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
	.ORG 0x500

	.CSEG
;/*****************************************************
;Chip type               : ATmega64A
;Program type            : Application
;AVR Core Clock frequency: 16,000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 1024
;*****************************************************/
;
;#include <mega64a.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;
;#define A           (PINE.5==1)
;#define LEFT        (PIND.5==0)
;#define RIGHT       (PIND.4==0)
;#define TASK_MAX    300
;#define REF_PLUS    PORTD&=~(1<<7);
;#define REF_MINUS   PORTD|=(1<<7);
;#define FEED_MAX    999
;#define FEED_MIN    0
;#define FEED_UP     (PIND.2==0)
;#define FEED_DOWN   (PIND.3==0)
;#define FEED_STEP   10
;#define JOG_PLUS    (PIND.0==0)
;#define JOG_MINUS   (PIND.1==0)
;#define JOG_RAPID   (PIND.6==0)
;#define SPEED_RAPID 512
;#define SPEED_WORK  256
;
;
;static flash unsigned char digit[]={
;    0b00111111, //0
;    0b00000110, //1
;    0b01011011, //2
;    0b01001111, //3
;    0b01100110, //4
;    0b01101101, //5
;    0b01111101, //6
;    0b00000111, //7
;    0b01111111, //8
;    0b01101111  //9
;};
;char enable = 0;
;float set_position = 0;
;long int current_position = 0;
;float feed = 0;
;eeprom int feed_eep;
;
;
;void sem_seg(int a);//show feed value
;void init(void);
;interrupt [EXT_INT4] void ext_int4_isr(void);//set position from spindel's encoder
;interrupt [EXT_INT6] void ext_int6_isr(void);//current position from axis's encoder
;void move(long int task);
;void buttons(void);
;
;
;void main(void)
; 0000 003B {

	.CSEG
_main:
; 0000 003C     init();
	RCALL _init
; 0000 003D     feed = feed_eep/100;
	LDI  R26,LOW(_feed_eep)
	LDI  R27,HIGH(_feed_eep)
	CALL __EEPROMRDW
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21
	LDI  R26,LOW(_feed)
	LDI  R27,HIGH(_feed)
	RCALL SUBOPT_0x0
; 0000 003E     sem_seg(feed_eep);
	LDI  R26,LOW(_feed_eep)
	LDI  R27,HIGH(_feed_eep)
	CALL __EEPROMRDW
	MOVW R26,R30
	RCALL _sem_seg
; 0000 003F 
; 0000 0040     while(1)
_0x3:
; 0000 0041     {
; 0000 0042         if(LEFT || RIGHT){
	LDI  R26,0
	SBIC 0x10,5
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BREQ _0x7
	LDI  R26,0
	SBIC 0x10,4
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE _0x6
_0x7:
; 0000 0043             enable = 1;
	LDI  R30,LOW(1)
	MOV  R5,R30
; 0000 0044             while(LEFT || RIGHT){
_0x9:
	LDI  R26,0
	SBIC 0x10,5
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BREQ _0xC
	LDI  R26,0
	SBIC 0x10,4
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE _0xB
_0xC:
; 0000 0045                 move(set_position - current_position);
	RCALL SUBOPT_0x1
; 0000 0046                 buttons();
	RCALL _buttons
; 0000 0047             }
	RJMP _0x9
_0xB:
; 0000 0048             move(0);
	__GETD2N 0x0
	RCALL _move
; 0000 0049             enable = 0;
	CLR  R5
; 0000 004A             delay_ms(100);
	LDI  R26,LOW(100)
	RCALL SUBOPT_0x2
; 0000 004B             current_position = 0;
	RCALL SUBOPT_0x3
; 0000 004C             set_position = 0;
; 0000 004D         }
; 0000 004E 
; 0000 004F         if(JOG_PLUS || JOG_MINUS){
_0x6:
	LDI  R26,0
	SBIC 0x10,0
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BREQ _0xF
	LDI  R26,0
	SBIC 0x10,1
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE _0xE
_0xF:
; 0000 0050             #asm("cli")
	cli
; 0000 0051             if(JOG_PLUS){
	SBIC 0x10,0
	RJMP _0x11
; 0000 0052                 REF_PLUS
	CBI  0x12,7
; 0000 0053             }else {
	RJMP _0x12
_0x11:
; 0000 0054                 REF_MINUS
	SBI  0x12,7
; 0000 0055             }
_0x12:
; 0000 0056             while(JOG_PLUS || JOG_MINUS){
_0x13:
	LDI  R26,0
	SBIC 0x10,0
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BREQ _0x16
	LDI  R26,0
	SBIC 0x10,1
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE _0x15
_0x16:
; 0000 0057                 if(JOG_RAPID){
	SBIC 0x10,6
	RJMP _0x18
; 0000 0058                     move(SPEED_RAPID);
	__GETD2N 0x200
	RJMP _0x29
; 0000 0059                 }else {
_0x18:
; 0000 005A                     move(SPEED_WORK);
	__GETD2N 0x100
_0x29:
	RCALL _move
; 0000 005B                 }
; 0000 005C             }
	RJMP _0x13
_0x15:
; 0000 005D             current_position = 0;
	RCALL SUBOPT_0x3
; 0000 005E             set_position = 0;
; 0000 005F             #asm("sei")
	sei
; 0000 0060         }
; 0000 0061 
; 0000 0062         buttons();
_0xE:
	RCALL _buttons
; 0000 0063         move(set_position - current_position);
	RCALL SUBOPT_0x1
; 0000 0064     }
	RJMP _0x3
; 0000 0065 }
_0x1A:
	RJMP _0x1A
;//----------------------------------------------------
;//
;//----------------------------------------------------
;void buttons(void)
; 0000 006A {
_buttons:
; 0000 006B     static float feed_show = 0;
; 0000 006C     static char num = 1;

	.DSEG

	.CSEG
; 0000 006D     if(num){
	LDS  R30,_num_S0000001000
	CPI  R30,0
	BREQ _0x1C
; 0000 006E         feed_show = feed_eep;
	LDI  R26,LOW(_feed_eep)
	LDI  R27,HIGH(_feed_eep)
	CALL __EEPROMRDW
	LDI  R26,LOW(_feed_show_S0000001000)
	LDI  R27,HIGH(_feed_show_S0000001000)
	RCALL SUBOPT_0x0
; 0000 006F         num = 0;
	LDI  R30,LOW(0)
	STS  _num_S0000001000,R30
; 0000 0070     }
; 0000 0071 
; 0000 0072     if(FEED_UP){
_0x1C:
	SBIC 0x10,2
	RJMP _0x1D
; 0000 0073         feed_show += FEED_STEP;
	RCALL SUBOPT_0x4
	__GETD2N 0x41200000
	CALL __ADDF12
	RCALL SUBOPT_0x5
; 0000 0074         if(feed_show>FEED_MAX)
	RCALL SUBOPT_0x6
	__GETD1N 0x4479C000
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+3
	JMP  _0x1E
; 0000 0075             feed_show = FEED_MAX;
	RCALL SUBOPT_0x5
; 0000 0076         feed = feed_show/100;
_0x1E:
	RCALL SUBOPT_0x7
; 0000 0077         sem_seg(feed_show);
; 0000 0078         delay_ms(200);
; 0000 0079         feed_eep = feed_show;
	RCALL SUBOPT_0x8
; 0000 007A      }
; 0000 007B      if(FEED_DOWN){
_0x1D:
	SBIC 0x10,3
	RJMP _0x1F
; 0000 007C         feed_show -= FEED_STEP;
	RCALL SUBOPT_0x4
	__GETD2N 0x41200000
	CALL __SUBF12
	RCALL SUBOPT_0x5
; 0000 007D         if(feed_show<FEED_MIN)
	LDS  R26,_feed_show_S0000001000+3
	TST  R26
	BRPL _0x20
; 0000 007E             feed_show = FEED_MIN;
	LDI  R30,LOW(0)
	STS  _feed_show_S0000001000,R30
	STS  _feed_show_S0000001000+1,R30
	STS  _feed_show_S0000001000+2,R30
	STS  _feed_show_S0000001000+3,R30
; 0000 007F         feed = feed_show/100;
_0x20:
	RCALL SUBOPT_0x7
; 0000 0080         sem_seg(feed_show);
; 0000 0081         delay_ms(200);
; 0000 0082         feed_eep = feed_show;
	RCALL SUBOPT_0x8
; 0000 0083      }
; 0000 0084 }
_0x1F:
	RET
;//----------------------------------------------------
;//
;//----------------------------------------------------
;void sem_seg(int a)
; 0000 0089 {
_sem_seg:
; 0000 008A     PORTC = digit[a%10];
	ST   -Y,R27
	ST   -Y,R26
;	a -> Y+0
	LD   R26,Y
	LDD  R27,Y+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	SUBI R30,LOW(-_digit_G000*2)
	SBCI R31,HIGH(-_digit_G000*2)
	LPM  R0,Z
	OUT  0x15,R0
; 0000 008B     PORTB = digit[(a%100)/10];
	LD   R26,Y
	LDD  R27,Y+1
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __MODW21
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	SUBI R30,LOW(-_digit_G000*2)
	SBCI R31,HIGH(-_digit_G000*2)
	LPM  R0,Z
	OUT  0x18,R0
; 0000 008C     PORTA = digit[(a%1000)/100];
	LD   R26,Y
	LDD  R27,Y+1
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL __MODW21
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21
	SUBI R30,LOW(-_digit_G000*2)
	SBCI R31,HIGH(-_digit_G000*2)
	LPM  R0,Z
	OUT  0x1B,R0
; 0000 008D }
	ADIW R28,2
	RET
;//----------------------------------------------------
;//
;//----------------------------------------------------
;void move(long int task)
; 0000 0092 {
_move:
; 0000 0093     if(task>0){
	CALL __PUTPARD2
;	task -> Y+0
	RCALL SUBOPT_0x9
	CALL __CPD02
	BRGE _0x21
; 0000 0094         REF_PLUS
	CBI  0x12,7
; 0000 0095     }
; 0000 0096     if(task<0){
_0x21:
	LDD  R26,Y+3
	TST  R26
	BRPL _0x22
; 0000 0097         REF_MINUS
	SBI  0x12,7
; 0000 0098         task *= -1;
	CALL __GETD1S0
	__GETD2N 0xFFFFFFFF
	CALL __MULD12
	RCALL SUBOPT_0xA
; 0000 0099     }
; 0000 009A     if(task>TASK_MAX)
_0x22:
	RCALL SUBOPT_0x9
	__CPD2N 0x12D
	BRLT _0x23
; 0000 009B         task = TASK_MAX;
	__GETD1N 0x12C
	RCALL SUBOPT_0xA
; 0000 009C 
; 0000 009D     PORTF = task;
_0x23:
	LD   R30,Y
	STS  98,R30
; 0000 009E     task = (task>>8);
	RCALL SUBOPT_0x9
	LDI  R30,LOW(8)
	CALL __ASRD12
	RCALL SUBOPT_0xA
; 0000 009F     PORTG = task;
	LD   R30,Y
	STS  101,R30
; 0000 00A0 }
	ADIW R28,4
	RET
;//----------------------------------------------------
;//
;//----------------------------------------------------
;interrupt [EXT_INT6] void ext_int6_isr(void)
; 0000 00A5 {
_ext_int6_isr:
	ST   -Y,R0
	ST   -Y,R1
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
; 0000 00A6     if(enable){
	TST  R5
	BREQ _0x24
; 0000 00A7         if(RIGHT){
	SBIC 0x10,4
	RJMP _0x25
; 0000 00A8             set_position += feed/2.5;
	RCALL SUBOPT_0xB
	CALL __ADDF12
	RCALL SUBOPT_0xC
; 0000 00A9         }
; 0000 00AA         if(LEFT){
_0x25:
	SBIC 0x10,5
	RJMP _0x26
; 0000 00AB             set_position -= feed/2.5;
	RCALL SUBOPT_0xB
	CALL __SWAPD12
	CALL __SUBF12
	RCALL SUBOPT_0xC
; 0000 00AC         }
; 0000 00AD     }
_0x26:
; 0000 00AE }
_0x24:
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
	LD   R1,Y+
	LD   R0,Y+
	RETI
;//----------------------------------------------------
;//
;//----------------------------------------------------
;interrupt [EXT_INT4] void ext_int4_isr(void)
; 0000 00B3 {
_ext_int4_isr:
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 00B4         if(!A){
	SBIC 0x1,5
	RJMP _0x27
; 0000 00B5             current_position++;
	LDI  R26,LOW(_current_position)
	LDI  R27,HIGH(_current_position)
	CALL __GETD1P_INC
	__SUBD1N -1
	RJMP _0x2A
; 0000 00B6         }else {
_0x27:
; 0000 00B7             current_position--;
	LDI  R26,LOW(_current_position)
	LDI  R27,HIGH(_current_position)
	CALL __GETD1P_INC
	SBIW R30,1
	SBCI R22,0
	SBCI R23,0
_0x2A:
	CALL __PUTDP1_DEC
; 0000 00B8         }
; 0000 00B9 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R23,Y+
	LD   R22,Y+
	RETI
;//----------------------------------------------------
;//
;//----------------------------------------------------
;void init(void)
; 0000 00BE {
_init:
; 0000 00BF     PORTA=0b00000000;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 00C0     DDRA=0x7F;
	LDI  R30,LOW(127)
	OUT  0x1A,R30
; 0000 00C1 
; 0000 00C2     PORTB=0x00000000;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 00C3     DDRB=0x7F;
	LDI  R30,LOW(127)
	OUT  0x17,R30
; 0000 00C4 
; 0000 00C5     PORTC=0b00000000;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 00C6     DDRC=0x7F;
	LDI  R30,LOW(127)
	OUT  0x14,R30
; 0000 00C7 
; 0000 00C8     PORTD=0b01111111;
	OUT  0x12,R30
; 0000 00C9     DDRD=0b10000000;
	LDI  R30,LOW(128)
	OUT  0x11,R30
; 0000 00CA 
; 0000 00CB     PORTE=0xFF;
	LDI  R30,LOW(255)
	OUT  0x3,R30
; 0000 00CC     DDRE=0x00;
	LDI  R30,LOW(0)
	OUT  0x2,R30
; 0000 00CD 
; 0000 00CE     PORTF=0x00;
	STS  98,R30
; 0000 00CF     DDRF=0xFF;
	LDI  R30,LOW(255)
	STS  97,R30
; 0000 00D0 
; 0000 00D1     PORTG=0x00;
	LDI  R30,LOW(0)
	STS  101,R30
; 0000 00D2     DDRG=0x03;
	LDI  R30,LOW(3)
	STS  100,R30
; 0000 00D3 
; 0000 00D4     // Timer/Counter 1 initialization
; 0000 00D5     // Clock source: System Clock
; 0000 00D6     // Clock value: 65,500 kHz
; 0000 00D7     // Mode: Normal top=0xFFFF
; 0000 00D8     // Input Capture on Falling Edge
; 0000 00D9     // Timer1 Overflow Interrupt: On
; 0000 00DA     TCCR1A=0x00;
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 00DB     TCCR1B=0x00;//0x04
	OUT  0x2E,R30
; 0000 00DC     TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 00DD     TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 00DE     ICR1H=0x00;
	OUT  0x27,R30
; 0000 00DF     ICR1L=0x00;
	OUT  0x26,R30
; 0000 00E0     OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 00E1     OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 00E2     OCR1BH=0x00;
	OUT  0x29,R30
; 0000 00E3     OCR1BL=0x00;
	OUT  0x28,R30
; 0000 00E4     OCR1CH=0x00;
	STS  121,R30
; 0000 00E5     OCR1CL=0x00;
	STS  120,R30
; 0000 00E6 
; 0000 00E7     // Timer/Counter 3 initialization
; 0000 00E8     // Clock source: T3 pin Rising Edge
; 0000 00E9     // Mode: CTC top=OCR3A
; 0000 00EA     // Input Capture on Falling Edge
; 0000 00EB     // Compare A Match Interrupt: On
; 0000 00EC     TCCR3A=0x00;
	STS  139,R30
; 0000 00ED     TCCR3B=0x00;
	STS  138,R30
; 0000 00EE     TCNT3H=0x00;
	STS  137,R30
; 0000 00EF     TCNT3L=0x00;
	STS  136,R30
; 0000 00F0     ICR3H=0x00;
	STS  129,R30
; 0000 00F1     ICR3L=0x00;
	STS  128,R30
; 0000 00F2     OCR3AH=0x00;
	STS  135,R30
; 0000 00F3     OCR3AL=0x00;
	STS  134,R30
; 0000 00F4     OCR3BH=0x00;
	STS  133,R30
; 0000 00F5     OCR3BL=0x00;
	STS  132,R30
; 0000 00F6     OCR3CH=0x00;
	STS  131,R30
; 0000 00F7     OCR3CL=0x00;
	STS  130,R30
; 0000 00F8 
; 0000 00F9     // External Interrupt(s) initialization
; 0000 00FA     // INT0: Off
; 0000 00FB     // INT1: Off
; 0000 00FC     // INT2: Off
; 0000 00FD     // INT3: Off
; 0000 00FE     // INT4: On
; 0000 00FF     // INT4 Mode: Rising Edge
; 0000 0100     // INT5: Off
; 0000 0101     // INT6: On
; 0000 0102     // INT6 Mode: Rising Edge
; 0000 0103     // INT7: Off
; 0000 0104     EICRA=0x00;
	STS  106,R30
; 0000 0105     EICRB=0x33;
	LDI  R30,LOW(51)
	OUT  0x3A,R30
; 0000 0106     EIMSK=0x50;
	LDI  R30,LOW(80)
	OUT  0x39,R30
; 0000 0107     EIFR=0x50;
	OUT  0x38,R30
; 0000 0108 
; 0000 0109     // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 010A     TIMSK=0x00;
	LDI  R30,LOW(0)
	OUT  0x37,R30
; 0000 010B 
; 0000 010C     ETIMSK=0x00;
	STS  125,R30
; 0000 010D 
; 0000 010E     #asm("sei")
	sei
; 0000 010F }
	RET
;//----------------------------------------------------
;//
;//----------------------------------------------------

	.DSEG
_set_position:
	.BYTE 0x4
_current_position:
	.BYTE 0x4
_feed:
	.BYTE 0x4

	.ESEG
_feed_eep:
	.BYTE 0x2

	.DSEG
_feed_show_S0000001000:
	.BYTE 0x4
_num_S0000001000:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	CALL __CWD1
	CALL __CDF1
	CALL __PUTDP1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x1:
	LDS  R30,_current_position
	LDS  R31,_current_position+1
	LDS  R22,_current_position+2
	LDS  R23,_current_position+3
	LDS  R26,_set_position
	LDS  R27,_set_position+1
	LDS  R24,_set_position+2
	LDS  R25,_set_position+3
	CALL __CDF1
	CALL __SWAPD12
	CALL __SUBF12
	CALL __CFD1
	MOVW R26,R30
	MOVW R24,R22
	RJMP _move

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2:
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(0)
	STS  _current_position,R30
	STS  _current_position+1,R30
	STS  _current_position+2,R30
	STS  _current_position+3,R30
	STS  _set_position,R30
	STS  _set_position+1,R30
	STS  _set_position+2,R30
	STS  _set_position+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x4:
	LDS  R30,_feed_show_S0000001000
	LDS  R31,_feed_show_S0000001000+1
	LDS  R22,_feed_show_S0000001000+2
	LDS  R23,_feed_show_S0000001000+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x5:
	STS  _feed_show_S0000001000,R30
	STS  _feed_show_S0000001000+1,R31
	STS  _feed_show_S0000001000+2,R22
	STS  _feed_show_S0000001000+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x6:
	LDS  R26,_feed_show_S0000001000
	LDS  R27,_feed_show_S0000001000+1
	LDS  R24,_feed_show_S0000001000+2
	LDS  R25,_feed_show_S0000001000+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x7:
	RCALL SUBOPT_0x6
	__GETD1N 0x42C80000
	CALL __DIVF21
	STS  _feed,R30
	STS  _feed+1,R31
	STS  _feed+2,R22
	STS  _feed+3,R23
	RCALL SUBOPT_0x4
	CALL __CFD1
	MOVW R26,R30
	RCALL _sem_seg
	LDI  R26,LOW(200)
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8:
	RCALL SUBOPT_0x4
	LDI  R26,LOW(_feed_eep)
	LDI  R27,HIGH(_feed_eep)
	CALL __CFD1
	CALL __EEPROMWRW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	CALL __GETD2S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA:
	CALL __PUTD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0xB:
	LDS  R26,_feed
	LDS  R27,_feed+1
	LDS  R24,_feed+2
	LDS  R25,_feed+3
	__GETD1N 0x40200000
	CALL __DIVF21
	LDS  R26,_set_position
	LDS  R27,_set_position+1
	LDS  R24,_set_position+2
	LDS  R25,_set_position+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xC:
	STS  _set_position,R30
	STS  _set_position+1,R31
	STS  _set_position+2,R22
	STS  _set_position+3,R23
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xFA0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__SWAPACC:
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__SUBF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
	LDI  R21,0x80
	EOR  R1,R21

	RJMP __ADDF120

__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF1211
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__CMPF12:
	TST  R25
	BRMI __CMPF120
	TST  R23
	BRMI __CMPF121
	CP   R25,R23
	BRLO __CMPF122
	BRNE __CMPF121
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __CMPF122
	BREQ __CMPF123
__CMPF121:
	CLZ
	CLC
	RET
__CMPF122:
	CLZ
	SEC
	RET
__CMPF123:
	SEZ
	CLC
	RET
__CMPF120:
	TST  R23
	BRPL __CMPF122
	CP   R25,R23
	BRLO __CMPF121
	BRNE __CMPF122
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	BRLO __CMPF122
	BREQ __CMPF123
	RJMP __CMPF121

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__ASRD12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	MOVW R22,R24
	BREQ __ASRD12R
__ASRD12L:
	ASR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R0
	BRNE __ASRD12L
__ASRD12R:
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__MULD12U:
	MUL  R23,R26
	MOV  R23,R0
	MUL  R22,R27
	ADD  R23,R0
	MUL  R31,R24
	ADD  R23,R0
	MUL  R30,R25
	ADD  R23,R0
	MUL  R22,R26
	MOV  R22,R0
	ADD  R23,R1
	MUL  R31,R27
	ADD  R22,R0
	ADC  R23,R1
	MUL  R30,R24
	ADD  R22,R0
	ADC  R23,R1
	CLR  R24
	MUL  R31,R26
	MOV  R31,R0
	ADD  R22,R1
	ADC  R23,R24
	MUL  R30,R27
	ADD  R31,R0
	ADC  R22,R1
	ADC  R23,R24
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	ADC  R22,R24
	ADC  R23,R24
	RET

__MULD12:
	RCALL __CHKSIGND
	RCALL __MULD12U
	BRTC __MULD121
	RCALL __ANEGD1
__MULD121:
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

__CHKSIGND:
	CLT
	SBRS R23,7
	RJMP __CHKSD1
	RCALL __ANEGD1
	SET
__CHKSD1:
	SBRS R25,7
	RJMP __CHKSD2
	CLR  R0
	COM  R26
	COM  R27
	COM  R24
	COM  R25
	ADIW R26,1
	ADC  R24,R0
	ADC  R25,R0
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSD2:
	RET

__GETD1P_INC:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X+
	RET

__PUTDP1:
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	RET

__PUTDP1_DEC:
	ST   -X,R23
	ST   -X,R22
	ST   -X,R31
	ST   -X,R30
	RET

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__GETD2S0:
	LD   R26,Y
	LDD  R27,Y+1
	LDD  R24,Y+2
	LDD  R25,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__PUTPARD2:
	ST   -Y,R25
	ST   -Y,R24
	ST   -Y,R27
	ST   -Y,R26
	RET

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__EEPROMRDW:
	ADIW R26,1
	RCALL __EEPROMRDB
	MOV  R31,R30
	SBIW R26,1

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRW:
	RCALL __EEPROMWRB
	ADIW R26,1
	PUSH R30
	MOV  R30,R31
	RCALL __EEPROMWRB
	POP  R30
	SBIW R26,1
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__CPD02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	CPC  R0,R24
	CPC  R0,R25
	RET

;END OF CODE MARKER
__END_OF_CODE:
