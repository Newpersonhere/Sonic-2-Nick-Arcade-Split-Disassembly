@echo off
IF EXIST s2nabuilt.bin move /Y s2nabuilt.bin s2nabuilt.prev.bin >NUL
asm68k /p /o l+ /o ae- "Sonic 2 (Early prototype).asm", s2nabuilt.bin, , s2na.lst >errors.txt
pause