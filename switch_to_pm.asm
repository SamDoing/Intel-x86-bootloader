[bits 16]
switch_to_pm:
	cli
	lgdt [gdt_descriptor]
	
	mov eax,cr0
	or eax, 1
	mov cr0, eax
	
	jmp CODE_SEG:init_pm
	
[bits 32]

init_pm:
	mov ax, DATA_SEG
	mov ds, ax
	mov ss, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ebp, 0x900000
	mov esp, ebp
	
	mov edx, Video_Memory_Adress+0xF94
	mov ah,0xf0
	mov ecx, msg
	mov al,[ecx]
	hello_printing:
	mov [edx],ax
	add edx,2
	inc ecx
	mov al,[ecx]
	cmp al,0
		jne hello_printing
	
	call BEGIN_PM
	
msg db "Hello!",0