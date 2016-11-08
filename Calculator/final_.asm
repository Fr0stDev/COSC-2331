; Final - Calculator project
; Guillermo Moran
; nasm -f elf final_.asm && ld -m elf_i386 -s -o final_ final_.o && ./final_


; Predefined for Quadratic
%define a               dword [ebp+8]
%define b               dword [ebp+12]
%define c               dword [ebp+16]
%define root1           dword [ebp+20]
%define root2           dword [ebp+24]
%define disc            dword [ebp-4]
%define one_over_2a     dword [ebp-8]

section .data

		;Global constants
		INT_LEN equ 32						;The max length of an integar

		; Input Length Limits
		input_limit equ 32

		; ======================
		; CLI Messages
		; ======================

		goodbye_message db 'Goodbye', 0xa
		goodbye_len equ $-goodbye_message

		please_enter_first db 'Please enter your first number: '
		pef_len equ $-please_enter_first

		please_enter_second db 'Please enter your second number: '
		pes_len equ $-please_enter_second

		please_enter_third db 'Please enter your third number: '
		pet_len equ $-please_enter_third

		choice_select db 0xa, 'a) add', 0xa, 's) subtract', 0xa, 'm) multiply', 0xa, 'd) divide', 0xa, 'r) roots', 0xa, 'e) exit', 0xa, 0xa, 'Please enter your choice: '
		choice_select_len equ $-choice_select

		answer_msg db 0xa, '-- The Answer is: '
		answer_msg_len equ $-answer_msg

		root1_is db 0xa, '-- Root 1:'
		root1_is_len equ $-root1_is

		root2_is db 0xa, '-- Root 2:'
		root2_is_len equ $-root2_is

		no_solution_msg db 0xa, '-- No Solutions Found', 0xa
		no_solution_msg_len equ $-no_solution_msg

		error_msg db 0xa, '-- Invalid Choice', 0xa
		error_len equ $-error_msg

		newline db 0xa
		newline_len equ $-newline

		; Quadratic Formula parameters
		MinusFour dw -4



section .bss

		; User inputs saved here
		num1 resb 1
		num2 resb 1
		num3 resb 1

		first_int resd 1
		second_int resd 1

		; Quadratic Forumla Stuff
		third_int resd 1

		root1_f resd 1
		root2_f resd 1

		first_float resd 1
		second_float resd 1
		third_float resd 1

		; final answer saved here
		answer resd 1

		; user choice saved here
		user_choice resb 1

		; ================================
		; atoi function parameters
		; ================================
		strin resb INT_LEN		;the string of int read from the console
		lenstrin resd 1			;the actual number of values entered by user

		; ================================
		; itoa function parameters
		; ================================
		tempstr resb INT_LEN	;temp string to hold inverted number string being calculated
		strout resb INT_LEN		;the int converted to string and displayed buffer
		lenstrout resd 1		;the length of string formed

section .text

global _start

; **********************
; MAIN FUNCTION _start
; **********************
_start:

		while_loop_main:

				mov byte[answer], 0

				; ============
				; Get User Choice
				; ============

				call showMenuAndGetChoice ;saves choice to 'choice'
				mov al, [user_choice]
				cmp al, 'e'
				je .UserChoseE

				; Get first number -> int
				call getFirstNum

				push num1
				call atoi ; returns int in eax
				add esp, 4

				; ============
				; For some absurd reason, you have to store something in second_int FIRST
				; I hate computers
				; ============
				mov [second_int], eax ; store number in first_int

				; Get second number -> int
				call getSecondNum

				push num2
				call atoi ; returns int in eax
				add esp, 4

				mov [first_int], eax ; store number in second_int

				; ================
				; Compare user choices
				; a - add
				; s - subtract
				; m - multiply
				; d - divide
				; r - roots
				; e - exit
				; =================

				mov al, [user_choice]
				cmp al, 'e'

				cmp al, 'a'
				je .UserChoseA

				cmp al, 's'
				je .UserChoseS

				cmp al, 'm'
				je .UserChoseM

				cmp al, 'd'
				je .UserChoseD

				cmp al, 'r'
				je .UserChoseR

				call showErrorMessage
				jmp while_loop_main


				.UserChoseA:
						call add_nums
						jmp while_loop_main

				.UserChoseS:
						call sub_nums
						jmp while_loop_main

				.UserChoseM:
						call mul_nums
						jmp while_loop_main

				.UserChoseD:
						call div_nums
						jmp while_loop_main

				.UserChoseR:

						; Get a third Number
						call getThirdNum

						push num3
						call atoi ; returns int in eax
						add esp, 4

						mov [third_int], eax ; store number in third_int

						call getRoots

						jmp while_loop_main

				.UserChoseE:
						call exit

