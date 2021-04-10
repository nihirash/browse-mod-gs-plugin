    macro GS_WaitCommand
.wait
    in a, (GeneralSound.CMD)
    rrca
    jr c, .wait
    endm

    macro GS_WaitData
.wait
    in a, (GeneralSound.CMD)
    rlca
    jr c, .wait
    endm

    macro GS_SendCommand nn
    ld a, nn : out (GeneralSound.CMD), a
    endm

    module GeneralSound
;; Control ports
CMD  = 187
DATA = 179

;; Commands
CMD_WARM_RESET      = #F3
CMD_COLD_RESET      = #F4
CMD_LOAD_MODULE     = #30
CMD_PLAY_MODULE     = #31
CMD_STOP_MODULE     = #32
CMD_CONTINUE_MODULE = #33
CMD_OPEN_STREAM     = #D1
CMD_CLOSE_STREAM    = #D2

; A - 0 warm reset, other - cold
init:
    GS_SendCommand CMD_WARM_RESET
    ret

;; Initializes loading module
loadModule:
    GS_SendCommand CMD_LOAD_MODULE
    GS_WaitCommand
    GS_SendCommand CMD_OPEN_STREAM
    GS_WaitCommand
    ret

;; Use it for streaming mod file 
sendByte:
    out (DATA), a
    GS_WaitData
    ret

;; Call it when module was loaded
finishLoadingModule:
    GS_SendCommand CMD_CLOSE_STREAM
    GS_WaitCommand
rewind:
    ld a, 1 : out (DATA), a
    GS_SendCommand CMD_PLAY_MODULE
    GS_WaitCommand
    ret

    endmodule