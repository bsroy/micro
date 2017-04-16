%macro write 02
mov rax,1
mov rdi,1
mov rsi,%1
mov rdx,%2
syscall
%endmacro

%macro read 02
mov rax,0
mov rdi,0
mov rsi,%1
mov rdx,%2
syscall
%endmacro

%macro exit 0
mov rax,60
mov rdi,0
syscall
%endmacro

section .data
msg1 db 10,"Processor is in protected mode."
len1 equ $-msg1
msg2 db 10,"Processor is in real mode."
len2 equ $-msg2
msg3 db 10,"GDTR: "
len3 equ $-msg3
msg4 db 10,"IDTR: "
len4 equ $-msg4
msg5 db 10,"LDTR: "
len5 equ $-msg5
msg6 db 10,"TR: "
len6 equ $-msg6
msg7 db 10,"MSW: "
len7 equ $-msg7
msg8 db " : "
len8 equ $-msg8

section .bss
GDTR resw 3
IDTR resw 3
LDTR resw 1
TR resw 1
MSW resw 1
char_buff resb 04

section .text
global _start
_start:
	SMSW [MSW]
	mov bx,[MSW]
	ror bx,01
	jc pmode
	write msg2,len2
	jmp skip
pmode:
	write msg1,len1
skip:
	write msg3,len3
	SGDT [GDTR]
	mov bx,[GDTR+4]
	call display
	mov bx,[GDTR+2]
	call display
	write msg8,len8
	mov bx,[GDTR]
	call display

	write msg4,len4	
	SIDT [IDTR]
	mov bx,[IDTR+4]
	call display
	mov bx,[IDTR+2]
	call display
	write msg8,len8
	mov bx,[IDTR]
	call display

	write msg5,len5	
	SLDT [LDTR]
	mov bx,[LDTR]
	call display
	
	write msg6,len6	
	STR [TR]
	mov bx,[TR]
	call display

	write msg7,len7	
	SMSW [MSW]
	mov bx,[MSW]
	call display
exit

display:
	mov rsi,char_buff+3
	mov rcx,04
up1:
	rol bx,04
	mov dl,bl
	and dl,0fH
	cmp dl,09H
	jbe add30
	add dl,07H
add30:
	add dl,30H
	mov byte[rsi],dl
	dec rsi
	dec rcx
	jnz up1
	write char_buff,04
ret
