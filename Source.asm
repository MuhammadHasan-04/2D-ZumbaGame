

INCLUDE Irvine32.inc

INCLUDE Macros.inc

ballStruct STRUC
    x DB ?             ; X position
    y DB ?             ; Y position
    color DB ?         ; Color
ballStruct ENDS


.data

;key decleration
leftMov byte  0
rightMov byte 0
upMov byte 0
downMov byte 0
col db -1
;ball movement
ballX byte 0
ballY byte 0
ballX_prev byte 0
ballY_prev byte 0
; Border data declaration
borderWidth BYTE '=' 
borderLength BYTE '|' 
widthNum = 80
lengthNum = 24 

; Data declaration for main menu
title1 byte "######## ##     ## ##     ## ########     ###           ", 0ah, 0
title2 byte "     ##  ##     ## ###   ### ##     ##   ## ##          ", 0ah, 0
title3 byte "    ##   ##     ## #### #### ##     ##  ##   ##         ", 0ah, 0
title4 byte "   ##    ##     ## ## ### ## ########  ##     ##        ", 0ah, 0
title5 byte "  ##     ##     ## ##     ## ##     ## #########        ", 0ah, 0
title6 byte " ##      ##     ## ##     ## ##     ## ##     ##        ", 0ah, 0
title7 byte "########  #######  ##     ## ########  ##     ##        ", 0ah, 0



msg1 BYTE '1.Start New Game', 0
msg2 BYTE '2.Control Menu', 0
msg3 BYTE '3.Exit the Game', 0
msg5 BYTE 'Enter From (1-4) : ',0
msg4 BYTE '4.Show Top Scores',0
choice byte ?

;control Menu
con1 byte '==>Use the arrow keys to move the shooter in the specified direction ',0
con2 byte 'when Pressed left once moves left once and so on till 3',0
con3 byte '==>Press space to shoot the incoming balls ',0

img1 byte '  ||  ',0
img11 byte 'XXXXX ',0
img12 byte' XXXXX ',0
text1 byte  'upward direction',0


img2 byte '\\',0
img21 byte 'XXXXX',0
img22 byte 'XXXXX',0
text2 byte 'one left direction'

; Score
scoreStr byte 'Score : ',0
levelStr byte 'Level : ',0

score byte 0
level byte 1

;movement checks
check byte ?

;ball initialization
ballArray ballStruct 10 DUP(<>) ; Array to hold 10 balls
arrayIndex DW 0
direction DB 1                  ; 1 for clockwise, -1 for counterclockwise
incomingBall ballStruct <0, 0, 0> ; Incoming ball

;for stopping at control menu
wait1 byte ?
.code
main PROC
    
mov ecx, 10                   ; 
mov esi, offset ballArray     ;

initBalls:
    mov byte ptr [esi + 0], 50 ; 
    mov byte ptr [esi + 1], 2  ;
    mov al, cl                 ;
    mov byte ptr [esi + 2], al 
    add esi, SIZE ballStruct  
    loop initBalls

  start:
    call clrscr         ; Clear screen
    call border         ; Display border
    call MainMenu
    ;cmp choice,2        ; Check if '2' is pressed for Control Menu
    ;je showControlMenu

mainLoop:
    call drawFire
    call displayRandomBalls

    mov edx, offset check
    call ReadChar
    mov check, al

    cmp al, 1Bh        
    je done            

   

    jmp mainLoop

showControlMenu:
    call controlMenu
    mov ax,1000
    call Delay
    jmp mainLoop

done:
    exit
main ENDP


; Procedure for forming the border
border PROC
    call Crlf
    call Crlf

     mov ax,lightblue   ; setting the text color
    call SetTextColor

    ; Draw top border
    mov cx, widthNum
topBorderLoop:
    cmp cx, 0
    je drawSides
    mov al, borderWidth
   
    call WriteChar
    dec cx
    jmp topBorderLoop

    ; Draw sides with left and right borders
drawSides:
    mov cx, lengthNum - 2 ; Exclude top and bottom borders
