	.file	"fill_mem.c"
	.option nopic
	.attribute arch, "rv32i2p1_m2p0_a2p1_f2p2_d2p2_c2p0_v1p0_zicsr2p0_zve32f1p0_zve32x1p0_zve64d1p0_zve64f1p0_zve64x1p0_zvl128b1p0_zvl32b1p0_zvl64b1p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	1
	.globl	fill_memory
	.type	fill_memory, @function
fill_memory:
	ble	a0,zero,.L1
	ble	a1,zero,.L1
	fcvt.s.w	fa3,a1
	slli	a6,a1,2
	li	a3,0
.L3:
	fcvt.s.w	fa4,a3
	mv	a4,a2
	li	a5,0
	fmul.s	fa4,fa4,fa3
.L4:
	fcvt.s.w	fa5,a5
	addi	a4,a4,4
	addi	a5,a5,1
	fadd.s	fa5,fa5,fa4
	fsw	fa5,-4(a4)
	bne	a1,a5,.L4
	addi	a3,a3,1
	add	a2,a2,a6
	bne	a0,a3,.L3
.L1:
	ret
	.size	fill_memory, .-fill_memory
	.section	.text.startup,"ax",@progbits
	.align	1
	.globl	main
	.type	main, @function
main:
	fmv.s.x	fa5,zero
	li	a3,0
	lui	t4,%hi(.LC0)
	fsw	fa5,0(a3)
	flw	fa5,%lo(.LC0)(t4)
	lui	t3,%hi(.LC1)
	lui	t1,%hi(.LC2)
	fsw	fa5,4(a3)
	flw	fa5,%lo(.LC1)(t3)
	li	a4,12
	lui	a7,%hi(.LC3)
	fsw	fa5,8(a3)
	flw	fa5,%lo(.LC2)(t1)
	lui	a6,%hi(.LC4)
	lui	a0,%hi(.LC5)
	fsw	fa5,0(a4)
	flw	fa5,%lo(.LC3)(a7)
	li	a5,24
	lui	a1,%hi(.LC6)
	fsw	fa5,4(a4)
	flw	fa5,%lo(.LC4)(a6)
	lui	a2,%hi(.LC7)
	fsw	fa5,8(a4)
	flw	fa5,%lo(.LC5)(a0)
	li	a0,0
	fsw	fa5,0(a5)
	flw	fa5,%lo(.LC6)(a1)
	fsw	fa5,4(a5)
	flw	fa5,%lo(.LC7)(a2)
	fsw	fa5,8(a5)
	ret
	.size	main, .-main
	.section	.srodata.cst4,"aM",@progbits,4
	.align	2
.LC0:
	.word	1065353216
	.align	2
.LC1:
	.word	1073741824
	.align	2
.LC2:
	.word	1077936128
	.align	2
.LC3:
	.word	1082130432
	.align	2
.LC4:
	.word	1084227584
	.align	2
.LC5:
	.word	1086324736
	.align	2
.LC6:
	.word	1088421888
	.align	2
.LC7:
	.word	1090519040
	.ident	"GCC: (gc891d8dc23e) 13.2.0"
