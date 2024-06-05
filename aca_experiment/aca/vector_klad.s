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

VLEN  		= 16
ADDRESS		= 12345

	li				a2,30*VLEN

# fill memory with values #
	li				a0,0					
	li				a1,ADDRESS				
.L1:
	fcvt.s.w		fa0,a0					
	addi			a0,a0,1					
	fsw				fa0,(a1)				
	addi			a1,a1,4					
	bne				a2,a0,.L1

# set vector length and element width #
	li				a0,VLEN				
	vsetvli 		t0,a0,e32			

	li				a1,ADDRESS
	vle32.v 		v1,(a1)
	li				a2,4*VLEN
	add				a1,a1,a2		
	vle32.v 		v2,(a1)
	add				a1,a1,a2		
	vle32.v 		v3,(a1)	
	add				a1,a1,a2		
	vle32.v 		v4,(a1)
	add				a1,a1,a2		
	vle32.v 		v5,(a1)
	add				a1,a1,a2		
	vle32.v 		v6,(a1)
	add				a1,a1,a2		
	vle32.v 		v7,(a1)
	add				a1,a1,a2		
	vle32.v 		v8,(a1)
	add				a1,a1,a2		
	vle32.v 		v9,(a1)
	add				a1,a1,a2		
	vle32.v 		v10,(a1)
	add				a1,a1,a2		
	vle32.v 		v11,(a1)
	add				a1,a1,a2		
	vle32.v 		v12,(a1)
	add				a1,a1,a2		
	vle32.v 		v13,(a1)
	add				a1,a1,a2		
	vle32.v 		v14,(a1)
	add				a1,a1,a2		
	vle32.v 		v15,(a1)
	add				a1,a1,a2		
	vle32.v 		v16,(a1)
	add				a1,a1,a2		
	vle32.v 		v17,(a1)
	add				a1,a1,a2		
	vle32.v 		v18,(a1)
	add				a1,a1,a2		
	vle32.v 		v19,(a1)
	add				a1,a1,a2		
	vle32.v 		v20,(a1)
	add				a1,a1,a2		
	vle32.v 		v21,(a1)
	add				a1,a1,a2		
	vle32.v 		v22,(a1)
	add				a1,a1,a2		
	vle32.v 		v23,(a1)
	add				a1,a1,a2		
	vle32.v 		v24,(a1)
	add				a1,a1,a2		
	vle32.v 		v25,(a1)
	add				a1,a1,a2		
	vle32.v 		v26,(a1)
	add				a1,a1,a2		
	vle32.v 		v27,(a1)
	add				a1,a1,a2		
	vle32.v 		v28,(a1)
	add				a1,a1,a2		
	vle32.v 		v29,(a1)
	add				a1,a1,a2		
	vle32.v 		v30,(a1)						
	vfadd.vv		v1,v2,v1
	vfadd.vv		v3,v4,v3
	vfadd.vv		v5,v6,v5
	vfadd.vv		v7,v8,v7
	vfadd.vv		v9,v10,v9
	vfadd.vv		v11,v12,v11
	vfadd.vv		v13,v14,v13
	vfadd.vv		v15,v16,v15
	vfadd.vv		v17,v18,v17
	vfadd.vv		v19,v20,v19
	vfadd.vv		v21,v22,v21
	vfadd.vv		v23,v24,v23
	vfadd.vv		v25,v26,v25
	vfadd.vv		v27,v28,v27
	vfadd.vv		v29,v30,v29
	li				a1,0
	vse32.v			v1,(a1)
	#add				a1,a1,a2
	#vse32.v			v3,(a1)
	#add				a1,a1,a2
	#vse32.v			v5,(a1)
	#add				a1,a1,a2
	#vse32.v			v7,(a1)
	#add				a1,a1,a2
	#vse32.v			v9,(a1)
	#add				a1,a1,a2
	#vse32.v			v11,(a1)
	#add				a1,a1,a2
	#vse32.v			v13,(a1)
	#add				a1,a1,a2
	#vse32.v			v15,(a1)
	#add				a1,a1,a2
	#vse32.v			v17,(a1)
	#add				a1,a1,a2
	#vse32.v			v19,(a1)
	#add				a1,a1,a2
	#vse32.v			v21,(a1)
	#add				a1,a1,a2
	#vse32.v			v23,(a1)
	#add				a1,a1,a2
	#vse32.v			v25,(a1)
	#add				a1,a1,a2
	#vse32.v			v27,(a1)
	#add				a1,a1,a2
	#vse32.v			v29,(a1)

	li	a5,0
	mv	a0,a5
	lw	s0,12(sp)
	addi	sp,sp,16
	jr	ra
	.size	main, .-main
	.ident	"GCC: (gc891d8dc23e) 13.2.0"