sideLoop:
    cmp cx, 0
    je drawBottom
    call Crlf
    mov al, borderLength 
    call WriteChar

    mov bx, widthNum - 2
    mov dx, bx
spaceLoop:
    cmp dx, 0
    je rightBorder
    mov al, ' '
    call WriteChar
    dec dx
    jmp spaceLoop

rightBorder:
    mov al, borderLength ; Right border '|'
    call WriteChar
    dec cx
    jmp sideLoop

    ; Draw bottom border
drawBottom:
    call Crlf
    mov cx, widthNum
bottomLoop:
    cmp cx, 0
    je endBorder
    mov al, borderWidth
    call WriteChar
    dec cx
    jmp bottomLoop

endBorder:
    ret
border ENDP


controlMenu  PROC

call clrscr
call border

mov dl,3
mov dh,5
call GOTOXY

mov edx, offset con1
call WriteString

mov dl,3
mov dh,6
call GOTOXY

mov edx, offset con2
call WriteString

mov dl,3
mov dh,8
call GOTOXY

mov edx, offset con3
call WriteString

mov dl,20
mov dh,17
call GOTOXY

mov eax,yellow
call SetTextColor

mov edx,offset img1
call WriteString

mov dl,20
mov dh,18
call GOTOXY

mov edx,offset img11
call WriteString

mov dl,19
mov dh,19
call GOTOXY

mov edx,offset img12
call WriteString

mov dl,15
mov dh,20
call GOTOXY

mov edx,offset text1
call WriteString


mov dl,60
mov dh,17
call GOTOXY

mov eax,yellow
call SetTextColor

mov edx,offset img2
call WriteString

mov dl,60
mov dh,18
call GOTOXY

mov edx,offset img21
call WriteString

mov dl,60
mov dh,19
call GOTOXY

mov edx,offset img22
call WriteString

mov dl,50
mov dh,20
call GOTOXY

mov edx,offset text2
call WriteString

L1:
   mov edx,offset wait1
   call ReadInt
   mov wait1,al
   cmp al,1
   je exit1
   jmp L1
exit1:
jmp displayRandomBalls

ret
controlMenu ENDP

MainMenu PROC

    mov ax,Yellow
    call SetTextColor

    mov dl,20
    mov dh,4
    call GOTOXY

    mov edx,offset title1
    call WriteString
    call crlf

    mov dl,20
    mov dh,5
    call GOTOXY

    mov edx, offset title2
    call WriteString
    call crlf

    mov dl,20
    mov dh,6
    call GOTOXY

    mov edx, offset title3
    call WriteString
    call crlf

    mov dl,20
    mov dh,7
    call GOTOXY

    mov edx, offset title4
    call WriteString
    call crlf

    mov dl,20
    mov dh,8
    call GOTOXY

    mov edx, offset title5
    call WriteString
    call crlf

    mov dl,20
    mov dh,9
    call GOTOXY

     mov edx, offset title6
    call WriteString
    call crlf

     mov dl,20
    mov dh,10
    call GOTOXY

   mov edx, offset title7
    call WriteString
    call crlf


    mov ax,Green
    call SetTextColor

    mov dl, 30       ; X-coordinate (column)
    mov dh, 12     ; Y-coordinate (row)
    call Gotoxy     

    mov edx,offset msg1
    call WriteString
    call crlf

    mov dl,30
    mov dh, 13    ; Y-coordinate (row)
    call Gotoxy

    mov edx,offset msg2
    call WriteString
    call crlf
    
    mov dl,30
    mov dh, 14     ; Y-coordinate (row)
    call Gotoxy

    mov edx,offset msg3
    call WriteString
    call crlf

    mov dl,30
    mov dh, 15     ; Y-coordinate (row)
    call Gotoxy

    mov edx,offset msg4
    call WriteString


    mov dl,30
    mov dh, 19    ; Y-coordinate (row)
    call Gotoxy

    mov edx,offset msg5
    call WriteString

    mov edx,offset choice
    call ReadInt
    mov choice,al



MainMenu ENDP

drawMid Proc

;for displaying the level and the score
call clrscr
call border


