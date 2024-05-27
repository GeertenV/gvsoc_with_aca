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
	li	a5,536870912
	li	a4,1
	sw	a4,0(a5)
	li	a5,536870912
	addi	a5,a5,32
	li	a4,2
	sw	a4,0(a5)
	li	a5,536870912
	addi	a5,a5,64
	li	a4,3
	sw	a4,0(a5)
	li	a5,536870912
	addi	a5,a5,96
	li	a4,4
	sw	a4,0(a5)
	li	a5,536870912
	addi	a5,a5,128
	li	a4,5
	sw	a4,0(a5)
	li	a5,536870912
	addi	a5,a5,160
	li	a4,6
	sw	a4,0(a5)
	li	a5,805306368
	lw	a5,0(a5)
	li	a5,805306368
	lw	a5,0(a5)
	li	a5,805306368
	lw	a5,0(a5)
	li	a5,805306368
	lw	a5,0(a5)
	li	a5,805306368
	lw	a5,0(a5)
	li	a5,805306368
	lw	a5,0(a5)
	li	a5,805306368
	lw	a5,0(a5)
	li	a5,805306368
	lw	a5,0(a5)
	li	a5,805306368
	lw	a5,0(a5)
	li	a5,805306368
	lw	a5,0(a5)
	li	a5,805306368
	lw	a5,0(a5)
	li	a5,805306368
	lw	a5,0(a5)
	li	a5,805306368
	lw	a5,0(a5)
	li	a5,805306368
	lw	a5,0(a5)
	li	a5,805306368
	lw	a5,0(a5)
	li	a5,805306368
	lw	a5,0(a5)
	li	a5,805306368
	lw	a5,0(a5)
	li	a5,805306368
	lw	a5,0(a5)
	li	a5,0
	mv	a0,a5
	lw	s0,12(sp)
	addi	sp,sp,16
	jr	ra
	.size	main, .-main
	.ident	"GCC: (gc891d8dc23e) 13.2.0"
