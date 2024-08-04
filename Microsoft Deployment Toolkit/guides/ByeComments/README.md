# ByeComments

So do you have hundreds of applications in your environment and supertired of having to scroll through those do-godders adding comments to every single application?
Well, here's how you add a CheckBox to toggle those comments out.


![alt-text](https://github.com/jockemedlinux/SoftwareDeployment/blob/master/Microsoft%20Deployment%20Toolkit/guides/ByeComments/byecomments.gif?raw=true)

outlined steps:

1. Add checkbox to Applications.xml
2. Add vbs-code to Applications.vbs
3. Add .css class to Wizard.css
4. Add BuildHTML function in ZTIConfigFile.vbs to include div class for sComments.



## Relevant Code:
// Will include complete files.

DeployWiz_Applications.xml
```xml
	  <!-- ToggleComments checkbox (ByeComments) -->
	  <img src="ItemIcon1.png" /> <input type="checkbox" id="ToggleComments" name="ToggleComments" value="ToggleComments" /> Check this box to toggle comments(!)
```

ZTIConfigFile.vbs
```vbs
sComments = ""
			If not oItem.SelectSingleNode("./Comments") is nothing then
				sComments = EncodeXML(oItem.SelectSingleNode("./Comments").Text)
				If sComments <> "" then
					sComments = "<div class='ByeComments1'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" & sComments & "</div>"
				End if
			End if
```

DeployWiz_Applications.vbs
```vbs
' Added ByeComments Checkbox fucntion. (IN THE INITIALIZE FUNCTION)

	Dim checkbox
	Set checkbox = document.getElementById("ToggleComments")
	If Not checkbox Is Nothing Then
	    checkbox.onclick = GetRef("ToggleCommentsClick")
	End If

'Added subroutine to toggle applications-comments. (TO THE BOTTOM OF THE PAGE)
Sub ToggleCommentsClick
    Dim allElements
    Dim commentElement
    Dim i

    ' Get all elements in the document
    Set allElements = document.all
    
    ' Loop through all elements and check their class names
    For i = 0 To allElements.length - 1
        Set commentElement = allElements.item(i)
        
        ' Check if the element has the class name ByeComments1
        If InStr(commentElement.className, "ByeComments1") > 0 Then
            If Not commentElement Is Nothing Then
                If commentElement.style.display = "none" Then
                    commentElement.style.display = "block"
                Else
                    commentElement.style.display = "none"
                End If
            End If
        End If
    Next
    
'    With CreateObject("wscript.shell")
'        '.Popup g_sApplicationDialog
'    End With
End Sub
```

Wizard.css
```css
/* Added ByeComments-Class for toggle comments in applications list */
.ByeComments1 {
	display: block; /* or "none" if you want it initially hidden */
}
```


## To get function for TaskSequence window also add these

DeployWiz_SelectTS.vbs
```vbs
	' Added ByeComments Checkbox fucntion.
	Dim checkbox
	Set checkbox = document.getElementById("ToggleComments")
	If Not checkbox Is Nothing Then
	    checkbox.onclick = GetRef("ToggleCommentsClick")
	End If
```

DeployWiz_SelectTS.xml
```xml
<!-- ToggleComments checkbox (ByeComments) -->
<img src="ToggleCommentsIcon1.png" width="15" height="15"/> <input type="checkbox" id="ToggleComments" name="ToggleComments" value="ToggleComments" /> Check this box to toggle comments. </br>
```