mov ax,Magenta
call SetTextColor

mov dl,1
mov dh,1
call Gotoxy

mov edx,offset scoreStr
call WriteString
mov al,score
call WriteDec

mov dl,65
mov dh,1
call GOTOXY

mov edx , offset levelStr
call WriteString
mov al,level
call WriteDec



;for displaying the square within

mov ax,Red
call SetTextColor


mov dl,38
mov dh,11
call GOTOXY

mov al,'|'
call WriteChar

add dl,2
call Gotoxy
mov al,'|'
CALL WriteChar


mov dl,35
mov dh,12
call GOTOXY
MOV ECX, 6

drawSquare:
    INC DL
    mov dh,12
    call GOTOXY
    mov al, 'X'        ; Character to draw
    call WriteChar

loop drawSquare

inc dh
mov dl,35
mov ecx,6

NextSquare:
    INC DL
    mov dh,13
    call GOTOXY
    mov al, 'X'        ; Character to draw
    call WriteChar
loop NextSquare

 
ret

drawMid ENDP



;========================
movedown proc
;=========================

;for displaying the level and the score
call clearAndUpdate


mov ax,Red
call SetTextColor



mov dl,35
mov dh,12
call GOTOXY
MOV ECX, 6

drawSquaredown:
    INC DL
    mov dh,12
    call GOTOXY
    mov al, 'X'        ; Character to draw
    call WriteChar

loop drawSquaredown

inc dh
mov dl,35
mov ecx,6

NextSquaredown:
    INC DL
    mov dh,13
    call GOTOXY
    mov al, 'X'        ; Character to draw
    call WriteChar
loop NextSquaredown


mov dl,38
mov dh,14
call GOTOXY

mov al,'|'
call WriteChar

add dl,2
call Gotoxy
mov al,'|'
CALL WriteChar

ret

movedown endp

;for moving it up and in the right place;
;=========================
moveup proc
;=========================

;for displaying the level and the score
call clearAndUpdate

mov ax,Red
call SetTextColor

mov dl,38
mov dh,11
call GOTOXY

mov al,'|'
call WriteChar

add dl,2
call Gotoxy
mov al,'|'
CALL WriteChar


mov dl,35
mov dh,12
call GOTOXY
MOV ECX, 6

drawSquareup:
    INC DL
    mov dh,12
    call GOTOXY
    mov al, 'X'        ; Character to draw
    call WriteChar

loop drawSquareup

inc dh
mov dl,35
mov ecx,6

NextSquareup:
    INC DL
    mov dh,13
    call GOTOXY
    mov al, 'X'        ; Character to draw
    call WriteChar
loop NextSquareup

ret
moveup endp



moveleft1 proc

call clearAndUpdate

mov ax,Red
call SetTextColor

mov dl,36
mov dh,11
call GOTOXY

mov al,'\'
call WriteChar

add dl,2
call Gotoxy
mov al,'\'
CALL WriteChar


mov dl,35
mov dh,12
call GOTOXY
MOV ECX, 6

drawSquareleft1:
    INC DL
    mov dh,12
    call GOTOXY
    mov al, 'X'        ; Character to draw
    call WriteChar

loop drawSquareleft1

inc dh
mov dl,35
mov ecx,6

NextSquareleft1:
    INC DL
    mov dh,13
    call GOTOXY
    mov al, 'X'        ; Character to draw
    call WriteChar
loop NextSquareleft1
;    \\  
;    xxxxx
;    xxxxx  
;

ret
moveleft1 endp


moveleft2 proc

call clearAndUpdate


mov ax,Red
call SetTextColor

mov dl,34
mov dh,12
call GOTOXY

mov al,'-'
call WriteChar
add dl,2


call Gotoxy
mov al,'-'
call WriteChar

mov dl,34
mov dh,13
call Gotoxy
mov al,'-'
CALL WriteChar

inc dl

call Gotoxy
mov al,'-'
call WriteChar


mov dl,35
mov dh,12
call GOTOXY
MOV ECX, 6

