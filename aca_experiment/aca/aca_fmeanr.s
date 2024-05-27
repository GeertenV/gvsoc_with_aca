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

IMGWIDTH  	= 22
RADIUS 		= 3
MOD_ADDRESS		= 536870912
REG_ADDRESS		= 805306368

DIAMETER 	= 2*RADIUS+1
WINDOWSIZE	= DIAMETER*DIAMETER

# initialize some constants # 
	li				a2,IMGWIDTH-DIAMETER+1				# x and y iterator img loop bounds
	li  			a4,MOD_ADDRESS
	li  			a5,REG_ADDRESS

	li				a0,DIAMETER
	vsetvli 		t0,a0,e32

# img loop #
	li				a0,0					# y iterator
.L1:
	li				a1,0					# x iterator
.L2:

	sw 				a0,0(a4)
	li 				a3,1
	sw 				a3,4(a4)
	li 				a3,DIAMETER
	sw 				a3,8(a4)

	sw 				a1,12(a4)
	li 				a3,1
	sw 				a3,16(a4)
	li 				a3,DIAMETER
	sw 				a3,20(a4)

	li				a3,1					# iterator for window
	li				a6,DIAMETER				# number of rows in the window

	li 				a7,0
	li 				a7,0
	li 				a7,0
	li 				a7,0
	li 				a7,0
	li 				a7,0
	li 				a7,0
	li 				a7,0
	li 				a7,0
	li 				a7,0
	li 				a7,0
	li 				a7,0
	li 				a7,0
	li 				a7,0
	li 				a7,0
	li 				a7,0
	li 				a7,0
	li 				a7,0
	li 				a7,0
	li 				a7,0

	vle32.v 		v1,(a5)					# load first vector

	li 				a7,0
	li 				a7,0
	li 				a7,0
	li 				a7,0
	li 				a7,0
	li 				a7,0
	li 				a7,0
	li 				a7,0
	li 				a7,0

.L3:
	li 				a7,0
	li 				a7,0
	li 				a7,0
	li 				a7,0
	li 				a7,0
	li 				a7,0
	li 				a7,0
	li 				a7,0
	li 				a7,0
	li 				a7,0
	li 				a7,0
	li 				a7,0
	vle32.v 		v2,(a5)					# load next vector
	vfadd.vv		v1,v2,v1				# add vectors
	addi			a3,a3,1					# increment iterator
	li 				a7,0
	li 				a7,0
	li 				a7,0
	li 				a7,0
	bne				a6,a3,.L3				# loop or exit

	vfredosum.vs	v3,v1,v0				# v3[0] = redsum(v1[*]) + v0[0]
	vfmv.f.s	 	fa5,v3					# move v3[0] to fa5
	li				a3,WINDOWSIZE			# set diviser
	fcvt.s.w		fa4,a3					# convert diviser to float
	li				a3,600
	fsw				fa5,(a3)
	fdiv.s			fa5,fa5,fa4				# division	
	fsw				fa5,(a3)				# store

	addi			a1,a1,1					# increment y iterator
	bne				a2,a1,.L2
	addi			a0,a0,1					# increment y iterator
	bne				a2,a0,.L1

