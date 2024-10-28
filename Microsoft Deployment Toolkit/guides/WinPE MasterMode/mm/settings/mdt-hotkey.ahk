#Persistent
toggle := false

^!+x::
    if (toggle = false) { 
       Run, cmd.exe /c "%SystemRoot%\System32\mm\mdt-mastermode.exe" &, , Hide
       Run, powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Stop-Process -Name WallpaperHost -Force -ErrorAction SilentlyContinue", , Hide
	   Sleep, 2000        
	   Run, powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Copy-Item $env:SystemRoot\System32\winpe.bmp $env:SystemRoot\System32\winpe.bmp.bak -Force", , Hide
	   Sleep, 2000        
       Run, powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Copy-Item $env:SystemRoot\System32\mm\settings\mastermode.bmp $env:SystemRoot\System32\winpe.bmp -Force", , Hide
       Sleep, 2000
	   Run, cmd.exe /c "%SystemRoot%\System32\WallpaperHost.exe" &, , Hide
        toggle := true
    } else {
       Run, powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Stop-Process -Name mdt-mastermode -Force -ErrorAction SilentlyContinue", , Hide
       Run, powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Stop-Process -Name WallpaperHost -Force -ErrorAction SilentlyContinue", , Hide
	   Sleep, 2000
       Run, powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Copy-Item $env:SystemRoot\System32\winpe.bmp.bak $env:SystemRoot\System32\winpe.bmp -Force", , Hide
       Sleep, 2000
       Run, cmd.exe /c "%SystemRoot%\System32\WallpaperHost.exe" &, , Hide
       toggle := false
    }
return