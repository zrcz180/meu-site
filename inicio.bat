@echo off
rem ============================================================
rem  INICIO DO TRABALHO
rem  Recebe do GitHub as alteracoes mais recentes (git pull).
rem  Este ficheiro tem de estar dentro da pasta do projeto.
rem ============================================================
title Inicio do trabalho
cd /d "%~dp0"

echo.
echo === INICIO DO TRABALHO ===
echo Pasta: %cd%
echo.

where git >nul 2>&1
if errorlevel 1 goto sem_git

git rev-parse --is-inside-work-tree >nul 2>&1
if errorlevel 1 goto sem_repo

echo A receber as alteracoes do GitHub...
echo.
git pull
if errorlevel 1 goto erro_pull

echo.
echo Estado atual do projeto:
git status --short --branch
echo.
echo [OK] Projeto atualizado. Podes comecar a trabalhar.
goto fim

:sem_git
echo [ERRO] O Git nao esta instalado neste computador.
echo        Instala-o a partir de https://git-scm.com/downloads
goto fim

:sem_repo
echo [ERRO] Esta pasta nao e um repositorio Git.
echo        Copia este ficheiro para dentro da pasta do projeto.
goto fim

:erro_pull
echo.
echo [ERRO] Nao foi possivel receber as alteracoes.
echo        Verifica a ligacao a Internet e le a mensagem acima.
echo        Se aparecer CONFLICT, chama o professor.
goto fim

:fim
echo.
pause
