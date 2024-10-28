##########################################################################
# DELL PROPRIETARY INFORMATION
#
# This software is confidential.  Dell Inc., or one of its subsidiaries, has supplied this
# software to you under the terms of a license agreement,nondisclosure agreement or both.
# You may not copy, disclose, or use this software except in accordance with those terms.
#
# Copyright 2020 Dell Inc. or its subsidiaries.  All Rights Reserved.
#
# DELL INC. MAKES NO REPRESENTATIONS OR WARRANTIES ABOUT THE SUITABILITY OF THE SOFTWARE,
# EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, OR NON-INFRINGEMENT.
# DELL SHALL NOT BE LIABLE FOR ANY DAMAGES SUFFERED BY LICENSEE AS A RESULT OF USING,
# MODIFYING OR DISTRIBUTING THIS SOFTWARE OR ITS DERIVATIVES.
#
#
#
##########################################################################

<#
This is a Resource designer script which generates a mof schema for DCPP_POSTBehavior resource in DellBIOSProvider module.


#>

$blockdefinition = New-xDscResourceProperty -name BlockDefinition -Type String -Attribute Key
$category = New-xDscResourceProperty -name Category -Type String -Attribute Write
$autoon = New-xDscResourceProperty -name AutoOn -Type String -Attribute Write  -ValidateSet @("EveryDay", "Disabled", "WeekDays", "SelectDays")
$autoonhour = New-xDscResourceProperty -name AutoOnHr -Type Uint16 -Attribute Write
$autoonminute = New-xDscResourceProperty -name AutoOnMn -Type Uint16 -Attribute Write
$autoonsunday= New-xDscResourceProperty -name AutoOnSun -Type string -Attribute Write  -ValidateSet @("Enabled", "Disabled")
$autoonmonday= New-xDscResourceProperty -name AutoOnMon -Type string -Attribute Write  -ValidateSet @("Enabled", "Disabled")
$autoontuesday= New-xDscResourceProperty -name AutoOnTue -Type string -Attribute Write  -ValidateSet @("Enabled", "Disabled")
$autoonwednesday= New-xDscResourceProperty -name AutoOnWed -Type string -Attribute Write  -ValidateSet @("Enabled", "Disabled")
$autoonthursday= New-xDscResourceProperty -name AutoOnThur -Type string -Attribute Write  -ValidateSet @("Enabled", "Disabled")
$autoonfriday= New-xDscResourceProperty -name AutoOnFri -Type string -Attribute Write  -ValidateSet @("Enabled", "Disabled")
$autoonsaturday= New-xDscResourceProperty -name AutoOnSat -Type string -Attribute Write  -ValidateSet @("Enabled", "Disabled")
$deepsleepcontrol = New-xDscResourceProperty -name DeepSleepCtrl -Type String -Attribute Write -ValidateSet @("Disabled", "S5Only", "S4AndS5")
$fanspeedcontrol= New-xDscResourceProperty -name FanSpeed -Type string -Attribute Write  -ValidateSet @("Auto", "High", "Med", "Low", "MedHigh", "MedLow" )
$fanspeedlevel = New-xDscResourceProperty -name FanSpeedLvl -Type Uint16 -Attribute Write
$usbwakesupport= New-xDscResourceProperty -name UsbWake -Type string -Attribute Write  -ValidateSet @("Disabled", "Enabled")
$fancontroloverride= New-xDscResourceProperty -name FanCtrlOvrd -Type string -Attribute Write  -ValidateSet @("Enabled", "Disabled")
$acbehavior= New-xDscResourceProperty -name AcPwrRcvry -Type string -Attribute Write  -ValidateSet @("Off", "On", "Last")
$wakeonLAN= New-xDscResourceProperty -name WakeOnLan -Type string -Attribute Write  -ValidateSet @("AddInCard","Onboard", "Disabled", "LanOnly","LanWithPxeBoot", "WlanOnly", "LanWlan" )
$sfpwakeonLAN= New-xDscResourceProperty -name SfpwakeOnLan -Type string -Attribute Write  -ValidateSet @("SFP","LANSFP", "SFPPXE")
$wakeOnAc = New-xDscResourceProperty -name WakeOnAc -Type String -Attribute Write  -ValidateSet @("Disabled", "Enabled")
$wakeOnDock = New-xDscResourceProperty -name WakeOnDock -Type string -Attribute Write  -ValidateSet @("Enabled", "Disabled")
$lidSwitch = New-xDscResourceProperty -name LidSwitch -Type string -Attribute Write  -ValidateSet @("Enabled", "Disabled")
$blinkPowerSupply1LED = New-xDscResourceProperty -name BlinkPowerSupply1LED -Type string -Attribute Write  -ValidateSet @("Enabled")
$blinkPowerSupply2LED = New-xDscResourceProperty -name BlinkPowerSupply2LED -Type string -Attribute Write  -ValidateSet @("Enabled")
$wlanAutoSense = New-xDscResourceProperty -name WlanAutoSense -Type String -Attribute Write  -ValidateSet @("Disabled", "Enabled")
$wwanAutoSense = New-xDscResourceProperty -name WwanAutoSense -Type String -Attribute Write  -ValidateSet @("Disabled", "Enabled")
$blocksleep= New-xDscResourceProperty -name BlockSleep -Type string -Attribute Write  -ValidateSet @("Enabled", "Disabled")
$sleepMode= New-xDscResourceProperty -name SleepMode -Type string -Attribute Write  -ValidateSet @("OSAutomaticSelection", "ForceS3")
$primarybatterychargeconfiguration= New-xDscResourceProperty -name PrimaryBattChargeCfg -Type string -Attribute Write  -ValidateSet @("Auto", "Standard", "Express", "PrimAcUse", "Custom"  )
$customChargeStart = New-xDscResourceProperty -name CustomChargeStart -Type Uint16 -Attribute Write
$customChargeEnd = New-xDscResourceProperty -name CustomChargeStop -Type Uint16 -Attribute Write
$batteryslicechargeconfiguration= New-xDscResourceProperty -name SliceBattChargeCfg -Type string -Attribute Write  -ValidateSet @("Standard", "Express")
$modbatteryconfiguration= New-xDscResourceProperty -name ModBattChargeCfg -Type string -Attribute Write  -ValidateSet @("Standard", "Express")
$dockbatteryconfiguration= New-xDscResourceProperty -name DockBatteryChargeConfiguration -Type string -Attribute Write  -ValidateSet @("Standard", "Express")
$intelsmartconnect= New-xDscResourceProperty -name IntlSmartConnect -Type string -Attribute Write  -ValidateSet @("Enabled", "Disabled")
$intelreadymode= New-xDscResourceProperty -name IntelReadyModeEn -Type string -Attribute Write  -ValidateSet @("Enabled", "Disabled")
$peakshift = New-xDscResourceProperty -name PeakShiftCfg -Type String -Attribute Write  -ValidateSet @("Enabled", "Disabled")
$peakshiftbatterythreshold = New-xDscResourceProperty -name PeakShiftBatteryThreshold -Type Uint16 -Attribute Write
$peakshiftdayconfiguration = New-xDscResourceProperty -name PeakShiftDayConfiguration -Type String -Attribute Write  
$starttime = New-xDscResourceProperty -name StartTime -Type String -Attribute Write
$endtime = New-xDscResourceProperty -name EndTime -Type String -Attribute Write
$chargestarttime = New-xDscResourceProperty -name ChargeStartTime -Type String -Attribute Write
$advancedbatterychargingmode = New-xDscResourceProperty -name AdvBatteryChargeCfg -Type String -Attribute Write  -ValidateSet @("Enabled", "Disabled")
$advancedbatterychargeconfiguration = New-xDscResourceProperty -name AdvancedBatteryChargeConfiguration -Type String -Attribute Write
$typeCOverload = New-xDscResourceProperty -name Type_CBatteryOverloadProtection -Type String -Attribute Write  -ValidateSet @("7.5Watts", "15Watts")
$beginningofday = New-xDscResourceProperty -name BeginningOfDay -Type String -Attribute Write
$workperiod = New-xDscResourceProperty -name WorkPeriod -Type String -Attribute Write
$docksupportonbattery = New-xDscResourceProperty -name DockSupportOnBattery -Type String -Attribute Write  -ValidateSet @("Enabled", "Disabled")
$Password = New-xDscResourceProperty -Name Password -Type string -Attribute Write -Description "Password"
$SecurePassword = New-xDscResourceProperty -Name SecurePassword -Type string -Attribute Write -Description "SecurePassword"
$PathToKey = New-xDscResourceProperty -Name PathToKey -Type string -Attribute Write

