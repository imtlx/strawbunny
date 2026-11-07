format ELF64 executable 3
entry start

segment readable executable

start:
	mov rax, 1
	mov rdi, 1
	mov rsi, title
	mov rdx, title_len
	syscall

	mov rsi, bunny
	mov rdx, bunny_len
	call print

	mov rsi, intro
	mov rdx, intro_len
	call print

	xor r12, r12	; strawberries distributed
	mov r13, 5	; initial strawberry stock

menu:
	mov rsi, menu_text
	mov rdx, menu_len
	call print

	; user choice
	mov rax, 0
	mov rdi, 0
	mov rsi, input
	mov rdx, 8
	syscall

	cmp byte [input], '1'
	je distribute

	cmp byte [input], '2'
	je inventory

	cmp byte [input], '3'
	je pet_bunny

	cmp byte [input], '4'
	je quit

	mov rsi, confused
	mov rdx, confused_len
	call print
	jmp menu

distribute:
	cmp r13, 0
	je no_strawberries

	dec r13
	inc r12

	mov rsi, delivery
	mov rdx, delivery_len
	call print

	cmp r12, 10
	je secret

	jmp menu

no_strawberries:
	mov rsi, empty
	mov rdx, empty_len
	call print
	jmp menu

inventory:
	mov rsi, stock_msg
	mov rdx, stock_len
	call print

	mov rax, r13
	call print_number
	jmp menu

pet_bunny:
	mov rsi, pet_msg
	mov rdx, pet_len
	call print

	cmp r13, 5
	je max_stock

	inc r13
	mov rsi, restock_msg
	mov rdx, restock_len
	call print

	jmp menu

max_stock:
	mov rsi, max_stock_msg
	mov rdx, max_stock_len
	call print
	jmp menu

secret:
	mov rsi, secret_msg
	mov rdx, secret_len
	call print
	jmp menu

quit:
	mov rsi, goodbye
	mov rdx, goodbye_len
	call print

	mov rax, 60
	xor rdi, rdi
	syscall

; print(rsi: addr, rdx: len)
print:
	mov rax, 1
	mov rdi, 1
	syscall
	ret

; print_number(rax: uint)
print_number:
	mov rcx, 10
	xor rdx, rdx
	div rcx
	add dl, '0'
	mov [number], dl

	mov byte [number+1], 10
	mov rsi, number
	mov rdx, 2
	call print
	ret

segment readable writeable

title	db 10
	db '================================', 10
	db '   THE STRAWBERRY DISTRIBUTOR   ', 10
	db '================================', 10, 10
title_len = $ - title

bunny	db '       (\_/)', 10
	db '       (o.o)   < hiiii!', 10
	db '       (> <)   ', 10, 10
bunny_len = $ - bunny

intro	db '  Bunbun welcomes you!', 10
	db '  Your mission: distribute joy.', 10, 10
intro_len = $ - intro

menu_text:
	db 10
	db '  +----------------------------+', 10
	db '  |  STRAWBERRY CONTROL PANEL  |', 10
	db '  +----------------------------+', 10
	db '  | 1. Distribute strawberry   |', 10
	db '  | 2. Check strawberry stock  |', 10
	db '  | 3. Pet the silly bnuuy     |', 10
	db '  | 4. Leave the garden        |', 10
	db '  +----------------------------+', 10
	db '  Choice: '
menu_len = $ - menu_text

delivery:
	db 10
	db '  🍓 *POP!* A strawberry was delivered!', 10
	db '  Bnuuy says: mwehehehe :3', 10
	db '  Thank you for spreading sweetness!', 10
	db 10
delivery_len = $ - delivery

empty	db 10
	db '  OH NO!! NO MORE STRAWBERRIES!!', 10
	db '  Bnuuy is staring at you sadly.', 10
	db '  (｡•́︿•̀｡)', 10
	db 10
empty_len = $ - empty

stock_msg:
	db 10
	db '  Strawberry stock: '
stock_len = $ - stock_msg

pet_msg:
	db 10
	db '  *pat pat pat*', 10
	db '  Bnuuy happiness increased!', 10
	db '  (\_/)', 10
	db '  ( ^.^)  < fren!!', 10
	db '  / >🍓', 10, 10
pet_len = $ - pet_msg

restock_msg:
	db '  +1 strawberry! Bnuuy loves you!', 10
	db 10
restock_len = $ - restock_msg

max_stock_msg:
	db '  Your strawberry basket is already full!', 10
	db '  Bnuuy says: no more roomies! :3', 10
	db 10
max_stock_len = $ - max_stock_msg

confused db '  Bnuuy does not understand.', 10
confused_len = $ - confused

secret_msg:
	db 10
	db '  ★★★ SECRET ACHIEVEMENT ★★★', 10
	db '  STRAWBERRY OVERLORD!!', 10
	db '  Bunbun bows before you.', 10
	db '  You are now an honorary bnuuy.', 10, 10
secret_len = $ - secret_msg

goodbye	db 10
	db '  Bnuuy waves goodbye!', 10
	db '       (\_/)', 10
	db '       (o.o)  < come back soon!', 10
	db '       (")(")', 10
	db 10
	db '  Stay sweet. Stay fluffy. 🍓', 10
	db 10
goodbye_len = $ - goodbye

input rb 8
number rb 2
