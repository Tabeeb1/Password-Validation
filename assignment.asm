.MODEL SMALL
.STACK 100H
.DATA

;--------- Anas Data Part Starts ----------

lower_flag db 0
upper_flag db 0
number_flag db 0
special_char db 0

array db 15 dup(?)
total_chars db 0

ask_generate_msg db 'Enter 1 to Generate Password $'
ask_password_msg db 'Enter 2 to Check Password Strength Validation: $'

enter_pass_msg db 'Enter Your Password: $'

no_lower_msg db 'No Lower Character$'
no_upper_msg db 'No Upper Character$'
no_number_msg db 'No Numbers$'
no_special_msg db 'No Special Character$'

strength_msg db 'Password Strength: $'

weak_pass_msg db 'Weak$'
average_pass_msg db 'Average$'
strong_pass_msg db 'Strong$'

;--------- Anas Data Part Ends ----------


;--------- Tabeeb Data Part Starts ----------

CR EQU 0DH       
LF EQU 0AH            

ps db 10 dup(?)  
   db '$'     


tbl db  'abcMNOdefghABCijklmnopqrstuvwDEF'     
tbl1 db 'GHK@L789PQRS12TxyzUVWXYZ#IJ03456'

nm db 5     

;--------- Tabeeb Data Part Ends ----------

;--------- Nafis Data Part Starts ----------

prompt db 'Enter password: $'
message1 db 'Sequence Detected. Please put another password$'
message2 db 'Consecutive same charatcer. Please put another password$'
message3 db 'Password is alright$'

passarr db 10 dup(?) 

;--------- Nafis Data Part Ends ---------- 
  
.CODE

;--------- Tabeeb Part Starts ----------

getRandChar proc           
; random number in dl 
mov ah, 0               
int 01ah                  

and dl,31           
 
; get random char in al
mov al,dl     
lea bx,tbl    
xlat         

ret

getRandChar endp



getRandChar2 proc

; random number in dl 
mov ah, 0
int 01ah 

and dl,31
 
; get random char in al
mov al,dl
lea bx,tbl1                 
xlat 

ret

getRandChar2 endp

;--------- Tabeeb Part Ends ----------



MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    
    ;--------- Anas Part Starts ----------
    
    lea dx, ask_generate_msg
    mov ah, 09h
    int 21h
    
    ; New Line Start
    
    MOV AH,2 ;display character function 
    MOV DL,0DH ;carriage return
    INT 21h ;execute carriage return
    MOV DL,0AH ;line feed
    INT 21h ;execute line feed
    
    ; New Line Finish

    lea dx, ask_password_msg  
    mov ah, 09h
    int 21h
    
    mov ah, 01h      
    int 21h
    
    cmp al, 31h ; it will go to this area if the input is 1
    je password_generate
    
    ; New Line Start
    
    MOV AH,2 ;display character function 
    MOV DL,0DH ;carriage return
    INT 21h ;execute carriage return
    MOV DL,0AH ;line feed
    INT 21h ;execute line feed
    
    ; New Line Finish
    
    
    ; This is the initial string to ask password
    
    lea dx, enter_pass_msg
    mov ah, 09h
    int 21h
    
    

    mov cx, 15
    mov si, 0

input_loop:
    mov ah, 01h      
    int 21h
    
    cmp al, 0Dh
    je breaking_loop      

    mov array[si], al 
    
    ; Check if the character is a lowercase letter
    cmp al, 'a'
    jb not_lower
    cmp al, 'z'
    jbe is_lower

not_lower:
    ; Check if the character is an uppercase letter
    cmp al, 'A'
    jb not_upper
    cmp al, 'Z'
    jbe is_upper

not_upper:
    ; Check if the character is a number
    cmp al, '0'
    jb not_number
    cmp al, '9'
    jbe is_number

not_number:
    ; If the character is not a letter or a number, it's a special character
    jmp is_special

is_lower:
    mov lower_flag, 1
    jmp continue_loop

is_upper:
    mov upper_flag, 1
    jmp continue_loop

is_number:
    mov number_flag, 1
    jmp continue_loop

is_special:
    mov special_char, 1

continue_loop:
    inc si           
    inc total_chars
    loop input_loop
    
    
breaking_loop: ; it will come here if the user breaks the loop by enter
    
    ; New Line Start
    
    MOV AH,2 ;display character function 
    MOV DL,0DH ;carriage return
    INT 21h ;execute carriage return
    MOV DL,0AH ;line feed
    INT 21h ;execute line feed
    
    ; New Line Finish
    
    ; This if for printing 
    mov bl, 0
    
    add bl, lower_flag
    add bl, upper_flag
    add bl, number_flag
    add bl, special_char
    
    cmp total_chars, 5
    jle skip_adding     ; it will skip if the characters are less than or equal to 5
    add bl, 1
    
    
skip_adding:    
    
    
    lea dx, strength_msg
    mov ah, 09h
    int 21h
    
    mov dl, bl
    
    
    ; If dl is less than 1, 1 or 0
    
    cmp dl, 1
    jnle not_weak
    
    lea dx, weak_pass_msg
    mov ah, 09h
    int 21h 
    
    
    jmp reasons
    

