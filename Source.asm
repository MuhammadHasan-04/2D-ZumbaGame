; Skeleton Code for the game "Zumba", the COAL Project of CS-Batch 2023.
; This code is intellectual property of 22i-0932, but may be used by the students of CS-Batch 2023 for their COAL Project.
; The following code has been written in the Irvine32 library, and is meant to be run in the MASM assembler.

; The program does ONLY what the official code uploaded by the lab instructors was supposed to do, except:
; 1. the bullets fire in 8 directions instead of 4, to make the game more challenging.
; 2. the emitter has no functionality yet. find ways to implement it yourself.
; 3. the balls do not change color. find ways to implement it yourself.

; Stop complaining about ambiguity in the instructions, although I understand your frustrations.
; I sympathise with your workload, but it is time to lock in.

; Best of luck soldiers. Reply in the comments if there are any queries about the functionalities implemented below.

; hold your horses, because fortunately unfortunately there are still a lot of features to implement. karte raho implement.

; PS. if anything breaks, i apologise. i wrote this code as a last minute decision. 

; -------------------------------------------------------------------------------------------------------------------------

; use QWEADZXC keys (omnidirectional) to rotate the player. use spacebar to shoot. and use your brain to code. good luck.

include Irvine32.inc
include macros.inc

.data
;LEVEL VARIABLE TO STORE LEVEL NNUMBER 
  level DB ?

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
title1 byte "######## ##     ## ##     ## ########     ###           ", 0ah, 0
title2 byte "     ##  ##     ## ###   ### ##     ##   ## ##          ", 0ah, 0
title3 byte "    ##   ##     ## #### #### ##     ##  ##   ##         ", 0ah, 0
title4 byte "   ##    ##     ## ## ### ## ########  ##     ##        ", 0ah, 0
title5 byte "  ##     ##     ## ##     ## ##     ## #########        ", 0ah, 0
title6 byte " ##      ##     ## ##     ## ##     ## ##     ##        ", 0ah, 0
title7 byte "########  #######  ##     ## ########  ##     ##        ", 0ah, 0


msg0 BYTE 'WELCOME TO ZUMBA 2D!!',0
msg9 BYTE 'Enter Your Name : ',0
NAME1 byte 10 dup(?)
msg1 BYTE '1.Start New Game', 0
msg2 BYTE '2.Control Menu', 0
msg3 BYTE '3.Exit the Game', 0
msg5 BYTE 'Enter From (1-4) : ',0
msg4 BYTE '4.Show Top Scores',0
choice byte ? 
    ; Level layout

    ;level 1 path 
pathX1 db 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69
     ; db 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99
      ;db 99, 100,101,102, 103 ,104, 105, 106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128


    pathY1 db 10, 10, 10, 10, 10, 10, 10, 10, 10, 10 ,10, 10, 10, 10, 10, 10, 10, 10, 10, 10 ,10, 10, 10, 10, 10, 10, 10, 10, 10, 10
       ;db 10, 10, 10, 10, 10, 10, 10, 10, 10, 10 ,10, 10, 10, 10, 10, 10, 10, 10, 10, 10 ,10, 10, 10, 10, 10, 10, 10, 10, 10, 10

        pathX2 db 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69
      db 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99
      ;db 99, 100,101,102, 103 ,104, 105, 106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128
      


      pathY2 db 10, 10.5, 11, 11.5, 11, 10.5, 10, 9.5, 9, 8.5, 9, 9.5, 10, 10.5, 11, 11.5, 11, 10.5, 10, 9.5, 9, 8.5, 9, 9.5, 10
             db 10.5,11,11.5,11,10.5,10, 9.5, 9, 8.5, 9, 9.5, 10, 10.5, 11, 11.5, 11, 10.5, 10, 9.5, 9, 8.5, 9, 9.5
   
pathX3 db 20,22,24,26,28,30,32,34,36,38,40,42,44,46,48,50,52,54,56,58,60,62,64,66,68,70,72,72,72,72,72,72,72,70,68,66,64,62,60,58,58
      ;  db 70,68,66,64,62,60

    pathY3 db 10, 10, 10, 10, 10, 10, 10, 10, 10, 10 ,10, 10, 10, 10, 10, 10, 10, 10, 10, 10 ,10,10,10,10,10,10,10,12,14,16,18,20,22,22,22,22,22,22,22,22,20,19
        ;db 28,28,28,28,28,28
;
       numBalls dword 0
       color db 0
       checkCol db 0
;    GENERIC vars    
    isAlive   db 300 dup (1)
    ballColor db 300 dup (0)
    pathX dd 0                ;pointer to path
    pathY dd 0                ;pointer to path
    ;level 2 path

    ;control menu