drawSquareleft2:
    INC DL
    mov dh,12
    call GOTOXY
    mov al, 'X'        ; Character to draw
    call WriteChar

loop drawSquareleft2

inc dh
mov dl,35
mov ecx,6

NextSquareleft2:
    INC DL
    mov dh,13
    call GOTOXY
    mov al, 'X'        ; Character to draw
    call WriteChar
loop NextSquareleft2


;
;
;   __xxxxx
;   --xxxxx
;

ret
moveleft2 endp


moveleft3 proc


call clearAndUpdate

mov ax,Red
call SetTextColor



mov dl,35
mov dh,12
call GOTOXY
MOV ECX, 6

drawSquareleft3:
    INC DL
    mov dh,12
    call GOTOXY
    mov al, 'X'        ; Character to draw
    call WriteChar

loop drawSquareleft3

inc dh
mov dl,35
mov ecx,6

NextSquareleft3:
    INC DL
    mov dh,13
    call GOTOXY
    mov al, 'X'        ; Character to draw
    call WriteChar
loop NextSquareleft3



mov dl,36
mov dh,14
call GOTOXY

mov al,'/'
call WriteChar

add dl,2
call Gotoxy
mov al,'/'
CALL WriteChar
;      
;    xxxxx
;    xxxxx  
;   //

ret

moveleft3 endp


handleLeftMovement proc

cmp leftMov,1
je First
cmp leftMov,2
je Second
cmp leftMov,3
je Third

First:
    call moveleft1
    jmp done
Second:
    call moveleft2
    jmp done
Third:
    call moveleft3
    jmp done
done:
    ret
handleLeftMovement endp 


moveright1 proc

call clearAndUpdate


mov ax,Red
call SetTextColor

mov dl,41
mov dh,11
call GOTOXY

mov al,'/'
call WriteChar

add dl,2
call Gotoxy
mov al,'/'
CALL WriteChar


mov dl,35
mov dh,12
call GOTOXY
MOV ECX, 6

drawSquareright1:
    INC DL
    mov dh,12
    call GOTOXY
    mov al, 'X'        ; Character to draw
    call WriteChar

loop drawSquareright1

inc dh
mov dl,35
mov ecx,6

NextSquareright1:
    INC DL
    mov dh,13
    call GOTOXY
    mov al, 'X'        ; Character to draw
    call WriteChar
loop NextSquareright1
;        // 
;    xxxxx
;    xxxxx  
;


ret
moveright1 endp

moveright2 proc

call clearAndUpdate


mov ax,Red
call SetTextColor

mov dl,41
mov dh,12
call GOTOXY

mov al,'-'
call WriteChar

mov dl,42
mov dh,12
call Gotoxy

mov al,'-'
call WriteChar

mov dl,41
mov dh,13
call Gotoxy

mov al,'-'
CALL WriteChar

mov dl,42
mov dh,13
call Gotoxy

call Gotoxy
mov al,'-'
call WriteChar



mov dl,35
mov dh,12
call GOTOXY
MOV ECX, 6

drawSquareright2:
    INC DL
    mov dh,12
    call GOTOXY
    mov al, 'X'        ; Character to draw
    call WriteChar

loop drawSquareright2

inc dh
mov dl,35
mov ecx,6

NextSquareright2:
    INC DL
    mov dh,13
    call GOTOXY
    mov al, 'X'        ; Character to draw
    call WriteChar
loop NextSquareright2


;      
;    xxxxx--
;    xxxxx--  
;   

ret
moveright2 endp

moveright3 proc



call clearAndUpdate

mov ax,Red
call SetTextColor



mov dl,35
mov dh,12
call GOTOXY
MOV ECX, 6

drawSquareright3:
    INC DL
    mov dh,12
    call GOTOXY
    mov al, 'X'        ; Character to draw
    call WriteChar

loop drawSquareright3

inc dh
mov dl,35
mov ecx,6

NextSquareright3:
    INC DL
    mov dh,13
    call GOTOXY
    mov al, 'X'        ; Character to draw
    call WriteChar
loop NextSquareright3



