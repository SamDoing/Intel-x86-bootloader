;Strings
DiskErrorMsg db "Disk can't be read",0
DiskSuccessMsg db "Disk Readed with Success [ok]",0

disk_load:
	pusha
	push dx 				;Setors to be read
	
	mov ah,02h				;BIOS read setor function
	mov al,dh 				;Sectors to read by BIOS function
	mov ch,00H 				;Select cylinder 0
	mov dh,0x00 			;Select head 0
	mov cl,02h 				;Start reading from setor 2 after our boot setor
	
	int 13h					;BIOS int 
		jc disk_error  		; if carry flag 
		
	pop dx 					;Return our setors numbers
	cmp dh,al 				;Verify if setors were read correctely
		jne disk_error 		;If error
		
	mov bx,DiskSuccessMsg 	;Print the Success
	call printf_BIOS
	popa
	ret
	
disk_error:
	mov bx,DiskErrorMsg
	call printf_BIOS
	jmp $ ;					loop here