control_m1 BYTE  "<=========================C O N T R O L  S C R E E N ======================> ", 0
control_m2 BYTE  "                                                                             ", 0
control_m3 BYTE  "                               GAME INSTRUCTIONS                             ", 0
control_m4 BYTE  " ----------------------------------------------------------------------------", 0
control_m5 BYTE  "   1. Press SPACE to shoot the incoming balls.                               ", 0
control_m6 BYTE  "   2. Balls of the same color in a line will be destroyed.                   ", 0
control_m7 BYTE  "   3. Move the player (shooter) in 8 directions to dodge and aim.            ", 0
control_m8 BYTE  "                                                                             ", 0
control_m9 BYTE  "                                                                             ", 0
control_m10 BYTE "                                 CONTROLS                                    ", 0
control_m11 BYTE "---------------------------------------------------------------------------- ", 0
control_m12 BYTE "  W      Q          E           Z          X      C              A        D  ", 0
control_m13 BYTE "                                                                             ", 0
control_m14 BYTE " TOP   TOPLEFT    TOPRIGHT     BOTTOMLEFT  DOWN    BOTTOMRIGHT   LEFT   RIGHT", 0
control_m15 BYTE "                                                                             ", 0
control_m16 BYTE "-----------------------------------------------------------------------------", 0
control_m17 BYTE "                            SHOOTING INSTRUCTIONS                            ", 0
control_m18 BYTE "-----------------------------------------------------------------------------", 0
control_m19 BYTE "                                                                             ", 0
control_m20 BYTE "   FOR SHOOTING: PRESS SPACE                                                 ", 0
control_m21 BYTE "                                                                             ", 0
control_m22 BYTE "     PLAYER           BULLET                                                 ", 0
control_m23 BYTE "        O-               *                                                   ", 0
control_m24 BYTE "                                                                             ", 0
isPaused db 0 ; 0 = not paused, 1 = paus

player_s1 BYTE "  --- ", 0
player_s2 BYTE " |   | ", 0
player_s3 BYTE " |   |", 0
player_s4 BYTE " |   |", 0
player_s5 BYTE "  --- ", 0

    walls BYTE " _____________________________________________________________________________ ", 0
          BYTE "|                                                                             |", 0
          BYTE "|                                                                             |", 0
          BYTE "|                                                                             |", 0
          BYTE "|                                                                             |", 0
          BYTE "|-----------------------------------------------------------------------------|", 0
          BYTE "|                                                                             |", 0
          BYTE "|-----------------------------------------------------------------------------|", 0
          BYTE "|                                                                             |", 0
          BYTE "|                                                                             |", 0
          BYTE "|                                    ---                                      |", 0
          BYTE "|                                   |   |                                     |", 0
          BYTE "|                                   |   |                                     |", 0
          BYTE "|                                   |   |                                     |", 0
          BYTE "|                                    ---                                      |", 0
          BYTE "|                                                                             |", 0
          BYTE "|                                                                             |", 0
          BYTE "|                                                                             |", 0
          BYTE "|                                                                             |", 0
          BYTE "|                                                                             |", 0
          BYTE "|                                                                             |", 0
          BYTE "|                                                                             |", 0
          BYTE "|                                                                             |", 0
          BYTE "|                                                                             |", 0
          BYTE "|_|", 0

   walls2 BYTE " _____________________________________________________________________________ ", 0
          BYTE "|                                                                             |", 0
          BYTE "|                                                                             |", 0
          BYTE "|                                                                             |", 0
          BYTE "|                                                                             |", 0
          BYTE "|                 \   \   /       \   /       \   /       \   /   /           |", 0
          BYTE "|                  \   \ /  /  \   \ /  /  \   \ /  /  \   \ /   /            |", 0
          BYTE "|                   \      /    \      /    \      /    \       /             |", 0
          BYTE "|                    \_   /      \    /      \    /      \  _  /              |", 0
          BYTE "|                                                                             |", 0
          BYTE "|                                    ---                                      |", 0
          BYTE "|                                   |   |                                     |", 0
          BYTE "|                                   |   |                                     |", 0
          BYTE "|                                   |   |                                     |", 0
          BYTE "|                                    ---                                      |", 0
          BYTE "|                                                                             |", 0
          BYTE "|                                                                             |", 0
          BYTE "|                                                                             |", 0
          BYTE "|                                                                             |", 0
          BYTE "|                                                                             |", 0
          BYTE "|                                                                             |", 0
          BYTE "|                                                                             |", 0
          BYTE "|                                                                             |", 0
          BYTE "|                                                                             |", 0
          BYTE "|_|", 0

    walls3 BYTE " _____________________________________________________________________________ ", 0
          BYTE "|                                                                             |", 0
          BYTE "|                                                                             |", 0
          BYTE "|                                                                             |", 0
          BYTE "|                                                                             |", 0
          BYTE "|------------------------------------------------------|                      |", 0
          BYTE "|                                                      |                      |", 0
          BYTE "|--------------------------------------------------|   |                      |", 0
          BYTE "|                                                  |   |                      |", 0
          BYTE "|                                                  |   |                      |", 0
          BYTE "|                                    ---           |   |                      |", 0
          BYTE "|                                   |   |          |   |                      |", 0
          BYTE "|                                   |   |          |   |                      |", 0
          BYTE "|                                   |   |          |   |                      |", 0
          BYTE "|                                    ---           |   |                      |", 0
          BYTE "|                                    |    |        |   |                      |", 0
          BYTE "|                                    |    |        |   |                      |", 0
          BYTE "|                                    |    | -------    |                      |", 0
          BYTE "|                                    |                 |                      |", 0
          BYTE "|                                    |-----------------|                      |", 0
          BYTE "|                                                                             |", 0
          BYTE "|                                                                             |", 0
          BYTE "|                                                                             |", 0
          BYTE "|                                                                             |", 0
          BYTE "|_|", 0

    ; Player sprite
    player_right BYTE "   ", 0
                 BYTE " O-", 0
                 BYTE "   ", 0

    player_left BYTE "   ", 0
                BYTE "-O ", 0
                BYTE "   ", 0

    player_up BYTE " | ", 0
              BYTE " O ", 0
              BYTE "   ", 0

    player_down BYTE "   ", 0
                BYTE " O ", 0
                BYTE " | ", 0

    player_upright BYTE "  /", 0
                   BYTE " O ", 0
                   BYTE "   ", 0

    player_upleft BYTE "\  ", 0
                  BYTE " O ", 0
                  BYTE "   ", 0

    player_downright BYTE "   ", 0
                     BYTE " O ", 0
                     BYTE "  \", 0

    player_downleft BYTE "   ", 0
                    BYTE " O ", 0
                    BYTE "/  ", 0

    ; Player's starting position (center)
    xPos db 56      ; Column (X)
    yPos db 15      ; Row (Y)

    xDir db 0
    yDir db 0

    inputChar db 0
    direction db "d"

    ; Colors for the emitter and player
    color_red db 4       ; Red
    color_green db 2     ; Green
    color_yellow db 14   ; Yellow (for fire symbol)

    current_color db 4   ; Default player color (red)

    emitter_color1 db 2  ; Green
    emitter_color2 db 4  ; Red

    fire_color db 14     ; Fire symbol color (Yellow)

    ; Emitter properties
    emitter_symbol db "#"
    emitter_row db 0    ; Two rows above player (fixed row for emitter)
    emitter_col db 1    ; Starting column of the emitter

    ; Fire symbol properties (fired from player)
    fire_symbol db "*", 0
    fire_row db 0        ; Fire will be fired from the player's position
    fire_col db 0        ; Initial fire column will be set in the update logic

    ; Interface variables
    score db 0          ; Player's score
    lives db 3          ; Player's lives
    levelInfo db 1
    
    ; Counter variables for loops
    counter1 db 0
    counter2 db 0