mov dl,41
mov dh,14
call GOTOXY

mov al,'\'
call WriteChar

add dl,2
call Gotoxy
mov al,'\'
CALL WriteChar
;      
;    xxxxx
;    xxxxx  
;        \\
ret
moveright3 endp



handleRightMovement proc

cmp rightMov,1
je First
cmp rightMov,2
je Second
cmp rightMov,3
je Third

First:
    call moveright1
    jmp done
Second:
    call moveright2
    jmp done
Third:
    call moveright3
    jmp done
done:
    ret
handleRightMovement endp 

;procedure for the balls movement and tracks
displayRandomBalls proc
    mov ecx, 50                    ; Set the loop counter for 50 iterations
Loop1:
    cmp ecx, 0
    je done    
    dec ecx

    mov arrayIndex, 0              ; Reset arrayIndex to 0
updateBalls:
    cmp arrayIndex, 10
    jge updateBallsDone            ; Exit when all 10 balls are processed

    movzx eax, arrayIndex            ; Zero-extend 16-bit arrayIndex into 32-bit EAX
    imul eax, SIZEOF ballStruct      ; Calculate offset: arrayIndex * structure size
    lea esi, ballArray               ; Load base address of ballArray
    add esi, eax                     ; Add calculated offset to ESI

    ; Update ball position (move in negative x and positive y direction)
    mov al, direction                ; Load the value of 'direction' into AL
    sub byte ptr [esi + 0], al       ; Move x-coordinate in negative direction (subtract)
    inc byte ptr [esi + 1]           ; Increment y (move in positive direction)

    ; Clear previous ball position
    mov dl, byte ptr [esi + 0]       ; Load x
    mov dh, byte ptr [esi + 1]       ; Load y
    dec dh                           ; Calculate previous y position (before increment)
    call gotoxy                      ; Move cursor to previous position
    mov al, ' '                      ; Clear the previous ball
    call WriteChar

    ; Draw the new ball position
    mov dl, byte ptr [esi + 0]       ; Load updated x
    mov dh, byte ptr [esi + 1]       ; Load updated y
    call gotoxy                      ; Move cursor to new position

    ; Set only the foreground color
    mov ah, byte ptr [esi + 2]       ; Load ball color (offset 2)
    push eax
    mov eax,16
    call RandomRange
    and ah,0fh
    call SetTextColor
    mov al, '*'                      ; Draw the new ball
    call WriteChar
    pop eax
    
    inc arrayIndex                   ; Increment arrayIndex
    jmp updateBalls                  ; Repeat for the next ball
updateBallsDone:

    ; Check for key input
    push ecx                         ; Save the loop counter
    call KeyHandler
    cmp col,-1
    jne next
next:
    call drawFire
    
    ; Collision detection with incoming ball
    lea eax, incomingBall     
    call detectCollision           ; Pass incomingBall to detectCollision
    pop ecx                          ; Restore the loop counter

    ; Delay
    mov eax, 1000                    ; Set delay value
    call Delay                       ; Call delay function
    jmp Loop1                        ; Repeat the main loop
done:
    ret
displayRandomBalls endp


; Detect collision between incoming ball and balls in ballArray
detectCollision proc
    mov edi, offset incomingBall          ; Load address of incomingBall into EAX
    movzx ebx, byte ptr [eax]      ; Load x-coordinate of incomingBall into EBX
    movzx ecx, byte ptr [eax + 1]  ; Load y-coordinate of incomingBall into ECX

    mov edx, 0                     ; Set array index to 0
    lea esi, ballArray             ; Load address of ballArray into ESI

