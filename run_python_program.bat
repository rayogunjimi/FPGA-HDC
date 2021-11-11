@echo off

:change to the path where the Bat file in
%~d0
cd %~dp0

@echo ==============================================
@echo  *** Run all required Python Programs  ***
@echo.
@echo  *** Run HDC's training phase *** 
python HamHD-text.py
@echo.
@echo  *** Generate input for Verilog from original csv dataset ***
python input_generator.py

pause