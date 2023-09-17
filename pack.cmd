@echo off

mkdir "%userprofile%/Documents/Teardown/mods/MorsWare"
xcopy /c /y /e . "%userprofile%/Documents/Teardown/mods/MorsWare"

cd "%userprofile%/Documents/Teardown/mods/MorsWare"
rmdir /s /q .github
rmdir /s /q media
rmdir /s /q tools
del README.md
del pack.cmd
del LICENSE
