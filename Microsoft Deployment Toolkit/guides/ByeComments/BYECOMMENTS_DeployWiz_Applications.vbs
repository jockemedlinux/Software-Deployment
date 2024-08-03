Option Explicit

'''''''''''''''''''''''''''''''''''''''''''
'  Application List
'

Dim g_sApplicationDialog
Dim g_oXMLAppList
Dim g_sByeCommentsOriginal


Function IsThereAtLeastOneApplicationPresent

    Dim oXMLAppList
    Dim dXMLCollection

    ' Bail out early if there is no "Install Application" step in the task sequence
    If Not FindTaskSequenceStep("//step[@type='BDD_InstallApplication' and ./defaultVarList/variable[@name='ApplicationGUID'] and ./defaultVarList[variable='']]", "ZTIApplications.wsf") Then
        IsThereAtLeastOneApplicationPresent = False
        Exit Function
    End If

    ' Load and cache the application list
    If IsEmpty(g_oXMLAppList) Then
        Set g_oXMLAppList = New ConfigFile
        g_oXMLAppList.sFileType = "Applications"
    End If

    ' Get the filtered list of applications
    g_oXMLAppList.sSelectionProfile = oEnvironment.Item("WizardSelectionProfile")
    g_oXMLAppList.sCustomSelectionProfile = oEnvironment.Item("CustomWizardSelectionProfile")
    Set dXMLCollection = g_oXMLAppList.FindItems

    If dXMLCollection.Count = 0 Then
        IsThereAtLeastOneApplicationPresent = False
        g_sApplicationDialog = ""
        Exit Function
    End If

    g_sApplicationDialog = g_oXMLAppList.GetHTMLEx("CheckBox", "Applications") 

    IsThereAtLeastOneApplicationPresent = True

End Function

Function InitializeApplicationList

    ' Set the innerHTML of AppListBox
    AppListBox.InnerHTML = g_sApplicationDialog
    PopulateElements

    ' Store the original content of ByeComments1
    Dim byeCommentsElement
    Set byeCommentsElement = document.getElementById("ByeComments1")
    
    If Not byeCommentsElement Is Nothing Then
        g_sByeCommentsOriginal = byeCommentsElement.innerHTML
        ' Hide the comments initially
        byeCommentsElement.innerHTML = ""
    End If

    ' Setup checkbox click handler
    Dim checkbox
    Set checkbox = document.getElementById("ToggleComments")
    If Not checkbox Is Nothing Then
        checkbox.onclick = GetRef("ToggleCommentsClick")
    End If

End Function

Function ReadyInitializeApplicationList
    Dim oInput, oApplicationList, oAppItem

    If Not ImageList.ReadyState = "complete" Then
        Exit Function
    End If

    Set oApplicationList = document.getElementsByName("Applications")

    If oApplicationList Is Nothing Or oApplicationList.Length < 1 Then
        Exit Function
    End If

    For Each oInput In oApplicationList
        If UCase(document.all.item(oInput.SourceIndex - 1).TagName) = "INPUT" Then
            If oInput.Value = "" Then
                document.all.item(oInput.SourceIndex - 1).Disabled = True
                document.all.item(oInput.SourceIndex - 1).Style.Display = "none"
            Else
                document.all.item(oInput.SourceIndex - 1).Style.Display = "inline"
                If Not IsEmpty(Property("Applications")) Then
                    For Each oAppItem In Property("Applications")
                        If UCase(oAppItem) = UCase(oInput.Value) Then
                            document.all.item(oInput.SourceIndex - 1).Checked = True
                            Exit For
                        End If
                    Next
                End If
                If Not IsEmpty(Property("MandatoryApplications")) Then
                    For Each oAppItem In Property("MandatoryApplications")
                        If UCase(oAppItem) = UCase(oInput.Value) Then
                            document.all.item(oInput.SourceIndex - 1).Disabled = True
                            document.all.item(oInput.SourceIndex - 1).Checked = True
                            Exit For
                        End If
                    Next
                End If
            End If
        End If
    Next

End Function

Sub AppItemChange

    document.all.item(window.event.srcElement.SourceIndex + 1).Disabled = Not window.event.SrcElement.Checked

End Sub

Sub ToggleCommentsClick
    Dim byeCommentsElement
    Set byeCommentsElement = document.getElementById("ByeComments1")
    
    If Not byeCommentsElement Is Nothing Then
    
        If window.event.srcElement.Checked Then
            ' Checkbox is checked, restore the original content
            byeCommentsElement.innerHTML = g_sByeCommentsOriginal
        Else
            ' Checkbox is unchecked, clear the content
            byeCommentsElement.innerHTML = ""
        End If
    End If

    ' Optionally display the content of g_sApplicationDialog (Uncomment if needed)
    ' MsgBox g_sApplicationDialog

    ' Optionally display the content of ByeComments1 (Uncomment if needed)
    ' MsgBox "Content of ByeComments1: " & byeCommentsElement.innerHTML
End Sub
