	.file	"fmeanr.c"
	.option nopic
	.attribute arch, "rv64i2p1_m2p0_a2p1_f2p2_d2p2_c2p0_zicsr2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	1
	.globl	fmeanr
	.type	fmeanr, @function
fmeanr:
 #APP
# 2 "fmeanr.c" 1
	#before y-loop
# 0 "" 2
 #NO_APP
	ble	a0,zero,.L39
	addi	sp,sp,-128
	sd	s1,112(sp)
	negw	s1,a2
	sd	s0,120(sp)
	sd	s4,88(sp)
	sd	s6,72(sp)
	mv	a6,a2
	sext.w	t4,a2
	sd	s2,104(sp)
	sd	s3,96(sp)
	sd	s5,80(sp)
	sd	s7,64(sp)
	sd	s8,56(sp)
	sd	s9,48(sp)
	sd	s10,40(sp)
	sd	s11,32(sp)
	mv	t6,a0
	mv	a7,a1
	mv	s4,a3
	slli	s0,a1,2
	mv	t1,s1
	li	a2,0
	mv	s6,s1
.L4:
 #APP
# 4 "fmeanr.c" 1
	#before x-loop
# 0 "" 2
 #NO_APP
	ble	a7,zero,.L21
	srliw	a5,t1,31
	sext.w	s2,a2
	sext.w	s5,s6
	beq	a5,zero,.L7
	negw	s5,s2
.L7:
	addw	s7,s5,s2
	mul	s9,s7,a7
	li	a3,0
	mv	s10,a2
	subw	s8,s2,t4
	mv	s3,a4
	sd	s5,16(sp)
	sd	s1,8(sp)
	sd	t4,24(sp)
	mv	a2,a3
	mv	t3,s1
.L20:
 #APP
# 8 "fmeanr.c" 1
	#before j-loop
# 0 "" 2
 #NO_APP
	blt	s8,zero,.L11
	ld	a5,8(sp)
	blt	a6,a5,.L36
.L11:
	ble	t6,s7,.L36
	srliw	a5,t3,31
	sext.w	t5,a2
	sext.w	a0,t3
	sext.w	t4,s6
	beq	a5,zero,.L13
	negw	t4,t5
.L13:
	addw	a3,t4,t5
	add	t0,a3,s9
	fmv.s.x	fa5,zero
	ld	t2,16(sp)
	slli	t0,t0,2
	add	t0,s4,t0
	li	a5,0
	mv	a1,s10
.L19:
 #APP
# 10 "fmeanr.c" 1
	#before i-loop
# 0 "" 2
 #NO_APP
	blt	a0,zero,.L17
	ld	s1,8(sp)
	blt	a6,s1,.L16
.L17:
	mv	s5,t0
	mv	s10,a5
	sext.w	s11,a5
	bgt	a7,a3,.L15
	j	.L16
.L40:
	addi	s5,s5,4
	bge	s1,a7,.L23
.L15:
 #APP
# 12 "fmeanr.c" 1
	#inside i-loop
# 0 "" 2
 #NO_APP
	flw	fa4,0(s5)
	addiw	s10,s10,1
	fadd.s	fa5,fa5,fa4
 #APP
# 15 "fmeanr.c" 1
	#inside after i-loop
# 0 "" 2
 #NO_APP
	addw	s1,s10,t5
	addw	a5,s10,t4
	addw	s1,s1,t4
	subw	a5,a5,s11
	subw	s1,s1,s11
	ble	a5,a6,.L40
.L23:
	mv	a5,s10
.L16:
 #APP
# 17 "fmeanr.c" 1
	#after i-loop
# 0 "" 2
 #NO_APP
	addiw	t2,t2,1
	blt	a6,t2,.L37
	addw	s5,t2,s2
	add	t0,t0,s0
	blt	s5,t6,.L19
.L37:
	fcvt.s.w	fa4,a5
	mv	s10,a1
.L10:
 #APP
# 19 "fmeanr.c" 1
	#after j-loop
# 0 "" 2
 #NO_APP
	fdiv.s	fa5,fa5,fa4
	addiw	a2,a2,1
	addi	s3,s3,4
	addiw	t3,t3,1
	fsw	fa5,-4(s3)
	bne	a7,a2,.L20
	ld	s1,8(sp)
	ld	t4,24(sp)
	mv	a2,s10
.L21:
 #APP
# 22 "fmeanr.c" 1
	#after x-loop
# 0 "" 2
 #NO_APP
	addiw	a2,a2,1
	add	a4,a4,s0
	addiw	t1,t1,1
	bne	t6,a2,.L4
 #APP
# 24 "fmeanr.c" 1
	#after y-loop
# 0 "" 2
 #NO_APP
	ld	s0,120(sp)
	ld	s1,112(sp)
	ld	s2,104(sp)
	ld	s3,96(sp)
	ld	s4,88(sp)
	ld	s5,80(sp)
	ld	s6,72(sp)
	ld	s7,64(sp)
	ld	s8,56(sp)
	ld	s9,48(sp)
	ld	s10,40(sp)
	ld	s11,32(sp)
	addi	sp,sp,128
	jr	ra
.L36:
	fmv.s.x	fa4,zero
	fmv.s	fa5,fa4
	j	.L10
.L39:
 #APP
# 24 "fmeanr.c" 1
	#after y-loop
# 0 "" 2
 #NO_APP
	ret
	.size	fmeanr, .-fmeanr
	.section	.text.startup,"ax",@progbits
	.align	1
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-16
	sd	ra,8(sp)
 #APP
# 34 "fmeanr.c" 1
	#fmeanr-begin
# 0 "" 2
 #NO_APP
	li	a4,805306368
	li	a3,536870912
	li	a2,1
	li	a1,5
	li	a0,5
	call	fmeanr
 #APP
# 36 "fmeanr.c" 1
	#fmeanr-end
# 0 "" 2
 #NO_APP
	ld	ra,8(sp)
	li	a0,0
	addi	sp,sp,16
	jr	ra
	.size	main, .-main
	.ident	"GCC: (gc891d8dc23e) 13.2.0"
