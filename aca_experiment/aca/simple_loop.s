	.file	"simple_loop.c"
	.option nopic
	.attribute arch, "rv64i2p1_m2p0_a2p1_f2p2_d2p2_c2p0_zicsr2p0"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	1
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-144
	sd	s0,136(sp)
	sd	s1,128(sp)
	sd	s2,120(sp)
	sd	s3,112(sp)
	sd	s4,104(sp)
	sd	s5,96(sp)
	sd	s6,88(sp)
	sd	s7,80(sp)
	sd	s8,72(sp)
	sd	s9,64(sp)
	addi	s0,sp,144
	mv	t0,sp
	mv	s9,t0
	li	t0,5
	sw	t0,-104(s0)
	li	t0,5
	sw	t0,-108(s0)
	lw	t0,-104(s0)
	lw	s8,-108(s0)
	mv	s1,t0
	addi	s1,s1,-1
	sd	s1,-120(s0)
	mv	s1,t0
	mv	s6,s1
	li	s7,0
	srli	s1,s6,59
	slli	s5,s7,5
	or	s5,s1,s5
	slli	s4,s6,5
	mv	s1,t0
	slli	s1,s1,2
	mv	s4,s8
	addi	s4,s4,-1
	sd	s4,-128(s0)
	mv	s4,t0
	mv	t3,s4
	li	t4,0
	mv	s4,s8
	mv	t1,s4
	li	t2,0
	mul	s5,t4,t1
	mul	s4,t2,t3
	add	s4,s5,s4
	mul	s5,t3,t1
	mulhu	t1,t3,t1
	mv	a2,s5
	mv	a3,t1
	add	t1,s4,a3
	mv	a3,t1
	srli	t1,a2,59
	slli	s3,a3,5
	or	s3,t1,s3
	slli	s2,a2,5
	mv	a3,t0
	mv	a6,a3
	li	a7,0
	mv	a3,s8
	mv	a0,a3
	li	a1,0
	mul	a2,a7,a0
	mul	a3,a1,a6
	add	a3,a2,a3
	mul	t1,a6,a0
	mulhu	a2,a6,a0
	mv	a4,t1
	mv	a5,a2
	add	a3,a3,a5
	mv	a5,a3
	srli	a3,a4,59
	slli	t6,a5,5
	or	t6,a3,t6
	slli	t5,a4,5
	mv	a4,t0
	mv	a5,s8
	mul	a5,a4,a5
	slli	a5,a5,2
	addi	a5,a5,15
	srli	a5,a5,4
	slli	a5,a5,4
	sub	sp,sp,a5
	mv	a5,sp
	addi	a5,a5,3
	srli	a5,a5,2
	slli	a5,a5,2
	sd	a5,-136(s0)
	sw	zero,-84(s0)
	j	.L2
.L5:
	sw	zero,-88(s0)
	j	.L3
.L4:
	lw	a5,-84(s0)
	mv	a4,a5
	lw	a5,-104(s0)
	mulw	a5,a4,a5
	sext.w	a4,a5
	srli	a5,s1,2
	lw	a3,-88(s0)
	addw	a4,a3,a4
	sext.w	a4,a4
	ld	a3,-136(s0)
	lw	a2,-88(s0)
	lw	a1,-84(s0)
	mul	a5,a1,a5
	add	a5,a2,a5
	slli	a5,a5,2
	add	a5,a3,a5
	sw	a4,0(a5)
	lw	a5,-88(s0)
	addiw	a5,a5,1
	sw	a5,-88(s0)
.L3:
	lw	a5,-88(s0)
	mv	a4,a5
	lw	a5,-104(s0)
	sext.w	a4,a4
	sext.w	a5,a5
	blt	a4,a5,.L4
	lw	a5,-84(s0)
	addiw	a5,a5,1
	sw	a5,-84(s0)
.L2:
	lw	a5,-84(s0)
	mv	a4,a5
	lw	a5,-108(s0)
	sext.w	a4,a4
	sext.w	a5,a5
	blt	a4,a5,.L5
	sw	zero,-92(s0)
##### outer-loop #####
	sw	zero,-96(s0)
	j	.L6
.L9:
##### inner-loop #####
	sw	zero,-100(s0)
	j	.L7
.L8:
##### operation #####
	srli	a5,s1,2
	ld		a4,-136(s0)
	lw		a3,-100(s0)
	lw		a2,-96(s0)
	mul		a5,a2,a5
	add		a5,a3,a5
	slli	a5,a5,2
	add		a5,a4,a5
	lw		a5,0(a5)
	lw		a4,-92(s0)
	addw	a5,a4,a5
	sw		a5,-92(s0)
##### operation #####
	lw	a5,-100(s0)
	addiw	a5,a5,1
	sw	a5,-100(s0)
.L7:
	lw	a5,-100(s0)
	mv	a4,a5
	lw	a5,-104(s0)
	sext.w	a4,a4
	sext.w	a5,a5
	blt	a4,a5,.L8
##### inner-loop #####
	lw	a5,-96(s0)
	addiw	a5,a5,1
	sw	a5,-96(s0)
.L6:
	lw	a5,-96(s0)
	mv	a4,a5
	lw	a5,-108(s0)
	sext.w	a4,a4
	sext.w	a5,a5
	blt	a4,a5,.L9
##### outer-loop #####
	lw	a5,-92(s0)
	fcvt.s.w	fa4,a5
	lw	a5,-104(s0)
	mv	a4,a5
	lw	a5,-108(s0)
	mulw	a5,a4,a5
	sext.w	a5,a5
	fcvt.s.w	fa5,a5
	fdiv.s	fa5,fa4,fa5
	fsw	fa5,-140(s0)
	flw	fa5,-140(s0)
	fcvt.w.s a5,fa5,rtz
	sext.w	a5,a5
	mv	sp,s9
	mv	a0,a5
	addi	sp,s0,-144
	ld	s0,136(sp)
	ld	s1,128(sp)
	ld	s2,120(sp)
	ld	s3,112(sp)
	ld	s4,104(sp)
	ld	s5,96(sp)
	ld	s6,88(sp)
	ld	s7,80(sp)
	ld	s8,72(sp)
	ld	s9,64(sp)
	addi	sp,sp,144
	jr	ra
	.size	main, .-main
	.ident	"GCC: (gc891d8dc23e) 13.2.0"
