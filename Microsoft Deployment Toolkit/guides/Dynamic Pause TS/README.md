# Pause TS
Credits: https://www.systanddeploy.com/2020/02/pause-task-sequence-on-fly-from.html  


Code to enter into ZTIUtility.vbs
```vbs
Dim TS_Pause_Status
If oEnvironment.Item("TSPause") = "TRUE"  Then 
 TS_Pause_Status = MsgBox ("Click on OK to continue the TS", vbOkOnly  + vbQuestion, "TS in pause")     
 If TS_Pause_Status = vbOK  Then
  oEnvironment.Item("TSPause") = "FALSE"
 End if   
End If
```

Included complete ZTIutility.vbs also with progress info.