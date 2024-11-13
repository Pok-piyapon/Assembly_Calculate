;Midterm project:version 0.1
;Student ID     : 673380050-9
;Section        : 1
;Student Name   : Piyapon Kaewkebkam
extern _printf 
extern _scanf
global _main

; AC  = EAX (4byte) , AL (1byte)
; EBP = XR , JMP = JUMP , JUMPZ = JZ , JUMPN = JC
; EIP = PC , SP = ESP
; STORE or LOAD = MOV
section .data
    sortText: db "Sorted is : ",0
    minText: db 10,"Min Value is : ",0
    maxText: db 10,"Max Value is : ",0
    rangeText: db 10,"Range Value is : ",0
    medianText: db 10,"Median Value is : ",0
    meanText: db 10,"Mean Value is : ",0
    min: db 0
    max: db 0
    range: db 0,0
    msg1: db "Enter amount of number : ",0 
    msg2: db "Enter number : ",0
    formatin: db "%d"
    result: times 99 db 0,0
    swap: db "1"
    index: db 0
    temp1: db 0


section .bss 
    amount: times 4 db 0
    number: times 4 db 0

section .text
_main:
    CALL setup
    CALL minValue
    CALL maxValue
    CALL RangeValue
    CALL MedianValue
    CALL MeanValue
    CALL ENDED

setup:
    ; Print Text msg1
    PUSH msg1
    CALL _printf

    ;Input amount of number
    ADD ESP, 4 ; ล้าง STACK 1 STEP
    PUSH amount
    PUSH formatin
    CALL _scanf
    MOV EAX,[amount]
    MOV [temp1],EAX
    ;ล้าง 2 STACK เพื่อไปยัง return address function
    ADD ESP,8
    
    ; วนซ้ำเข้ารับเลขเข้า Stack
    MOV EAX,'0'
    PUSH EAX
    MOV EAX,0
    JMP LoopInput
    RET

LoopInput:
    
    ;Input to Stack
    ;Print To tell user input number
    MOV EAX,[amount]
    CMP EAX,0
    JZ  bubble_sort
    PUSH msg2
    CALL _printf
    ADD ESP,4 ; ล้าง STACK ของ print function
    
    PUSH number
    PUSH formatin
    CALL _scanf
    ADD ESP,8
    ; PUSH number to stack
    MOV EAX,[number]
    PUSH EAX
    MOV EAX,[amount]
    SUB EAX,1
    MOV [amount],EAX

    MOV EBP,0
    JMP LoopInput
;;;;;;;;;;;;;;;;;;;;;;;;;;;;; BUBLE SORT ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
bubble_sort:
    ; set INDEX POINTER
    MOV AL,[index]
    MOV EBP,EAX
start_sort:
    ; Set Index Pointer
    MOV AL,[index]
    MOV EBP,EAX
    ; Load Stack with indicate pointer
    MOV EAX,[ESP + EBP]

    ; Add Index To next
    ADD EBP,4
    ; Load Stack with indicate pointer
    MOV EBP,[ESP + EBP]
    ; Sub track for find value
    SUB EAX,EBP
    JC RIGHTMORE
    JMP LEFTMORE

LEFTMORE:
    ; Swap to true
    MOV AL,[swap]
    SUB AL,'0'
    SUB AL,1
    MOV [swap],AL
    ; Save for missing
    MOV AL,[index]
    MOV EBP,EAX
    ADD EBP,4
    MOV EAX,[ESP + EBP]
    MOV [temp1],AL

    ; Mov First value to Second Value
    MOV AL,[index]
    MOV EBP,EAX
    MOV EAX,[ESP + EBP]
    ADD EBP,4
    MOV [ESP + EBP],EAX
    
    ; Mov Second Value to First Value
    MOV AL,[index]
    MOV EBP,EAX
    MOV AL,[temp1]
    MOV [ESP + EBP],EAX

    ; Increment Index to 4
    MOV AL,[index]
    ADD AL,4
    MOV [index],AL

    ; Check if Swap is true
    MOV AL,[swap]
    CMP AL,0
    JZ  Restart
    ; Loop For Sorting
    JMP start_sort

RIGHTMORE:
    MOV EAX,0
    MOV AL,[index]
    ADD AL,4
    MOV [index],AL
    ; Reset Swap to '1'
    MOV AL,'1'
    MOV [swap],AL
    ; Check if Sorted Successfully
    MOV AL,[index]
    ADD AL,4
    MOV EBP,EAX
    MOV EAX,[ESP + EBP]
    CMP EAX,'0'
    JE  save_sort
    ; Loop
    JMP start_sort

Restart:
    MOV AL,[index]
    MOV AL,0
    MOV [index],AL
    JMP start_sort

save_sort:
    MOV AL,0
    MOV [index],AL
