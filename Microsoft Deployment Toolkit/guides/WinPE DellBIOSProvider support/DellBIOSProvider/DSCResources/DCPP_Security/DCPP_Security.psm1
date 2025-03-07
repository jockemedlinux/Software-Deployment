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
		MultiCoreSupport = [System.String]
		IntelSpeedStep = [System.String]
		CStates = [System.String]
		IntelTurboBoost = [System.String]
		HyperThreadControl = [System.String]
		Password = [System.String]
		SecurePassword = [System.String]
		PathToKey = [System.String]
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

		[ValidateSet("RebootBypass","Disabled","ResumeBypass","RebootandResumeBypass")]
		[System.String]
		$PasswordBypass,

		[ValidateSet("Enabled","Disabled")]
		[System.String]
		$PasswordLock,

		[ValidateSet("Enabled","Disabled")]
		[System.String]
		$CpuXdSupport,
		
		[ValidateSet("Enabled","Disabled")]
		[System.String]
		$CapsuleFirmwareUpdate,

		[ValidateSet("Enabled","Disabled")]
		[System.String]
		$StrongPassword,

		[ValidateSet("Enabled","Disabled","OnetimeEnable")]
		[System.String]
		$OromKeyboardAccess,
		
		[ValidateSet("Enabled","Disabled","SilentEnable")]
		[System.String]
		$ChasIntrusion,

		[ValidateSet("DoorOpen","DoorClosed","Tripped","TripReset")]
		[System.String]
		$ChassisIntrusionStatus,

		[ValidateSet("Enabled","Disabled")]
		[System.String]
		$AdminSetupLockout,
		
		[ValidateSet("Enabled","Disabled")]
		[System.String]
		$HddProtection,
		
		[ValidateSet("Enabled","Disabled")]
		[System.String]
		$IntlPlatformTrust,
		
		[ValidateSet("Enabled","Disabled")]
		[System.String]
		$WirelessSwitchChanges,

		[ValidateSet("Enabled","Disabled")]
		[System.String]
		$GeneralPurposeEncryption,

		[ValidateSet("Enabled","Disabled")]
		[System.String]
		$MasterPasswordLockout,
		
		[ValidateSet("Enabled","Disabled")]
		[System.String]
		$BlockSid,
		
		[ValidateSet("Enabled","Disabled")]
		[System.String]
		$PpiBypassForBlockSid,
		
		[ValidateSet("Enabled","Disabled")]
		[System.String]
		$SmmSecurityMitigation,

		[System.String]
		$Password,

		[System.String]
		$SecurePassword,

		[System.String]
		$PathToKey
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

		[ValidateSet("RebootBypass","Disabled","ResumeBypass","RebootandResumeBypass")]
		[System.String]
		$PasswordBypass,

		[ValidateSet("Enabled","Disabled")]
		[System.String]
		$PasswordLock,

		[ValidateSet("Enabled","Disabled")]
		[System.String]
		$CpuXdSupport,
		
		[ValidateSet("Enabled","Disabled")]
		[System.String]
		$CapsuleFirmwareUpdate,

		[ValidateSet("Enabled","Disabled")]
		[System.String]
		$StrongPassword,

		[ValidateSet("Enabled","Disabled","OnetimeEnable")]
		[System.String]
		$OromKeyboardAccess,
		
		[ValidateSet("Enabled","Disabled","SilentEnable")]
		[System.String]
		$ChasIntrusion,

		[ValidateSet("DoorOpen","DoorClosed","Tripped","TripReset")]
		[System.String]
		$ChassisIntrusionStatus,

		[ValidateSet("Enabled","Disabled")]
		[System.String]
		$AdminSetupLockout,
		
		[ValidateSet("Enabled","Disabled")]
		[System.String]
		$HddProtection,
		
		[ValidateSet("Enabled","Disabled")]
		[System.String]
		$IntlPlatformTrust,
		
		[ValidateSet("Enabled","Disabled")]
		[System.String]
		$WirelessSwitchChanges,

		[ValidateSet("Enabled","Disabled")]
		[System.String]
		$GeneralPurposeEncryption,

		[ValidateSet("Enabled","Disabled")]
		[System.String]
		$MasterPasswordLockout,
		
		[ValidateSet("Enabled","Disabled")]
		[System.String]
		$BlockSid,
		
		[ValidateSet("Enabled","Disabled")]
		[System.String]
		$PpiBypassForBlockSid,
		
		[ValidateSet("Enabled","Disabled")]
		[System.String]
		$SmmSecurityMitigation,

		[System.String]
		$Password,

		[System.String]
		$SecurePassword,

		[System.String]
		$PathToKey
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
# MIIqwgYJKoZIhvcNAQcCoIIqszCCKq8CAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCDPuR4XPRfNhUqJ
# MOfS0ybwaP+BlsEjCp6SytM9lsa5TKCCElwwggXfMIIEx6ADAgECAhBOQOQ3VO3m
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
# 43z/+bkZlb52uQ15sgJRGkrIn4jCQzGCF7wwghe4AgEBMGMwTzELMAkGA1UEBhMC
# VVMxFjAUBgNVBAoTDUVudHJ1c3QsIEluYy4xKDAmBgNVBAMTH0VudHJ1c3QgQ29k
# ZSBTaWduaW5nIENBIC0gT1ZDUzICECnIzuCvIOH2BRaYqhgelIgwDQYJYIZIAWUD
# BAIBBQCgfDAQBgorBgEEAYI3AgEMMQIwADAZBgkqhkiG9w0BCQMxDAYKKwYBBAGC
# NwIBBDAcBgorBgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAvBgkqhkiG9w0BCQQx
# IgQgNk78MN3bpS5YAWFlbYY8wTLWTOqi2Jgjl2dczY01Se4wDQYJKoZIhvcNAQEB
# BQAEggGAeheZkqEwqnbtEyIc2uK6T9tTFOieC7RgaPfkBu67jjfF36GxflfhtGKT
# f9s494fR5cS1Klnhv1fit+rTwo5d5F4xVxDR1e07zJbF6/F3AFmBeUID4hnLqVT/
# XOw77fCeGQYxBu8FZrlco/qjq3cmWyZARQyAMAgMXVdKzUvE7rz9vKna8Tk3+Kqa
# AMG/S/nwSNgjOfDhBE3atBSadtClvATgl80DtlBa95Heg5hcm/X2HM3qARPwNupu
# JIwpxRpqGNDR7GGkZ/gkV+Qf04yOxiUbMujYpp/Tr2rx9Ckd88NlIpjTdHRBvon0
# IyzOpCkCasPta3C1+c1QqDVFg30CvzHYH4LiR3SnSo/sMdl8UyFvQ6mGQtD7SZlp
# FuILbRW0N2k1mIVG6HjSy/wHDVZwCM5bk2juMynpdJo/4r1adoD/J5485vo4pfEm
# bD0sYs/uVeZhPtFRzeNrlq+sst726NPQG4NU0WYjRuVulYc9PEjh3js7WbmAB2eo
# k3OaOPdVoYIVLDCCFSgGCisGAQQBgjcDAwExghUYMIIVFAYJKoZIhvcNAQcCoIIV
# BTCCFQECAQMxDTALBglghkgBZQMEAgEwgfQGCyqGSIb3DQEJEAEEoIHkBIHhMIHe
# AgEBBgpghkgBhvpsCgMFMDEwDQYJYIZIAWUDBAIBBQAEIM7vrVrYguNvQ4hYFgj1
# l25NlbYnktzZ4xG6FOC/0eaoAgkA9htFltHegI4YDzIwMjQwNDE5MTAwODA2WjAD
# AgEBoHmkdzB1MQswCQYDVQQGEwJDQTEQMA4GA1UECBMHT250YXJpbzEPMA0GA1UE
# BxMGT3R0YXdhMRYwFAYDVQQKEw1FbnRydXN0LCBJbmMuMSswKQYDVQQDEyJFbnRy
# dXN0IFRpbWVzdGFtcCBBdXRob3JpdHkgLSBUU0ExoIIPWDCCBCowggMSoAMCAQIC
# BDhj3vgwDQYJKoZIhvcNAQEFBQAwgbQxFDASBgNVBAoTC0VudHJ1c3QubmV0MUAw
# PgYDVQQLFDd3d3cuZW50cnVzdC5uZXQvQ1BTXzIwNDggaW5jb3JwLiBieSByZWYu
# IChsaW1pdHMgbGlhYi4pMSUwIwYDVQQLExwoYykgMTk5OSBFbnRydXN0Lm5ldCBM
# aW1pdGVkMTMwMQYDVQQDEypFbnRydXN0Lm5ldCBDZXJ0aWZpY2F0aW9uIEF1dGhv
# cml0eSAoMjA0OCkwHhcNOTkxMjI0MTc1MDUxWhcNMjkwNzI0MTQxNTEyWjCBtDEU
# MBIGA1UEChMLRW50cnVzdC5uZXQxQDA+BgNVBAsUN3d3dy5lbnRydXN0Lm5ldC9D
# UFNfMjA0OCBpbmNvcnAuIGJ5IHJlZi4gKGxpbWl0cyBsaWFiLikxJTAjBgNVBAsT
# HChjKSAxOTk5IEVudHJ1c3QubmV0IExpbWl0ZWQxMzAxBgNVBAMTKkVudHJ1c3Qu
# bmV0IENlcnRpZmljYXRpb24gQXV0aG9yaXR5ICgyMDQ4KTCCASIwDQYJKoZIhvcN
# AQEBBQADggEPADCCAQoCggEBAK1NS6kShrLqoyAHFRZkKitL0b8LSk2O7YB2pWe3
# eEDAc0LIaMDbUyvdXrh2mDWTixqdfBM6Dh9btx7P5SQUHrGBqY19uMxrSwPxAgzc
# q6VAJAB/dJShnQgps4gL9Yd3nVXN5MN+12pkq4UUhpVblzJQbz3IumYM4/y9uEnB
# dolJGf3AqL2Jo2cvxp+8cRlguC3pLMmQdmZ7lOKveNZlU1081pyyzykD+S+kULLU
# SM4FMlWK/bJkTA7kmAd123/fuQhVYIUwKfl7SKRphuM1Px6GXXp6Fb3vAI4VIlQX
# AJAmk7wOSWiRv/hH052VQsEOTd9vJs/DGCFiZkNw1tXAB+ECAwEAAaNCMEAwDgYD
# VR0PAQH/BAQDAgEGMA8GA1UdEwEB/wQFMAMBAf8wHQYDVR0OBBYEFFXkgdERgL7Y
# ibkIozH5oSQJFrlwMA0GCSqGSIb3DQEBBQUAA4IBAQA7m49WmzDnU5l8enmnTZfX
# GZWQ+wYfyjN8RmOPlmYk+kAbISfK5nJz8k/+MZn9yAxMaFPGgIITmPq2rdpdPfHO
# bvYVEZSCDO4/la8Rqw/XL94fA49XLB7Ju5oaRJXrGE+mH819VxAvmwQJWoS1btgd
# OuHWntFseV55HBTF49BMkztlPO3fPb6m5ZUaw7UZw71eW7v/I+9oGcsSkydcAy1v
# MNAethqs3lr30aqoJ6b+eYHEeZkzV7oSsKngQmyTylbe/m2ECwiLfo3q15ghxvPn
# PHkvXpzRTBWN4ewiN8yaQwuX3ICQjbNnm29ICBVWz7/xK3xemnbpWZDFfIM1EWVR
# MIIFEzCCA/ugAwIBAgIMWNoT/wAAAABRzg33MA0GCSqGSIb3DQEBCwUAMIG0MRQw
# EgYDVQQKEwtFbnRydXN0Lm5ldDFAMD4GA1UECxQ3d3d3LmVudHJ1c3QubmV0L0NQ
# U18yMDQ4IGluY29ycC4gYnkgcmVmLiAobGltaXRzIGxpYWIuKTElMCMGA1UECxMc
# KGMpIDE5OTkgRW50cnVzdC5uZXQgTGltaXRlZDEzMDEGA1UEAxMqRW50cnVzdC5u
# ZXQgQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkgKDIwNDgpMB4XDTE1MDcyMjE5MDI1
# NFoXDTI5MDYyMjE5MzI1NFowgbIxCzAJBgNVBAYTAlVTMRYwFAYDVQQKEw1FbnRy
# dXN0LCBJbmMuMSgwJgYDVQQLEx9TZWUgd3d3LmVudHJ1c3QubmV0L2xlZ2FsLXRl
# cm1zMTkwNwYDVQQLEzAoYykgMjAxNSBFbnRydXN0LCBJbmMuIC0gZm9yIGF1dGhv
# cml6ZWQgdXNlIG9ubHkxJjAkBgNVBAMTHUVudHJ1c3QgVGltZXN0YW1waW5nIENB
# IC0gVFMxMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA2SPmFKTofEuF
# cVj7+IHmcotdRsOIAB840Irh1m5WMOWv2mRQfcITOfu9ZrTahPuD0Cgfy3boYFBp
# m/POTxPiwT7B3xLLMqP4XkQiDsw66Y1JuWB0yN5UPUFeQ18oRqmmt8oQKyK8W01b
# jBdlEob9LHfVxaCMysKD4EdXfOdwrmJFJzEYCtTApBhVUvdgxgRLs91oMm4QHzQR
# uBJ4ZPHuqeD347EijzRaZcuK9OFFUHTfk5emNObQTDufN0lSp1NOny5nXO2W/KW/
# dFGI46qOvdmxL19QMBb0UWAia5nL/+FUO7n7RDilCDkjm2lH+jzE0Oeq30ay7PKK
# GawpsjiVdQIDAQABo4IBIzCCAR8wEgYDVR0TAQH/BAgwBgEB/wIBADAOBgNVHQ8B
# Af8EBAMCAQYwOwYDVR0gBDQwMjAwBgRVHSAAMCgwJgYIKwYBBQUHAgEWGmh0dHA6
# Ly93d3cuZW50cnVzdC5uZXQvcnBhMDMGCCsGAQUFBwEBBCcwJTAjBggrBgEFBQcw
# AYYXaHR0cDovL29jc3AuZW50cnVzdC5uZXQwMgYDVR0fBCswKTAnoCWgI4YhaHR0
# cDovL2NybC5lbnRydXN0Lm5ldC8yMDQ4Y2EuY3JsMBMGA1UdJQQMMAoGCCsGAQUF
# BwMIMB0GA1UdDgQWBBTDwnHSe9doBa47OZs0JQxiA8dXaDAfBgNVHSMEGDAWgBRV
# 5IHREYC+2Im5CKMx+aEkCRa5cDANBgkqhkiG9w0BAQsFAAOCAQEAHSTnmnRbqnD8
# sQ4xRdcsAH9mOiugmjSqrGNtifmf3w13/SQj/E+ct2+P8/QftsH91hzEjIhmwWON
# uld307gaHshRrcxgNhqHaijqEWXezDwsjHS36FBD08wo6BVsESqfFJUpyQVXtWc2
# 6Dypg+9BwSEW0373LRFHZnZgghJpjHZVcw/fL0td6Wwj+Af2tX3WaUWcWH1hLvx4
# S0NOiZFGRCygU6hFofYWWLuRE/JLxd8LwOeuKXq9RbPncDDnNI7revbTtdHeaxOZ
# RrOL0k2TdbXxb7/cACjCJb+856NlNOw/DR2XjPqqiCKkGDXbBY524xDIKY9j0K6s
# GNnaxJ9REjCCBg8wggT3oAMCAQICEAfXE1PaJWG0YemQR4pMzgQwDQYJKoZIhvcN
# AQELBQAwgbIxCzAJBgNVBAYTAlVTMRYwFAYDVQQKEw1FbnRydXN0LCBJbmMuMSgw
# JgYDVQQLEx9TZWUgd3d3LmVudHJ1c3QubmV0L2xlZ2FsLXRlcm1zMTkwNwYDVQQL
# EzAoYykgMjAxNSBFbnRydXN0LCBJbmMuIC0gZm9yIGF1dGhvcml6ZWQgdXNlIG9u
# bHkxJjAkBgNVBAMTHUVudHJ1c3QgVGltZXN0YW1waW5nIENBIC0gVFMxMB4XDTI0
# MDExOTE2NDYyOFoXDTI5MDYwMTAwMDAwMFowdTELMAkGA1UEBhMCQ0ExEDAOBgNV
# BAgTB09udGFyaW8xDzANBgNVBAcTBk90dGF3YTEWMBQGA1UEChMNRW50cnVzdCwg
# SW5jLjErMCkGA1UEAxMiRW50cnVzdCBUaW1lc3RhbXAgQXV0aG9yaXR5IC0gVFNB
# MTCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAMeSOEE5/6A/X01Nipcx
# 45uHw3gFaTYLUrOqg12w0r1+voOgX16el/PbNRep+dsVYnzK9sXJNBXiEaWSsS7g
# aVRdDiu+VcYBjIVjskktNV/lTkPEcQuktB40Tf9FyP5P4TDo6WVsa2XTvtQsaNCt
# BJtqudBU+zUAkDHG2GhqXa/qftD5nRPvzp1jZEJyB4X7BjGL450LptUy21KlTgw8
# wcCa0X8Cd2MTzfM9PB4CSzaG4AS0eHfkmy/hiSregl3r5Brcjbp7pJ+Pjmx16wPg
# gAS/sQkc+mF6s5uBtwvJEwp47Qj2zKZfQkcSOkd4dv682pk/ZOs3XirfUuKZsP3v
# hMqROqKwp7G2Vhw/RPh+ke94piT+3ike+PX3UX+2eC2HtL0AucYe4OjhE+7uX9de
# 7qR8dWDOoTWQWMKrtUhDe+nHd4mJi8ahjGmXz256Q/70X/tj5STq3+AQkKcSkMwb
# rQiK0Y2FIKJuoYsWJ5Ux089uAymfRMInCKy39IlNN+QliVpTLFMNghRzxuzFsNmH
# 2JsS7iY6X5cvcMkweKFaSm3SSEoPVWp+9lvih1/aERt3vhpe90gKmHEMfa4qgX2y
# npFgDtHZajASiuSa7KZLb4UGSRAOhUg/LuYUz1rjTzgqr9cxALwslpWSrXPPehxR
# y/4t6cAuWA4KFWXLiHsyG2ANAgMBAAGjggFbMIIBVzAMBgNVHRMBAf8EAjAAMB0G
# A1UdDgQWBBRDaB9vnyLQ+F8J9/y45SPGjgdCkjAfBgNVHSMEGDAWgBTDwnHSe9do
# Ba47OZs0JQxiA8dXaDBoBggrBgEFBQcBAQRcMFowIwYIKwYBBQUHMAGGF2h0dHA6
# Ly9vY3NwLmVudHJ1c3QubmV0MDMGCCsGAQUFBzAChidodHRwOi8vYWlhLmVudHJ1
# c3QubmV0L3RzMS1jaGFpbjI1Ni5jZXIwMQYDVR0fBCowKDAmoCSgIoYgaHR0cDov
# L2NybC5lbnRydXN0Lm5ldC90czFjYS5jcmwwDgYDVR0PAQH/BAQDAgeAMBYGA1Ud
# JQEB/wQMMAoGCCsGAQUFBwMIMEIGA1UdIAQ7MDkwNwYKYIZIAYb6bAoBBzApMCcG
# CCsGAQUFBwIBFhtodHRwczovL3d3dy5lbnRydXN0Lm5ldC9ycGEwDQYJKoZIhvcN
# AQELBQADggEBAL6w3P28+man/CMd89lXYvQk3x0v+VjLyswMfc9uh/Vuglor3uNf
# xs4a5AivjgQBHv8C+AVTuKhihXuZq0V72aqxF4PRKX6TIeg2iEIhOPv7DYHJw4qM
# yipeZq/5nPSNfBL7em06irAA9ztwpQ+7tVOp4cYpJurcEkovXVoEuKrjhwt9yJ4G
# /mlmS46n9L4wyaXikKGogQ0+RyGSUF0y5PJWz6mUIbswwncYEZomrvHiPi/8P4kz
# N12U590axeXMZmz6AM6W4oDt+CynxWgTaXwERK0I1fmrya0XZtUvC1fwm89cHqsN
# J0Zp/qi3BSWO4LIVM0pfupyL0CgJPLWFsuExggSYMIIElAIBATCBxzCBsjELMAkG
# A1UEBhMCVVMxFjAUBgNVBAoTDUVudHJ1c3QsIEluYy4xKDAmBgNVBAsTH1NlZSB3
# d3cuZW50cnVzdC5uZXQvbGVnYWwtdGVybXMxOTA3BgNVBAsTMChjKSAyMDE1IEVu
# dHJ1c3QsIEluYy4gLSBmb3IgYXV0aG9yaXplZCB1c2Ugb25seTEmMCQGA1UEAxMd
# RW50cnVzdCBUaW1lc3RhbXBpbmcgQ0EgLSBUUzECEAfXE1PaJWG0YemQR4pMzgQw
# CwYJYIZIAWUDBAIBoIIBpTAaBgkqhkiG9w0BCQMxDQYLKoZIhvcNAQkQAQQwHAYJ
# KoZIhvcNAQkFMQ8XDTI0MDQxOTEwMDgwNlowKQYJKoZIhvcNAQk0MRwwGjALBglg
# hkgBZQMEAgGhCwYJKoZIhvcNAQELMC8GCSqGSIb3DQEJBDEiBCAmqGDz2Hz8amjf
# uJm1OfqysuOEm+g+9K+fRKx9NoqaEzCCAQsGCyqGSIb3DQEJEAIvMYH7MIH4MIH1
# MIHyBCAoSfcxGNdBRQVhc80+7Mu9U0teDvD6BhaNsOJzSQPujzCBzTCBuKSBtTCB
# sjELMAkGA1UEBhMCVVMxFjAUBgNVBAoTDUVudHJ1c3QsIEluYy4xKDAmBgNVBAsT
# H1NlZSB3d3cuZW50cnVzdC5uZXQvbGVnYWwtdGVybXMxOTA3BgNVBAsTMChjKSAy
# MDE1IEVudHJ1c3QsIEluYy4gLSBmb3IgYXV0aG9yaXplZCB1c2Ugb25seTEmMCQG
# A1UEAxMdRW50cnVzdCBUaW1lc3RhbXBpbmcgQ0EgLSBUUzECEAfXE1PaJWG0YemQ
# R4pMzgQwCwYJKoZIhvcNAQELBIICABk+HIUWVuLIsX0z4GFt4dUeJ6KlCgpLgZMz
# 602j55EfmQGRyyDlRRaqbV6vu89L0EVABJyMZ1jjUt2K6GgG8vORJAucASyW7o2A
# DWPsgqZhyq325utoCajh4nliVyApoJxCqpGzxW2B7h1UlTyIoYC/WiaZcTpQYReF
# QFSHZ9uSOPDOjciVfepnrcxZt7zwoHiBvbVdfvMMACN2povtDdb7u2pemyXnShYH
# MQAdSrC5NzIQITK9w0xXLri5AGgo8fY1+cqgqNlkw0X+UcvLuZflk9iJB9EIaZxX
# 708gA+1f9WeDjVWuTznlqrNtI+7gyigTc4k5ccZjyNJgCnWIQ8GGjJeutT4+rAUq
# bInvBjhzwcHpPuWvxSTm/YD+Trn+XDa5QT8jv32vECdk1mWqjNtGoVISE9pec6LG
# GJ6p3nzc5dYE0L8IzhKjSH5sjCMdZzpeCrRIbA9vx0hfL6vVAlj8uP0qLvo3o7XG
# u89QCzKg9H/pnal6f4RRoshqaPj5dsf9Mhyo26RMh9sWafTa3NocCJio4t7mnYm4
# 3fr+Y3mWhlSM+MABSxi8MLYllO7EdH/fUyylOZ8yaYTWFBWzOfG12MeiJVsemj6M
# nNI6eroiDmE7pbQDhU45dR/8OVX8f/noxeINCLpyyCHIREkVFa8ZcmL6C05s2PKD
# /0XwyL7N
# SIG # End signature block
