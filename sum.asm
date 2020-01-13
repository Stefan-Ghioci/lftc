section .data
formatin: db "%d", 0
formatout: db "%d", 10, 0
a: times 4 db 0
b: times 4 db 0
c: times 4 db 0
temp1: times 4 db 0

section .text
global main
extern scanf
extern printf
main:
push a
push formatin
call scanf
add esp, 8
push b
push formatin
call scanf
add esp, 8
mov ebx, dword [a]
mov ecx, dword [b]
add ebx, ecx
mov [temp1], ebx
mov eax, [temp1]
mov [c], eax
push dword [c]
push formatout
call printf
add esp, 8

mov eax, 0
ret