; **********************
; void add_nums
; -- Add Numbers
; **********************
add_nums:
		push ebp
		mov ebp, esp

		fild dword [second_int]
		fild dword [first_int]
		faddp
		fstp dword [answer]

		fld dword [answer]
		fistp dword [answer]

		; The answer is:
		push answer_msg_len
		push answer_msg
		call output_str
		add esp, 8

		mov eax, [answer]
		push eax
		call itoa
		add esp, 4

		; New Line
		push newline_len
		push newline
		call output_str
		add esp, 8

		pop ebp
		ret

; **********************
; void sub_nums
; -- Subtract Numbers
; **********************
sub_nums:
		push ebp
		mov ebp, esp

		fild dword [second_int]
		fild dword [first_int]
		fsubp
		fstp dword [answer]

		fld dword [answer]
		fistp dword [answer]

		; The answer is:
		push answer_msg_len
		push answer_msg
		call output_str
		add esp, 8

		mov eax, [answer]
		push eax
		call itoa
		add esp, 4

		; New Line
		push newline_len
		push newline
		call output_str
		add esp, 8

		pop ebp
		ret

; **********************
; void mul_nums
; -- Multiply Numbers
; **********************
mul_nums:
		push ebp
		mov ebp, esp

		fild dword [second_int]
		fild dword [first_int]
		fmulp
		fstp dword [answer]

		fld dword [answer]
		fistp dword [answer]

		; The answer is:
		push answer_msg_len
		push answer_msg
		call output_str
		add esp, 8

		mov eax, [answer]
		push eax
		call itoa
		add esp, 4

		; New Line
		push newline_len
		push newline
		call output_str
		add esp, 8

		pop ebp
		ret

; **********************
; void div_nums
; -- Divide Numbers
; **********************
div_nums:
		push ebp
		mov ebp, esp

		fild dword [second_int]
		fild dword [first_int]
		fdivp
		fstp dword [answer]

		fld dword [answer]
		fistp dword [answer]

		; The answer is:
		push answer_msg_len
		push answer_msg
		call output_str
		add esp, 8

		mov eax, [answer]
		push eax
		call itoa
		add esp, 4

		; New Line
		push newline_len
		push newline
		call output_str
		add esp, 8

		pop ebp
		ret

; **********************
; void getRoots
; -- Converts first_int, second_int, third_int to floats
; -- Uses them to calculate roots using the quadratic equation
; **********************

getRoots:

		push ebp
		mov ebp, esp

		; Convert numbers to floats
		fild dword [second_int]
		fstp dword [second_float]

		fild dword [first_int]
		fstp dword [first_float]

		fild dword [third_int]
		fstp dword [third_float]

		; pushing in this order is important
		; Remember:
		; 		a = second_float
		; 		b = first_float
		; 		c = third_float
		push root2_f 		; root2 stored here
		push root1_f 		; root1 stored here
		push third_float 	; c
		push first_float  ; b
		push second_float	; a
		call quadratic
		add esp, 20

		fld dword [root1_f]
		fistp dword [root1_f]

		fld dword [root2_f]
		fistp dword [root2_f]

		cmp eax, 1
		je .sol_found
		jb .no_sol

		.no_sol:
				push no_solution_msg_len
				push no_solution_msg
				call output_str
				add esp, 8

				jmp .root_done

		.sol_found:
				; =======
				; Print Root 1
				; =======
				push root1_is_len
				push root1_is
				call output_str
				add esp, 8

				mov eax, [root1_f]
				push eax
				call itoa
				add esp, 4

				; New Line
				push newline_len
				push newline
				call output_str
				add esp, 8

				; =======
				; Print Root 2
				; =======

				push root2_is_len
				push root2_is
				call output_str
				add esp, 8

				mov eax, [root2_f]
				push eax
				call itoa
				add esp, 4

				; New Line
				push newline_len
				push newline
				call output_str
				add esp, 8

		.root_done:
				pop ebp
				ret


