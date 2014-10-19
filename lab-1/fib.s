	.syntax unified
	.arch armv7-a
	.text
	.align 2
	.thumb
	.thumb_func

	.global fibonacci
	.type fibonacci, function

fibonacci:
	@ ADD/MODIFY CODE BELOW
	@ PROLOG
	push {r4, r5, lr}

        @ r4=r0-0
        @ if r4<=(r0-0), jump to .L3
        subs r4, r0, #0  
        ble .L3         
        
        @ compare if r4==1
        @ if r4==1, jump to .L4
        cmp r4, #1     
        beq .L4         
	
	@ fib(x-1)
        sub r0, r4, #1
        bl fibonacci
      
        @ store r0 to r5
        mov r5, r0

        @ fib(x-2)
        sub r0, r4, #2
        bl fibonacci

        @ fib(x)=fib(x-1)+fib(x-2)
        add r0, r0, r5
        pop {r4, r5, pc}


	@ END CODE MODIFICATION
	@ EPILOG
.L3:
	mov r0, #0			@ R0 = 0
	pop {r4, r5, pc}		@ EPILOG

.L4:
	mov r0, #1			@ R0 = 1
	pop {r4, r5, pc}		@ EPILOG

	.size fibonacci, .-fibonacci
	.end
