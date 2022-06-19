HexString db '0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'
value db 0x0C
printf_BIOS:
	pusha
	mov si, bx
	mov ah,0x0E
	printing:
		lodsb
		int 0x10
		inc cx
		cmp al,0x0
			je lineCR
		jmp printing
	done:
		mov byte[value],0x0C
		popa
		ret
	lineCR:
		mov dx,50h
		sub dx, cx
		lineCRdoing:
		int 10h
		dec dx
		cmp dx,0
			je done
		jmp lineCRdoing
		
		
printf_hex:
	pusha
	mov ah,0x0E
	mov al,'0'
	int 10h
	mov al, 'x'
	int 10h
	printing_hex:
		mov bx,dx
		mov cl,byte[value]
		shr bx,cl
		and bx,0Fh
		mov al,[HexString+bx]
		int 10h
		cmp byte[value],0h
			jle done
		sub byte[value],4h
		jmp printing_hex