.code

MainMenu PROC

    mov ax,Yellow
    call SetTextColor

    mov dl,35
    mov dh,4
    call GOTOXY

    mov edx,offset title1
    call WriteString
    call crlf

    mov dl,35
    mov dh,5
    call GOTOXY

    mov edx, offset title2
    call WriteString
    call crlf

    mov dl,35
    mov dh,6
    call GOTOXY

    mov edx, offset title3
    call WriteString
    call crlf

    mov dl,35
    mov dh,7
    call GOTOXY

    mov edx, offset title4
    call WriteString
    call crlf

    mov dl,35
    mov dh,8
    call GOTOXY

    mov edx, offset title5
    call WriteString
    call crlf

    mov dl,35
    mov dh,9
    call GOTOXY

     mov edx, offset title6
    call WriteString
    call crlf

     mov dl,35
    mov dh,10
    call GOTOXY

   mov edx, offset title7
    call WriteString
    call crlf


    mov ax,Green
    call SetTextColor

    mov dl, 50       ; X-coordinate (column)
    mov dh, 13    ; Y-coordinate (row)
    call Gotoxy     

    mov edx,offset NAME1
    call ReadString

    mov edx,offset msg1
    call WriteString
    call crlf

    mov dl,50
    mov dh, 14    ; Y-coordinate (row)
    call Gotoxy

    mov edx,offset msg2
    call WriteString
    call crlf
    
    mov dl,50
    mov dh, 15     ; Y-coordinate (row)
    call Gotoxy

    mov edx,offset msg3
    call WriteString
    call crlf

    mov dl,50
    mov dh, 16    ; Y-coordinate (row)
    call Gotoxy

    mov edx,offset msg4
    call WriteString


    mov dl,45
    mov dh, 20   ; Y-coordinate (row)
    call Gotoxy

    MOV EDX, OFFSET msg9
	CALL WriteString
    
    ;NAME1 INPUT
    MOV EDX,OFFSET NAME1    
    mov ecx,lengthof NAME1
    CALL ReadString

    mov dl,45
	mov dh, 21   ; Y-coordinate (row)
	call Gotoxy


    mWrite "Welcome "
    
    MOV EAX, Magenta + (black * 16)
	CALL SetTextColor

    mov edx,offset NAME1
	call WriteString

    mov ax,Green
    call SetTextColor

    mWrite " To Zumba 2D Game"
    
	mov dl,45
	mov dh, 22
	call Gotoxy

    mov edx,offset msg5
    call WriteString


    mov edx,offset choice
    call ReadInt
    mov choice,al

    call clrscr


    call SelectLevel
    

ret
MainMenu ENDP

createBalls PROC
    ; Initialize variables
    cmp level, 1
    je Level1

    cmp level, 2
    je Level2

    cmp level, 3
    je Level3

