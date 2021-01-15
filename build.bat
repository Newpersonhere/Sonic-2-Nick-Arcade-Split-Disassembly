@echo off
IF EXIST s2nabuilt.bin move /Y s2nabuilt.bin s2nabuilt.prev.bin >NUL
asm68k /k /p /c /m /o ae- "Sonic 2 (Early prototype).asm", s2nabuilt.bin, , s2na.lst >errors.txt
fixheadr.exe s2nabuilt.bin