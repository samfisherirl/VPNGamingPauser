#SingleInstance
SetWorkingDir %A_ScriptDir%
Gui Font, s11 cBlue
Gui, 1:Add, Text, x32 y22 w397 h21 +Left, NordVPN Unofficial: Gaming Mode Shutoff
Gui Font
Gui, 1:Add, Text, x10 y49 w332 h43 , This application will Close NordVPN when launching specific games. It will also close sensitive apps like torrents`, browsers`, at your request. Once the game closes`, the VPN will automatically reload.
Gui, 1:Add, Edit, x201 y112 w128 h16 vappname, QBittorrent.exe ; // sensitive app you want to close

Gui, 1:Add, Text, x11 y108 w177 h41 , Enter the name of app you want to close before NordVPN disconnects (ex. chrome.exe):
Gui, 1:Add, Text, x12 y160 w180 h71 , Locate the EXE for Steam games. `nIf it's not a Steam game, feel free to use a Shortcut. 
Gui, 1:Add, Button, x200 y162 w130 h25 gbrowse, Browse
Gui, 1:Add, Button, x11 y247 w322 h23 ggenerate, Generate Shortcut!
Gui, 1:Add, Button, x200 y278 w133 h24 gexit, Exit
Gui, 1:Add, Button, x12 y278 w134 h26 greadme, Readme
Filetype1 := "exe"
Filetype2 := "lnk"
MenuStart:
    ; Generated using SmartGUI Creator 4.0
    Gui, 1:Show, x166 y156 h342 w355, NordVPN Unofficial: Gaming Mode Shutoff
    if (not Winactive("NordVPN Unofficial: Gaming Mode Shutoff"))
    ExitApp
Return 

readme:
    MsgBox, This is the v0.5 release. Please search samfisherirl on github for instructions and sharing bugs. `nSorry I do not have a read me just yet. Reach out for questions. 
    return

browse:
    {
        FileSelectFile, Selectgame, 32, , Select a game, Application (*.exe; *.lnk)
        if (Selectgame = "")
            MsgBox, The user didn't select anything.
        else
        {
            SplitPath, Selectgame, Gameexe, Gamepath, Gameextenstion, Gamenameonly
        }
    }
return

generate:
    {
        loglocal := "\NordVPNGamingShutoff\Logfile.txt"
        Logfile := A_AppDataCommon loglocal
        MsgBox, The user selected the following game:`n %Gameexe% 
        If (Gameextenstion = %Filetype1%)
        {
            Run, REQUIRED_KEEP_WITH_EXE.bat, A_ScriptDir, min	
            Goto, Nextup ;min ; checks for install file in program data 
        }
        If (Gameextenstion = %Filetype2%)
        {
            Run, REQUIRED_KEEP_WITH_EXE.bat, A_ScriptDir,	
            
            FileGetShortcut, %Gamepath%, Gamepathlnk, OutDir, OutArgs, OutDesc, OutIcon, OutIconNum, ;extract shortcut path
            If Gameextenstion=%Filetype1%  
                Goto, Nextup
            else {
                MsgBox false no exe in shortcut, please try again
                Goto, MenuStart
            }
            Goto, Nextup ;min ; checks for install file in program data    
        }
        Next:
            if Gameextenstion not in %Filetype1%,%Filetype2%  
            {
                MsgBox You have uploaded the wrong file type. Potentially a Steam Shortcut. `nFor Any game, run the game. Open task manager, right click on the game and click open file location. Return to this app and select location.`n Try again. 
                Goto, Menustart
            }
        Nextup:
            guiControlGet, theapp,, appname ; 					displays file name complete, unneeded	deletes local file incase of existing file
            FileDelete, %Logfile%
            FileAppend, %Gamenameonly%, %Logfile% 	; send game file to .txt file
            
            Desktop1 := A_Desktop "\"
            Desktop2 := Gamenameonly ".bat"
            Filecomplete :=  Desktop1 Desktop2 ; 	builds string from file name		
            ;info from input field 
            FileDelete, Filecomplete ; 
            FileAppend,
            (
            @echo off
            Cls
            
            taskkill /IM %theapp% /F
            
            ECHO.%theapp%  has been closed.
            ECHO.
            ECHO.   
            Timeout /t 1
            ECHO.
            
            Cls
            taskkill /IM NordVPN.exe /F
            
            
            ECHO.
            ECHO.
            
            Cls
            
            ECHO.   Giving Nord a moment to close..
            ECHO.
            Timeout /t 6
            ECHO.
            ECHO.
            Cls
            ECHO.Launching %Gamenameonly% now. 
            ECHO.
            ECHO.
            Cls
            Start ""  "%Selectgame%"
            Cls 
            ECHO. %Gamenameonly% is launching now. Pausing to allow the game to launch before the VPN looper starts. 
                ECHO.
            Timeout /t 22
            
            Start ""  "%ProgramData%\NordVPNGamingShutoff\vpn looper.exe" 
                
            ECHO.
            ), %Filecomplete% ; appends theapp variable to text
            
            MsgBox, a .bat file for %Gamenameonly% has been sent to Desktop. `nI am working on a way to create a Desktop shortcut, until then you can move the .bat file, right click and click Send to > Desktop.`nThen right click properties to change icon.
            ShortcutMaker := Desktop1 "." FileType2
            FileCreateShortcut, Filecomplete, ShortcutMaker, Desktop1,,OutIcon 
        }
        Return
        exit:
            {
                ExitApp
            }
            
            Pause::ExitApp
            
        GuiClose:
            ExitApp 
            