Level1:
    mov esi, OFFSET pathX1    
    mov edi, OFFSET pathY1   
    mov ecx, sizeof pathX1
    mov ebx, 0                
    mov eax, 0
    jmp next

Level2:
    mov esi, OFFSET pathX2   
    mov edi, OFFSET pathY2   
    mov ecx, sizeof pathX2
    mov ebx, 0                
    mov eax, 0
    jmp next

Level3:
    mov esi, OFFSET pathX3    
    mov edi, OFFSET pathY3  
    mov ecx, sizeof pathX3
    mov ebx, 0                
    mov eax, 0
    jmp next

next:
    mov numBalls, 0

    ; Loop to create balls
L1:
    mov dl, [esi]            ; load X coordinate
    mov dh, [edi]            ; load Y coordinate
    call GotoXY

    ; Generate a random color for the ball
    mov eax, 15              
    call RandomRange         ; Irvine32 library function to generate a random number
    inc eax                  ; adjust to inclusive range (1-15)
    mov color, al            ; store the random color

    movzx eax, color
    call SetTextColor

    ; Draw the ball if it's alive
    cmp isAlive[ebx], 1
    jne continueNext
    mov al, "*"
    call WriteChar
    jmp ballCreated

continueNext:
    ; If the ball is not alive, draw a space
    mov al, " "
    call WriteChar
    mov dl, 10
    mov dh, 10
    call GotoXY

ballCreated:
    ; Store the ball's color
    mov al, color
    mov byte ptr ballColor[ebx], al

    ; Increment indices and counters
    inc esi
    inc edi
    inc ebx

    ; Save registers before calling MovePlayer
    push eax
    push ecx
    push edx
    push esi
    push edi
    push ebx

    ; Call MovePlayer
    call MovePlayer

    call ReadKey
    cmp al, "p"
    je NewP

    ; Restore registers after MovePlayer
    pop ebx
    pop edi
    pop esi
    pop edx
    pop ecx
    pop eax

    ; Increment numBalls
    inc numBalls

    ; Loop condition
    mov eax, 500
    call Delay
    cmp numBalls, ecx
    jne L1

    ret

NewP:
    mov eax , 500
call Delay
    call PauseGame
    
    pop ebx
    pop edi
    pop esi
    pop edx
    pop ecx
    pop eax
    jmp L1

createBalls ENDP


gameOver Proc

mov ecx , sizeof pathX3

cmp isAlive[ecx] , 1
call clrscr

newOne:
mWrite  " ______     ______     __    __     ______          ______     __   __   ______     ______    ", 0
mWrite  "/\  ___\   /\   __ \   /\ ""-./  \   /\  ___\      /\  __ \   /\ \ / /  /\  ___\   /\  == \   ", 0
mWrite   "\ \ \__ \   \  \  __\  \ \ \-./\ \  \ \  __\      \ \ \ /\ \  \ \ \'/   \ \  __\   \ \  __<   ", 0
mWrite   " \ \\  \ \\ \\  \ \\ \ \\  \ \\     \ \\  \ \|     \ \\ \ \\\\ ", 0
mWrite  "   \//   \//\//   \//  \//   \//      \//   \//      \//  \// /_/ ", 0
mWrite  "                                                                                             ", 0

mov eax, 0
call ReadKey

cmp al ,0
jne done
jmp newOne

done:
ret
gameOver endp



FireBall PROC
    ; Fire a projectile from the player's current face direction

    mov dl, xPos      ; Fire column starts at the player's X position
    mov dh, yPos      ; Fire row starts at the player's Y position

    mov fire_col, dl  ; Save the fire column position
    mov fire_row, dh  ; Save the fire row position

    mov al, direction
    cmp al, "w"
    je fire_up

    cmp al, "x"
    je fire_down

    cmp al, "a"
    je fire_left

    cmp al, "d"
    je fire_right

    cmp al, "q"
    je fire_upleft

    cmp al, "e"
    je fire_upright

    cmp al, "z"
    je fire_downleft

    cmp al, "c"
    je fire_downright

    jmp end_fire

fire_up:
    mov fire_row, 14         ; Move fire position upwards
    mov fire_col, 57         ; Center fire position
    mov xDir, 0
    mov yDir, -1
    jmp fire_loop

fire_down:
    mov fire_row, 18         ; Move fire position downwards
    mov fire_col, 57         ; Center fire position
    mov xDir, 0
    mov yDir, 1
    jmp fire_loop

fire_left:
    mov fire_col, 55         ; Move fire position leftwards
    mov fire_row, 16         ; Center fire position
    mov xDir, -1
    mov yDir, 0
    jmp fire_loop

fire_right:
    mov fire_col, 59         ; Move fire position rightwards
    mov fire_row, 16         ; Center fire position
    mov xDir, 1
    mov yDir, 0
    jmp fire_loop

fire_upleft:
    mov fire_row, 14         ; Move fire position upwards
    mov fire_col, 55         ; Move fire position leftwards
    mov xDir, -1
    mov yDir, -1
    jmp fire_loop

fire_upright:
    mov fire_row, 14         ; Move fire position upwards
    mov fire_col, 59         ; Move fire position rightwards
    mov xDir, 1
    mov yDir, -1
    jmp fire_loop