start_save_sort:
    MOV AL,[index]
    MOV EBP,EAX
    POP EAX
    SUB AL,'0'
    CMP AL,0 ; Jump Zero Flag
    JZ pre_print_sort
    ADD AL,'0'
    MOV [result + EBP],AL
    MOV AL,[index] ;Increment Index To replace data
    ADD AL,1
    MOV [index],AL
    ; Increment Value of amount
    MOV AL,[amount]
    ADD AL,1
    MOV [amount],AL
    MOV EAX,0 ; Clear register
    JMP start_save_sort
pre_print_sort:
    MOV AL,0
    MOV [index],AL
print_sort:
    MOV AL,[index]
    MOV EBP,EAX
    MOV AL,[result + EBP]
    ADD AL,'0'
    SUB AL,'0'
    JZ  print
    ADD AL,'0'
    MOV [result + EBP],AL
    MOV AL,[index]
    ADD AL,1
    MOV [index],AL
    JMP print_sort
print:
    PUSH sortText
    CALL _printf
    ADD ESP,4
    PUSH result
    CALL _printf
    ADD ESP,4
    JMP return

return:
    RET
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; minValue ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
minValue:
    MOV EBP,0
    MOV AL,[result + EBP]
    MOV [min],AL
    PUSH minText
    CALL _printf
    ADD ESP,4
    PUSH min
    CALL _printf
    ADD ESP,4
    JMP return
;;;;;;;;;;;;;;;;;;;;;;;;;; maxValue ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
maxValue:
    MOV AL,[amount]
    SUB AL,1
    MOV EBP,EAX
    MOV AL,[result + EBP]
    MOV [max],AL
    PUSH maxText
    CALL _printf
    ADD ESP,4
    PUSH max
    CALL _printf
    ADD ESP,4
    JMP return
;;;;;;;;;;;;;;;;;;;;;;;;;;;; RangeValue ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
RangeValue:
    MOV AL,[max]
    SUB AL,[min]
    ADD AL,'0'
    MOV [range],AL
    ; Print Range
    PUSH rangeText
    CALL _printf
    ADD ESP,4
    ; Print Range Value
    PUSH range
    CALL _printf
    ADD ESP,4
    JMP return
;;;;;;;;;;;;;;;;;;;;;;;;;;;; _Diver function ;;;;;;;;;;;;;;;;;;;;;;;;;;
_diver:
    MOV AL,0
    MOV [temp1],AL
start_diver:
    ; Increment value of diver
    MOV AL,[temp1]
    ADD AL,1
    MOV [temp1],AL
    ; END
    MOV EBP,0
    MOV EBP,4
    MOV AL,[ESP + EBP]
    ADD EBP,4
    SUB AL,[ESP + EBP]
    SUB EBP,4
    MOV [ESP + EBP],AL
    ; Check if it has a one
    SUB AL,1
    JZ  return
    JC  negative_dive

    JMP start_diver
negative_dive:
    ADD AL,1
    JMP return
;;;;;;;;;;;;;;;;;;;;;;;;;;;; MedianValue ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MedianValue:
    PUSH 2
    MOV EAX,[amount]
    PUSH EAX
    CALL _diver
    POP  EAX
    ADD ESP,4

    SUB AL,1
    JZ  odd
    JMP even
even:
    MOV AL,[temp1]
    MOV EBP,EAX
    SUB EBP,1
    MOV AL,[result + EBP]
    SUB AL,'0'
    MOV [temp1],AL
    ADD EBP,1
    MOV AL,[result + EBP]
    SUB AL,'0'
    ADD AL,[temp1]
    ; dive
    PUSH 2
    PUSH EAX
    CALL _diver
    ADD ESP,8
    ; print median value
    MOV AL,[temp1]
    ADD AL,'0'
    MOV [temp1],AL
    PUSH medianText
    CALL _printf
    ADD ESP,4
    PUSH temp1
    CALL _printf
    ADD ESP,4
    JMP return
odd:
    PUSH medianText
    CALL _printf
    ADD ESP,4
    MOV AL,[temp1]
    MOV EBP,EAX
    MOV AL,[result + EBP]
    MOV [temp1],AL
    PUSH temp1
    CALL _printf
    ADD ESP,4
    JMP return
;;;;;;;;;;;;;;;;;;;;;;;;;; Mean Value ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MeanValue:
    MOV AL,0
    MOV [index],AL
    MOV [temp1],AL
SummaryValue:
    MOV AL,[index]
    MOV EBP,EAX
    MOV AL,[result + EBP]
    SUB AL,'0'
    JC endMean
    ADD AL,[temp1]
    MOV [temp1],AL
    ; increment index by one
    MOV AL,[index]
    ADD AL,1
    MOV [index],AL
    JMP SummaryValue
endMean:
    MOV EAX,[amount]
    PUSH EAX
    MOV EAX,[temp1]
    PUSH EAX
    CALL _diver
    ADD ESP,8
    PUSH meanText
    CALL _printf
    ADD ESP,4
    MOV AL,[temp1]
    ADD AL,'0'
    MOV [temp1],AL
    PUSH temp1
    CALL _printf
    ADD ESP,4
    JMP return
;;;;;;;;;;;;;;;;;;;;;;;;; ENDED ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDED:
    INT 80h