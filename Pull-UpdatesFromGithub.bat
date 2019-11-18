@ECHO OFF

SET "_PREV_COMMITS_TO_GET=8"

SET "_BRANCH=backup-and-restore"

REM -------------------------------------------------------------------------------
REM ===============================================================================
REM - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
:Main

:: - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

ECHO - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

::Thanks to:
::https://git-scm.com/book/en/v2/Git-Basics-Viewing-the-Commit-History
ECHO:
ECHO Last %_PREV_COMMITS_TO_GET% commits known in the local repository:
ECHO:

:: Natural command:
::git log -6 --pretty=format:"%h - %an, %ar : %s"
:: This will work from the command line, but in batch script percentage signs % must be doubled-up to be literal %%

git log -%_PREV_COMMITS_TO_GET% --pretty=format:"%%h - %%an, %%ar : %%s"

ECHO:
ECHO - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

:: - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

::Thanks to:
::https://stackoverflow.com/questions/180272/how-to-preview-git-pull-without-doing-fetch

::git fetch

ECHO:
ECHO - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

ECHO:
ECHO Newly-fetched commits from %_BRANCH%:
ECHO:

git -P log HEAD..origin/%_BRANCH%

ECHO:
ECHO - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

:: - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

ECHO:
ECHO Files changed in my local folder:
ECHO:

git -P diff --name-status

ECHO:
ECHO - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

ECHO:
ECHO Details of local changes:
ECHO:
PAUSE
ECHO:

git -P diff

ECHO:
ECHO - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
ECHO:

:PromptForCommitMsg
SET /P "_COMMIT_MESSAGE=Please enter a message about your changes: "
IF /I "%_COMMIT_MESSAGE%"=="" GOTO PromptForCommitMsg

ECHO "CMDLINE: %_COMMIT_MESSAGE%"

PAUSE

git add .
git commit -m "CMDLINE: %_COMMIT_MESSAGE%"

:: - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

ECHO:
ECHO - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
ECHO:
ECHO Merge:
ECHO:
PAUSE
ECHO:

git merge

ECHO:
ECHO - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
ECHO:
ECHO Pull:
ECHO:
PAUSE
ECHO:

git pull

ECHO:
ECHO - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
ECHO:
ECHO Push:
ECHO:
PAUSE
ECHO:

git push

ECHO:
ECHO - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

:: - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

:: End Main

REM - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
REM ===============================================================================
REM -------------------------------------------------------------------------------

:Footer
:END
::ENDLOCAL
ECHO: 
ECHO End %~nx0
ECHO: 
PAUSE
::GOTO :EOF
EXIT /B & REM If you call this program from the command line and want it to return to CMD instead of closing Command Prompt, need to use EXIT /B or no EXIT command at all.