; **********************
; void getFirstNum
; -- Takes user input for num1
; **********************
getFirstNum:

		push ebp
		mov ebp, esp

		; Prompt for num1
		push pef_len
		push please_enter_first
		call output_str
		add esp, 8


		; Take input for num1
		push input_limit
		push num1
		call input_str
		add esp, 8

		pop ebp

		ret
; **********************
; void getSecondNum
; -- Takes user input for num2
; **********************
getSecondNum:

		push ebp
		mov ebp, esp

		; Prompt for num2
		push pes_len
		push please_enter_second
		call output_str
		add esp, 8

		; Take input for num2
		push input_limit
		push num2
		call input_str
		add esp, 8

		pop ebp

		ret

; **********************
; void getThirdNum
; -- Takes user input for num3 (for roots)
; **********************
getThirdNum:

		push ebp
		mov ebp, esp

		; Prompt for num2
		push pet_len
		push please_enter_third
		call output_str
		add esp, 8

		; Take input for num2
		push input_limit
		push num3
		call input_str
		add esp, 8

		pop ebp

		ret

; **********************
; void showGoodbyeMessage
; -- Shows exit message
; **********************
showGoodbyeMessage:

		push ebp
		mov ebp, esp

		push goodbye_len
		push goodbye_message
		call output_str
		add esp, 8

		pop ebp
		ret

; **********************
; void showErrorMessage:
; -- Shows error message
; **********************
showErrorMessage:

		push ebp
		mov ebp, esp

		push error_len
		push error_msg
		call output_str
		add esp, 8

		pop ebp
		ret

; **********************
; void showMenuAndGetChoice
; -- Displays the user menu,
; -- Prompts for a choice selection
; **********************
showMenuAndGetChoice:

		push ebp
		mov ebp, esp

		push choice_select_len
		push choice_select
		call output_str
		add esp, 8

		; Get selection
		push input_limit
		push user_choice
		call input_str
		add esp, 8

		pop ebp

		ret

; ********************
; void output_string(str*, str_len) - displays the string str* on screen
; ********************
output_str:

		push ebp
		mov ebp, esp

		mov eax, 4
		mov ebx, 1
		mov ecx, [ebp + 8]
		mov edx, [ebp + 12]

		int 0x80
		pop ebp
		ret

; ********************
; void input_string(str*, str_len) - gets user input in the buffer str*
; ********************
input_str:

		push ebp
		mov ebp, esp

		mov eax, 3
		mov ebx, 2
		mov ecx, [ebp + 8]
		mov edx, [ebp + 12]

		int 0x80
		pop ebp
		ret

; **********************
; int atoi()
; Read and returns an int from the console. The value is returned in EAX.
; **********************
atoi:
	push ebp
	mov ebp, esp

	dec eax				;remove null char

	mov [lenstrin],eax

	;Initialize
	mov eax, 0				;number will be built in eax
	mov esi, [ebp + 8]			;pointer to string read from the screen
	mov ebx, 0				;placeholder for the number char
	mov ecx, [lenstrin]		;length of the string for looping

	;move first value
	mov al, [esi]			;read first char from the string
	sub eax, 48				;convert to a number n store in eax
	inc esi					;move string pointer forward
	dec ecx					;decrement looping parameter

	jecxz return			;skip over looping if the number was only 1 value long

 ;loop through the rest of the values
	for_loop:
		mov bl,[esi]		;copy the char
		sub ebx, 48			;convert to num
		imul eax,10			;shift existing number to left
		add eax, ebx		;copy current number at the unit's place
		inc esi				;move string pointer
		loop for_loop

	return:
	pop ebp
	ret					;EAX has the return value i.e. the int read from screen

		;EAX has the return value i.e. the int read from screen

