	.syntax unified
	.arch armv7-a
	.text

	.equ locked, 1
	.equ unlocked, 0

	.global lock_mutex
	.type lock_mutex, function
lock_mutex:
        @ INSERT CODE BELOW
	LDR     r1, =locked	@load locked value into R1
	LDREX	r2, [r0]	@atomic operation to load R0's value into R2
	CMP	r2, r1		@check if the mutex is locked
@	WFEEQ			@if mutex is locked, wait for event before retry ; qemu doesn't support WFE
	BEQ	lock_mutex	@if mutex is locked, retry
	STREXNE	r2, r1, [r0]	@if mutex is not locked, attempt to lock by storing r1 (locked) into mutex
	CMPNE	r2, #1		@check if strex success
	BEQ	lock_mutex	@strex return 1 (failed), retry
	DMB			@make sure previous memory access has completed before continue (to return from lock_mutex)
        @ END CODE INSERT
	bx lr

	.size lock_mutex, .-lock_mutex

	.global unlock_mutex
	.type unlock_mutex, function
unlock_mutex:
	@ INSERT CODE BELOW
        LDR	r1, = unlocked	@lock unlocked value into R1
	DMB			@make sure previous memory access (esp to locked resources) has completed before unlock
	STR	r1, [r0]	@Unlock mutex
@	DSB			@make sure update is completed before sending event ; qemu doesn't support sending event
@	SEV			@send event to indicate unlocked			;qemu doesn't support sending event
        @ END CODE INSERT
	bx lr
	.size unlock_mutex, .-unlock_mutex

	.end
