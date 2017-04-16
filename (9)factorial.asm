section .data
msg1 db "Factorial is :",10
len1 equ $-msg1
msg2 db "Parameter missing",10
len2 equ $-msg2
msg3 db "Too many parameters",10
len3 equ $-msg3

%macro write 2
mov rax ,1
mov rdi,1
mov rsi,%1
mov rdx,%2
syscall
%endmacro

section .bss

actl resb 1
char_buff resb 16


section .text
global _start
_start:
pop rcx
cmp rcx,02
jl err1
jg err2
pop rcx
pop rcx
mov rdx,0
mov byte[actl],0
again:mov bl,byte[rcx+rdx]
      cmp bl,00h
      je next
      mov [char_buff+rdx],bl
      inc rdx
      inc byte[actl]
      jmp again

next:call convert
     push rbx 
     call factorial
     mov rbx,rax
     write msg1,len1
     call display
jmp exit
err1:write msg2,len2
jmp exit
err2:write msg3,len3
jmp exit
exit:
mov rax,60
mov rdi,0
syscall

convert:
        mov rsi,char_buff
        
        mov rbx,00
        mov rdx,00

up:shl rbx,04
   mov dl,byte[rsi]
   cmp dl,39h
   jbe sub_30
   sub dl,07h

sub_30:sub dl,30h
       add rbx,rdx
       inc rsi
       dec byte[actl]
       jnz up
       
       
       ret

display:mov rsi,char_buff
        mov rcx,16

up1:rol rbx,04
    mov dl,bl
    and dl,0FH
    cmp dl,09H
    jbe add_30
    add dl,07H

add_30:add dl,30H
       mov [rsi],dl
       inc rsi
       dec rcx
       jnz up1

write char_buff,16

ret

factorial:push rbp
          mov rbp,rsp
          mov rax,[rbp+16]
          cmp rax,1
          je end_factorial
          dec rax
          push rax
          call factorial
          mov rbx,[rbp+16]
          imul rax,rbx

end_factorial:mov rsp,rbp
              pop rbp
              ret
