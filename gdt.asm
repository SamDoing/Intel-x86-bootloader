; GDT
gdt_start:


gdt_null:
	dd 0x0			; the mandatory null descriptor
	dd 0x0			; 'dd' is double word(i.e. 4 bytes)

gdt_code:			; the code segment descriptor
	; base=0x0, limit=0xfffff,
	; 1st flags:  (present) 1 (privilege) 00 (descriptor type) 1	-> 1001b
	; type flags: (code) 1 (conforming) 0 (readable) 1 (accessed) 0 -> 1010b
	; 2st flags:  (granularity) 1 (32-bit default) 1 (64-bit seg) 0 (AVL) 0 -> 1100b
	dw 0xffff		; Limit (bits 0-15)
	dw 0x0			; Base  (bits 0-15)
	db 0x0			; Base  (bits 16-23)
	db 10011010b	; 1st flags, type flags
	db 11001111b	; 2st flags, limit (bits 16-19)
	db 0x0			; Base (bits 24-31)
	
gdt_data:			; the data segment descriptor
	; Same as code segment except for type flags:
	; type flags: (code) 0 (expand_down) (writable) 1 (accessed) 0 -> 0010b
	dw 0xffff		; Limit (bits 0-15) 
	dw 0x0			; Base  (bits 0-15)
	db 0x0			; Base  (bits 16-23)
	db 10010010b	; 1st flags, type flags
	db 11001111b	; 2st flags, limit (bits 16-19)
	db 0x0			; Base (bits 24-31)
					
gdt_end:			; The reason for putting a label at the end of the
					; GDT is so we can have the assembler calculate
					; The size of the GDT for the GDT descriptor

; GDT_descriptor
gdt_descriptor:
	dw gdt_end - 1 - gdt_start	; Size of our GDT, always less one
								; of the true size.
	dd gdt_start				; Start adress of our GDT

; Define some handy constants for the GDT segment descriptor offsets, which
; are what segment registers must contain when in protected mode. For example,
; When we set DS = 0x10 in PM, the CPU knows that we mean it to use the
; segment described at offset 0x10 (i.e. 16 bytes) in our GDT, which in our
; case is the DATA  segment (0x0 -> NULL; 0x08 -> CODE; 0x10 -> DATA)
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

;									"DOC"
; Base (32bits), defines where our the segment begins in physical memory
; Segment Limit (20 bits), defines the size of the segment
; Present , used for virtual memory
; Privilege, segment privilege
; Descriptor type, 1 for code or data segment, 0 is used for traps -> ?
; Type: 
; 		Code: 1 for code, 0 for data
;		Conforming: 0 code segment with lower cannot call code in this segment -> key to memory protection
;		Readable: 1 if readeble, 0 if executed-only.
;		Acessed: it is for debugging and virtual memory techniques.
;
;Granularity,
;Expand down,
;32-bit default,
;64-bit code segment,
;AVL,