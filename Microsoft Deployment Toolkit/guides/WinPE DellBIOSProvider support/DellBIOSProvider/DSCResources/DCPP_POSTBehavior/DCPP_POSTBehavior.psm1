# Import the helper functions

Import-Module $PSScriptRoot\..\..\Misc\helper.psm1 -Verbose:$false

function Get-TargetResource
{
	[CmdletBinding()]
	[OutputType([System.Collections.Hashtable])]
	param
	(
		[parameter(Mandatory = $true)]
		[System.String]
		$Category
	)

	#Write-Verbose "Use this cmdlet to deliver information about command processing."

	#Write-Debug "Use this cmdlet to write debug information while troubleshooting."


	<#
	$returnValue = @{
		Category = [System.String]
		Keypad = [System.String]
		Numlock = [System.String]		
		Fastboot = [System.String]
		FnLock = [System.String]
		FullScreenLogo = [System.String]
		FnLockMode = [System.String]
		Password = [System.String]
		SecurePassword = [System.String]
		PathToKey = [System.String]
		WarningsAndErr = [System.String]
		PowerWarn = [System.String]
		PntDevice = [System.String]
		ExternalHotKey = [System.String]
		PostF2Key = [System.String]
		PostF12Key = [System.String]
		PostHelpDeskKey = [System.String]
		RptKeyErr = [System.String]
		ExtPostTime = [System.String]
		SignOfLifeIndication = [System.String]
		WyseP25Access = [System.String]
	}

	$returnValue
	#>

   # Check if module DellBIOSprovider is already loaded. If not, load it.
   try{
    $bool = Confirm-DellPSDrive -verbose
    }
    catch 
    {
        write-Verbose $_
        $msg = "Get-TargetResource: $($_.Exception.Message)"
        Write-DellEventLog -Message $msg -EventID 1 -EntryType 'Error'
        write-Verbose "Exiting Get-TargetResource"
        return
    }
    if ($bool) {                      
        Write-Verbose "Dell PS-Drive DellSmbios is found."
    }
    else{
        $Message = “Get-TargetResource: Module DellBiosProvider was imported correctly."
        Write-DellEventLog -Message $Message -EventID 2 
    }

    $Get = get-childitem -path @("DellSmbios:\" + $Category)
     # Removing Verbose and Debug from output
    $PSBoundParameters.Remove("Verbose") | out-null
    $PSBoundParameters.Remove("Debug") | out-null

  
    $out = @{}   
    $Get | foreach-Object {$out.Add($_.Attribute, $_.CurrentValue)}
    $out.add('Category', $Category )
    $out
}


function Set-TargetResource
{
	[CmdletBinding()]
	param
	(
		[parameter(Mandatory = $true)]
		[System.String]
		$Category,

		[ValidateSet("EnabledByFnKey","EnabledByNumlock")]
		[System.String]
		$Keypad,

		[ValidateSet("Enabled","Disabled")]
		[System.String]
		$Numlock,

		[ValidateSet("Minimal","Thorough","Auto")]
		[System.String]
		$Fastboot,

		[ValidateSet("Enabled","Disabled")]
		[System.String]
		$FnLock,
		
		[ValidateSet("Enabled","Disabled")]
		[System.String]
		$FullScreenLogo,

		[ValidateSet("Secondary","Standard")]
		[System.String]
		$FnLockMode,

		[System.String]
		$Password,

		[System.String]
		$SecurePassword,

		[System.String]
		$PathToKey,
		
		[ValidateSet("Enabled","Disabled")]
		[System.String]
		$SignOfLifeByKbdBacklight,
		
		[ValidateSet("Enabled","Disabled")]
		[System.String]
		$SignOfLifeByDisplay,
		
		[ValidateSet("Enabled","Disabled")]
		[System.String]
		$SignOfLifeByAudio,

		[ValidateSet("PromptWrnErr","ContWrn","ContWrnErr")]
		[System.String]
		$WarningsAndErr,

		[ValidateSet("Enabled","Disabled")]
		[System.String]
		$PowerWarn,

		[ValidateSet("SerialMouse","Ps2Mouse","Touchpad","SwitchToExternalPS2")]
		[System.String]
		$PntDevice,

		[ValidateSet("Enabled","Disabled")]
		[System.String]
		$ExternalHotKey,

		[ValidateSet("Enabled","Disabled")]
		[System.String]
		$PostF2Key,

		[ValidateSet("Enabled","Disabled")]
		[System.String]
		$PostF12Key,
		
		[ValidateSet("Enabled","Disabled")]
		[System.String]
		$PostHelpDeskKey,

		[ValidateSet("Enabled","Disabled")]
		[System.String]
		$RptKeyErr,

		[ValidateSet("0s","5s","10s")]
		[System.String]
		$ExtPostTime,

		[ValidateSet("Enabled","Disabled")]
		[System.String]
		$SignOfLifeIndication,

		[ValidateSet("Enabled","Disabled")]
		[System.String]
		$WyseP25Access
	)

    if (-not(CheckModuleLoaded)) {
        Write-Verbose -Message 'Required module DellBiosProvider does not exist. Exiting.'
        return $true
    }

    $DellPSDrive = get-psdrive -name Dellsmbios
    if ( !$DellPSDrive)
    {
        $Message = "Drive DellSmbios is not found. Exiting."
        Write-Verbose $Message
        Write-DellEventLog -Message $Message -EventID 3 -EntryType "Error"
        return $true
    }
    $attributes_desired = $PSBoundParameters
    $atts = $attributes_desired

    $pathToCategory = $DellPSDrive.Name + ':\' + $atts["Category"]
    
    Dir $pathToCategory -verbose

    $atts.Remove("Verbose") | out-null
    $atts.Remove("Category") | out-null
    $atts.Remove("Debug") | out-null
    $securePwd=$atts["SecurePassword"]
    $passwordSet=$atts["Password"]
    $atts.Remove("Password") | Out-Null
    $atts.Remove("SecurePassword") | Out-Null
    $pathToKey=$atts["PathToKey"]
	if(-Not [string]::IsNullOrEmpty($pathToKey))
	{  
		if(Test-Path $pathToKey)
		{
		$key=Get-Content $pathToKey
		}
		else
		{
		$key=""
		}
	}
    $atts.Remove("PathToKey") | Out-Null
    
    #foreach($a in Import-Csv((Get-DellBIOSEncryptionKey)))
    #{
   # $key+=$a
   # }
    $atts.Keys | foreach-object { 
                   # $atts[$_]
                    $path = $pathToCategory + '\' + $($_)
                    $value = $atts[$_]
		    if(-Not [string]::IsNullOrEmpty($securePwd))
		    {                
			$pasvar=ConvertTo-SecureString $securePwd.ToString() -Key $key
            Set-Item  -path $path -value $value -verbose -ErrorVariable ev -ErrorAction SilentlyContinue -PasswordSecure $pasvar
		    }

		    elseif(-Not [string]::IsNullOrEmpty($passwordSet))
		    {
			Set-Item  -path $path -value $value -verbose -ErrorVariable ev -ErrorAction SilentlyContinue -Password $passwordSet
		    }

		    else
		    {
			Set-Item  -path $path -value $value -verbose -ErrorVariable ev -ErrorAction SilentlyContinue
		    }
                    if ( $ev) { 
                        $cmdline = $ExecutionContext.InvokeCommand.ExpandString($ev.InvocationInfo.Line)
                        $Message = "An error occured in executing " + $cmdline + "`nError message: $($ev.ErrorDetails)"
                        Write-Verbose $Message
                        Write-DellEventLog -Message $Message -EventID 5 -EntryType "Error"
                    }
                    
                 }


}


function Test-TargetResource
{
	[CmdletBinding()]
	[OutputType([System.Boolean])]
	param
	(
		[parameter(Mandatory = $true)]
		[System.String]
		$Category,

		[ValidateSet("EnabledByFnKey","EnabledByNumlock")]
		[System.String]
		$Keypad,

		[ValidateSet("Enabled","Disabled")]
		[System.String]
		$Numlock,

		[ValidateSet("Minimal","Thorough","Auto")]
		[System.String]
		$Fastboot,

		[ValidateSet("Enabled","Disabled")]
		[System.String]
		$FnLock,
		
		[ValidateSet("Enabled","Disabled")]
		[System.String]
		$FullScreenLogo,

		[ValidateSet("Secondary","Standard")]
		[System.String]
		$FnLockMode,

		[System.String]
		$Password,

		[System.String]
		$SecurePassword,

		[System.String]
		$PathToKey,
		
		[ValidateSet("Enabled","Disabled")]
		[System.String]
		$SignOfLifeByKbdBacklight,
		
		[ValidateSet("Enabled","Disabled")]
		[System.String]
		$SignOfLifeByDisplay,
		
		[ValidateSet("Enabled","Disabled")]
		[System.String]
		$SignOfLifeByAudio,

		[ValidateSet("PromptWrnErr","ContWrn","ContWrnErr")]
		[System.String]
		$WarningsAndErr,

		[ValidateSet("Enabled","Disabled")]
		[System.String]
		$PowerWarn,

		[ValidateSet("SerialMouse","Ps2Mouse","Touchpad","SwitchToExternalPS2")]
		[System.String]
		$PntDevice,

		[ValidateSet("Enabled","Disabled")]
		[System.String]
		$ExternalHotKey,

		[ValidateSet("Enabled","Disabled")]
		[System.String]
		$PostF2Key,

		[ValidateSet("Enabled","Disabled")]
		[System.String]
		$PostF12Key,
		
		[ValidateSet("Enabled","Disabled")]
		[System.String]
		$PostHelpDeskKey,

		[ValidateSet("Enabled","Disabled")]
		[System.String]
		$RptKeyErr,

		[ValidateSet("0s","5s","10s")]
		[System.String]
		$ExtPostTime,

		[ValidateSet("Enabled","Disabled")]
		[System.String]
		$SignOfLifeIndication,

		[ValidateSet("Enabled","Disabled")]
		[System.String]
		$WyseP25Access
	)
    $Get = Get-TargetResource $PSBoundParameters['Category'] -verbose

    New-DellEventLog
 
    $PSBoundParameters.Remove("Verbose") | out-null
    $PSBoundParameters.Remove("Debug") | out-null
    $PSBoundParameters.Remove("Category") | out-null
    $PSBoundParameters.Remove("Password") | out-null
    $PSBoundParameters.Remove("SecurePassword") | out-null

    $attributes_desired = $PSBoundParameters

    $bool = $true

    foreach ($config_att in  $PSBoundParameters.GetEnumerator())
    {
        if ($Get.ContainsKey($config_att.Key)) {
            $currentvalue = $Get[$config_att.Key]
            $currentvalue_nospace = $currentvalue -replace " ", ""
            if ($config_att.Value -ne $currentvalue_nospace){
                $bool = $false
                $drift  = "`nCurrentValue: $currentvalue_nospace`nDesiredValue: $($config_att.value)"
                $message = "Configuration is drifted in category $Category for $($config_att.Key). $drift"
                write-verbose $message
                Write-DellEventLog -Message $message -EventID 4 -EntryType Warning
            
            }
            else {
                write-Debug "Configuration is same for $config_att."
            }
    }
    else
    {
        $message = "Unsupported attribute $($config_att)"
        Write-Verbose $message
    }
   }
   return $bool
}


Export-ModuleMember -Function *-TargetResource


# SIG # Begin signature block
# MIIqwQYJKoZIhvcNAQcCoIIqsjCCKq4CAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCA71kt+K8GRK59I
# KiQtdSh3TQlT5NQAXo7+PvuAe8wPjqCCElwwggXfMIIEx6ADAgECAhBOQOQ3VO3m
# jAAAAABR05R/MA0GCSqGSIb3DQEBCwUAMIG+MQswCQYDVQQGEwJVUzEWMBQGA1UE
# ChMNRW50cnVzdCwgSW5jLjEoMCYGA1UECxMfU2VlIHd3dy5lbnRydXN0Lm5ldC9s
# ZWdhbC10ZXJtczE5MDcGA1UECxMwKGMpIDIwMDkgRW50cnVzdCwgSW5jLiAtIGZv
# ciBhdXRob3JpemVkIHVzZSBvbmx5MTIwMAYDVQQDEylFbnRydXN0IFJvb3QgQ2Vy
# dGlmaWNhdGlvbiBBdXRob3JpdHkgLSBHMjAeFw0yMTA1MDcxNTQzNDVaFw0zMDEx
# MDcxNjEzNDVaMGkxCzAJBgNVBAYTAlVTMRYwFAYDVQQKDA1FbnRydXN0LCBJbmMu
# MUIwQAYDVQQDDDlFbnRydXN0IENvZGUgU2lnbmluZyBSb290IENlcnRpZmljYXRp
# b24gQXV0aG9yaXR5IC0gQ1NCUjEwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIK
# AoICAQCngY/3FEW2YkPy2K7TJV5IT1G/xX2fUBw10dZ+YSqUGW0nRqSmGl33VFFq
# gCLGqGZ1TVSDyV5oG6v2W2Swra0gvVTvRmttAudFrnX2joq5Mi6LuHccUk15iF+l
# OhjJUCyXJy2/2gB9Y3/vMuxGh2Pbmp/DWiE2e/mb1cqgbnIs/OHxnnBNCFYVb5Cr
# +0i6udfBgniFZS5/tcnA4hS3NxFBBuKK4Kj25X62eAUBw2DtTwdBLgoTSeOQm3/d
# vfqsv2RR0VybtPVc51z/O5uloBrXfQmywrf/bhy8yH3m6Sv8crMU6UpVEoScRCV1
# HfYq8E+lID1oJethl3wP5bY9867DwRG8G47M4EcwXkIAhnHjWKwGymUfe5SmS1dn
# DH5erXhnW1XjXuvH2OxMbobL89z4n4eqclgSD32m+PhCOTs8LOQyTUmM4OEAwjig
# nPqEPkHcblauxhpb9GdoBQHNG7+uh7ydU/Yu6LZr5JnexU+HWKjSZR7IH9Vybu5Z
# HFc7CXKd18q3kMbNe0WSkUIDTH0/yvKquMIOhvMQn0YupGaGaFpoGHApOBGAYGuK
# Q6NzbOOzazf/5p1nAZKG3y9I0ftQYNVc/iHTAUJj/u9wtBfAj6ju08FLXxLq/f0u
# DodEYOOp9MIYo+P9zgyEIg3zp3jak/PbOM+5LzPG/wc8Xr5F0wIDAQABo4IBKzCC
# AScwDgYDVR0PAQH/BAQDAgGGMBIGA1UdEwEB/wQIMAYBAf8CAQEwHQYDVR0lBBYw
# FAYIKwYBBQUHAwMGCCsGAQUFBwMIMDsGA1UdIAQ0MDIwMAYEVR0gADAoMCYGCCsG
# AQUFBwIBFhpodHRwOi8vd3d3LmVudHJ1c3QubmV0L3JwYTAzBggrBgEFBQcBAQQn
# MCUwIwYIKwYBBQUHMAGGF2h0dHA6Ly9vY3NwLmVudHJ1c3QubmV0MDAGA1UdHwQp
# MCcwJaAjoCGGH2h0dHA6Ly9jcmwuZW50cnVzdC5uZXQvZzJjYS5jcmwwHQYDVR0O
# BBYEFIK61j2Xzp/PceiSN6/9s7VpNVfPMB8GA1UdIwQYMBaAFGpyJnrQHu995ztp
# UdRsjZ+QEmarMA0GCSqGSIb3DQEBCwUAA4IBAQAfXkEEtoNwJFMsVXMdZTrA7LR7
# BJheWTgTCaRZlEJeUL9PbG4lIJCTWEAN9Rm0Yu4kXsIBWBUCHRAJb6jU+5J+Nzg+
# LxR9jx1DNmSzZhNfFMylcfdbIUvGl77clfxwfREc0yHd0CQ5KcX+Chqlz3t57jpv
# 3ty/6RHdFoMI0yyNf02oFHkvBWFSOOtg8xRofcuyiq3AlFzkJg4sit1Gw87kVlHF
# VuOFuE2bRXKLB/GK+0m4X9HyloFdaVIk8Qgj0tYjD+uL136LwZNr+vFie1jpUJuX
# bheIDeHGQ5jXgWG2hZ1H7LGerj8gO0Od2KIc4NR8CMKvdgb4YmZ6tvf6yK81MIIG
# ATCCA+mgAwIBAgIQKcjO4K8g4fYFFpiqGB6UiDANBgkqhkiG9w0BAQ0FADBPMQsw
# CQYDVQQGEwJVUzEWMBQGA1UEChMNRW50cnVzdCwgSW5jLjEoMCYGA1UEAxMfRW50
# cnVzdCBDb2RlIFNpZ25pbmcgQ0EgLSBPVkNTMjAeFw0yMzA5MjExNTMxMjZaFw0y
# NDA5MjExNTMxMjVaMH4xCzAJBgNVBAYTAlVTMQ4wDAYDVQQIEwVUZXhhczETMBEG
# A1UEBxMKUm91bmQgUm9jazERMA8GA1UEChMIRGVsbCBJbmMxJDAiBgNVBAsTG0RV
# UCBDbGllbnQgQ3JlYXRpb24gU2VydmljZTERMA8GA1UEAxMIRGVsbCBJbmMwggGi
# MA0GCSqGSIb3DQEBAQUAA4IBjwAwggGKAoIBgQCMaBhwV7jJkdmP+tXH06aqD1fq
# fge3rGr6hGz+V/ifIReHg8LxzLxOspMPj6t8IpXRcpkV3tt3fg793FCg4jfSWVmR
# inwVJOHD8bR6XUNfLbtS/1M/PsSQijNKdSbL1nDKcIF5JfeN6CgkdU9AateJGLKF
# Qc9YUgbNnnwlrHWjQmV78Cu4TDz7dOxjrwnRMTXe9wPL+38nwRZYOo97bBYmtTjW
# LGfZOfg3e9DypJykJ1kQqGUa9O5PLAfvQb+NOi8gSpn3+XkliY29xx0ocQQrGDG8
# +KzfjXjGArElKBwjVirQaLhpBeeaWuDNeKTcJOzYL9Sh9IzVNpuBPwiImin5Za7S
# KwyEPlPAsFgCduEsKCoWq67MPx0z7bGRPwp5Y03KZGJUDxQAG+PlI3jvjFZiZ6YB
# Xi4TStiisY6t0Ol5kpE2lKHp3Pt/9iam1x7/y0EiQtkMXTuep1qdc3Waa7s0jEDD
# 3/T4AknlkfhROxP85xaii32M9In0Tqr1hPm3pqsCAwEAAaOCASgwggEkMAwGA1Ud
# EwEB/wQCMAAwHQYDVR0OBBYEFBFKGdzeU/CRsp0sA1HLF7oe6ORSMB8GA1UdIwQY
# MBaAFO+funmwc/IlHnicA1KcG1OE3o3tMGcGCCsGAQUFBwEBBFswWTAjBggrBgEF
# BQcwAYYXaHR0cDovL29jc3AuZW50cnVzdC5uZXQwMgYIKwYBBQUHMAKGJmh0dHA6
# Ly9haWEuZW50cnVzdC5uZXQvb3ZjczItY2hhaW4ucDdjMDEGA1UdHwQqMCgwJqAk
# oCKGIGh0dHA6Ly9jcmwuZW50cnVzdC5uZXQvb3ZjczIuY3JsMA4GA1UdDwEB/wQE
# AwIHgDATBgNVHSUEDDAKBggrBgEFBQcDAzATBgNVHSAEDDAKMAgGBmeBDAEEATAN
# BgkqhkiG9w0BAQ0FAAOCAgEAGtZRY5WmdTQbQGP/Nx77+u6udEUQn40GDjXPfT4j
# nVlhJ99N35giv1mWstRXxOqY7YauotNcUNzep1d8oV5/YKc7+x0s/ZwuNQmLtVyb
# VSrDy7DJiYNle/4am6GDefIUMMWgr8BGY8n/LdDVfL9Gir72V+HOe2N4cVnti0Ti
# U9/1ebEdhKd/a0awP+mh8EZG7OJ41A1JkPc4rjsh3yfQi5AQ4P1RF1hSgudkZpQI
# 8051WnnwjStKEWA2uiX3x2z63TvrPtdaJoYbtIniUx9ZVg3373sV8StFwPcyPzqX
# 9Eod7Goj4D+Vg3bB73jjG+miuykSjxNHVnhNB7EnCVffnsD5hJHRXGRCZvof59id
# NhpkuF0G4ZIYDrAF06HvJ4kxyGZCiNi6oJxfyndhG4FsCPI4XiE0n1N25lx1GeJZ
# tgRH7okPBMOu3rYTQDH2+g85yNBwap18EC7XDTyi7H/Ih616pG9ca9Xv4MsptRU9
# 6UXqPemiXG9TbuEsBWgu6YYx0qBMlIT+bqDbghkpeXrF/zRjDBAD9p38VHnqay3B
# r4RTbap/gUMQzgD2P2f6axjAg3yZaXab1qtI7VZptyXmVK7nRPwXCZmTR6SnxCaS
# 7gD2GtIZiCiztpBq6zJEQhS39BQoXVV0bQ7k+m1ZX2VW0z8Ld54PZlbc8vnP1YcA
# iyowggZwMIIEWKADAgECAhBx71V0rzVUw1osafZvS2vNMA0GCSqGSIb3DQEBDQUA
# MGkxCzAJBgNVBAYTAlVTMRYwFAYDVQQKDA1FbnRydXN0LCBJbmMuMUIwQAYDVQQD
# DDlFbnRydXN0IENvZGUgU2lnbmluZyBSb290IENlcnRpZmljYXRpb24gQXV0aG9y
# aXR5IC0gQ1NCUjEwHhcNMjEwNTA3MTkyMDQ1WhcNNDAxMjI5MjM1OTAwWjBPMQsw
# CQYDVQQGEwJVUzEWMBQGA1UEChMNRW50cnVzdCwgSW5jLjEoMCYGA1UEAxMfRW50
# cnVzdCBDb2RlIFNpZ25pbmcgQ0EgLSBPVkNTMjCCAiIwDQYJKoZIhvcNAQEBBQAD
# ggIPADCCAgoCggIBAJ6ZdhcanlYXCGMsk02DYYQzNAK22WKg3sIOuSBMyFedD91U
# Ww0M1gHdL0jhkQnh28gVBIK2e/DY1jA7GXFw+6iml/YpXaQMqfRTPlfbDE5u/Hbb
# XyTpql9D45PnDs/KJbzETDALWg/mBvTlbgyZZlhPg2HCc3xcIm8BRcUP90BPZEvQ
# FwqpDh4CL6GPTPJnUNs+5J/CTz906zGk0JTQmbwwkglqyyTNoth2UtBOdZhPZFrS
# XoP0WMBdanXE2D9kOosUDdh24eq5a+cRcEkROGMTbvHG+r0QRTUH5nYV0HUWqsJD
# V/6r/mNzRiKguPPkx3BGCfmpN0Gas0tsH3Byowf2NZJ0EWRu+QLVwJKV8ZdZfg3u
# oiXycVW4m42/ze6u3fsM564yTlCNod/Rc7/Bzn912qu/0K2COMXniO2ibTqGEbfX
# sOGoizsMQReaX+RbmMidAJ/3c9LD6Z8Fh3khg9YL7dHMCJ/g8cXJWLpTX9SHsYtZ
# qNJezWnQPvrEOQmvtLXt5zz6IofWc/kXlWrDHPVVeF/U+gvAWz+MeBUOWkw6buUm
# mNAnzCDfwIY7eo1lRn7ZYV6p9K4+1PyvRcc6s4UESovICV2zewIoWeOGfYCiWEBm
# YuA4VYOrnylBJrq76dhk+La7KHPNFUrXnnPjZkyxUZ2BI4vIhneytiw3InAhAgMB
# AAGjggEsMIIBKDASBgNVHRMBAf8ECDAGAQH/AgEAMB0GA1UdDgQWBBTvn7p5sHPy
# JR54nANSnBtThN6N7TAfBgNVHSMEGDAWgBSCutY9l86fz3Hokjev/bO1aTVXzzAz
# BggrBgEFBQcBAQQnMCUwIwYIKwYBBQUHMAGGF2h0dHA6Ly9vY3NwLmVudHJ1c3Qu
# bmV0MDEGA1UdHwQqMCgwJqAkoCKGIGh0dHA6Ly9jcmwuZW50cnVzdC5uZXQvY3Ni
# cjEuY3JsMA4GA1UdDwEB/wQEAwIBhjATBgNVHSUEDDAKBggrBgEFBQcDAzBFBgNV
# HSAEPjA8MDAGBFUdIAAwKDAmBggrBgEFBQcCARYaaHR0cDovL3d3dy5lbnRydXN0
# Lm5ldC9ycGEwCAYGZ4EMAQQBMA0GCSqGSIb3DQEBDQUAA4ICAQBe84aZNcF57vAQ
# r9eSQ9KF0FvgmKDgcVHJFMtQmmAOsAQmSbHP6bqbCKHaQ13UbyOiufhAx0f+TQEL
# SJA/yNxqtD5TNSi+QEpHhWoed0DMgH9htDxPeajmo6agfkSGcb8SG5WBcvcNpdDe
# Z5/Gorjxavn8/nRmxmTmeT1qA2FOSx/MIGLLAhjsY+1+cT+WugteaCJn7B/A0gUW
# ZrGypOr8xZWjjRKl9Y3vGyDNmffnMvNZcR/dlOZ55VIjEFYq/Fk4v795JZJqx/2r
# Z3dxsQR9Na0UwT6o/CMXVggYfNd6ImuRasw1RW1PO51DnQW4nfP8NCFcBBgyVzg0
# wcqDI0amiCMhxn4UgKux77sLrAk/7lORMbPiVESqtX0wPCwjnOg/o1jqQAgXoyBf
# esAM26r/AxYDDXRkIpqUXjA1dhP10+Hj4AfK2epFiEacVNUQ4vMyCUC251wXMv7M
# r+ttz2A8dfPuXGBAVRu1Wa9yI2hNnHQEDBDJr1Bbpw1mD5blmpXgIKIa0LDuOEme
# KmeekZZsmNvEEG1gfB5uSOe2fq8zBxJx772VO76pg9RCfbenNNdfhpG1r1ZY2lV9
# F73bvM1kQRWNMVEGT7Qusos9nPNN41gDVMysiPhSPE5LRgklGf8V56eYRi59uurj
# 43z/+bkZlb52uQ15sgJRGkrIn4jCQzGCF7swghe3AgEBMGMwTzELMAkGA1UEBhMC
# VVMxFjAUBgNVBAoTDUVudHJ1c3QsIEluYy4xKDAmBgNVBAMTH0VudHJ1c3QgQ29k
# ZSBTaWduaW5nIENBIC0gT1ZDUzICECnIzuCvIOH2BRaYqhgelIgwDQYJYIZIAWUD
# BAIBBQCgfDAQBgorBgEEAYI3AgEMMQIwADAZBgkqhkiG9w0BCQMxDAYKKwYBBAGC
# NwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAvBgkqhkiG9w0BCQQx
# IgQgcrEshG+0dfUXZl7YJ2JmshxGDbPhv7npgfxrs6KgQw4wDQYJKoZIhvcNAQEB
# BQAEggGATVsIldGQI2DPBTWU5rk5WpEWKm3J/bppW9IKVTWKPUbX+US+58Qh7BE1
# OtqkZCJLLaedfwY0ONmQ4PanWsei+aFYBZ8yF1xKywBuetwuolInZdF4fESbnWIf
# 1f5k3BpLzGbMS8dt6te4pvkDJNDPcHK0tqdpiLwITx1W7MBkCjDjRPXlZqt0oDoe
# fzGTFQ8wW7MY0HGL1QVGGM7cYPBztZa8koaMtwoPWxpNx+MbQasQgcpt8H52NYPG
# VgBIvEF7Kl2YUirNc6fZkVgUOps4Ah3fpeEqP3MDrlJtpHREWhslFhWaIFK06udC
# DrzlD+ifJB2zQanymCdHNEc15hM7qtmLtSo/PEubDfn8xrXYuIbsXHTO0UKwqOBf
# 22w9WSvHbY8T+G7Em68ImnwMC5kw2vUwWvLsC6L7W0idKwLzCgh7C4BnNM87ss/T
# argOv2XXMlNxw6+v2Q5hXrPqq0SIls31VLKWnkFrP6PNTU9Li6qI69BjiyN2dQrR
# j/4iIVaNoYIVKzCCFScGCisGAQQBgjcDAwExghUXMIIVEwYJKoZIhvcNAQcCoIIV
# BDCCFQACAQMxDTALBglghkgBZQMEAgEwgfMGCyqGSIb3DQEJEAEEoIHjBIHgMIHd
# AgEBBgpghkgBhvpsCgMFMDEwDQYJYIZIAWUDBAIBBQAEIBU1oMds0TeI8Lh+ISxx
# OM7rFPbUnGjuYARH624RvtLDAgh8EEAVzC1D5hgPMjAyNDA0MTkxMDA1NTlaMAMC
# AQGgeaR3MHUxCzAJBgNVBAYTAkNBMRAwDgYDVQQIEwdPbnRhcmlvMQ8wDQYDVQQH
# EwZPdHRhd2ExFjAUBgNVBAoTDUVudHJ1c3QsIEluYy4xKzApBgNVBAMTIkVudHJ1
# c3QgVGltZXN0YW1wIEF1dGhvcml0eSAtIFRTQTGggg9YMIIEKjCCAxKgAwIBAgIE
# OGPe+DANBgkqhkiG9w0BAQUFADCBtDEUMBIGA1UEChMLRW50cnVzdC5uZXQxQDA+
# BgNVBAsUN3d3dy5lbnRydXN0Lm5ldC9DUFNfMjA0OCBpbmNvcnAuIGJ5IHJlZi4g
# KGxpbWl0cyBsaWFiLikxJTAjBgNVBAsTHChjKSAxOTk5IEVudHJ1c3QubmV0IExp
# bWl0ZWQxMzAxBgNVBAMTKkVudHJ1c3QubmV0IENlcnRpZmljYXRpb24gQXV0aG9y
# aXR5ICgyMDQ4KTAeFw05OTEyMjQxNzUwNTFaFw0yOTA3MjQxNDE1MTJaMIG0MRQw
# EgYDVQQKEwtFbnRydXN0Lm5ldDFAMD4GA1UECxQ3d3d3LmVudHJ1c3QubmV0L0NQ
# U18yMDQ4IGluY29ycC4gYnkgcmVmLiAobGltaXRzIGxpYWIuKTElMCMGA1UECxMc
# KGMpIDE5OTkgRW50cnVzdC5uZXQgTGltaXRlZDEzMDEGA1UEAxMqRW50cnVzdC5u
# ZXQgQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkgKDIwNDgpMIIBIjANBgkqhkiG9w0B
# AQEFAAOCAQ8AMIIBCgKCAQEArU1LqRKGsuqjIAcVFmQqK0vRvwtKTY7tgHalZ7d4
# QMBzQshowNtTK91euHaYNZOLGp18EzoOH1u3Hs/lJBQesYGpjX24zGtLA/ECDNyr
# pUAkAH90lKGdCCmziAv1h3edVc3kw37XamSrhRSGlVuXMlBvPci6Zgzj/L24ScF2
# iUkZ/cCovYmjZy/Gn7xxGWC4LeksyZB2ZnuU4q941mVTXTzWnLLPKQP5L6RQstRI
# zgUyVYr9smRMDuSYB3Xbf9+5CFVghTAp+XtIpGmG4zU/HoZdenoVve8AjhUiVBcA
# kCaTvA5JaJG/+EfTnZVCwQ5N328mz8MYIWJmQ3DW1cAH4QIDAQABo0IwQDAOBgNV
# HQ8BAf8EBAMCAQYwDwYDVR0TAQH/BAUwAwEB/zAdBgNVHQ4EFgQUVeSB0RGAvtiJ
# uQijMfmhJAkWuXAwDQYJKoZIhvcNAQEFBQADggEBADubj1abMOdTmXx6eadNl9cZ
# lZD7Bh/KM3xGY4+WZiT6QBshJ8rmcnPyT/4xmf3IDExoU8aAghOY+rat2l098c5u
# 9hURlIIM7j+VrxGrD9cv3h8Dj1csHsm7mhpElesYT6YfzX1XEC+bBAlahLVu2B06
# 4dae0Wx5XnkcFMXj0EyTO2U87d89vqbllRrDtRnDvV5bu/8j72gZyxKTJ1wDLW8w
# 0B62GqzeWvfRqqgnpv55gcR5mTNXuhKwqeBCbJPKVt7+bYQLCIt+jerXmCHG8+c8
# eS9enNFMFY3h7CI3zJpDC5fcgJCNs2ebb0gIFVbPv/ErfF6adulZkMV8gzURZVEw
# ggUTMIID+6ADAgECAgxY2hP/AAAAAFHODfcwDQYJKoZIhvcNAQELBQAwgbQxFDAS
# BgNVBAoTC0VudHJ1c3QubmV0MUAwPgYDVQQLFDd3d3cuZW50cnVzdC5uZXQvQ1BT
# XzIwNDggaW5jb3JwLiBieSByZWYuIChsaW1pdHMgbGlhYi4pMSUwIwYDVQQLExwo
# YykgMTk5OSBFbnRydXN0Lm5ldCBMaW1pdGVkMTMwMQYDVQQDEypFbnRydXN0Lm5l
# dCBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eSAoMjA0OCkwHhcNMTUwNzIyMTkwMjU0
# WhcNMjkwNjIyMTkzMjU0WjCBsjELMAkGA1UEBhMCVVMxFjAUBgNVBAoTDUVudHJ1
# c3QsIEluYy4xKDAmBgNVBAsTH1NlZSB3d3cuZW50cnVzdC5uZXQvbGVnYWwtdGVy
# bXMxOTA3BgNVBAsTMChjKSAyMDE1IEVudHJ1c3QsIEluYy4gLSBmb3IgYXV0aG9y
# aXplZCB1c2Ugb25seTEmMCQGA1UEAxMdRW50cnVzdCBUaW1lc3RhbXBpbmcgQ0Eg
# LSBUUzEwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDZI+YUpOh8S4Vx
# WPv4geZyi11Gw4gAHzjQiuHWblYw5a/aZFB9whM5+71mtNqE+4PQKB/LduhgUGmb
# 885PE+LBPsHfEssyo/heRCIOzDrpjUm5YHTI3lQ9QV5DXyhGqaa3yhArIrxbTVuM
# F2UShv0sd9XFoIzKwoPgR1d853CuYkUnMRgK1MCkGFVS92DGBEuz3WgybhAfNBG4
# Enhk8e6p4PfjsSKPNFply4r04UVQdN+Tl6Y05tBMO583SVKnU06fLmdc7Zb8pb90
# UYjjqo692bEvX1AwFvRRYCJrmcv/4VQ7uftEOKUIOSObaUf6PMTQ56rfRrLs8ooZ
# rCmyOJV1AgMBAAGjggEjMIIBHzASBgNVHRMBAf8ECDAGAQH/AgEAMA4GA1UdDwEB
# /wQEAwIBBjA7BgNVHSAENDAyMDAGBFUdIAAwKDAmBggrBgEFBQcCARYaaHR0cDov
# L3d3dy5lbnRydXN0Lm5ldC9ycGEwMwYIKwYBBQUHAQEEJzAlMCMGCCsGAQUFBzAB
# hhdodHRwOi8vb2NzcC5lbnRydXN0Lm5ldDAyBgNVHR8EKzApMCegJaAjhiFodHRw
# Oi8vY3JsLmVudHJ1c3QubmV0LzIwNDhjYS5jcmwwEwYDVR0lBAwwCgYIKwYBBQUH
# AwgwHQYDVR0OBBYEFMPCcdJ712gFrjs5mzQlDGIDx1doMB8GA1UdIwQYMBaAFFXk
# gdERgL7YibkIozH5oSQJFrlwMA0GCSqGSIb3DQEBCwUAA4IBAQAdJOeadFuqcPyx
# DjFF1ywAf2Y6K6CaNKqsY22J+Z/fDXf9JCP8T5y3b4/z9B+2wf3WHMSMiGbBY426
# V3fTuBoeyFGtzGA2GodqKOoRZd7MPCyMdLfoUEPTzCjoFWwRKp8UlSnJBVe1Zzbo
# PKmD70HBIRbTfvctEUdmdmCCEmmMdlVzD98vS13pbCP4B/a1fdZpRZxYfWEu/HhL
# Q06JkUZELKBTqEWh9hZYu5ET8kvF3wvA564per1Fs+dwMOc0jut69tO10d5rE5lG
# s4vSTZN1tfFvv9wAKMIlv7zno2U07D8NHZeM+qqIIqQYNdsFjnbjEMgpj2PQrqwY
# 2drEn1ESMIIGDzCCBPegAwIBAgIQB9cTU9olYbRh6ZBHikzOBDANBgkqhkiG9w0B
# AQsFADCBsjELMAkGA1UEBhMCVVMxFjAUBgNVBAoTDUVudHJ1c3QsIEluYy4xKDAm
# BgNVBAsTH1NlZSB3d3cuZW50cnVzdC5uZXQvbGVnYWwtdGVybXMxOTA3BgNVBAsT
# MChjKSAyMDE1IEVudHJ1c3QsIEluYy4gLSBmb3IgYXV0aG9yaXplZCB1c2Ugb25s
# eTEmMCQGA1UEAxMdRW50cnVzdCBUaW1lc3RhbXBpbmcgQ0EgLSBUUzEwHhcNMjQw
# MTE5MTY0NjI4WhcNMjkwNjAxMDAwMDAwWjB1MQswCQYDVQQGEwJDQTEQMA4GA1UE
# CBMHT250YXJpbzEPMA0GA1UEBxMGT3R0YXdhMRYwFAYDVQQKEw1FbnRydXN0LCBJ
# bmMuMSswKQYDVQQDEyJFbnRydXN0IFRpbWVzdGFtcCBBdXRob3JpdHkgLSBUU0Ex
# MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAx5I4QTn/oD9fTU2KlzHj
# m4fDeAVpNgtSs6qDXbDSvX6+g6BfXp6X89s1F6n52xVifMr2xck0FeIRpZKxLuBp
# VF0OK75VxgGMhWOySS01X+VOQ8RxC6S0HjRN/0XI/k/hMOjpZWxrZdO+1Cxo0K0E
# m2q50FT7NQCQMcbYaGpdr+p+0PmdE+/OnWNkQnIHhfsGMYvjnQum1TLbUqVODDzB
# wJrRfwJ3YxPN8z08HgJLNobgBLR4d+SbL+GJKt6CXevkGtyNunukn4+ObHXrA+CA
# BL+xCRz6YXqzm4G3C8kTCnjtCPbMpl9CRxI6R3h2/rzamT9k6zdeKt9S4pmw/e+E
# ypE6orCnsbZWHD9E+H6R73imJP7eKR749fdRf7Z4LYe0vQC5xh7g6OET7u5f117u
# pHx1YM6hNZBYwqu1SEN76cd3iYmLxqGMaZfPbnpD/vRf+2PlJOrf4BCQpxKQzBut
# CIrRjYUgom6hixYnlTHTz24DKZ9EwicIrLf0iU035CWJWlMsUw2CFHPG7MWw2YfY
# mxLuJjpfly9wyTB4oVpKbdJISg9Van72W+KHX9oRG3e+Gl73SAqYcQx9riqBfbKe
# kWAO0dlqMBKK5JrspktvhQZJEA6FSD8u5hTPWuNPOCqv1zEAvCyWlZKtc896HFHL
# /i3pwC5YDgoVZcuIezIbYA0CAwEAAaOCAVswggFXMAwGA1UdEwEB/wQCMAAwHQYD
# VR0OBBYEFENoH2+fItD4Xwn3/LjlI8aOB0KSMB8GA1UdIwQYMBaAFMPCcdJ712gF
# rjs5mzQlDGIDx1doMGgGCCsGAQUFBwEBBFwwWjAjBggrBgEFBQcwAYYXaHR0cDov
# L29jc3AuZW50cnVzdC5uZXQwMwYIKwYBBQUHMAKGJ2h0dHA6Ly9haWEuZW50cnVz
# dC5uZXQvdHMxLWNoYWluMjU2LmNlcjAxBgNVHR8EKjAoMCagJKAihiBodHRwOi8v
# Y3JsLmVudHJ1c3QubmV0L3RzMWNhLmNybDAOBgNVHQ8BAf8EBAMCB4AwFgYDVR0l
# AQH/BAwwCgYIKwYBBQUHAwgwQgYDVR0gBDswOTA3BgpghkgBhvpsCgEHMCkwJwYI
# KwYBBQUHAgEWG2h0dHBzOi8vd3d3LmVudHJ1c3QubmV0L3JwYTANBgkqhkiG9w0B
# AQsFAAOCAQEAvrDc/bz6Zqf8Ix3z2Vdi9CTfHS/5WMvKzAx9z26H9W6CWive41/G
# zhrkCK+OBAEe/wL4BVO4qGKFe5mrRXvZqrEXg9EpfpMh6DaIQiE4+/sNgcnDiozK
# Kl5mr/mc9I18Evt6bTqKsAD3O3ClD7u1U6nhxikm6twSSi9dWgS4quOHC33Ingb+
# aWZLjqf0vjDJpeKQoaiBDT5HIZJQXTLk8lbPqZQhuzDCdxgRmiau8eI+L/w/iTM3
# XZTn3RrF5cxmbPoAzpbigO34LKfFaBNpfARErQjV+avJrRdm1S8LV/Cbz1weqw0n
# Rmn+qLcFJY7gshUzSl+6nIvQKAk8tYWy4TGCBJgwggSUAgEBMIHHMIGyMQswCQYD
# VQQGEwJVUzEWMBQGA1UEChMNRW50cnVzdCwgSW5jLjEoMCYGA1UECxMfU2VlIHd3
# dy5lbnRydXN0Lm5ldC9sZWdhbC10ZXJtczE5MDcGA1UECxMwKGMpIDIwMTUgRW50
# cnVzdCwgSW5jLiAtIGZvciBhdXRob3JpemVkIHVzZSBvbmx5MSYwJAYDVQQDEx1F
# bnRydXN0IFRpbWVzdGFtcGluZyBDQSAtIFRTMQIQB9cTU9olYbRh6ZBHikzOBDAL
# BglghkgBZQMEAgGgggGlMBoGCSqGSIb3DQEJAzENBgsqhkiG9w0BCRABBDAcBgkq
# hkiG9w0BCQUxDxcNMjQwNDE5MTAwNTU5WjApBgkqhkiG9w0BCTQxHDAaMAsGCWCG
# SAFlAwQCAaELBgkqhkiG9w0BAQswLwYJKoZIhvcNAQkEMSIEIJoyws0acoMeVAN6
# b/20GWH26+nu9V++uB/y9MzgQVDsMIIBCwYLKoZIhvcNAQkQAi8xgfswgfgwgfUw
# gfIEIChJ9zEY10FFBWFzzT7sy71TS14O8PoGFo2w4nNJA+6PMIHNMIG4pIG1MIGy
# MQswCQYDVQQGEwJVUzEWMBQGA1UEChMNRW50cnVzdCwgSW5jLjEoMCYGA1UECxMf
# U2VlIHd3dy5lbnRydXN0Lm5ldC9sZWdhbC10ZXJtczE5MDcGA1UECxMwKGMpIDIw
# MTUgRW50cnVzdCwgSW5jLiAtIGZvciBhdXRob3JpemVkIHVzZSBvbmx5MSYwJAYD
# VQQDEx1FbnRydXN0IFRpbWVzdGFtcGluZyBDQSAtIFRTMQIQB9cTU9olYbRh6ZBH
# ikzOBDALBgkqhkiG9w0BAQsEggIAMpFGVpH7X2QHq7u7yLi1pqezQ4ry5XsDPnsq
# 6oOqJcwCicraGLv/DlMo/CwrgA0apE0OFZNSEVSfunJl5uWMOFqP/S+8FcGzsnts
# 0CgdJKWp3TgfwRk4HmRxHukSVZHIXKYMzcNgX5aLM2a9auRRQdlhGNehRGZ4ZAkq
# hrUZCcVK4iIrZQZ4NqUbdqDlvQ7eeYSxoI6dJL6xhVxlUZSa7FYp11HS4ikt6P7l
# ijL19mvWqiYVtDEhxfwgnA4uRvNYh9rwH6yAPl4pVANg988YFuCUz21VBisRfsl7
# BC5UgDwnmcwKLyUiqAu3CiDbDtgqqgQm39Dy7bU5EdAv7iz5/XIDEPdJpnysag5l
# BvZ5N6AcvhGfvhqUZF3N8nvG/kaPg3XAviWYAGKeM/yYbdku9omscIkzdXlB6+gA
# H6fd2ZU0fv1gnSfj3dVxxD6GzI3vqx/SQ0Lu1dbRjtLxKwRaH6YCB1r5Uq6oMb3x
# 5GTxsx9IFJq+d5q7umrWqAHwBvc0CYdWQtta50CWpcpx5RdvsxmxqCDEyvzEXBjS
# /RmRDGgyRJVThwYFevb0tNRBAEbtHl6FpTWS8UdrOxjleVYdiP47zXjOg3VTM7Gb
# bSB9yx+dLuqrCnw248lhGxjHk7TFqXdNr8jSWZ+qa5voH6WD7oKvKbmgj6VBtdSn
# wom94X8=
# SIG # End signature block
