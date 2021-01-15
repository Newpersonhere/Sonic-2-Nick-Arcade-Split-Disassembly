; ---------------------------------------------------------------------------
; Align and pad
; input: length to align to, value to use as padding (default is 0)
; ---------------------------------------------------------------------------

align:	macro
	if (narg=1)
	dcb.b \1-(*%\1),0
	else
	dcb.b \1-(*%\1),\2
	endc
	endm
	
; Macros from Plutiedev.com

PauseZ80: macro
    move.w  #$100, (Z80BusReq)
.WaitZ80\@:
    btst    #0,(Z80BusReq).l
    bne.s   .WaitZ80\@
    endm
    
ResumeZ80: macro
    move.w  #0, (Z80BusReq)
    endm
    
FastPauseZ80: macro
    move.w  #$100, (Z80BusReq)
    endm

; ---------------------------------------------------------------------------
; disable interrupts
; ---------------------------------------------------------------------------

disable_ints:	macro
		move	#$2700,sr
		endm

; ---------------------------------------------------------------------------
; enable interrupts
; ---------------------------------------------------------------------------

enable_ints:	macro
		move	#$2300,sr
		endm
		
SetGfxMode macro mode
    move.w  #VDPREG_MODE4|(mode), (VdpCtrl)
    endm
