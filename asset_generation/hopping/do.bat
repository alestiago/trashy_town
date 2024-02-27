@echo off
setlocal enabledelayedexpansion

:: for some ungodly reason if you want to guarnatee the order of the files, you have to specify them in the order you want them to appear in the command

set "files="
for /l %%i in (1, 1, 112) do (
    set "files=!files! raw\%%i.png"
)

magick montage %files% -geometry 512x512 -tile 7x16 -background transparent -filter Catrom sprite_sheet.png