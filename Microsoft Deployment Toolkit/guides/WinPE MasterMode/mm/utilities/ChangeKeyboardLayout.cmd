@ECHO OFF

:SELECT
CLS
ECHO ================================================
ECHO    Hiren's BootCD PE
ECHO    Change Keyboard Layout v1.0.0
ECHO    https://www.hirensbootcd.org/
ECHO =================================================
ECHO.

:: ===================================================================================
:: = Known Bugs =
:: ===================================================================================
:: The languages below returns "The command failed with status 0x80074005." error.
:: This seems a known problem: http://web.archive.org/web/20180520092436/http://archives.miloush.net/michkap/archive/2011/11/23/10240896.html

:: 92. Lisu (Basic) (Wpeutil SetKeyboardLayout 0c00:00070c00)
:: 93. Lisu (Standard) (Wpeutil SetKeyboardLayout 0c00:00080c00)
:: 107. Myanmar (Wpeutil SetKeyboardLayout 0c00:00010c00)
:: 108. N'Ko (Wpeutil SetKeyboardLayout 0c00:00090c00)
:: 110. New Tai Lue (Wpeutil SetKeyboardLayout 0c00:00020c00)
:: 114. Ogham (Wpeutil SetKeyboardLayout 0c00:00040c00)
:: 118. Phags-pa (Wpeutil SetKeyboardLayout 0c00:000a0c00)
:: 156. Tai Le (Wpeutil SetKeyboardLayout 0c00:00030c00)
:: 166. Tifinagh (Basic) (Wpeutil SetKeyboardLayout 0c00:00050c00)
:: 167. Tifinagh (Extended) (Wpeutil SetKeyboardLayout 0c00:00060c00)

:: ===================================================================================


