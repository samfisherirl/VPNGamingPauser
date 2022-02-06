FileReadLine, gamename, logfile.txt, 1
Loop 
{
    
    sleep 5000
    Process, Exist, %gamename%
    If Errorlevel
    {  
        Sleep 5000    
    }
    Else 
    {
        Process, Close, NordVPN.exe
    	Sleep 5000
        Run, C:\Program Files\NordVPN\NordVPN.exe
        Sleep 5000
        ExitApp
    }
}

Pause::ExitApp
