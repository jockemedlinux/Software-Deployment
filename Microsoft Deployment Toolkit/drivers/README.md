# Drivers related


### Driver Packs WinPE
```
//DELL

https://www.dell.com/support/kbdoc/sv-se/000108642/winpe-10-drivrutinspaket
https://www.dell.com/support/kbdoc/sv-se/000211541/winpe-11-drivrutinspaket

//HP
https://ftp.ext.hp.com/pub/caps-softpaq/cmit/HP_WinPE_DriverPack.html
https://ftp.hp.com/pub/caps-softpaq/cmit/softpaq/WinPE10.html

//LENOVO
https://support.lenovo.com/us/en/solutions/ht074984
```


### Handle .cab files
```
// Expand the .cab files
expand <sourecabfile> -F:* <destination>
expand .\WinPE11.0-Drivers-A03-V81GV.cab -F:* .\win11
```