$properties = @($blockdefinition,$category,$autoon,$autoonhour,$autoonminute,$autoonsunday,$autoonmonday,$autoontuesday,$autoonwednesday,$autoonthursday,$autoonfriday,$autoonsaturday,$deepsleepcontrol,$fanspeedcontrol,$fanspeedlevel,$usbwakesupport,$fancontroloverride,$acbehavior,$wakeonLAN,$sfpwakeonLAN,$wakeOnAc,$wakeOnDock,$lidSwitch,$blinkPowerSupply1LED,$blinkPowerSupply2LED,$wlanAutoSense,$wwanAutoSense,$blocksleep,$sleepMode,$primarybatterychargeconfiguration,$customChargeStart,$customChargeEnd,$batteryslicechargeconfiguration,$modbatteryconfiguration,$dockbatteryconfiguration,$intelsmartconnect,$intelreadymode,$peakshift,$peakshiftbatterythreshold,$peakshiftdayconfiguration,$starttime,$endtime,$chargestarttime,$advancedbatterychargingmode,$advancedbatterychargeconfiguration,$typeCOverload,$beginningofday,$workperiod,$docksupportonbattery,$Password,$SecurePassword,$PathToKey)

New-xDscResource -ModuleName DellBIOSProviderX86 -Name DCPP_PowerManagement -Property $properties -Path 'C:\Program Files\WindowsPowerShell\Modules' -FriendlyName "PowerManagement" -Force -Verbose

