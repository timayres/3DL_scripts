@echo off
setlocal

:: Original source:  http://blog.dotsmart.net/2011/01/27/executing-cygwin-bash-scripts-on-windows/
:: Usage: rename this .cmd script to be the same as the bash .bsh script.
:: You can now run the cygwin bash script from windows, including 
:: dragging & dropping files on this .cmd script.
:: This will run the script from ~/, however you can
:: use the _CYGPATH env varible to cd from within the script

:: Check for bash .bsh script file:
if not exist "%~dpn0.bsh" echo Script "%~dpn0.bsh" not found & exit 2

:: Set the cygwin path; this may need to be changed for different installations
set _CYGBIN=C:\cygwin64\bin
if not exist "%_CYGBIN%" echo Couldn't find Cygwin at "%_CYGBIN%" & exit 3
 
:: Resolve ___.bsh to /cygdrive based *nix path and store in %_CYGSCRIPT%
for /f "delims=" %%A in ('%_CYGBIN%\cygpath.exe "%~dpn0.bsh"') do set _CYGSCRIPT=%%A

:: Resolve script working directory
for /f "delims=" %%A in ('%_CYGBIN%\cygpath.exe "%CD%"') do set _CYGPATH=%%A

:: invoke script, passing any args that were passed to us
:: Note that the script will have access to the CYG variables,
:: e.g. so that the correct working path can be set 
%_CYGBIN%\bash --login "%_CYGSCRIPT%" %*

:: discard variables
endlocal
