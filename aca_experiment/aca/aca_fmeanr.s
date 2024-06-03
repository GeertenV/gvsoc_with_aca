	.file	"main.c"
	.option nopic
	.attribute arch, "rv32i2p1_m2p0_f2p2_d2p2_v1p0_zicsr2p0_zve32f1p0_zve32x1p0_zve64d1p0_zve64f1p0_zve64x1p0_zvl128b1p0_zvl32b1p0_zvl64b1p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	2
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-16
	sw	s0,12(sp)
	addi	s0,sp,16

IMGWIDTH  	= 256
RADIUS 		= 7
MOD_ADDRESS		= 33554432
REG_ADDRESS		= 50331648

DIAMETER 	= 2*RADIUS+1
WINDOWSIZE	= DIAMETER*DIAMETER

# initialize some constants # 
	li				a2,IMGWIDTH-DIAMETER+1				# x and y iterator img loop bounds
	#li				a2,1
	li  			a4,MOD_ADDRESS
	li  			a5,REG_ADDRESS
	li				a3,WINDOWSIZE			# set diviser
	fcvt.s.w		fa4,a3					# convert diviser to float
	li				a6,DIAMETER-1			# number of rows in the window

# set vector length and element width #
	li				a0,DIAMETER
	vsetvli 		t0,a0,e32

# set ACA values that remain constant #
	li 				a3,1					# Row Stride = 1
	sw 				a3,4(a4)				# set Row Stride
	li 				a3,DIAMETER				# Row Cycles = DIAMETER
	sw 				a3,8(a4)				# set Row Cycles

	li 				a3,1					# Col Stride = 1
	sw 				a3,16(a4)				# set Col Stride
	li 				a3,DIAMETER				# Col Cycles = DIAMETER
	sw 				a3,20(a4)				# set Col Cycles

# img loop #
	li				a0,0					# y iterator
.L1:
	li				a1,0					# x iterator
.L2:
# set ACA start point and trigger go #
	sw 				a0,0(a4)				# set row start
	sw 				a1,12(a4)				# set col start
	sw 				a3,24(a4)				# go ACA

	li				a3,0					# iterator for window

	NOP
	NOP
	NOP
	NOP
	NOP

	NOP
	NOP
	NOP
	NOP
	NOP

	NOP
	NOP
	NOP
	NOP
	NOP

	vle32.v 		v1,(a5)					# load first vector

	NOP
	NOP
	NOP
	NOP
	NOP

	NOP
	NOP

# window loop #
.L3:
	NOP
	NOP
	NOP
	NOP
	NOP

	NOP
	NOP
	NOP

	vle32.v 		v2,(a5)					# load next vector
	vfadd.vv		v1,v2,v1				# add vectors
	addi			a3,a3,1					# increment window iterator
	NOP
	NOP
	bne				a6,a3,.L3				# loop or exit

# calculate average #
	vfredosum.vs	v3,v1,v0				# v3[0] = redsum(v1[*]) + v0[0]
	vfmv.f.s	 	fa5,v3					# move v3[0] to fa5
	li				a3,MOD_ADDRESS
	# fsw			fa5,28(a3)				# store sum (just for debugging)
	fdiv.s			fa5,fa5,fa4				# division	
	fsw				fa5,28(a3)				# store

	addi			a1,a1,1					# increment x iterator
	bne				a2,a1,.L2
	
	addi			a0,a0,1					# increment y iterator
	bne				a2,a0,.L1

	li	a5,0
	mv	a0,a5
	lw	s0,12(sp)
	addi	sp,sp,16
	jr	ra
	.size	main, .-main
	.ident	"GCC: (gc891d8dc23e) 13.2.0"