fire_downleft:
    mov fire_row, 18         ; Move fire position downwards
    mov fire_col, 55         ; Move fire position leftwards
    mov xDir, -1
    mov yDir, 1
    jmp fire_loop

fire_downright:
    mov fire_row, 18         ; Move fire position downwards
    mov fire_col, 59         ; Move fire position rightwards
    mov xDir, 1
    mov yDir, 1
    jmp fire_loop

fire_loop:
    ; Initialise fire position
    mov dl, fire_col
    mov dh, fire_row
    call GoToXY
         mov eax,  15
        call RandomRange
        inc eax
       mov fire_color , al
    ; Loop to move the fireball in the current direction
    L1:

        ; Ensure fire stays within the bounds of the emitter wall
        cmp dl, 20            ; Left wall boundary
        jle end_fire

        cmp dl, 96            ; Right wall boundary
        jge end_fire

        cmp dh, 5             ; Upper wall boundary
        jle end_fire

        cmp dh, 27            ; Lower wall boundary
        jge end_fire

        ; Print the fire symbol at the current position
        movzx eax , fire_color
        call SetTextColor

        add dl, xDir
        add dh, yDir
        call Gotoxy

        push dx

        call CheckCollision
        mWrite "*"

        pop dx
        ; Continue moving fire in the current direction (recursive)
        mov eax, 50
        call Delay

        ; erase the fire before redrawing it
        call GoToXY
        mWrite " "

        cmp checkCol,1
        je end_fire

        jmp L1

    end_fire:
        mov dx, 0
        call GoToXY
        mov checkCol,0

    ret
FireBall ENDP

CheckCollision PROC
    mov fire_col, dl
    mov fire_row, dh

    cmp level,1
    je Level1_col
    cmp level ,2 
    je Level2_col
    cmp level,3
    je Level3_col

Level1_col:

    mov esi, OFFSET pathX1    
    mov edi, OFFSET pathY1    
    mov ecx, sizeof pathX1    
    mov ebx, 0
    jmp next1
Level2_col:

    mov esi, OFFSET pathX2    
    mov edi, OFFSET pathY2    
    mov ecx, sizeof pathX2   
    mov ebx, 0
    jmp next1

Level3_col:
    mov esi, OFFSET pathX3   
    mov edi, OFFSET pathY3    
    mov ecx, sizeof pathX3    
    mov ebx, 0
    jmp next1

next1:

CheckLoop:
    mov dl, [esi]            ; X coordinate
    mov dh, [edi]            ; Y coordinate

    cmp isAlive[ebx], 1
    jne NotAlive            

    cmp dl, fire_col        
    jne NotAlive
    cmp dh, fire_row        
    jne NotAlive

CollisionDetected:
    mov ballColor[ebx], 0

  
    mov isAlive[ebx], 0
    cmp level,1
    je level1
    cmp level,2
    je level2
    cmp level,3
    je level3

level1:
    call DrawWall
    call createBalls
    jmp next
level2:
    call DrawWall2
    call createBalls
    jmp next
level3:
    call DrawWall3
    call createBalls
    jmp next
next:

   
    add score, 3
    call drawScore

    mov checkCol, 1

    ;mov eax, Red
    ;call SetTextColor
    ;call GoToXY
    ;mWrite " "

    jmp Done

NotAlive:
   
    inc esi
    inc edi
    inc ebx

    ; Loop condition
  dec ecx 
 cmp ecx , 0
jne CheckLoop


Done:
    ret
CheckCollision ENDP

drawScore PROC
	mov eax, White + (black * 16)
	call SetTextColor

	mov dl, 19
	mov dh, 2
	call Gotoxy
	mWrite <"Score: ">

	mov eax, Blue + (black * 16)
    call SetTextColor
	mov al, score
	call WriteDec




	ret
    drawScore ENDP

 clearPlayer proc
    
    mov ecx, 10          
    mov dl, 47          
    mov dh, 13        
    call GoToXY       
    
    outerLoop:
        call gotoxy   
        mov ebx, 10    
        
        innerLoop:
            mov al, ' '
            call WriteChar
            
            inc dl      
            dec ebx    
            jnz innerLoop 
        
      
        inc dh         
        mov dl,54
        
        dec ecx         
        jnz outerLoop  
    
    ret
clearPlayer endp

DrawWall PROC
	call clrscr

    mov dl,19
	mov dh,2
	call Gotoxy
	mWrite <"Score: ">
	mov eax, Blue + (black * 16)
	call SetTextColor
	mov al, score
	call WriteDec

    mov eax, White + (black * 16)
	call SetTextColor

	mov dl,90
	mov dh,2
	call Gotoxy
	mWrite <"Lives: ">
	mov eax, Red + (black * 16)
	call SetTextColor
	mov al, lives
	call WriteDec

	mov eax, white + (black * 16)
	call SetTextColor

	mov dl,55
	mov dh,2
	call Gotoxy

	mWrite "LEVEL " 
	mov al, levelInfo
	call WriteDec

	mov eax, gray + (black*16)
	call SetTextColor

	mov dl, 19
	mov dh, 4
	call Gotoxy

	mov esi, offset walls

	mov counter1, 50
	mov counter2, 80
	movzx ecx, counter1
	printcolumn:
		mov counter1, cl
		movzx ecx, counter2
		printrow:
			mov eax, [esi]
			call WriteChar
            
			inc esi
		loop printrow
		
        dec counter1
		movzx ecx, counter1

		mov dl, 19
		inc dh
		call Gotoxy
	loop printcolumn

	ret
