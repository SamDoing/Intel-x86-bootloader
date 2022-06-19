[bits 32]

;Constants
Video_Memory_Adress equ 0xb8000
White_On_Black equ 0x0f

printf_32:
	pusha
	mov esi, ebx
	mov ecx, Video_Memory_Adress
	mov ah, White_On_Black
	printing_Visual:
		lodsb
		mov [ecx], ax
		add ecx,0x2
		cmp al,0x0
			je done
		jmp printing_Visual