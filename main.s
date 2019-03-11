.syntax unified

.word 0x20000100
.word _start

.global _start
.type _start, %function
_start:
	//
	//mov # to reg
	//
	movs	r0,	#250
	movs	r1,	#250
	movs	r2,	#102
	movs	r3,	#103
	movs    r4, #36
	movs    r5, #36
	movs    r6, #190
	movs    r7, #270
	movs    r8, #300
	movs    r9, #360
    
	// move reg to reg
    movs    r0, r5  //check difference between mov and movs 
	mov     r1, r4

	// sub 
	sub     r1, r2 //r1 =-66
	sub     r4, r5 // r4 =0
    // reset
	movs	r0,	#250
	movs	r1,	#250
	movs	r2,	#102
	movs	r3,	#103


	// push and pop
	//
    push	{r0, r1, r2, r3}
	 // reset
	movs	r0,	#250
	movs	r1,	#250
	movs	r2,	#102
	movs	r3,	#103
	// push and pop
	//
    push	{r1, r2, r0, r3}  //still in compiler is {r0,r1,r2,r3}

	// push and pop
    pop     {r6,r7,r8,r9}   //stack pointer 
    // push and pop
	pop     {r8,r7,r9,r6}  //stack pointer getting bigger but still in compiler {r6,r7,r8,r9}