DrawWall ENDP


DrawWall2 PROC
	call clrscr

    mov dl,19
	mov dh,2
	call Gotoxy
	mWrite <"Score: ">
	mov eax, Blue + (black * 16)
	call SetTextColor
	mov al, score
	call WriteDec

    mov eax, White + (black * 16)
	call SetTextColor

	mov dl,90
	mov dh,2
	call Gotoxy
	mWrite <"Lives: ">
	mov eax, Red + (black * 16)
	call SetTextColor
	mov al, lives
	call WriteDec

	mov eax, white + (black * 16)
	call SetTextColor

	mov dl,55
	mov dh,2
	call Gotoxy

	mWrite "LEVEL " 
	mov al, levelInfo
	call WriteDec

	mov eax, gray + (black*16)
	call SetTextColor

	mov dl, 19
	mov dh, 4
	call Gotoxy

	mov esi, offset walls2

	mov counter1, 50
	mov counter2, 80
	movzx ecx, counter1
	printcolumn:
		mov counter1, cl
		movzx ecx, counter2
		printrow:
			mov eax, [esi]
			call WriteChar
            
			inc esi
		loop printrow
		
        dec counter1
		movzx ecx, counter1

		mov dl, 19
		inc dh
		call Gotoxy
	loop printcolumn

	ret
DrawWall2 ENDP


DrawWall3 PROC
	call clrscr

    mov dl,19
	mov dh,2
	call Gotoxy
	mWrite <"Score: ">
	mov eax, Blue + (black * 16)
	call SetTextColor
	mov al, score
	call WriteDec

    mov eax, White + (black * 16)
	call SetTextColor

	mov dl,90
	mov dh,2
	call Gotoxy
	mWrite <"Lives: ">
	mov eax, Red + (black * 16)
	call SetTextColor
	mov al, lives
	call WriteDec

	mov eax, white + (black * 16)
	call SetTextColor

	mov dl,55
	mov dh,2
	call Gotoxy

	mWrite "LEVEL " 
	mov al, level
	call WriteDec

	mov eax, gray + (black*16)
	call SetTextColor

	mov dl, 19
	mov dh, 4
	call Gotoxy

	mov esi, offset walls3

	mov counter1, 50
	mov counter2, 80
	movzx ecx, counter1
	printcolumn:
		mov counter1, cl
		movzx ecx, counter2
		printrow:
			mov eax, [esi]
			call WriteChar
            
			inc esi
		loop printrow
		
        dec counter1
		movzx ecx, counter1

		mov dl, 19
		inc dh
		call Gotoxy
	loop printcolumn

	ret
DrawWall3 ENDP


PrintPlayer PROC
    mov eax, brown + (black * 16)
    call SetTextColor

    mov al, direction
    cmp al, "w"
    je print_up

    cmp al, "x"
    je print_down

    cmp al, "a"
    je print_left

    cmp al, "d"
    je print_right

    cmp al, "q"
    je print_upleft

    cmp al, "e"
    je print_upright

    cmp al, "z"
    je print_downleft

    cmp al, "c"
    je print_downright

    ret

    print_up:
        mov esi, offset player_up
        jmp print

    print_down:
        mov esi, offset player_down
        jmp print

    print_left:
        mov esi, offset player_left
        jmp print

    print_right:
        mov esi, offset player_right
        jmp print

    print_upleft:
        mov esi, offset player_upleft
        jmp print

    print_upright:
        mov esi, offset player_upright
        jmp print

    print_downleft:
        mov esi, offset player_downleft
        jmp print

    print_downright:
        mov esi, offset player_downright
        jmp print

    print:
    mov dl, xPos
    mov dh, yPos
    call GoToXY

    mov counter1, 3
	mov counter2, 4
	movzx ecx, counter1
	printcolumn:
		mov counter1, cl
		movzx ecx, counter2
		printrow:
			mov eax, [esi]
			call WriteChar
            
			inc esi
		loop printrow

		movzx ecx, counter1

		mov dl, xPos
		inc dh
		call Gotoxy
	loop printcolumn
    
ret
PrintPlayer ENDP