not_weak:
    cmp dl, 3
    jnle not_average
    
    lea dx, average_pass_msg
    mov ah, 09h
    int 21h
    
    
    jmp reasons


not_average:
    lea dx, strong_pass_msg
    mov ah, 09h
    int 21h

    
    
    
reasons:
    
    ; New Line Start
    
    MOV AH,2 ;display character function 
    MOV DL,0DH ;carriage return
    INT 21h ;execute carriage return
    MOV DL,0AH ;line feed
    INT 21h ;execute line feed
    
    ; New Line Finish  

    
    mov cx, 15
    mov si, 0

output_loop:
    ; These 3 lines below prints the string it took as input. only used for debugging
    ;mov dl, array[si] 
    ;mov ah, 02h       
    ;int 21h
    
    ; Check other flags or perform other operations here
    
    inc si            
    loop output_loop
    
    ; New Line Start
    
    MOV AH,2 ;display character function 
    MOV DL,0DH ;carriage return
    INT 21h ;execute carriage return
    MOV DL,0AH ;line feed
    INT 21h ;execute line feed
    
    ; New Line Finish
    
    cmp lower_flag, 0
    jne not_needed_lower
    lea dx, no_lower_msg
    mov ah, 09h
    int 21h

not_needed_lower:

    ; New Line Start
    
    MOV AH,2 ;display character function 
    MOV DL,0DH ;carriage return
    INT 21h ;execute carriage return
    MOV DL,0AH ;line feed
    INT 21h ;execute line feed
    
    ; New Line Finish
    
    
    
    ; Print messages for flags not set
    cmp upper_flag, 0
    jne not_needed_upper
    lea dx, no_upper_msg
    mov ah, 09h
    int 21h
not_needed_upper:
    ; New Line Start
    
    MOV AH,2 ;display character function 
    MOV DL,0DH ;carriage return
    INT 21h ;execute carriage return
    MOV DL,0AH ;line feed
    INT 21h ;execute line feed
    
    ; New Line Finish

    cmp number_flag, 0
    jne not_needed_number
    lea dx, no_number_msg
    mov ah, 09h
    int 21h
not_needed_number:

    ; New Line Start
    
    MOV AH,2 ;display character function 
    MOV DL,0DH ;carriage return
    INT 21h ;execute carriage return
    MOV DL,0AH ;line feed
    INT 21h ;execute line feed
    
    ; New Line Finish 



    cmp special_char, 0
    jne not_needed_special
    lea dx, no_special_msg
    mov ah, 09h
    int 21h
not_needed_special:
    ; Print a newline character for better formatting
    mov dl, 0Ah
    mov ah, 02h
    int 21h
    
    

    jmp nafis_part

;--------- Anas Part Ends ----------

;--------- Tabeeb Part Starts ----------
    
password_generate:


    
    MOV AH,2 ;display character function 
    MOV DL,0DH ;carriage return
    INT 21h ;execute carriage return
    MOV DL,0AH ;line feed
    INT 21h ;execute line feed
    


mov si,0            


top: 

call getRandChar     


;push to ps   
mov [ps+si],al        
inc si                 

 
 
call getRandChar2             
;push to ps                     
mov [ps+si],al                 
inc si                           
                                    
 
sub nm,1                         
jnz top                         


mov ah,9                       
mov dx,offset ps          
int 21h

jmp exit
    


;--------- Tabeeb Part Ends ---------- 


;--------- Nafis Part Starts ----------

;mov ah, 09h         ; Display prompt message
;    lea dx, prompt
;    int 21h
    
;    mov cx,10
;    mov si,0
;    mov ah,01h
;    input:
;    int 21h
;    mov passarr[si],al
;    inc si
;    loop input
    
;    MOV AH,2
;    MOV DL, 0DH ;carriage return
;    INT 21h ;execute
;    MOV DL, 0AH ; line feed
;    int 21H ; execute
    
;    mov cx,10
;    mov si,0

nafis_part:

; New Line Start
    
    MOV AH,2 ;display character function 
    MOV DL,0DH ;carriage return
    INT 21h ;execute carriage return
    MOV DL,0AH ;line feed
    INT 21h ;execute line feed
    
; New Line Finish

mov cx, 0 
mov cl, total_chars
mov si,0
    
    show:
    mov al , array[si]
    inc si
    mov bl , array[si]
    cmp al,bl
    je equal
    
    sub bl,al
    cmp bl,1
    je sequence
    loop show
    
    mov ah, 09h         ; Display Password is alright message
    lea dx, message3
    int 21h
    jmp exit
    
    equal:
    mov ah, 09h         ; Display Consecutive same charatcer message
    lea dx, message2
    int 21h
    jmp exit
    
    sequence:
    mov ah, 09h         ; Display Sequence Detected message
    lea dx, message1
    int 21h
    jmp exit

;--------- Nafis Part Ends ----------

   
exit:

    ; This is just for debugging, it prints the total number of characters in the string
    ;mov dl, total_chars
    ;add dl, '0'
    ;mov ah, 02h
    ;int 21h
    
    

MAIN ENDP
end main