collisionLoop:
    ; Loop through all balls in the ball array

    mov eax, edx                    ; Move current index (edx) into eax
    imul eax, SIZEOF ballStruct      ; Multiply index by SIZEOF ballStruct to get offset

    lea esi, ballArray              ; Load base address of ballArray into esi
    add esi, eax                    ; Add the calculated offset to point to the current ball

    ; Load x and y coordinates of the current ball from the array
    mov al, byte ptr [esi]        ; Get x-coordinate of current ball (first byte)
    mov bl, byte ptr [esi + 1]    ; Get y-coordinate of current ball (second byte)

    ; Load incoming ball's coordinates (assuming incoming ball's x is in EAX, y in EBX)
    mov dl, byte ptr [edi+0]          ; Load incoming ball's x-coordinate into DL
    cmp dl, al                      ; Compare incoming x-coordinate (DL) with current ball's x (AL)
    jne nextBall                    ; If no match, go to the next ball

    mov dh, byte ptr [edi + 1]      ; Load incoming ball's y-coordinate into DH
    cmp dh, bl                      ; Compare incoming y-coordinate (DH) with current ball's y (BL)
    jne nextBall                    ; If no match, go to the next ball

    ; Collision detected: print "& there"
    call gotoxy                     ; Set the position for output (optional)
    mov al, '&'                     ; Print '&'
    call WriteChar

    ; Print "there" message
    mov al, ' '                     ; Print ' ' (space)
    call WriteChar
    mov al, 't'
    call WriteChar
    mov al, 'h'
    call WriteChar
    mov al, 'e'
    call WriteChar
    mov al, 'r'
    call WriteChar
    mov al, 'e'
    call WriteChar

    ; Exit the collision detection loop after printing message
    jmp done

nextBall:
    inc edx                         ; Move to the next ball (increment index)
    cmp edx, 10                      ; Compare with 10 balls (assuming 10 balls)
    jl collisionLoop                 ; If less than 10, repeat the loop

done:
    ; End of collision detection
    ret
detectCollision endp


KeyHandler Proc

LookForKey:
    mov eax, 50            ; Delay for input handling
    call Delay            

    call ReadKey           ; Read a key from the keyboard buffer

    cmp al, 00h            ; Check if it's a special key (e.g., arrow keys)
    je  SpecialKeyHandler 

    cmp al, VK_ESCAPE      ; Check if ESC was pressed
    je  controlMenu

    cmp al, 32             ; Check for the space key (ASCII code 32)
    je HandleSpaceKey

    ; Handle other regular key logic here
    jmp done               ; Otherwise, keep waiting for key input

SpecialKeyHandler:
    ; Special key detected, now check the second byte (stored in AH)
    cmp ah, 48h            ; Check for Up Arrow
    je  HandleUpArrow

    cmp ah, 50h            ; Check for Down Arrow
    je  HandleDownArrow

    cmp ah, 4Bh            ; Check for Left Arrow
    je  HandleLeftArrow

    cmp ah, 4Dh            ; Check for Right Arrow
    je  HandleRightArrow

    ; If it's not an arrow key, continue looking for keys
    jmp LookForKey

HandleSpaceKey:
    jmp MoveFireBall
    jmp LookForKey

HandleUpArrow:
    mov rightMov, 0
    mov leftMov, 0
    mov upMov, 1
    mov downMov, 0
    call moveup            ; Call your move-up function
    jmp LookForKey

HandleDownArrow:
    mov rightMov, 0
    mov leftMov, 0
    mov upMov, 0
    mov downMov, 1
    call movedown          ; Call your move-down function
    jmp LookForKey

HandleLeftArrow:
    inc leftMov  
    mov rightMov, 0
    mov upMov, 0
    mov downMov, 0
    call handleLeftMovement
    jmp LookForKey

HandleRightArrow:
    inc rightMov
    mov leftMov, 0
    mov upMov, 0
    mov downMov, 0
    call handleRightMovement
    jmp LookForKey

done:
    ret

KeyHandler endp


MoveFireBall proc

    
    cmp upMov, 1
    je UpSet
    cmp downMov, 1
    je DownSet
    cmp leftMov,0
    jne LeftSet
    cmp rightMov,0
    jne RightSet

UpSet:
    mov dl, 39
    mov dh, 11
    call gotoxy
    jmp next

DownSet:
    mov dl, 39
    mov dh, 14
    call gotoxy
    jmp next2

LeftSet:
    cmp leftMov,1
    je left1
    cmp leftMov,2
    je left2
    cmp leftMov,3
    je left3