SelectLevel proc
 mov ax,Yellow
    call SetTextColor

    mov dl,35
    mov dh,4
    call GOTOXY

    mov edx,offset title1
    call WriteString
    call crlf

    mov dl,35
    mov dh,5
    call GOTOXY

    mov edx, offset title2
    call WriteString
    call crlf

    mov dl,35
    mov dh,6
    call GOTOXY

    mov edx, offset title3
    call WriteString
    call crlf

    mov dl,35
    mov dh,7
    call GOTOXY

    mov edx, offset title4
    call WriteString
    call crlf

    mov dl,35
    mov dh,8
    call GOTOXY

    mov edx, offset title5
    call WriteString
    call crlf

    mov dl,35
    mov dh,9
    call GOTOXY

     mov edx, offset title6
    call WriteString
    call crlf

     mov dl,35
    mov dh,10
    call GOTOXY

   mov edx, offset title7
    call WriteString
    call crlf

    mov ax,Green
    call SetTextColor


 mov dl , 50
 mov dh , 15
 call GotoXY

 mWrite "1.LEVEL 1"

 mov dl , 50
 mov dh , 16
 call GotoXY

 mWrite "2.LEVEL 2"

 mov dl , 50
 mov dh , 17
 call GotoXY

 mWrite "3.LEVEL 3"


 mov dl , 45
 mov dh , 19
 call GotoXY

 mWrite "Enter Level Number : "
 mov edx , offset level
 call ReadInt
 mov level,al



ret
SelectLevel endp


MovePlayer PROC
    
        push eax
        push ecx
        push edx
        push esi
        push edi
        push ebx

    mov dx, 0
    call GoToXY

    checkInput:

    mov eax, 5
    call Delay

    ; Check for key press
    mov eax, 0
    call ReadKey
    jz done

    mov inputChar, al
    

    cmp inputChar, VK_SPACE
    je shoot

     cmp inputChar, VK_ESCAPE
    je togglePause

    

    cmp inputChar, "w"
    je move

    cmp inputChar, "a"
    je move

    cmp inputChar, "x"
    je move

    cmp inputChar, "d"
    je move

    cmp inputChar, "q"
    je move

    cmp inputChar, "e"
    je move

    cmp inputChar, "z"
    je move

    cmp inputChar, "c"
    je move

    cmp inputChar , "p"
    je pauseScn

   

    ; if character is invalid, check for a new keypress
    jmp checkInput

    move:
        mov al, inputChar
        mov direction, al
        jmp chosen

     togglePause:
        cmp isPaused, 0
        CALL drawControlMenu
        cmp inputChar, VK_ESCAPE
        je back
        jmp togglePause    

    back:
        call clrscr
        Call InitialiseScreen
        call createBalls


		jmp checkInput
    shoot:
        call FireBall
        jmp checkInput
    chosen:
        call PrintPlayer
        call MovePlayer
        jmp checkInput

    pauseScn:
        call PauseGame
        call clearPlayer
        call PlayerBouundary
        call PrintPlayer

		jmp checkInput
        
        
done:
            pop ebx
            pop edi
            pop esi
            pop edx
            pop ecx
            pop eax
    ret
MovePlayer ENDP


DrawControlMenu PROC


    mov eax,gray+(black*16)
    call SetTextColor
    
    mov dl,20
    mov dh,4
    call gotoxy
    MOV EDX, OFFSET control_m1
    CALL WriteString
    call crlf

    mov dl,20
    mov dh,6
    call gotoxy
    MOV EDX, OFFSET control_m2
    CALL WriteString
    call crlf

    mov dl,20
    mov dh,7
    call gotoxy
    MOV EDX, OFFSET control_m3
    CALL WriteString
    call crlf

    mov dl,20
    mov dh,8
    call gotoxy
    MOV EDX, OFFSET control_m4
    CALL WriteString
    call crlf

    mov dl,20
    mov dh,9
    call gotoxy

    MOV EDX, OFFSET control_m5
    CALL WriteString
    call crlf

    mov dl,20
    mov dh,10
    call gotoxy

    MOV EDX, OFFSET control_m6
    CALL WriteString
    call crlf

    mov dl,20
    mov dh,11
    call gotoxy
    MOV EDX, OFFSET control_m7
    CALL WriteString
    call crlf

    mov dl,20
    mov dh,12
    call gotoxy

    MOV EDX, OFFSET control_m8
    CALL WriteString
    call crlf

    MOV EDX, OFFSET control_m9
    CALL WriteString
    call crlf

    mov dl,20
    mov dh,13
    call gotoxy
    MOV EDX, OFFSET control_m10
    CALL WriteString
    call crlf

    mov dl,20
    mov dh,12
    call gotoxy

    MOV EDX, OFFSET control_m11
    CALL WriteString
    call crlf
    
    mov dl,20
    mov dh,13
    call gotoxy

    MOV EDX, OFFSET control_m12
    CALL WriteString
    call crlf
    
    mov dl,20
    mov dh,14
    call gotoxy

    MOV EDX, OFFSET control_m13
    CALL WriteString
    call crlf
    
    mov dl,20
    mov dh,15
    call gotoxy

    MOV EDX, OFFSET control_m14
    CALL WriteString
    call crlf

    mov dl,20
    mov dh,16
    call gotoxy

    MOV EDX, OFFSET control_m15
    CALL WriteString
    call crlf

    mov dl,20
    mov dh,17
    call gotoxy

    MOV EDX, OFFSET control_m16
    CALL WriteString
    call crlf

    mov dl,20
    mov dh,18
    call gotoxy

    MOV EDX, OFFSET control_m17
    CALL WriteString
    call crlf

    mov dl,20
    mov dh,19
    call gotoxy

    MOV EDX, OFFSET control_m18
    CALL WriteString
    call crlf

    mov dl,20
    mov dh,20
    call gotoxy

    MOV EDX, OFFSET control_m19
    CALL WriteString
    call crlf

    mov dl,20
    mov dh,21
    call gotoxy

    MOV EDX, OFFSET control_m20
    CALL WriteString
    call crlf

    mov dl,20
    mov dh,22
    call gotoxy

    MOV EDX, OFFSET control_m21
    CALL WriteString
    call crlf

    mov dl,20
    mov dh,23
    call gotoxy

    MOV EDX, OFFSET control_m22
    CALL WriteString
    call crlf

    mov dl,20
    mov dh,24
    call gotoxy

    MOV EDX, OFFSET control_m23
    CALL WriteString
    call crlf

    mov dl,20
    mov dh,25
    call gotoxy

    MOV EDX, OFFSET control_m24
    CALL WriteString
    call crlf
    
    mov dl,20
    mov dh,26
    call gotoxy

    mov eax,1000
    call Delay

    waitForResume:
        mov eax, 0
        call ReadKey
        cmp al, VK_ESCAPE
        jne waitForResume


    RET
