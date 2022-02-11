#SingleInstance
SetWorkingDir %A_ScriptDir%
Gui Font, s11 cBlue
Gui, 1:Add, Text, x194 y16 w476 h33 +Left, VPN Gaming Pauser
Gui Font
Gui, 1:Add, Text, x20 y60 w519 h68, This application will Close NordVPN when launching specific games. It will also close sensitive apps like torrents`, browsers`, at your request. Once the game closes`, the VPN will automatically reload.
Gui, 1:Add, Edit, x310 y140 w200 h20 vappname, chrome.exe ; // sensitive app you want to close

Gui, 1:Add, Text, x20 y140 w276 h64, Enter the name of app you want to close before NordVPN disconnects (ex. chrome.exe):
Gui, 1:Add, Text, x20 y220 w281 h63, Locate the EXE for Steam games. `nIf it's not a Steam game, feel free to use a Shortcut. 
Gui, 1:Add, Button, x310 y220 w201 h29 gbrowse, Browse
Gui, 1:Add, Button, x16 y360 w495 h36 ggenerate, Generate Shortcut!
Gui, 1:Add, Button, x340 y420 w155 h38 gexit, Exit
Gui, 1:Add, Button, x16 y420 w155 h41 greadme, Readme
Gui, 1: Add, DropDownList, x312 y302 w201 Choose1 vvpn, NordVPN||SurfShark||Other VPN
Gui, 1: Add, Text, x24 y296 w275 h29 +0x200, Select your VPN 
Gui, 1: Add, Button, x180 y420 w155 h40 ginstall, Install (Required)
Filetype1 := "exe"
Filetype2 := "lnk"
MenuStart:
    ; Generated using SmartGUI Creator 4.0
    Gui, 1:Show, x166 y156 w550 h478, VPN Gaming Pauser
    if (not Winactive("VPN Gaming Pauser"))
        ExitApp
Return 

readme:
    MsgBox, This is the v0.5 release. Please search samfisherirl on github for instructions and sharing bugs. `nSorry I do not have a read me just yet. Reach out for questions. 
return
install:
    {
        Run,  %A_ScriptDir%\INSTALL THIS FIRST.bat
        MsgBox, You can now move the EXE for this app anywhere
        Goto, MenuStart
    }
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
        installercheck := A_AppDataCommon "\NordVPNGamingShutoff\vpn looper.exe"
        if !FileExist(installercheck)
        {
            MsgBox, Install Required
            Goto, MenuStart
        }
        else
        {
            
            loglocal := "\NordVPNGamingShutoff\Logfile.txt"
            Logfile := A_AppDataCommon loglocal
            MsgBox, The user selected the following game:`n %Gameexe% 
            If Gameextenstion is in %Filetype1%
            { 
                Goto, Nextup ;min ; checks for install file in program data 
            }
            If Gameextenstion is in %Filetype2%
            {             
                FileGetShortcut, %Gamepath%, Gamepathlnk, OutDir, OutArgs, OutDesc, OutIcon, OutIconNum, ;extract shortcut path
                If (%Filetype1% is in Gameextenstion)
                    Goto, Nextup
                else {
                    MsgBox false no exe in shortcut, please try again
                    Goto, MenuStart
                }
                Goto, Nextup ;min ; checks for install file in program data    
            }
            Next:
                if Gameextenstion not in %Filetype1%, %Filetype2%  
                {
                    MsgBox You have uploaded the wrong file type or selected nothing.`nFor any steam game, run the game. Open task manager, right click on the game and click open file location. Return to this app and select location.`n Try again. 
                    Goto, Menustart
                }
            Nextup:
                guiControlGet, theapp,, appname ; 					displays file name complete, unneeded	deletes local file incase of existing file
                guiControlGet, vpnchoice,, vpn ; 	
                FileDelete, %Logfile%
                FileAppend, %Gamenameonly%, %Logfile% 	; send game file to .txt file
                appendexe := ".exe"                      ; get vpn type, if other, browse for vpn
                if (vpnchoice="NordVPN")
                {
                    vpnexe := vpnchoice appendexe
                    Goto, makethefile
                }
                if (vpnchoice="SurfShark")
                {
                    vpnexe := vpnchoice appendexe
                    Goto, makethefile
                }        
                if (vpnchoice="Other VPN")
                {
                    MsgBox, You will be prompted to select your VPN. Select a shortcut or an EXE
                    FileSelectFile, vpnchoice, , , Select your VPN, Application (*.exe; *.lnk)
                    if (vpnchoice = "Other VPN" or vpnchoice = "") 
                    {
                        MsgBox, The user didn't select anything.
                        Goto, MenuStart
                    }
                    else
                    {
                        SplitPath, vpnchoice, vpnexe , , , vpnnoext
                        Goto, makethefile
                    }
                }
            makethefile: 
                Desktop1 := A_AppData "\"
                Desktop2 := Gamenameonly ".bat"
                Filecomplete :=  Desktop1 Desktop2 ; 	builds string from file name		
                ;info from input field 
                FileDelete, %Filecomplete% ; 
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
                taskkill /IM %vpnexe% /F
                
                
                ECHO.
                ECHO.
                
                Cls
                
                ECHO.   Giving %vpnnoext% a moment to close..
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
                ECHO. 
                ECHO. 
                Timeout /t 22                 
                ECHO. 
                ECHO. 
                Start ""  "%ProgramData%\NordVPNGamingShutoff\vpn looper.exe" 
                    
                ECHO.
                ), %Filecomplete% ; appends theapp variable to text
                
                MsgBox, a shortcut for %Gamenameonly% with the VPN Pauser has been sent to Desktop. 
                ShortcutMaker1 := A_Desktop "\" 
                ShortcutMaker2 := Gamenameonly " VPN Pauser.lnk"
                ShortcutMaker := ShortcutMaker1 ShortcutMaker2 
                FileCreateShortcut, %Filecomplete%, %ShortcutMaker%, %A_AppData%, "%A_ScriptFullPath%", My Description, %Selectgame%, i
            }
        }
        Return
        exit:
            {
                ExitApp
            }
            
            Pause::ExitApp
            
        GuiClose:
            ExitApp 
            