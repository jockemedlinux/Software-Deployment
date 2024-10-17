# Migrate UserState

### Steps Outlined   
```
1. Create necessary task-sequences
2. Configure customsettings.ini
3. Capture UserState
4. Deploy new Machine with previously captured userstate.
```

Advanced
```
1. Create more widely adapted MigUser.xml and other files to capture more updated and relevant things
```

CustomSettings.ini relevant settings   
``` 
;Capture UserState
UserDataLocation=Network
UDShare=\\RAMbunctious\share$\UserState
UDDIR=%OSDComputername%
``` 

![](_resources\1.png)


Resources:
https://www.youtube.com/watch?v=UEdEJ5lsEs4
https://askme4tech.com/how-use-usmt-mdt-transfer-user-profiles
https://ehlertech.com/customxmls
