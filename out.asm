section .data
formatin: db "%d", 0
formatout: db "%d", 10, 0
a: times 4 db 0
b: times 4 db 0
c: times 4 db 0
d: times 4 db 0
temp1: times 4 db 0
temp2: times 4 db 0
temp3: times 4 db 0

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
push d
push formatin
call scanf
add esp, 8
mov ebx, dword [a]
mov ecx, dword [b]
add ebx, ecx
mov [temp1], ebx
mov eax, [temp1]
mov [c], eax
mov ebx, dword [c]
mov ecx, dword [d]
add ebx, ecx
mov [temp2], ebx
mov eax, [temp2]
mov [c], eax
push dword [c]
push formatout
call printf
add esp, 8
push a
push formatin
call scanf
add esp, 8
mov edx, 0
mov eax, dword [a]
mov ecx, dword [b]
mul ecx
mov [temp3], eax
mov eax, [temp3]
mov [a], eax
push dword [a]
push formatout
call printf
add esp, 8

mov eax, 0
ret