# SIG # Begin signature block
# MIIutAYJKoZIhvcNAQcCoIIupTCCLqECAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCA0ukM6FsVukfrn
# lLUMsm+2rS/Ch3sdlkLr60CNi44rsaCCEugwggXfMIIEx6ADAgECAhBOQOQ3VO3m
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
# ejCCBGKgAwIBAgIQXppEwdVMjAFyZoUhC+DGojANBgkqhkiG9w0BAQsFADBjMQsw
# CQYDVQQGEwJVUzEWMBQGA1UEChMNRW50cnVzdCwgSW5jLjE8MDoGA1UEAxMzRW50
# cnVzdCBFeHRlbmRlZCBWYWxpZGF0aW9uIENvZGUgU2lnbmluZyBDQSAtIEVWQ1My
# MB4XDTI0MDIxNDIwNTQ0MloXDTI1MDIyNzIwNTQ0MVowgdUxCzAJBgNVBAYTAlVT
# MQ4wDAYDVQQIEwVUZXhhczETMBEGA1UEBxMKUm91bmQgUm9jazETMBEGCysGAQQB
# gjc8AgEDEwJVUzEZMBcGCysGAQQBgjc8AgECEwhEZWxhd2FyZTEfMB0GA1UEChMW
# RGVsbCBUZWNobm9sb2dpZXMgSW5jLjEdMBsGA1UEDxMUUHJpdmF0ZSBPcmdhbml6
# YXRpb24xEDAOBgNVBAUTBzUyODAzOTQxHzAdBgNVBAMTFkRlbGwgVGVjaG5vbG9n
# aWVzIEluYy4wggGiMA0GCSqGSIb3DQEBAQUAA4IBjwAwggGKAoIBgQDDo1XKkZwW
# xJ2HF9BoBTYk8SHvDp3z2FVdLQay6VKOSz+Xrohhe56UrKQOW/pePeBC+bj+GM0j
# R7bCZCx0X26sh6SKz3RgIRgc+QP3TRKu6disqSWIjIMKFmNegyQPJbDLaDMhvrVk
# j7qobtphs0OB/8N+hSkcTRmiphzDvjwTiYh6Bgt37pPDEvhz1tkZ/fhWWhp355lW
# FWYBPmxVS2vTKDRSQnLtJ31dltNBXalMW0ougqtJNVJTm1m9m8ZgkBtm2a2Ydgdg
# tYbgye5A0udl0HwcImgiDG1eAKNR1W4eG353UsS7n6IWG93QpF5L++2o7DDcDtBr
# 9qtVy3RjzWuzgYW5/wIvLkWS7UolX65tFfwKai617FikhrrqcgWcwfbKVrUA4nL3
# i4OL4718Y9T/8N39Knwp1+ZJx9hMiFVVCr6XteO0LQg18/NFjDzbuRXzX2adEzxm
# Fdbw3ZGLUfCYN2LQTa+ssOc2hAEumaiVRdntd2d5TaOHwXhsSaBMnh8CAwEAAaOC
# ATUwggExMAwGA1UdEwEB/wQCMAAwHQYDVR0OBBYEFHcDtMS/dbtrhMpavR1yYhFn
# +k1vMB8GA1UdIwQYMBaAFM6JT4JRqhWihGLKMSNh0mH7+P54MGcGCCsGAQUFBwEB
# BFswWTAjBggrBgEFBQcwAYYXaHR0cDovL29jc3AuZW50cnVzdC5uZXQwMgYIKwYB
# BQUHMAKGJmh0dHA6Ly9haWEuZW50cnVzdC5uZXQvZXZjczItY2hhaW4ucDdjMDEG
# A1UdHwQqMCgwJqAkoCKGIGh0dHA6Ly9jcmwuZW50cnVzdC5uZXQvZXZjczIuY3Js
# MA4GA1UdDwEB/wQEAwIHgDATBgNVHSUEDDAKBggrBgEFBQcDAzAgBgNVHSAEGTAX
# MAcGBWeBDAEDMAwGCmCGSAGG+mwKAQIwDQYJKoZIhvcNAQELBQADggIBABB9FgN1
# YzMm05EhuGuTIEQNOwq4VoETYArSR88RLDN9Dr8lu45+WghxE7MigaGKF8AEi6Z3
# diDeN+5TJOiBd6Zv2LDa3UfMpqf8GZm/L1pd5TF19s44NLbxlIad/yq/NbXFcWsc
# VNu4TtM/PdCg7E0ggh044pNllpR/Ofqqu2D/kV6TBMw2cgL24l5YZxat+hxfWBuw
# Rhtwu/kWiSIe0ad/vB4ChVPY7PvNuU/jCU7PlgXOUiIsPbLsheAoWjxAK+Vl/NYX
# 91T/eXBZ7A4McMoprqPeVkKti0OpC2zhb+3NFHjR/gSkVLkmwEh48ebsip6uqEBY
# KS9zj6P6g0P8HHlwNZMkQ4llOzjIsQriORfayBAmjDpsgHr0r3Q362+svyI//k1V
# HjX3WTTYO1tFfOl0LYVzcfOUj5OY04kH35Y+yi30DGJy2mG0qwlRSAfiDr1a8OpL
# eaxkwvN2R2Ml0s6Oiqq0lTuLNFRnl/tCxahaT8liOzFd2WU7I3L5IL0ufRMlbezA
# S453qkkX4Xtd7KtRDQnWU5IbzBg8Yswwv+DLNm2Ep7PHTU3t4GiF0O+oaDq83QaM
# ovN80wPcCce1PkUB9iSvOuBbbrODjlSFa6OVpLHnvDesW1L99YS8sOitcRnXoNXw
# HST4XAO+86tKYUw2XtjBapV1ND20AMhuaZ5KMIIGgzCCBGugAwIBAgIQNa+3e500
# H2r8j4RGqzE1KzANBgkqhkiG9w0BAQ0FADBpMQswCQYDVQQGEwJVUzEWMBQGA1UE
# CgwNRW50cnVzdCwgSW5jLjFCMEAGA1UEAww5RW50cnVzdCBDb2RlIFNpZ25pbmcg
# Um9vdCBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eSAtIENTQlIxMB4XDTIxMDUwNzE5
# MTk1MloXDTQwMTIyOTIzNTkwMFowYzELMAkGA1UEBhMCVVMxFjAUBgNVBAoTDUVu
# dHJ1c3QsIEluYy4xPDA6BgNVBAMTM0VudHJ1c3QgRXh0ZW5kZWQgVmFsaWRhdGlv
# biBDb2RlIFNpZ25pbmcgQ0EgLSBFVkNTMjCCAiIwDQYJKoZIhvcNAQEBBQADggIP
# ADCCAgoCggIBAL69pznJpX3sXWXx9Cuph9DnrRrFGjsYzuGhUY1y+s5YH1y4JEIP
# RtUxl9BKTeObMMm6l6ic/kU2zyeA53u4bsEkt9+ndNyF8qMkWEXMlJQ7AuvEjXxG
# 9VxmguOkwdMfrG4MUyMO1Dr62kLxg1RfNTJW8rV4m1cASB6pYWEnDnMDQ7bWcJL7
# 1IWaMMaz5ppeS+8dKthmqxZG/wvYD6aJSgJRV0E8QThOl8dRMm1njmahXk2fNSKv
# 1Wq3f0BfaDXMafrxBfDqhabqMoXLwcHKg2lFSQbcCWy6SWUZjPm3NyeMZJ414+Xs
# 5wegnahyvG+FOiymFk49nM8I5oL1RH0owL2JrWwv3C94eRHXHHBL3Z0ITF4u+o29
# p91j9n/wUjGEbjrY2VyFRJ5jBmnQhlh4iZuHu1gcpChsxv5pCpwerBFgal7JaWUu
# 7UMtafF4tzstNfKqT+If4wFvkEaq1agNBFegtKzjbb2dGyiAJ0bH2qpnlfHRh3vH
# yCXphAyPiTbSvjPhhcAz1aA8GYuvOPLlk4C/xsOre5PEPZ257kV2wNRobzBePLQ2
# +ddFQuASBoDbpSH85wV6KI20jmB798i1SkesFGaXoFppcjFXa1OEzWG6cwcVcDt7
# AfynP4wtPYeM+wjX5S8Xg36Cq08J8inhflV3ZZQFHVnUCt2TfuMUXeK7AgMBAAGj
# ggErMIIBJzASBgNVHRMBAf8ECDAGAQH/AgEAMB0GA1UdDgQWBBTOiU+CUaoVooRi
# yjEjYdJh+/j+eDAfBgNVHSMEGDAWgBSCutY9l86fz3Hokjev/bO1aTVXzzAzBggr
# BgEFBQcBAQQnMCUwIwYIKwYBBQUHMAGGF2h0dHA6Ly9vY3NwLmVudHJ1c3QubmV0
# MDEGA1UdHwQqMCgwJqAkoCKGIGh0dHA6Ly9jcmwuZW50cnVzdC5uZXQvY3NicjEu
# Y3JsMA4GA1UdDwEB/wQEAwIBhjATBgNVHSUEDDAKBggrBgEFBQcDAzBEBgNVHSAE
# PTA7MDAGBFUdIAAwKDAmBggrBgEFBQcCARYaaHR0cDovL3d3dy5lbnRydXN0Lm5l
# dC9ycGEwBwYFZ4EMAQMwDQYJKoZIhvcNAQENBQADggIBAD4AVLgq849mr2EWxFiT
# ZPRBi2RVjRs1M6GbkdirRsqrX7y+fnDk0tcHqJYH14bRVwoI0NB4Tfgq37IE85rh
# 13zwwQB6wUCh34qMt8u0HQFh8piapt24gwXKqSwW3JwtDv6nl+RQqZeVwUsqjFHj
# xALga3w1TVO8S5QTi1MYFl6mCqe4NMFssess5DF9DCzGfOGkVugtdtWyE3XqgwCu
# AHfGb6k97mMUgVAW/FtPEhkOWw+N6kvOBkyJS64gzI5HpnXWZe4vMOhdNI8fgk1c
# QqbyFExQIJwJonQkXDnYiTKFPK+M5Wqe5gQ6pRP/qh3NR0suAgW0ao/rhU+B7wrb
# fZ8pj6XCP1I4UkGVO7w+W1QwQiMJY95QjYk1RfqruA+Poq17ehGT8Y8ohHtoeUdq
# 6GQpTR/0HS9tHsiUhjzTWpl6a3yrNfcrOUtPuT8Wku8pjI2rrAEazHFEOctAPiAS
# zghw40f+3IDXCADRC2rqIbV5ZhfpaqpW3c0VeLEDwBStPkcYde0KU0syk83/gLGQ
# 1hPl5EF4Iu1BguUO37DOlSFF5osB0xn39CtVrNlWc2MQ4LigbctUlpigmSFRBqqm
# DDorY8t52kO50hLM3o9VeukJ8+Ka0yXBezaS2uDlUmfN4+ZUCqWd1HOj0y9dBmSF
# A3d/YNjCvHTJlZFot7d+YRl1MYIbIjCCGx4CAQEwdzBjMQswCQYDVQQGEwJVUzEW
# MBQGA1UEChMNRW50cnVzdCwgSW5jLjE8MDoGA1UEAxMzRW50cnVzdCBFeHRlbmRl
# ZCBWYWxpZGF0aW9uIENvZGUgU2lnbmluZyBDQSAtIEVWQ1MyAhBemkTB1UyMAXJm
# hSEL4MaiMA0GCWCGSAFlAwQCAQUAoIGaMBkGCSqGSIb3DQEJAzEMBgorBgEEAYI3
# AgEEMBwGCisGAQQBgjcCAQsxDjAMBgorBgEEAYI3AgEVMC4GCisGAQQBgjcCAQwx
# IDAeoByAGgBEAGUAbABsACAAUwBvAGwAdQB0AGkAbwBuMC8GCSqGSIb3DQEJBDEi
# BCB8VLe/fsr+XwtIBebh5J38Drn474knWColpRyBsT/RGjANBgkqhkiG9w0BAQEF
# AASCAYC8ivPttMT+caMwXdyV5EBaoA86QYTpncqStK/y0UVO1Gd1UygwZRPRswAO
# Yzf5inmcz1aHMztFsub7bY5UmdJOrE9c8WRRRi0A+KesfAtyNgXS6f+PADl+58ds
# vDv322y5H5UrNumOgwhyqI8UmRYkEpXSHeXE/KOG1tBNPNOR93KhIuZUtWdFZJ8v
# 2BB1a1P6RrTLqvJT/4dmK9RrtvuRr8TVCdvxkgcP/hATN/y4/MEXk2UJfdcWqD09
# 62qkIneLQJt6nhZsU5l2+KwhQa1ryBfxDiO4+PPQtNWY1NLNiaw1LmiWcnOoZdGS
# bvtzJ4SnsIqMjR+aQ03XRWIWY6/BJwZlrQ/vSDbrcM1rwYLWdrdepWPJXQRxO1rr
# pSx8XnxOX+MCW6PY95Ji7wqbkvWn8f0svCbPMgB41VENA7ZtG9gW//q+V44LopwM
# OtOThGYCd/0W2Q7OXc1I9N22KUGpTi639fpi3/QM7BATShepctplTRSeLJtNt3Dd
# 6Ys0Cj2hghhfMIIYWwYKKwYBBAGCNwMDATGCGEswghhHBgkqhkiG9w0BBwKgghg4
# MIIYNAIBAzENMAsGCWCGSAFlAwQCAzCB8wYLKoZIhvcNAQkQAQSggeMEgeAwgd0C
# AQEGCmCGSAGG+mwKAwUwMTANBglghkgBZQMEAgEFAAQgiCLn5SXIE0UZ6/GaTIMs
# dpNEKygD90RCDNorFTtsKJQCCH9JBsZOaLlFGA8yMDI0MDQxODA3MzI1MFowAwIB
# AaB5pHcwdTELMAkGA1UEBhMCQ0ExEDAOBgNVBAgTB09udGFyaW8xDzANBgNVBAcT
# Bk90dGF3YTEWMBQGA1UEChMNRW50cnVzdCwgSW5jLjErMCkGA1UEAxMiRW50cnVz
# dCBUaW1lc3RhbXAgQXV0aG9yaXR5IC0gVFNBMqCCEw4wggXfMIIEx6ADAgECAhBO
# QOQ3VO3mjAAAAABR05R/MA0GCSqGSIb3DQEBCwUAMIG+MQswCQYDVQQGEwJVUzEW
# MBQGA1UEChMNRW50cnVzdCwgSW5jLjEoMCYGA1UECxMfU2VlIHd3dy5lbnRydXN0
# Lm5ldC9sZWdhbC10ZXJtczE5MDcGA1UECxMwKGMpIDIwMDkgRW50cnVzdCwgSW5j
# LiAtIGZvciBhdXRob3JpemVkIHVzZSBvbmx5MTIwMAYDVQQDEylFbnRydXN0IFJv
# b3QgQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkgLSBHMjAeFw0yMTA1MDcxNTQzNDVa
# Fw0zMDExMDcxNjEzNDVaMGkxCzAJBgNVBAYTAlVTMRYwFAYDVQQKDA1FbnRydXN0
# LCBJbmMuMUIwQAYDVQQDDDlFbnRydXN0IENvZGUgU2lnbmluZyBSb290IENlcnRp
# ZmljYXRpb24gQXV0aG9yaXR5IC0gQ1NCUjEwggIiMA0GCSqGSIb3DQEBAQUAA4IC
# DwAwggIKAoICAQCngY/3FEW2YkPy2K7TJV5IT1G/xX2fUBw10dZ+YSqUGW0nRqSm
# Gl33VFFqgCLGqGZ1TVSDyV5oG6v2W2Swra0gvVTvRmttAudFrnX2joq5Mi6LuHcc
# Uk15iF+lOhjJUCyXJy2/2gB9Y3/vMuxGh2Pbmp/DWiE2e/mb1cqgbnIs/OHxnnBN
# CFYVb5Cr+0i6udfBgniFZS5/tcnA4hS3NxFBBuKK4Kj25X62eAUBw2DtTwdBLgoT
# SeOQm3/dvfqsv2RR0VybtPVc51z/O5uloBrXfQmywrf/bhy8yH3m6Sv8crMU6UpV
# EoScRCV1HfYq8E+lID1oJethl3wP5bY9867DwRG8G47M4EcwXkIAhnHjWKwGymUf
# e5SmS1dnDH5erXhnW1XjXuvH2OxMbobL89z4n4eqclgSD32m+PhCOTs8LOQyTUmM
# 4OEAwjignPqEPkHcblauxhpb9GdoBQHNG7+uh7ydU/Yu6LZr5JnexU+HWKjSZR7I
# H9Vybu5ZHFc7CXKd18q3kMbNe0WSkUIDTH0/yvKquMIOhvMQn0YupGaGaFpoGHAp
# OBGAYGuKQ6NzbOOzazf/5p1nAZKG3y9I0ftQYNVc/iHTAUJj/u9wtBfAj6ju08FL
# XxLq/f0uDodEYOOp9MIYo+P9zgyEIg3zp3jak/PbOM+5LzPG/wc8Xr5F0wIDAQAB
# o4IBKzCCAScwDgYDVR0PAQH/BAQDAgGGMBIGA1UdEwEB/wQIMAYBAf8CAQEwHQYD
# VR0lBBYwFAYIKwYBBQUHAwMGCCsGAQUFBwMIMDsGA1UdIAQ0MDIwMAYEVR0gADAo
# MCYGCCsGAQUFBwIBFhpodHRwOi8vd3d3LmVudHJ1c3QubmV0L3JwYTAzBggrBgEF
# BQcBAQQnMCUwIwYIKwYBBQUHMAGGF2h0dHA6Ly9vY3NwLmVudHJ1c3QubmV0MDAG
# A1UdHwQpMCcwJaAjoCGGH2h0dHA6Ly9jcmwuZW50cnVzdC5uZXQvZzJjYS5jcmww
# HQYDVR0OBBYEFIK61j2Xzp/PceiSN6/9s7VpNVfPMB8GA1UdIwQYMBaAFGpyJnrQ
# Hu995ztpUdRsjZ+QEmarMA0GCSqGSIb3DQEBCwUAA4IBAQAfXkEEtoNwJFMsVXMd
# ZTrA7LR7BJheWTgTCaRZlEJeUL9PbG4lIJCTWEAN9Rm0Yu4kXsIBWBUCHRAJb6jU
# +5J+Nzg+LxR9jx1DNmSzZhNfFMylcfdbIUvGl77clfxwfREc0yHd0CQ5KcX+Chql
# z3t57jpv3ty/6RHdFoMI0yyNf02oFHkvBWFSOOtg8xRofcuyiq3AlFzkJg4sit1G
# w87kVlHFVuOFuE2bRXKLB/GK+0m4X9HyloFdaVIk8Qgj0tYjD+uL136LwZNr+vFi
# e1jpUJuXbheIDeHGQ5jXgWG2hZ1H7LGerj8gO0Od2KIc4NR8CMKvdgb4YmZ6tvf6
# yK81MIIGbzCCBFegAwIBAgIQJbwr8ynKEH8eqbqIhdSdOzANBgkqhkiG9w0BAQ0F
# ADBpMQswCQYDVQQGEwJVUzEWMBQGA1UECgwNRW50cnVzdCwgSW5jLjFCMEAGA1UE
# Aww5RW50cnVzdCBDb2RlIFNpZ25pbmcgUm9vdCBDZXJ0aWZpY2F0aW9uIEF1dGhv
# cml0eSAtIENTQlIxMB4XDTIxMDUwNzE5MjIxNFoXDTQwMTIyOTIzNTkwMFowTjEL
# MAkGA1UEBhMCVVMxFjAUBgNVBAoTDUVudHJ1c3QsIEluYy4xJzAlBgNVBAMTHkVu
# dHJ1c3QgVGltZSBTdGFtcGluZyBDQSAtIFRTMjCCAiIwDQYJKoZIhvcNAQEBBQAD
# ggIPADCCAgoCggIBALUDKga2hE80zJ4xvuqOxntuICQPA9e9gTYz5m/SPrvEnqqg
# zGZdQmA0UeItYYO6PJ5ouEvDZo6l3iu6my1Bpd7Qy1cFLYjZwEaIbTw1DRmQrLgM
# GfBMxdtFW9w7wryNRADgOP//XcjPCJo91LLre5XDxKUA4GIBZFlfjON7i6n5RbfG
# sKIKN0O4RoGrhn5/L97wX+vNIMylLTHjqC6Zm+B43fTbXYJjfTA5iH4kBuZ8YIR4
# yFwp5ZXL9XtPz1jckM+nonsUVMTgN5gwwZu2rpwp9mslQ+cSaj4Zi77A54HXSjAI
# fnyN3zzzSJMh3oGDap0APtdgutGzYgiW6bZJADj0XHYN2ndqPaCV3h6hzFl6Xp/P
# 6XZdQPK1FbVgaCzzWskjg9j1GmtpKKS21K5iBt4mRb3e6VZ3qtxksEHNzBPxXXF0
# spQIS08ybn5wuHfp1TI3wnreQhLocRzi2GK/qmtBhgZb5mm+Jgn0l8L+TPSAcoRu
# 297FB6mOFaJt4RvgCQ/1oAegu8R3cwk8B5ONAbUSZy1NGbW4xckQq3DPQv+lJx3W
# EtbkGERg+zldhLtmtVMSnQMUgmUptOxJcv2zQ+XDAikkuh/4uL5do7cuqfzPYtn6
# l8QTeONVuVp6hOv/u89piMC2+YtghUEQUMcFENJedp0+Nez2T4r5Ens/rws3AgMB
# AAGjggEsMIIBKDASBgNVHRMBAf8ECDAGAQH/AgEAMB0GA1UdDgQWBBQmD/DESAgb
# zd2R9VRUtrOz/JnxCDAfBgNVHSMEGDAWgBSCutY9l86fz3Hokjev/bO1aTVXzzAz
# BggrBgEFBQcBAQQnMCUwIwYIKwYBBQUHMAGGF2h0dHA6Ly9vY3NwLmVudHJ1c3Qu
# bmV0MDEGA1UdHwQqMCgwJqAkoCKGIGh0dHA6Ly9jcmwuZW50cnVzdC5uZXQvY3Ni
# cjEuY3JsMA4GA1UdDwEB/wQEAwIBhjATBgNVHSUEDDAKBggrBgEFBQcDCDBFBgNV
# HSAEPjA8MDAGBFUdIAAwKDAmBggrBgEFBQcCARYaaHR0cDovL3d3dy5lbnRydXN0
# Lm5ldC9ycGEwCAYGZ4EMAQQCMA0GCSqGSIb3DQEBDQUAA4ICAQB2PUZohV8JwM7J
# +Me4136nXDsLRnPOIlOLOPYRunfEwochjyfZDJXr6EvlXNeQFW+oKiyKauAiETR5
# +r2Wech2Fs2xROpxUQ+bVckYfNWCeZzzpreTqQU4cgIGl6Gosnl+Xgjibmx5mqiH
# lM5/j1U2QA+fP1HVZr57q4bmboe6TmNdsdiOH8tnww1w2nrrk7IUhNI+fZM/Fgw2
# oFx5AJ8LbuWEKtiIwW0Etzfzkppw4DsD/c27J4LOL/yN5LLKvvglhcbtdMg9NV84
# CT15T+sb4EFepXSBP1EVwPhJiI+6uwXUrUWCM3nBJY1fVD2R5LifF5gAXa0o5U9f
# G/v4VLWlxCT88HY7+A1ezEewyqq7blHfU7VJGvFgh7f5/WkGdV9z1hGQ8oBYjuXD
# DwOYjARTsymH3z/3sOlMV4EkRHlo/hs2B9ZlPexv1sK1qmF8Zgbs0uVpgPhxki5c
# 4hFGGEVL1voFZO+73gbKQyW9343JAXRhiNvwx6Y94wxxvH9L58jgbuDagPkAnsBr
# JdWjulwr/sRgIBRKByMx5RrLkUSymntD8VuYtSFLuDE7IlTueWH3mpQbZicqxt/h
# ZV3vcTnmUCX9hzS5rl18JzvnZZP4KISxb4aTLJOTtnCvoe7IpGGphDv7Crf4uG0m
# 7kdO9V4F+pwPEX3Xy5GuQyD3FVljvDCCBrQwggScoAMCAQICEFtwJsyW9ngau4X2
# EfVtu24wDQYJKoZIhvcNAQENBQAwTjELMAkGA1UEBhMCVVMxFjAUBgNVBAoTDUVu
# dHJ1c3QsIEluYy4xJzAlBgNVBAMTHkVudHJ1c3QgVGltZSBTdGFtcGluZyBDQSAt
# IFRTMjAeFw0yNDAxMTkxNjQ3NDdaFw0zNTA0MTgwMDAwMDBaMHUxCzAJBgNVBAYT
# AkNBMRAwDgYDVQQIEwdPbnRhcmlvMQ8wDQYDVQQHEwZPdHRhd2ExFjAUBgNVBAoT
# DUVudHJ1c3QsIEluYy4xKzApBgNVBAMTIkVudHJ1c3QgVGltZXN0YW1wIEF1dGhv
# cml0eSAtIFRTQTIwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQCqhgQ4
# Xo9ov4P1Wv1Um8V9OnWdxKctT23p0AUfUeMzuy9fOrGWVIrpCHw0rYmDVaSfAswj
# C9gbekCkzJ9C6hN/fLjgt0oCBeKDSQRvBobNc0Gpg9SYZ/r0Uhl640pZKIdWF11I
# 8YaRC7giZNtB+V1UtTWkbjjcCA0aVhhAw36YPEIzhA3FpWFRziBtTwDLQvCodRvb
# Rv4p3Bue1/gYBVF2MJt0vZUfGVNlFUcsVmNr6bpIrAo4tsFy/SAKo3Qaawd/0d2s
# F861HMd6iQzsbRwwjQXwrz2XzDW0tQUDZrqedvw52sia1hIS5EHChSJA8Mu6iOnS
# h8KrxjQ75asNAAYOBrWLe9ELIto8qMlWe/A1BJbqWUaMj9SgtamDsM6E+0tE5UGo
# FvOv2tGgJ3DfB+83866RztQhf4aY3F7uj8DaR9tpyhC5kZWAFWPxKxrClqEfwvc8
# 1PZ9JAclqFSUbwpV29skQ24uO6J7Sbu11hiP2QSzvurHtWSaS85SYR4rBR5jN0ad
# scnVXoek6tc0siFCF7g6KDpepe0+/TcXf2Mg8nvWX8rzFD/hzv+Kd5RmbYnB4Ox/
# BHA4ZCf1pxd9TcoMgRvF5fE2xXqufSmkRzU4+g30UwMpBfxvoYvJzfG4iEDT0tue
# JTGt1+Za2AS0hLsERmFm/10y3vzTPnxOGO9+3wIDAQABo4IBZTCCAWEwDAYDVR0T
# AQH/BAIwADAdBgNVHQ4EFgQU9XYa+BCYkqEbd6kALPGVYgILeScwHwYDVR0jBBgw
# FoAUJg/wxEgIG83dkfVUVLazs/yZ8QgwaAYIKwYBBQUHAQEEXDBaMCMGCCsGAQUF
# BzABhhdodHRwOi8vb2NzcC5lbnRydXN0Lm5ldDAzBggrBgEFBQcwAoYnaHR0cDov
# L2FpYS5lbnRydXN0Lm5ldC90czItY2hhaW4yNTYucDdjMDEGA1UdHwQqMCgwJqAk
# oCKGIGh0dHA6Ly9jcmwuZW50cnVzdC5uZXQvdHMyY2EuY3JsMA4GA1UdDwEB/wQE
# AwIHgDAWBgNVHSUBAf8EDDAKBggrBgEFBQcDCDBMBgNVHSAERTBDMDcGCmCGSAGG
# +mwKAQcwKTAnBggrBgEFBQcCARYbaHR0cHM6Ly93d3cuZW50cnVzdC5uZXQvcnBh
# MAgGBmeBDAEEAjANBgkqhkiG9w0BAQ0FAAOCAgEAqat9vxoAhVvc7XEmXpSCr1yC
# S/ocOcVTtcMG3QNgfvlhmkEgwq5BFy6lQgiRCV6XMJiBRdaytYQ9i+mHB9oBP+AI
# WGcRIJQewBaOY3e9m2wFjT21y5oxqUpcYjKiE86QnA3HkE9nw+Cof4eES9fywSEP
# EOcXufu9Ccy+iqYB/k2CT2kgmnVr5A33UCZT/DP3/huup2rAqOseryLTPWAVn7rk
# 1SmktVefsWX2sUxh1dLI2resqhgfIBiKpvj1B/lyK/Zj2CWcFv77lN+GdKIgtPII
# 3xbvOYB2OpKx0JaDatp8U4lZGw1c8bsp8iFPYSwkifh2CX/ZaJCOVwxk1XYAcVnz
# 1ITIPKGIf6hv871uf7CojuaTbOkUxXUcDCvO8gf7ta7UQTG/wcxpmBiuWwiPq1xk
# uYRqvVw4od9PQrdLW1LT3vc7y59vwllCIk4LGLciyC/8agmF7VApUXrElEu2cWWK
# SoaaS3hLVoqh3i+Lk1syzKG576m2DNgGCxcwvw1vj5OsyxH18ccAntAZ15xfjlR8
# a6lDO2PcwUSrvYw6Q/ByPySVzYSRXSEADXhrDVwjJJ9MrzTLFFreseRFUP2vb6cF
# gqdzz8/pkupzKrHh3aID5iC8HWcaVsIu9qxfyk6BsOZaHXPP0hTzUHgoBU4VboUk
# +DOoiK90bfRSzoyohJ4xggQWMIIEEgIBATBiME4xCzAJBgNVBAYTAlVTMRYwFAYD
# VQQKEw1FbnRydXN0LCBJbmMuMScwJQYDVQQDEx5FbnRydXN0IFRpbWUgU3RhbXBp
# bmcgQ0EgLSBUUzICEFtwJsyW9ngau4X2EfVtu24wCwYJYIZIAWUDBAIDoIIBiTAa
# BgkqhkiG9w0BCQMxDQYLKoZIhvcNAQkQAQQwHAYJKoZIhvcNAQkFMQ8XDTI0MDQx
# ODA3MzI1MFowKQYJKoZIhvcNAQk0MRwwGjALBglghkgBZQMEAgOhCwYJKoZIhvcN
# AQENME8GCSqGSIb3DQEJBDFCBED0xObYWcSKDFhor1CSQ+A8aHzkafcFmX4x4gbk
# L3C3iqDNDOcNSF7M02hBxrZIYC64h6Ii6Cmo41Zvgbu/noriMIHQBgsqhkiG9w0B
# CRACLzGBwDCBvTCBujCBtzALBglghkgBZQMEAgMEQDkRQi4XAj6qmSSZdA4OyOjS
# ctNV/Fz2bPkRVq+XVTTkgK/TvHxMW1fv0f+823UUZeDUBVqFTpsROdn37FXV/iQw
# ZjBSpFAwTjELMAkGA1UEBhMCVVMxFjAUBgNVBAoTDUVudHJ1c3QsIEluYy4xJzAl
# BgNVBAMTHkVudHJ1c3QgVGltZSBTdGFtcGluZyBDQSAtIFRTMgIQW3AmzJb2eBq7
# hfYR9W27bjALBgkqhkiG9w0BAQ0EggIAMEeDJp7THWd2vPZCn6P83FnC7JLVf+Ci
# 9fPHc53Guog2Izmc/sgmIJZKeKGk7INN8yZFN/5Zk8YQuWuYcQTBhkDjHw79xjjb
# /8P1PqtuFT3n9AE5voceEl1ShOqvsbLN7sDZnnOzVwu5g7DI2sRrKrP80hn8W6ff
# QJXDv5ytd9Rv2tk66sxmqozlz4DZku0Tf6W54e+ZJEEF66OBJ2w8LkE7muCZnZcJ
# +awC39fFz+hTV4OwG8mqGCMHa0ojCNM2WIqlYBOobei459AFR40Phv6hgddVvt04
# bkWvmNHo0Agrtfi2ZOiYIGvmuAsHK2uBEVrzXtituP8Hzk6Z2RCiO+b3+3zeRSBt
# HKu6hC/scfFG0JyyemwheyzYqAKAiqaSXxdzcdCYEzh6pzNcoAATeENdqH0ftWX9
# muayHYAfBKIDHgXKd4+nXb7C9HCdiBrlo9hL3v81UcRJfGSmEQ8qgq8gBFDxutFm
# yLAiIh7UPxGExnz6CThtftYZWlCIb+SIPX/vlz+iFavgMPxloAR+c0+xp2BXqX+k
# D8c+TnsArnuBCtwIyWcPiQFmsD4auwqlUr31yC8cMXOiiy4YYaIaBiBhm3QQvmnY
# 8sGTLuf54xbmGnjC/i8M52B1dB+guy3vFbTaq2yriryxzQzcMKwNsF2aXZVMhAhl
# KIl1Zx+kY7Y=
# SIG # End signature block
