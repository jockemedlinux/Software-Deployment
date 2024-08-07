# Progression Status in LiteToucj Window

### Credits:
https://www.systanddeploy.com/2018/02/add-complete-progression-status-to.html


[alt text](https://github.com/jockemedlinux/SoftwareDeployment/blob/master/Microsoft%20Deployment%20Toolkit/guides/Progressionstatus%20in%20LiteTouch%20window/progressionimage.png?raw=true)

Code to add in ZTIUtility.vbs
```vbs
' Variables declaration
' This part should be located at the begining, just below the existing part ==> Dim uMaxStep
Dim uStatus, uStep_Division, uStep_Division_Round, uStep_Percent
 
' Progression calcul
' this part should be located just below thos one ==> uMaxStep = CLng(oEnvironment.Item("_SMSTSInstructionTableSize"))
uStep_Division = uStep / uMaxStep * 100  
uStep_Division_Round = Round(uStep_Division)
uStep_Percent = uStep_Division_Round & " % completed"
uStatus = oEnvironment.Item("_SMSTSCurrentActionName") & " - " & " Step " & uStep & " on " & uMaxStep & " - " & uStep_Percent
 
' Replace the existing Call oProgress.ShowActionProgress part with the below
Call oProgress.ShowActionProgress(oEnvironment.Item("_SMSTSOrgName"), oEnvironment.Item("_SMSTSPackageName"), oEnvironment.Item("_SMSTSCustomProgressDialogMessage"), uStatus, (uStep), (uMaxStep), sMsg, (iPercent), (iMaxPercent))
```

Entire function with new code
```vbs
Public Function ReportProgress(sMsg, iPercent)

		Dim iMaxPercent
		Dim oProgress
		Dim uStep
		Dim uMaxStep
		' This part should be located at the begining, just below the existing part ==> Dim uMaxStep
		Dim uStatus, uStep_Division, uStep_Division_Round, uStep_Percent

		CreateEntry "Update progress [ " & iPercent & " ] : " & sMsg , LogTypeVerbose


		' Try to create the progress UI object

		On Error Resume Next
		Set oProgress = CreateObject("Microsoft.SMS.TSProgressUI")
		If Err then
			Err.Clear

			' Record the progress in the registry

			oShell.RegWrite "HKLM\Software\Microsoft\Deployment 4\ProgressPercent", iPercent, "REG_DWORD"
			oShell.RegWrite "HKLM\Software\Microsoft\Deployment 4\ProgressText", sMsg, "REG_SZ"

			on error goto 0
			Exit Function
		End if
		On Error Goto 0


		' Update the progress

		On Error Resume Next

		iMaxPercent = 100
		uStep = CLng(oEnvironment.Item("_SMSTSNextInstructionPointer"))
		uMaxStep = CLng(oEnvironment.Item("_SMSTSInstructionTableSize"))
		
		' this part should be located just below thos one ==> uMaxStep = CLng(oEnvironment.Item("_SMSTSInstructionTableSize"))
		uStep_Division = uStep / uMaxStep * 100  
		uStep_Division_Round = Round(uStep_Division)
		uStep_Percent = uStep_Division_Round & " % completed"
		uStatus = oEnvironment.Item("_SMSTSCurrentActionName") & " - " & " Step " & uStep & " on " & uMaxStep & " - " & uStep_Percent
		
		' Replace the existing Call oProgress.ShowActionProgress part with the below
		Call oProgress.ShowActionProgress(oEnvironment.Item("_SMSTSOrgName"), oEnvironment.Item("_SMSTSPackageName"), oEnvironment.Item("_SMSTSCustomProgressDialogMessage"), uStatus, (uStep), (uMaxStep), sMsg, (iPercent), (iMaxPercent))    
		If Err then
			CreateEntry "Unable to update progress: " & Err.Description & " (" & Err.Number & ")", LogTypeInfo
			ReportProgress = Failure
			Err.Clear
			Exit Function
		End if

		On Error Goto 0


		' Dispose of the object

		Set oProgress = Nothing

	End Function
```
