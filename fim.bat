@echo off
rem ============================================================
rem  FIM DO TRABALHO
rem  Guarda as alteracoes (git add + git commit) e envia-as
rem  para o GitHub (git pull + git push).
rem  Este ficheiro tem de estar dentro da pasta do projeto.
rem ============================================================
title Fim do trabalho
setlocal
cd /d "%~dp0"

echo.
echo === FIM DO TRABALHO ===
echo Pasta: %cd%
echo.

where git >nul 2>&1
if errorlevel 1 goto sem_git

git rev-parse --is-inside-work-tree >nul 2>&1
if errorlevel 1 goto sem_repo

rem --- Ha alteracoes por guardar? ---
git status --porcelain | findstr . >nul
if errorlevel 1 goto sem_alteracoes

echo Ficheiros alterados:
git status --short
echo.

set "MSG="
set /p "MSG=Descreve o que fizeste hoje (Enter para mensagem automatica): "
if not defined MSG set "MSG=Trabalho de %date% %time:~0,5%"
rem As aspas dentro da mensagem estragam o comando; trocam-se por plicas.
set "MSG=%MSG:"='%"

echo.
echo A guardar as alteracoes...
git add -A
git commit -m "%MSG%"
if errorlevel 1 goto erro_commit
goto enviar

:sem_alteracoes
echo Nao ha alteracoes novas por guardar.
echo.

:enviar
echo.
echo A sincronizar com o GitHub...
git pull --no-edit
if errorlevel 1 goto erro_pull

git push
if not errorlevel 1 goto sucesso

rem Primeiro envio deste ramo: define a ligacao ao GitHub.
git push -u origin HEAD
if errorlevel 1 goto erro_push

:sucesso
echo.
echo Ultimos commits:
git log --oneline -3
echo.
echo [OK] Trabalho guardado e enviado para o GitHub.
goto fim

:sem_git
echo [ERRO] O Git nao esta instalado neste computador.
echo        Instala-o a partir de https://git-scm.com/downloads
goto fim

:sem_repo
echo [ERRO] Esta pasta nao e um repositorio Git.
echo        Copia este ficheiro para dentro da pasta do projeto.
goto fim

:erro_commit
echo.
echo [ERRO] Nao foi possivel fazer o commit. Le a mensagem acima.
echo        Se aparecer "Author identity unknown", configura o nome
echo        e o email com git config (seccao 2 do manual).
goto fim

:erro_pull
echo.
echo [ERRO] Nao foi possivel receber as alteracoes do GitHub.
echo        O teu trabalho ficou guardado neste computador, mas
echo        ainda NAO foi enviado. Se aparecer CONFLICT, chama o professor.
goto fim

:erro_push
echo.
echo [ERRO] Nao foi possivel enviar para o GitHub.
echo        O teu trabalho ficou guardado neste computador, mas
echo        ainda NAO foi enviado. Verifica a ligacao a Internet
echo        e se o repositorio esta ligado ao GitHub (git remote -v).
goto fim

:fim
echo.
pause
endlocal