ECHO 1. Albanian
ECHO 2. Arabic (101)
ECHO 3. Arabic (102)
ECHO 4. Arabic (102) AZERTY
ECHO 5. Armenian Eastern (Legacy)
ECHO 6. Armenian Phonetic
ECHO 7. Armenian Typewriter
ECHO 8. Armenian Western (Legacy)
ECHO 9. Assamese - INSCRIPT
ECHO 10. Azeri Cyrillic
ECHO 11. Azeri Latin
ECHO 12. Bashkir
ECHO 13. Belarusian
ECHO 14. Belgian (Comma)
ECHO 15. Belgian (Period)
ECHO 16. Belgian French
ECHO 17. Bengali
ECHO 18. Bengali - INSCRIPT
ECHO 19. Bengali - INSCRIPT (Legacy)
ECHO 20. Bosnian (Cyrillic)
ECHO 21. Bulgarian
ECHO 22. Bulgarian (Latin)
ECHO 23. Bulgarian (Phonetic Traditional)
ECHO 24. Bulgarian (Phonetic)
ECHO 25. Bulgarian (Typewriter)
ECHO 26. Canadian French
ECHO 27. Canadian French (Legacy)
ECHO 28. Canadian Multilingual Standard
ECHO 29. Central Kurdish
ECHO 30. Cherokee Nation
ECHO 31. Cherokee Phonetic
ECHO 32. Chinese (Simplified) - US
ECHO 33. Chinese (Simplified, Singapore) - US
ECHO 34. Chinese (Traditional) - US
ECHO 35. Chinese (Traditional, Hong Kong S.A.R.) - US
ECHO 36. Chinese (Traditional, Macao S.A.R.) - US
ECHO 37. Czech
ECHO 38. Czech (QWERTY)
ECHO 39. Czech Programmers
ECHO 40. Danish
ECHO 41. Devanagari - INSCRIPT
ECHO 42. Divehi Phonetic
ECHO 43. Divehi Typewriter
ECHO 44. Dutch
ECHO 45. English (India)
ECHO 46. Estonian
ECHO 47. Faeroese
ECHO 48. Finnish
ECHO 49. Finnish with Sami
ECHO 50. French
ECHO 51. Georgian (Ergonomic)
ECHO 52. Georgian (Legacy)
ECHO 53. Georgian (MES)
ECHO 54. Georgian (Old Alphabets)
ECHO 55. Georgian (QWERTY)
ECHO 56. German
ECHO 57. German (IBM)
ECHO 58. Greek
ECHO 59. Greek (220)
ECHO 60. Greek (220) Latin
ECHO 61. Greek (319)
ECHO 62. Greek (319) Latin
ECHO 63. Greek Latin
ECHO 64. Greek Polytonic
ECHO 65. Greenlandic
ECHO 66. Gujarati
ECHO 67. Hausa
ECHO 68. Hawaiian
ECHO 69. Hebrew
ECHO 70. Hebrew (Standard)
ECHO 71. Hindi Traditional
ECHO 72. Hungarian
ECHO 73. Hungarian 101-key
ECHO 74. Icelandic
ECHO 75. Igbo
ECHO 76. Inuktitut - Latin
ECHO 77. Inuktitut - Naqittaut
ECHO 78. Irish
ECHO 79. Italian
ECHO 80. Italian (142)
ECHO 81. Japanese
ECHO 82. Kannada
ECHO 83. Kazakh
ECHO 84. Khmer
ECHO 85. Khmer (NIDA)
ECHO 86. Korean
ECHO 87. Kyrgyz Cyrillic
ECHO 88. Lao
ECHO 89. Latin American
ECHO 90. Latvian
ECHO 91. Latvian (QWERTY)
ECHO 92. Lisu (Basic)
ECHO 93. Lisu (Standard)
ECHO 94. Lithuanian
ECHO 95. Lithuanian IBM
ECHO 96. Lithuanian Standard
ECHO 97. Luxembourgish
ECHO 98. Macedonian (FYROM)
ECHO 99. Macedonian (FYROM) - Standard
ECHO 100. Malayalam
ECHO 101. Maltese 47-Key
ECHO 102. Maltese 48-Key
ECHO 103. Maori
ECHO 104. Marathi
ECHO 105. Mongolian (Mongolian Script)
ECHO 106. Mongolian Cyrillic
ECHO 107. Myanmar
ECHO 108. N'Ko
ECHO 109. Nepali
ECHO 110. New Tai Lue
ECHO 111. Norwegian
ECHO 112. Norwegian with Sami
ECHO 113. Odia
ECHO 114. Ogham
ECHO 115. Pashto (Afghanistan)
ECHO 116. Persian
ECHO 117. Persian (Standard)
ECHO 118. Phags-pa
ECHO 119. Polish (214)
ECHO 120. Polish (Programmers)
ECHO 121. Portuguese
ECHO 122. Portuguese (Brazil ABNT)
ECHO 123. Portuguese (Brazil ABNT2)
ECHO 124. Punjabi
ECHO 125. Romanian (Legacy)
ECHO 126. Romanian (Programmers)
ECHO 127. Romanian (Standard)
ECHO 128. Russian
ECHO 129. Russian (Typewriter)
ECHO 130. Russian - Mnemonic
ECHO 131. Sakha
ECHO 132. Sami Extended Finland-Sweden
ECHO 133. Sami Extended Norway
ECHO 134. Scottish Gaelic
ECHO 135. Serbian (Cyrillic)
ECHO 136. Serbian (Latin)
ECHO 137. Sesotho sa Leboa
ECHO 138. Setswana
ECHO 139. Sinhala
ECHO 140. Sinhala - Wij 9
ECHO 141. Slovak
ECHO 142. Slovak (QWERTY)
ECHO 143. Slovenian
ECHO 144. Sorbian Extended
ECHO 145. Sorbian Standard
ECHO 146. Sorbian Standard (Legacy)
ECHO 147. Spanish
ECHO 148. Spanish Variation
ECHO 149. Standard
ECHO 150. Swedish
ECHO 151. Swedish with Sami
ECHO 152. Swiss French
ECHO 153. Swiss German
ECHO 154. Syriac
ECHO 155. Syriac Phonetic
ECHO 156. Tai Le
ECHO 157. Tajik
ECHO 158. Tamil
ECHO 159. Tatar (Legacy)
ECHO 160. Telugu
ECHO 161. Thai Kedmanee
ECHO 162. Thai Kedmanee (non-ShiftLock)
ECHO 163. Thai Pattachote
ECHO 164. Thai Pattachote (non-ShiftLock)
ECHO 165. Tibetan (PRC)
ECHO 166. Tifinagh (Basic)
ECHO 167. Tifinagh (Extended)
ECHO 168. Turkish F
ECHO 169. Turkish Q
ECHO 170. Turkmen
ECHO 171. Ukrainian
ECHO 172. Ukrainian (Enhanced)
ECHO 173. United Kingdom
ECHO 174. United Kingdom Extended
ECHO 175. United States-Dvorak
ECHO 176. United States-Dvorak for left hand
ECHO 177. United States-Dvorak for right hand
ECHO 178. United States-International
ECHO 179. Urdu
ECHO 180. US (Default)
ECHO 181. US English Table for IBM Arabic 238_L
ECHO 182. Uyghur
ECHO 183. Uyghur (Legacy)
ECHO 184. Uzbek Cyrillic
ECHO 185. Vietnamese
ECHO 186. Wolof
ECHO 187. Yoruba
ECHO 0. EXIT

