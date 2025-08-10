section .data
    global red_color
    global green_color
    global yellow_color
    global blue_color
    global magenta_color
    global cyan_color
    global white_color
    global reset_color
    global redC

    global redlen
    global greenlen
    global yellowlen
    global bluelen
    global magentalen
    global cyanlen
    global whitelen
    global resetlen





; Red
red_color:
    db 0x1B, '[31m'
redlen equ $ - red_color

; Green
green_color:
    db 0x1B, '[32m'
greenlen equ $ - green_color

; Yellow
yellow_color:
    db 0x1B, '[33m'
yellowlen equ $ - yellow_color

; Blue
blue_color:
    db 0x1B, '[34m'
bluelen equ $ - blue_color

; Magenta
magenta_color:
    db 0x1B, '[35m'
magentalen equ $ - magenta_color

; Cyan
cyan_color:
    db 0x1B, '[36m'
cyanlen equ $ - cyan_color

; White
white_color:
    db 0x1B, '[37m'
whitelen equ $ - white_color

; Reset
reset_color:
    db 0x1B, '[0m'
resetlen equ $ - reset_color
