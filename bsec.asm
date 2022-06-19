[org 0x7c00] 									; Ask the BIOS to load us at 7C00 memory adreess
bits 16]
jmp entry  										;Go to our entry point

;Bytes(u can say it is like a variable declaration)
WelcomeMsg db "THE BOOT ACHIVED WAS UNLOCKED hehe",0
DiskLoadingMsg db "Loading Data from Disk",0
BOOT_DRIVE db 0x0
BOOT_LOAD_ADRESS dw 0x9000
entry: 										;our entry point
	mov [BOOT_DRIVE],dl
	mov bp,0x8000
	mov sp, bp
	
	pusha 									;Save the registers for later
	mov bx,WelcomeMsg 						;Here we send that string to be printed
	call printf_BIOS 						;our function, it just print things(ASCII)
	
	mov bx,DiskLoadingMsg
	call printf_BIOS
	
	mov dl,[BOOT_DRIVE]
	mov bx,[BOOT_LOAD_ADRESS]							;Indirectely
	mov dh,2h								;Setor to be read
	call disk_load
	
	popa 									;Get back our registers
	
	call switch_to_pm
	jmp $
	
;import my "functions"
%include "printf.asm"
%include "disk_load.asm"
%include "gdt.asm"
%include "switch_to_pm.asm"
%include "printf_32bits.asm"
	
[bits 32]

BEGIN_PM:
	mov ebx, MSG_PROT_MODE
	call printf_32
	
	jmp $

MSG_PROT_MODE db "Sucessfull 32 bits mode", 0 

times 510 - ($-$$) db 0 					;Just ocuping space necessary for our boot setor works!
dw 0xaa55 									;Magic number for BIOS(The BIOS need that to accept this boot sector)

times 256 dw 0xdada
times 256 dw 0xface