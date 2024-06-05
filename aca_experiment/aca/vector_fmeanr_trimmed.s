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
ADDRESS		= 12345

DIAMETER 	= 2*RADIUS+1
WINDOWSIZE	= DIAMETER*DIAMETER

# initialize some constants #
	li				a2,IMGWIDTH				# calc IMGSIZE
	mul				a2,a2,a2				# calc IMGSIZE
	li				a7,IMGWIDTH				# offset between vectors in a window
	slli			a7,a7,2					# offset between vectors in a window
	li				a3,WINDOWSIZE			# set diviser
	fcvt.s.w		fa4,a3					# convert diviser to float
	li				a5,DIAMETER-1			# number of rows in the window (minus 1)

# fill memory with pixel values #
	li				a0,0					# iterator
	li				a1,ADDRESS				# start address
.L1:
	fcvt.s.w		fa0,a0					# copy iterator to float register
	addi			a0,a0,1					# increment iterator
	fsw				fa0,(a1)				# store float value to pixel array
	addi			a1,a1,4					# increment address
	bne				a2,a0,.L1

# set vector length and element width #
	li				a0,DIAMETER				# vector length = window diameter
	vsetvli 		t0,a0,e32				# set vector length and element size

	li				a0,0					# y iterator
	li				a2,IMGWIDTH-DIAMETER+1	# x and y iterator img loop bounds
	li				a4,ADDRESS				# top left corner of window

# y loop #
.L2:
	li				a1,0					# x iterator

# x loop #
.L3:
	li				a3,0					# iterator for window
	mv				a6,a4					# set start of vector to top left corner of window
	vle32.v 		v1,(a6)					# load first vector

# window loop #
.L4:
	add				a6,a6,a7				# calculate next vector address, a7 holds 4*IMGWIDTH
	vle32.v 		v2,(a6)					# load next vector
	vfadd.vv		v1,v2,v1				# add vectors
	addi			a3,a3,1					# increment iterator
	bne				a5,a3,.L4				# loop or exit

# calculate average #
	vfredosum.vs	v3,v1,v0				# v3[0] = redsum(v1[*]) + v0[0]
	vfmv.f.s	 	fa5,v3					# move v3[0] to fa5
	li				a3,ADDRESS-1			# setting storage adress to arbitrary location
	#fsw			fa5,0(a3)				# store sum (just for debugging)
	fdiv.s			fa5,fa5,fa4				# division	
	fsw				fa5,0(a3)				# store

	addi			a1,a1,1					# increment x iterator
	addi			a4,a4,4					# col address step
	bne				a2,a1,.L3				# col loop

	addi			a0,a0,1					# increment y iterator			
	slli			a6,a5,2					# window-sized address step to the beginning of the new row
	add				a4,a4,a6				# window-sized address step to the beginning of the new row
	bne				a2,a0,.L2				# row loop

	li	a5,0
	mv	a0,a5
	lw	s0,12(sp)
	addi	sp,sp,16
	jr	ra
	.size	main, .-main
	.ident	"GCC: (gc891d8dc23e) 13.2.0"
