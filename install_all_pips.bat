@echo off

:change to the path where the Bat file in
%~d0
cd %~dp0

@echo ==============================================
@echo  *** Install python requirements  ***
cd installer
pip uninstall -y -r uninstall.txt
pip install -r requirements.txt --no-index -f pip_files

pause