left1:
    
    mov dl,37
    mov dh,11
    call GOTOXY
    jmp nextLeft1

left2:
    mov dl,32
    mov dh,12
    call GOTOXY
    jmp nextLeft2
    

left3:
    mov dl,37
    mov dh,14
    call GOTOXY
    jmp nextLeft3
    
RightSet:
    cmp rightMov,1
    je right1
    cmp rightMov,2
    je right2
    cmp rightMov,3
    je right3


right1:

    mov dl,42
    mov dh,11
    call GOTOXY
    jmp nextRight1


right2:
    
    mov dl,43
    mov dh,12
    call GOTOXY
    jmp nextRight2


right3:
    mov dl,42
    mov dh,14
    call GOTOXY
    jmp nextRight3


next:
    mov dh,10
    call Gotoxy

    call colorSet
    mov esi,offset incomingBall
    
loop1:
    call gotoxy
    mov al, ' '        ; Character to be printed
    call WriteChar     ; Print the character
    dec dh
    mov [esi+0],dl
    mov [esi+1],dh
    call gotoxy
    mov al, '*'        ; Character to be printed
    call WriteChar     ; Print the character
    mov eax,200
    call delay
    loop loop1

    jmp done


next2:
    mov dh,15
    call gotoxy

    call colorSet
    mov esi,offset incomingBall

loop2:
     call gotoxy
    mov al, ' '        ; Character to be printed
    call WriteChar     ; Print the character
    inc dh
    mov [esi+0],dl
    mov [esi+1],dh
    call gotoxy
    mov al, '*'        ; Character to be printed
    call WriteChar     ; Print the character
    mov eax,200
    call delay
    loop loop2
    
    jmp done

nextLeft1:
    mov dh,10
    call gotoxy
    call colorSet
    mov esi,offset incomingBall


loop3:  
    call gotoxy
    mov al,' '
    call WriteChar
    dec dh
    dec dl
    mov [esi+0],dl
    mov [esi+1],dh
    call gotoxy
    mov al,'*'
    call WriteChar
    mov eax,200
    call delay
    loop loop3

    jmp done

nextLeft2:
    mov dl,31
    call gotoxy
    call colorSet
    mov ecx,50
    mov esi,offset incomingBall

loop4:
     call gotoxy
    mov al,' '
    call WriteChar
    dec dl
    mov [esi+0],dl
    mov [esi+1],dh
    call gotoxy
    mov al,'*'
    call WriteChar
    mov eax,200
    call delay
    loop loop4

    jmp done
nextLeft3:
    mov dh,15
    call gotoxy
    call colorSet
    mov esi,offset incomingBall

loop5:
    call gotoxy
    mov al,' '
    call WriteChar
    inc dh
    dec dl
    mov [esi+0],dl
    mov [esi+1],dh
    call gotoxy
    mov al,'*'
    call WriteChar
    mov eax,200
    call delay
    loop loop5

    jmp done
nextRight1:
    mov dh,10
    call gotoxy
    call colorSet
    mov esi,offset incomingBall

loop6:
    call gotoxy
    mov al,' '
    call WriteChar
    dec dh
    inc dl
    mov [esi+0],dl
    mov [esi+1],dh
    call gotoxy
    mov al,'*'
    call WriteChar
    mov eax,200
    call delay
    loop loop6

    jmp done

nextRight2:
 
    mov dl,44
    call gotoxy
    call colorSet
    mov ecx,50
    mov esi,offset incomingBall
loop7:
     call gotoxy
    mov al,' '
    call WriteChar
    inc dl
    mov [esi+0],dl
    mov [esi+1],dh
    call gotoxy
    mov al,'*'
    call WriteChar
    mov eax,200
    call delay
    loop loop7

    jmp done
nextRight3:
    mov dh,15
    call gotoxy
    call colorSet
    mov esi,offset incomingBall
loop8:
    call gotoxy
    mov al,' '
    call WriteChar
    inc dh
    inc dl
    mov [esi+0],dl
    mov [esi+1],dh
    call gotoxy
    mov al,'*'
    call WriteChar
    mov eax,200
    call delay
    loop loop8

    jmp done

    
