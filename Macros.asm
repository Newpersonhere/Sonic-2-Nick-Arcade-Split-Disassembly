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
	
; ---------------------------------------------------------------------------
; reset the Z80
; ---------------------------------------------------------------------------

resetZ80:	macro
		move.w	#$100,(Z80Reset).l
		endm

resetZ80a:	macro
		move.w	#0,(Z80Reset).l
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
		
; ---------------------------------------------------------------------------
; Set a VRAM address via the VDP control port.
; input: 16-bit VRAM address, control port (default is ($C00004).l)
; ---------------------------------------------------------------------------

locVRAM:	macro loc,controlport
		if (narg=1)
		move.l	#(VRAM_DMA_CMD+((loc&$3FFF)<<16)+((loc&vram_fg)>>14)),(VdpCtrl).l
		else
		move.l	#(VRAM_DMA_CMD+((loc&$3FFF)<<16)+((loc&vram_fg)>>14)),controlport
		endc
		endm

; ---------------------------------------------------------------------------
; DMA copy data from 68K (ROM/RAM) to the VRAM
; input: source, length, destination
; ---------------------------------------------------------------------------

writeVRAM:	macro
		lea	(VdpCtrl).l,a5
		move.l	#$94000000+(((\2>>1)&$FF00)<<8)+VDPREG_DMALEN_L+((\2>>1)&$FF),(a5)
		move.l	#$96000000+(((\1>>1)&$FF00)<<8)+VDPREG_DMASRC_L+((\1>>1)&$FF),(a5)
		move.w	#VDPREG_DMASRC_H+((((\1>>1)&$FF0000)>>16)&$7F),(a5)
		move.w	#$4000+(\3&$3FFF),(a5)
		move.w	#$80+((\3&vram_fg)>>14),($FFFFF640).w
		move.w	($FFFFF640).w,(a5)
		endm

; ---------------------------------------------------------------------------
; DMA copy data from 68K (ROM/RAM) to the CRAM
; input: source, length, destination
; ---------------------------------------------------------------------------

writeCRAM:	macro
		lea	(VdpCtrl).l,a5
		move.l	#$94000000+(((\2>>1)&$FF00)<<8)+VDPREG_DMALEN_L+((\2>>1)&$FF),(a5)
		move.l	#$96000000+(((\1>>1)&$FF00)<<8)+VDPREG_DMASRC_L+((\1>>1)&$FF),(a5)
		move.w	#VDPREG_DMASRC_H+((((\1>>1)&$FF0000)>>16)&$7F),(a5)
		move.w	#vram_fg+(\3&$3FFF),(a5)
		move.w	#$80+((\3&vram_fg)>>14),($FFFFF640).w
		move.w	($FFFFF640).w,(a5)
		endm

; ---------------------------------------------------------------------------
; DMA fill VRAM with a value
; input: value, length, destination
; ---------------------------------------------------------------------------

fillVRAM:	macro value,length,loc
		lea	(VdpCtrl).l,a5
		move.w	#VDPREG_INCR+1,(a5)
		move.l	#$94000000+((length&$FF00)<<8)+VDPREG_DMALEN_L+(length&$FF),(a5)
		move.w	#VDPREG_DMASRC_H+$80,(a5)
		move.l	#VRAM_DMA_CMD+((loc&$3FFF)<<16)+((loc&vram_fg)>>14),(a5)
		move.w	#value,(VdpData).l
		endm

; ---------------------------------------------------------------------------
; Copy a tilemap from 68K (ROM/RAM) to the VRAM without using DMA
; input: source, destination, width [cells], height [cells]
; ---------------------------------------------------------------------------

copyTilemap:	macro source,loc,width,height
		lea	(source).l,a1
		move.l	#VRAM_ADDR_CMD+((loc&$3FFF)<<16)+((loc&vram_fg)>>14),d0
		moveq	#width,d1
		moveq	#height,d2
		bsr.w	ShowVDPGraphics
		endm