#	li  			a4,MOD_ADDRESS
#	li 				a3,0
#	sw 				a3,0(a4)
#	li 				a3,1
#	sw 				a3,4(a4)
#	li 				a3,DIAMETER
#	sw 				a3,8(a4)
#	li 				a3,0
#	sw 				a3,12(a4)
#	li 				a3,1
#	sw 				a3,16(a4)
#	li 				a3,DIAMETER
#	sw 				a3,20(a4)
#
#	
#	li				a0,DIAMETER
#	vsetvli 		t0,a0,e32
#	li  			a5,REG_ADDRESS
#
#	li 				a0,0
#	li 				a0,0
#	li 				a0,0
#	li 				a0,0
#	li 				a0,0
#	li 				a0,0
#	li 				a0,0
#	li 				a0,0
#	li 				a0,0
#	li 				a0,0
#
#	vle32.v 		v1,(a5)
#	li 				a0,0
#	li 				a0,0
#	li 				a0,0
#	li 				a0,0
#	li 				a0,0
#	li 				a0,0
#	li 				a0,0
#	li 				a0,0
#	li 				a0,0
#	li 				a0,0
#	vle32.v 		v1,(a5)
#	li 				a0,0
#	li 				a0,0
#	li 				a0,0
#	li 				a0,0
#	li 				a0,0
#	li 				a0,0
#	li 				a0,0
#	li 				a0,0
#	li 				a0,0
#	li 				a0,0
#	vle32.v 		v1,(a5)
#	li 				a0,0
#	li 				a0,0
#	li 				a0,0
#	li 				a0,0
#	li 				a0,0
#	li 				a0,0
#	li 				a0,0
#	li 				a0,0
#	li 				a0,0
#	li 				a0,0
#	vle32.v 		v1,(a5)
#	li 				a0,0
#	li 				a0,0
#	li 				a0,0
#	li 				a0,0
#	li 				a0,0
#	li 				a0,0
#	li 				a0,0
#	li 				a0,0
#	li 				a0,0
#	li 				a0,0
#	vle32.v 		v1,(a5)

# initialize some constants #
#	li				a2,IMGWIDTH				# calc IMGSIZE
#	mul				a2,a2,a2				# calc IMGSIZE
#	li				a6,IMGWIDTH+1			# address offset top left corner of window compared to centre
#	li				a3,4*RADIUS				# address offset top left corner of window compared to centre
#	mul				a6,a6,a3				# address offset top left corner of window compared to centre
#	li				a7,IMGWIDTH				# offset between vectors in a window
#	slli			a7,a7,2					# offset between vectors in a window

## fill memory with pixel values #
#	li				a0,0					# iterator
#	li				a1,ADDRESS				# start address
#.L1:
#	fcvt.s.w		fa0,a0					# copy iterator to float register
#	addi			a0,a0,1					# increment iterator
#	fsw				fa0,(a1)				# store float value to pixel array
#	addi			a1,a1,4					# increment address
#	bne				a2,a0,.L1
#
## set vector length and element width #
#	li				a0,DIAMETER				# vector length = window diameter
#	vsetvli 		t0,a0,e32				# set vector length and element size
#
## image loop #
#	li				a0,0					# iterator for image
#	li				a1,ADDRESS				# start adress of the middle pixel of the window
#
#.L2:
## window loop #
#	li				a3,1					# iterator for window
#	sub				a4,a1,a6				# address offset top left corner of window compared to centre
#	li				a5,DIAMETER				# number of rows in the window
#	vle32.v 		v1,(a4)					# load first vector
#.L3:
#	add				a4,a4,a7				# calculate next vector address
#	vle32.v 		v2,(a4)					# load next vector
#	vfadd.vv		v1,v2,v1				# add vectors
#	addi			a3,a3,1					# increment iterator
#	bne				a5,a3,.L3				# loop or exit
#
## calculate average #
#	vfredosum.vs	v3,v1,v0				# v3[0] = redsum(v1[*]) + v0[0]
#	vfmv.f.s	 	fa5,v3					# move v3[0] to fa5
#	li				a3,WINDOWSIZE			# set diviser
#	fcvt.s.w		fa4,a3					# convert diviser to float
#	slli			a3,a2,2					# calc output address offset (a2 holds image size)
#	add				a3,a1,a3				# calc output address		 (a1 holds current pixel addr)
#	#fsw			fa5,(a3)				# store sum (just for debugging)
#	fdiv.s			fa5,fa5,fa4				# division	
#	fsw				fa5,(a3)				# store
#
#	addi			a0,a0,1					# increment iterator
#	addi			a1,a1,4					# next pixel address
#	bne				a2,a0,.L2

	li	a5,0
	mv	a0,a5
	lw	s0,12(sp)
	addi	sp,sp,16
	jr	ra
	.size	main, .-main
	.ident	"GCC: (gc891d8dc23e) 13.2.0"
