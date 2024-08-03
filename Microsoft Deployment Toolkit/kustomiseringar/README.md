# Kustomiseringar i MDT


## Registernycklar
### Göm användare från inloggningsskärm
```
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList" /t REG_DWORD /f /d 0 /v <ANVÄNDARE ATT GÖMMA>
```

### Lägg till funktioner i kontext-menyn Högerklick	
```
reg add "HKEY_CLASSES_ROOT\Directory\background\shell\<NAMN PÅ FUNKTION>"
reg add "HKEY_CLASSES_ROOT\Directory\background\shell\<NAMN PÅ FUNKTION>" /f /v Icon /d "<SÖKVÄG TILL ICON FÖR FUNKTION>"
reg add "HKEY_CLASSES_ROOT\Directory\background\shell\<NAMN PÅ FUNKTION>\command"
reg add "HKEY_CLASSES_ROOT\Directory\background\shell\<NAMN PÅ FUNKTION>\command" /f /ve /d "<KOMMANDO ATT UTFÖRA>"
```

### Lägg till ADMIN-rättigheter för program
```
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /f /v "C:\Program Files\WSL\wsl.exe" /d "^ RUNASADMIN"
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" /f /v "C:\Program Files\WSL\kali.exe" /d "^ RUNASADMIN"
```

## Powershell Relaterat
```
```

## GPO Relaterat
```
```

## BAT relaterat
```
```