done:
ret
MoveFireBall endp

colorSet proc
    
    mov esi,offset incomingBall
    mov al, col        ; Move the color from 'col' into AL
    mov [esi+2],al
    call SetTextColor  ; Call the procedure to set the text color
    mov col,-1
    mov ecx,10
ret
colorSet endp

drawFire proc
    cmp upMov, 1
    je UpSet
    cmp downMov, 1
    je DownSet
    cmp leftMov, 0
    jne LeftSet
    cmp rightMov, 0
    jne RightSet

UpSet:
    mov dl, 39                  ; Set the x position for the ball
    mov dh, 11                  ; Set the y position for the ball
    call gotoxy                 ; Move the cursor to the (dl, dh) position

    cmp col, -1                 ; If color is not set
    jne UseExistingColor        ; Use existing color if col is not -1
    mov eax, 16                 ; Generate a random color value
    call RandomRange
    and al, 0Fh                 ; Mask the result to get the color (lower 4 bits)
    mov col, al                 ; Save the color

UseExistingColor:
    ; Update incomingBall's position and color
    mov esi, offset incomingBall       ; Load address of incomingBall struct
    mov [esi + 0], dl           ; Set the x-coordinate (ball position)
    mov [esi + 1], dh   
    mov al, col                 ; Load the color
    mov [esi + 2], al           ; Set the color of the ball

    call SetTextColor           ; Set the text color

    ; Draw fire character ('*')
    mov al, '*'                 ; Set the character to be drawn (fire)
    call WriteChar              ; Write the character to the console
    jmp done

DownSet:
    mov dl, 39                  ; Set the x position for the ball
    mov dh, 14                  ; Set the y position for the ball
    call gotoxy                 ; Move the cursor to the (dl, dh) position

    cmp col, -1                 ; If color is not set
    jne UseExistingColor        ; Use existing color if col is not -1
    mov eax, 16                 ; Generate a random color value
    call RandomRange
    and al, 0Fh                 ; Mask the result to get the color (lower 4 bits)
    mov col, al                 ; Save the color
    jmp UseExistingColor

LeftSet:
    cmp leftMov, 1
    je left1
    cmp leftMov, 2
    je left2
    cmp leftMov, 3
    je left3

left1:
    mov dl, 37                  ; Set x for left position
    mov dh, 11                  ; Set y for left position
    call gotoxy
    jmp next

left2:
    mov dl, 32                  ; Set x for another left position
    mov dh, 12                  ; Set y for another left position
    call gotoxy
    jmp next

left3:
    mov dl, 37                  ; Set x for left position
    mov dh, 14                  ; Set y for left position
    call gotoxy
    jmp next

RightSet:
    cmp rightMov, 1
    je right1
    cmp rightMov, 2
    je right2
    cmp rightMov, 3
    je right3

right1:
    mov dl, 42                  ; Set x for right position
    mov dh, 11                  ; Set y for right position
    call gotoxy
    jmp next

right2:
    mov dl, 43                  ; Set x for another right position
    mov dh, 12                  ; Set y for another right position
    call gotoxy
    jmp next

right3:
    mov dl, 42                  ; Set x for right position
    mov dh, 14                  ; Set y for right position
    call gotoxy
    jmp next

next:
    cmp col, -1                 ; If color is not set
    jne UseExistingColor        ; Use existing color if col is not -1
    mov eax, 16                 ; Generate a random color value
    call RandomRange
    and al, 0Fh                 ; Mask the result to get the color (lower 4 bits)
    mov col, al                 ; Save the color

done:
    ret
drawFire endp



clearAndUpdate proc
    mov dh, 10        
    mov ecx, 6       

outerLoop:
    mov dl, 30            
    call Gotoxy           

    mov ebx, 14          
innerLoop:
    mov al, ' '           
    call WriteChar       
    inc dl         
    cmp dl, 44           
    jl innerLoop         

    inc dh               
    loop outerLoop       

    ret
clearAndUpdate endp

END main