;---------------------------------------------------------------------------------------
;int itoa(int num)
; Converts an integar to a string and displays it on screen
;---------------------------------------------------------------------------------------
itoa:
	push ebp
	mov ebp, esp

	;Initializations
	mov eax,[ebp+8]			;The number to be converted in displayed (input param)
	mov edi, tempstr		;Int string being built
    mov esi, 0				;Length of the strout being built
    mov ecx, 10   			;The divisor has to be in ecx

    ;Build string by dividing by 10 every iteration and saving the remainder
    while_loop:
    	xor edx,edx			;clear higher bits for div
    	idiv ecx			;EAX has the quotient and EDX has the remainder
    	add edx, 48
    	mov [edi], dl
    	inc edi
    	inc esi
    	cmp eax, 0
	    jnz while_loop

    ;copy the final length of output string
    inc esi
    mov [lenstrout], esi
    ;dec esi

    ;copy string to reverse
    mov ecx, esi				;copy the string length to loop
    mov esi, strout				;ESI will index the final string

    ;Reverse the string
    loop1:
    	mov eax, [edi]
    	mov [esi],eax
    	dec edi
    	inc esi
    	loop loop1
    mov [esi],byte 0			;null terminate the string

	  ;Display the final number
	 	mov eax, 4
	 	mov ebx, 1
	 	mov ecx, strout
	 	mov edx, [lenstrout]
	 	int 80h

	  pop ebp
	  ret

quadratic:
        push    ebp
        mov     ebp, esp
        sub     esp, 8         ; allocate 2 doubles (disc & one_over_2a)
        push    ebx             ; must save original ebx

        fild    word [MinusFour]; stack -4
        fld     a               ; stack: a, -4
        fld     c               ; stack: c, a, -4
        fmulp   st1             ; stack: a*c, -4
        fmulp   st1             ; stack: -4*a*c
        fld     b
        fld     b               ; stack: b, b, -4*a*c
        fmulp   st1             ; stack: b*b, -4*a*c
        faddp   st1             ; stack: b*b - 4*a*c
        ftst                    ; test with 0
        fstsw   ax
        sahf
        jb      no_real_solutions ; if disc < 0, no real solutions
        fsqrt                   ; stack: sqrt(b*b - 4*a*c)
        fstp    disc            ; store and pop stack
        fld1                    ; stack: 1.0
        fld     a               ; stack: a, 1.0
        fscale                  ; stack: a * 2^(1.0) = 2*a, 1
        fdivp   st1             ; stack: 1/(2*a)
        fst     one_over_2a     ; stack: 1/(2*a)
        fld     b               ; stack: b, 1/(2*a)
        fld     disc            ; stack: disc, b, 1/(2*a)
        fsubrp  st1             ; stack: disc - b, 1/(2*a)
        fmulp   st1             ; stack: (-b + disc)/(2*a)
        mov     ebx, root1
        fstp    dword [ebx]     ; store in *root1
        fld     b               ; stack: b
        fld     disc            ; stack: disc, b
        fchs                    ; stack: -disc, b
        fsubrp  st1             ; stack: -disc - b
        fmul    one_over_2a     ; stack: (-b - disc)/(2*a)
        mov     ebx, root2
        fstp    dword [ebx]     ; store in *root2
        mov     eax, 1          ; return value is 1
        jmp     short quit

		no_real_solutions:
        		;ffree   st0             ; dump disc off stack
        		mov     eax, 0          ; return value is 0

		quit:
		        pop     ebx
		        mov     esp, ebp
		        pop     ebp
		        ret

; **********************
; exit - exits the program
; **********************
exit:
		call showGoodbyeMessage
		mov eax, 1
		int 0x80
