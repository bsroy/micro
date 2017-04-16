
%macro write 2
push rax
push rdi
push rsi
push rdx
mov rax,1
mov rdi,1
mov rsi, %1
mov rdx, %2
syscall
pop rdx
pop rsi
pop rdi
pop rax
%endmacro

%macro read 2            
mov rax,0
mov rdi,0
mov rsi, %1
mov rdx, %2
syscall

%endmacro

%macro exit 0
push rax
push rdi
mov rax,60
mov rdi,0
syscall
pop rdi
pop rax
%endmacro

section .data

	m1 db 10,10,"------------MENU-----------",10,"    1.Type",10,"    2.Copy",10,"    3.Delete",10,"    4.Exit",10,"Enter your choice",10
	l1 equ $-m1
	m5 db "Creating the destination file as file were not present",10
	l5 equ $-m5
	m7 db "File successfully deleted....",10
	l7 equ $-m7
	m8 db 10,"Data Successfully copied..."
	l8 equ $-m8
	e db 10,"Invalid Arguments"
	e_len equ $-e	
	e1 db 10,"Error opening file"
	e1_len equ $-e1
	e2 db "Error opening source file as file does not exists",10
	e2_len equ $-e2
	e3 db "Error opening destination file",10
	e3_len equ $-e3
	e4 db "File doesn't exists to delete"
	e4_len equ $-e4

section .bss


	src resb 50
	det resb 50
	choice resb 2
	d1 resb 8
	d2 resb 8
	d3 resb 8
	d4 resb 8
	d5 resb 8
	buffer resb 100
	size resb 8
	act1 resb 8
	act2 resb 8
	argc resb 8

section .text
global _start:
_start:

	pop rcx 	;pop count
	mov qword[argc],rcx
	cmp rcx,03
	jl err
	jg err

	;getting first file and store in src

	pop rcx
	pop rcx ;pop arguments
	mov rsi,src ;forming filename in src
	mov rdx,00
lb1:
	mov bl,byte[rcx+rdx]
	cmp bl,00
	je lb2
	mov byte[rsi+rdx],bl
	inc rdx
	jmp lb1
lb2:
	mov qword[act1],rdx
	mov byte[rsi+rdx],00

	;getting second file in strore in det

	pop rcx
	mov rsi,det
	mov rdx,00
lb3:
	mov bl,byte[rcx+rdx]
	cmp bl,00
	je lb4
	mov byte[rsi+rdx],bl
	inc rdx
	jmp lb3
lb4:
	mov qword[act2],rdx
	mov byte[rsi+rdx],00



menu:
	write m1,l1
	read choice,2
	cmp byte[choice],'1'
	je type1
	cmp byte[choice],'2'
	je copy1
	cmp byte[choice],'3'
	je delete1
	exit

type1:
	;opening file in read mode

	mov rax,02
	mov rdi,src
	mov rsi,0
	mov rdx,0644H
	syscall
	cmp rax,00
	je error1
	mov qword[d1],rax
	
	;reading from file

  lab1:
	mov rax,0
	mov rdi,qword[d1]
	mov rsi,buffer
	mov rdx,100
	syscall
	mov qword[size],rax

	;writing to moniter

	write buffer,qword[size]
	cmp qword[size],100
	je lab1
	
	;closing the file
	
	mov rax,3
	mov rdi,qword[d1]
	syscall

	jmp menu



copy1:
	
	;opening src file in read mode
	
	mov rax,02
	mov rdi,src
	mov rsi,00
	mov rdx,0777o
	syscall
	cmp rax,00
	jle error2
	mov qword[d2],rax

	;opening det file in read mode to check whether file exists or not

	mov rax,02
	mov rdi,det
	mov rsi,00
	mov rdx,0777o
	syscall
	cmp rax,00
	jle create_det
	mov qword[d3],rax
	
	;closing the file as det file is present
	
	mov rax,03
	mov rdi,qword[d3]
	syscall
	jmp lab2

create_det:

	write m5,l5
	mov rax,85
	mov rdi,det	
	mov rsi,0777o
	syscall
	
lab2:
	;opening det file in write mode 

	mov rax,02
	mov rdi,det
	mov rsi,201h
	mov rdx,0777o
	syscall
	cmp rax,00
	jle error3
	mov qword[d4],rax
	

	;reading the src file

reed:
	mov rax,00
	mov rdi,qword[d2]
	mov rsi,buffer
	mov rdx,100
	syscall
	mov qword[size],rax  ;rax will return how much data it has written

	;writing to the det file

	mov rax,01
	mov rdi,qword[d4]
	mov rsi,buffer
	mov rdx,qword[size]
	syscall
	cmp qword[size],100
	je reed
	
	;closing the src file

	mov rax,3
	mov rdi,qword[d2]
	syscall

	;closing the det file

	mov rax,3
	mov rdi,qword[d4]
	syscall
	write m8,l8
	jmp menu
	



delete1:

	;opening the file to check whether file is present or not

	mov rax,02
	mov rdi,src
	mov rsi,00
	mov rdx,0777o
	syscall
	cmp rax,00
	jle error4
	mov qword[d5],rax

	;closing the file

	mov rax,03
        mov rdi,qword[d5]
        syscall
	
	;unlink syscall

	mov rax,87
	mov rdi,src
	syscall

	write m7,l7
	jmp menu


err:
	write e,e_len
	exit

error1:
	write e1,e1_len
	jmp menu

error2:
	write e2,e2_len
	jmp menu

error3:
	write e3,e3_len
	jmp menu

error4:
	write e4,e4_len
	jmp menu