ECHO.
SET /p ChoosedLanguage=Choose a language: 

IF %ChoosedLanguage% == 0 GOTO E
IF %ChoosedLanguage% GEQ 1 IF %ChoosedLanguage% LEQ 187 GOTO %ChoosedLanguage%

GOTO SELECT

:1
Wpeutil SetKeyboardLayout 041c:0000041c&GOTO DONE
:2
Wpeutil SetKeyboardLayout 0401:00000401&GOTO DONE
:3
Wpeutil SetKeyboardLayout 0401:00010401&GOTO DONE
:4
Wpeutil SetKeyboardLayout 0401:00020401&GOTO DONE
:5
Wpeutil SetKeyboardLayout 042b:0000042b&GOTO DONE
:6
Wpeutil SetKeyboardLayout 042b:0002042b&GOTO DONE
:7
Wpeutil SetKeyboardLayout 042b:0003042b&GOTO DONE
:8
Wpeutil SetKeyboardLayout 042b:0001042b&GOTO DONE
:9
Wpeutil SetKeyboardLayout 044d:0000044d&GOTO DONE
:10
Wpeutil SetKeyboardLayout 082c:0000082c&GOTO DONE
:11
Wpeutil SetKeyboardLayout 042c:0000042c&GOTO DONE
:12
Wpeutil SetKeyboardLayout 046d:0000046d&GOTO DONE
:13
Wpeutil SetKeyboardLayout 0423:00000423&GOTO DONE
:14
Wpeutil SetKeyboardLayout 080c:0001080c&GOTO DONE
:15
Wpeutil SetKeyboardLayout 0813:00000813&GOTO DONE
:16
Wpeutil SetKeyboardLayout 080c:0000080c&GOTO DONE
:17
Wpeutil SetKeyboardLayout 0445:00000445&GOTO DONE
:18
Wpeutil SetKeyboardLayout 0445:00020445&GOTO DONE
:19
Wpeutil SetKeyboardLayout 0445:00010445&GOTO DONE
:20
Wpeutil SetKeyboardLayout 201a:0000201a&GOTO DONE
:21
Wpeutil SetKeyboardLayout 0402:00030402&GOTO DONE
:22
Wpeutil SetKeyboardLayout 0402:00010402&GOTO DONE
:23
Wpeutil SetKeyboardLayout 0402:00040402&GOTO DONE
:24
Wpeutil SetKeyboardLayout 0402:00020402&GOTO DONE
:25
Wpeutil SetKeyboardLayout 0402:00000402&GOTO DONE
:26
Wpeutil SetKeyboardLayout 1009:00001009&GOTO DONE
:27
Wpeutil SetKeyboardLayout 0c0c:00000c0c&GOTO DONE
:28
Wpeutil SetKeyboardLayout 1009:00011009&GOTO DONE
:29
Wpeutil SetKeyboardLayout 0492:00000492&GOTO DONE
:30
Wpeutil SetKeyboardLayout 045c:0000045c&GOTO DONE
:31
Wpeutil SetKeyboardLayout 045c:0001045c&GOTO DONE
:32
Wpeutil SetKeyboardLayout 0804:00000804&GOTO DONE
:33
Wpeutil SetKeyboardLayout 1004:00001004&GOTO DONE
:34
Wpeutil SetKeyboardLayout 0404:00000404&GOTO DONE
:35
Wpeutil SetKeyboardLayout 0c04:00000c04&GOTO DONE
:36
Wpeutil SetKeyboardLayout 1404:00001404&GOTO DONE
:37
Wpeutil SetKeyboardLayout 0405:00000405&GOTO DONE
:38
Wpeutil SetKeyboardLayout 0405:00010405&GOTO DONE
:39
Wpeutil SetKeyboardLayout 0405:00020405&GOTO DONE
:40
Wpeutil SetKeyboardLayout 0406:00000406&GOTO DONE
:41
Wpeutil SetKeyboardLayout 0439:00000439&GOTO DONE
:42
Wpeutil SetKeyboardLayout 0465:00000465&GOTO DONE
:43
Wpeutil SetKeyboardLayout 0465:00010465&GOTO DONE
:44
Wpeutil SetKeyboardLayout 0413:00000413&GOTO DONE
:45
Wpeutil SetKeyboardLayout 4009:00004009&GOTO DONE
:46
Wpeutil SetKeyboardLayout 0425:00000425&GOTO DONE
:47
Wpeutil SetKeyboardLayout 0438:00000438&GOTO DONE
:48
Wpeutil SetKeyboardLayout 040b:0000040b&GOTO DONE
:49
Wpeutil SetKeyboardLayout 083b:0001083b&GOTO DONE
:50
Wpeutil SetKeyboardLayout 040c:0000040c&GOTO DONE
:51
Wpeutil SetKeyboardLayout 0437:00020437&GOTO DONE
:52
Wpeutil SetKeyboardLayout 0437:00000437&GOTO DONE
:53
Wpeutil SetKeyboardLayout 0437:00030437&GOTO DONE
:54
Wpeutil SetKeyboardLayout 0437:00040437&GOTO DONE
:55
Wpeutil SetKeyboardLayout 0437:00010437&GOTO DONE
:56
Wpeutil SetKeyboardLayout 0407:00000407&GOTO DONE
:57
Wpeutil SetKeyboardLayout 0407:00010407&GOTO DONE
:58
Wpeutil SetKeyboardLayout 0408:00000408&GOTO DONE
:59
Wpeutil SetKeyboardLayout 0408:00010408&GOTO DONE
:60
Wpeutil SetKeyboardLayout 0408:00030408&GOTO DONE
:61
Wpeutil SetKeyboardLayout 0408:00020408&GOTO DONE
:62
Wpeutil SetKeyboardLayout 0408:00040408&GOTO DONE
:63
Wpeutil SetKeyboardLayout 0408:00050408&GOTO DONE
:64
Wpeutil SetKeyboardLayout 0408:00060408&GOTO DONE
:65
Wpeutil SetKeyboardLayout 046f:0000046f&GOTO DONE
:66
Wpeutil SetKeyboardLayout 0447:00000447&GOTO DONE
:67
Wpeutil SetKeyboardLayout 0468:00000468&GOTO DONE
:68
Wpeutil SetKeyboardLayout 0475:00000475&GOTO DONE
:69
Wpeutil SetKeyboardLayout 040d:0000040d&GOTO DONE
:70
Wpeutil SetKeyboardLayout 040d:0002040d&GOTO DONE
:71
Wpeutil SetKeyboardLayout 0439:00010439&GOTO DONE
:72
Wpeutil SetKeyboardLayout 040e:0000040e&GOTO DONE
:73
Wpeutil SetKeyboardLayout 040e:0001040e&GOTO DONE
:74
Wpeutil SetKeyboardLayout 040f:0000040f&GOTO DONE
:75
Wpeutil SetKeyboardLayout 0470:00000470&GOTO DONE
:76
Wpeutil SetKeyboardLayout 085d:0000085d&GOTO DONE
:77
Wpeutil SetKeyboardLayout 045d:0001045d&GOTO DONE
:78
Wpeutil SetKeyboardLayout 1809:00001809&GOTO DONE
:79
Wpeutil SetKeyboardLayout 0410:00000410&GOTO DONE
:80
Wpeutil SetKeyboardLayout 0410:00010410&GOTO DONE
:81
Wpeutil SetKeyboardLayout 0411:00000411&GOTO DONE
:82
Wpeutil SetKeyboardLayout 044b:0000044b&GOTO DONE
:83
Wpeutil SetKeyboardLayout 043f:0000043f&GOTO DONE
:84
Wpeutil SetKeyboardLayout 0453:00000453&GOTO DONE
:85
Wpeutil SetKeyboardLayout 0453:00010453&GOTO DONE
:86
Wpeutil SetKeyboardLayout 0412:00000412&GOTO DONE
:87
Wpeutil SetKeyboardLayout 0440:00000440&GOTO DONE
:88
Wpeutil SetKeyboardLayout 0454:00000454&GOTO DONE
:89
Wpeutil SetKeyboardLayout 080a:0000080a&GOTO DONE
:90
Wpeutil SetKeyboardLayout 0426:00000426&GOTO DONE
:91
Wpeutil SetKeyboardLayout 0426:00010426&GOTO DONE
:92
Wpeutil SetKeyboardLayout 0c00:00070c00&GOTO DONE
:93
Wpeutil SetKeyboardLayout 0c00:00080c00&GOTO DONE
:94
Wpeutil SetKeyboardLayout 0427:00010427&GOTO DONE
:95
Wpeutil SetKeyboardLayout 0427:00000427&GOTO DONE
:96
Wpeutil SetKeyboardLayout 0427:00020427&GOTO DONE
:97
Wpeutil SetKeyboardLayout 046e:0000046e&GOTO DONE
:98
Wpeutil SetKeyboardLayout 042f:0000042f&GOTO DONE
:99
Wpeutil SetKeyboardLayout 042f:0001042f&GOTO DONE
:100
Wpeutil SetKeyboardLayout 044c:0000044c&GOTO DONE
:101
Wpeutil SetKeyboardLayout 043a:0000043a&GOTO DONE
:102
Wpeutil SetKeyboardLayout 043a:0001043a&GOTO DONE
:103
Wpeutil SetKeyboardLayout 0481:00000481&GOTO DONE
:104
Wpeutil SetKeyboardLayout 044e:0000044e&GOTO DONE
:105
Wpeutil SetKeyboardLayout 0850:00000850&GOTO DONE
:106
Wpeutil SetKeyboardLayout 0450:00000450&GOTO DONE
:107
Wpeutil SetKeyboardLayout 0c00:00010c00&GOTO DONE
:108
Wpeutil SetKeyboardLayout 0c00:00090c00&GOTO DONE
:109
Wpeutil SetKeyboardLayout 0461:00000461&GOTO DONE
:110
Wpeutil SetKeyboardLayout 0c00:00020c00&GOTO DONE
:111
Wpeutil SetKeyboardLayout 0414:00000414&GOTO DONE
:112
Wpeutil SetKeyboardLayout 043b:0000043b&GOTO DONE
:113
Wpeutil SetKeyboardLayout 0448:00000448&GOTO DONE
:114
Wpeutil SetKeyboardLayout 0c00:00040c00&GOTO DONE
:115
Wpeutil SetKeyboardLayout 0463:00000463&GOTO DONE
:116
Wpeutil SetKeyboardLayout 0429:00000429&GOTO DONE
:117
Wpeutil SetKeyboardLayout 0429:00050429&GOTO DONE
:118
Wpeutil SetKeyboardLayout 0c00:000a0c00&GOTO DONE
:119
Wpeutil SetKeyboardLayout 0415:00010415&GOTO DONE
:120
Wpeutil SetKeyboardLayout 0415:00000415&GOTO DONE
:121
Wpeutil SetKeyboardLayout 0816:00000816&GOTO DONE
:122
Wpeutil SetKeyboardLayout 0416:00000416&GOTO DONE
:123
Wpeutil SetKeyboardLayout 0416:00010416&GOTO DONE
:124
Wpeutil SetKeyboardLayout 0446:00000446&GOTO DONE
:125
Wpeutil SetKeyboardLayout 0418:00000418&GOTO DONE
:126
Wpeutil SetKeyboardLayout 0418:00020418&GOTO DONE
:127
Wpeutil SetKeyboardLayout 0418:00010418&GOTO DONE
:128
Wpeutil SetKeyboardLayout 0419:00000419&GOTO DONE
:129
Wpeutil SetKeyboardLayout 0419:00010419&GOTO DONE
:130
Wpeutil SetKeyboardLayout 0419:00020419&GOTO DONE
:131
Wpeutil SetKeyboardLayout 0485:00000485&GOTO DONE
:132
Wpeutil SetKeyboardLayout 083b:0002083b&GOTO DONE
:133
Wpeutil SetKeyboardLayout 043b:0001043b&GOTO DONE
:134
Wpeutil SetKeyboardLayout 1809:00011809&GOTO DONE
:135
Wpeutil SetKeyboardLayout 0c1a:00000c1a&GOTO DONE
:136
Wpeutil SetKeyboardLayout 081a:0000081a&GOTO DONE
:137
Wpeutil SetKeyboardLayout 046c:0000046c&GOTO DONE
:138
Wpeutil SetKeyboardLayout 0432:00000432&GOTO DONE
:139
Wpeutil SetKeyboardLayout 045b:0000045b&GOTO DONE
:140
Wpeutil SetKeyboardLayout 045b:0001045b&GOTO DONE
:141
Wpeutil SetKeyboardLayout 041b:0000041b&GOTO DONE
:142
Wpeutil SetKeyboardLayout 041b:0001041b&GOTO DONE
:143
Wpeutil SetKeyboardLayout 0424:00000424&GOTO DONE
:144
Wpeutil SetKeyboardLayout 042e:0001042e&GOTO DONE
:145
Wpeutil SetKeyboardLayout 042e:0002042e&GOTO DONE
:146
Wpeutil SetKeyboardLayout 042e:0000042e&GOTO DONE
:147
Wpeutil SetKeyboardLayout 040a:0000040a&GOTO DONE
:148
Wpeutil SetKeyboardLayout 040a:0001040a&GOTO DONE
:149
Wpeutil SetKeyboardLayout 041a:0000041a&GOTO DONE
:150
Wpeutil SetKeyboardLayout 041d:0000041d&GOTO DONE
:151
Wpeutil SetKeyboardLayout 083b:0000083b&GOTO DONE
:152
Wpeutil SetKeyboardLayout 100c:0000100c&GOTO DONE
:153
Wpeutil SetKeyboardLayout 0807:00000807&GOTO DONE
:154
Wpeutil SetKeyboardLayout 045a:0000045a&GOTO DONE
:155
Wpeutil SetKeyboardLayout 045a:0001045a&GOTO DONE
:156
Wpeutil SetKeyboardLayout 0c00:00030c00&GOTO DONE
:157
Wpeutil SetKeyboardLayout 0428:00000428&GOTO DONE
:158
Wpeutil SetKeyboardLayout 0449:00000449&GOTO DONE
:159
Wpeutil SetKeyboardLayout 0444:00000444&GOTO DONE
:160
Wpeutil SetKeyboardLayout 044a:0000044a&GOTO DONE
:161
Wpeutil SetKeyboardLayout 041e:0000041e&GOTO DONE
:162
Wpeutil SetKeyboardLayout 041e:0002041e&GOTO DONE
:163
Wpeutil SetKeyboardLayout 041e:0001041e&GOTO DONE
:164
Wpeutil SetKeyboardLayout 041e:0003041e&GOTO DONE
:165
Wpeutil SetKeyboardLayout 0451:00000451&GOTO DONE
:166
Wpeutil SetKeyboardLayout 0c00:00050c00&GOTO DONE
:167
Wpeutil SetKeyboardLayout 0c00:00060c00&GOTO DONE
:168
Wpeutil SetKeyboardLayout 041f:0001041f&GOTO DONE
:169
Wpeutil SetKeyboardLayout 041f:0000041f&GOTO DONE
:170
Wpeutil SetKeyboardLayout 0442:00000442&GOTO DONE
:171
Wpeutil SetKeyboardLayout 0422:00000422&GOTO DONE
:172
Wpeutil SetKeyboardLayout 0422:00020422&GOTO DONE
:173
Wpeutil SetKeyboardLayout 0809:00000809&GOTO DONE
:174
Wpeutil SetKeyboardLayout 0452:00000452&GOTO DONE
:175
Wpeutil SetKeyboardLayout 0409:00010409&GOTO DONE
:176
Wpeutil SetKeyboardLayout 0409:00030409&GOTO DONE
:177
Wpeutil SetKeyboardLayout 0409:00040409&GOTO DONE
:178
Wpeutil SetKeyboardLayout 0409:00020409&GOTO DONE
:179
Wpeutil SetKeyboardLayout 0420:00000420&GOTO DONE
:180
Wpeutil SetKeyboardLayout 0409:00000409&GOTO DONE
:181
Wpeutil SetKeyboardLayout 0409:00050409&GOTO DONE
:182
Wpeutil SetKeyboardLayout 0480:00010480&GOTO DONE
:183
Wpeutil SetKeyboardLayout 0480:00000480&GOTO DONE
:184
Wpeutil SetKeyboardLayout 0843:00000843&GOTO DONE
:185
Wpeutil SetKeyboardLayout 042a:0000042a&GOTO DONE
:186
Wpeutil SetKeyboardLayout 0488:00000488&GOTO DONE
:187
Wpeutil SetKeyboardLayout 046a:0000046a&GOTO DONE


:DONE
ECHO Please close and re-open the applications you are using for the language change to take effect.
PAUSE

:E