DrawControlMenu ENDP



PlayerBouundary PROC
    
    mov eax,gray + (black * 16)
    call SetTextColor

    mov dl,54
    mov dh,14
    call gotoxy

    mov edx,offset player_s1
    call WriteString

    mov dl,54
    mov dh,15
    call gotoxy

    mov edx,offset player_s2
    call WriteString

    mov dl,54
    mov dh,16
    call gotoxy
    
    mov edx,offset player_s3
    call WriteString

    mov dl,54
    mov dh,17
    call gotoxy

    mov edx,offset player_s4
    call WriteString

    mov dl,54
    mov dh,18
    call gotoxy

    mov edx,offset player_s5
    call WriteString


	ret
PlayerBouundary ENDP

PauseGame PROC
	
    call clearPlayer
    mov dl, 54
    mov dh, 15
    call GotoXY
    mWrite <"GAMEPAUSED">

pauseScn:
    mov eax,100
    call Delay
    mov isPaused, 1
    call readkey

    cmp al, "p"
    je done
    mov eax,100
    call delay
    jmp pauseScn
	

	done:
	ret
    PauseGame ENDP



InitialiseScreen PROC
    ; Draw the level layout at the start
    cmp level,1
    je level1
    cmp level,2
    je level2
    cmp level,3
    je level3

level1:
    call DrawWall
    call PrintPlayer
    jmp done
level2:
    call DrawWall2
    call PrintPlayer
    jmp done
level3:
    call DrawWall3
    call PrintPlayer
    jmp done
 done:
    ret
InitialiseScreen ENDP

main PROC
    ; Initialize screen and emitter
    call MainMenu

    call InitialiseScreen

    ; Call Player Cannon movement function(this function is recursive, and will repeat until the game is either won or lost)
   ; cmp level,1
    
    call createBalls

    call MovePlayer

    call gameOver

    exit
main ENDP
END main

; This segment was written inside the main procedure in the original skeleton code. i do not know what these functions do, as i did not understand the "emitter" variable.
Temp PROC
    ; Main loop for player movement and updates
    main_loop:
        call check_for_key_press
        call update_emitter
        call fire    ; Call the fire procedure
        jmp main_loop

    ret
Temp ENDP

; ---------------------------------------------------------------------------------------------------------------------------------
; i have not called these functions. try to understand them before implementing them. these functions are untouched by me(i think).
update_emitter PROC
    ; Update the emitter symbols to animate the line
    push ax
    push cx
    push dx

    mov cx, 80           ; Number of columns (console width)
    mov dl, emitter_col
    mov dh, emitter_row

    ; Redraw emitter with updated colors
emitter_update_loop:
    ; Alternate emitter colors between green and red
    cmp al, emitter_color1
    jne set_green_color
    mov al, emitter_color2
    jmp draw_symbol

set_green_color:
    mov al, emitter_color1

draw_symbol:
    mov al, emitter_symbol
    call Gotoxy
    call WriteChar

    inc dl               ; Move to the next column
    cmp dl, 80           ; Wrap around at the end of the row
    jne emitter_update_loop
    mov dl, emitter_col  ; Reset column

    pop dx
    pop cx
    pop ax
    ret
update_emitter ENDP

; i have not called this function
draw_emitter PROC
    ; Draw the emitter with alternating colors
    push ax
    push cx
    push dx

    mov cx, 119          ; Number of columns (console width)
    mov dl, emitter_col
    mov dh, emitter_row

emitter_loop:
    ; Alternate emitter colors between green and red
    mov al, emitter_color1
    call SetTextColor

    mov al, emitter_symbol
    call Gotoxy
    call WriteChar

    ; Toggle color for the next symbol
    cmp al, emitter_color1
    jne set_green
    mov al, emitter_color2
    jmp next_symbol

set_green:
    mov al, emitter_color1

next_symbol:
    inc dl               ; Move to the next column
    cmp dl, 119          ; Wrap around at the end of the row
    jne emitter_loop
    mov dl, emitter_col  ; Reset column

    pop dx
    pop cx
    pop ax
    ret
draw_emitter ENDP
