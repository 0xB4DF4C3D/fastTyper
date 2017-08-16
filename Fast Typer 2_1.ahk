#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
Menu, Tray, NoStandard
#SingleInstance, force




CurLine := 1
Cur := 1
Cur2 := 1
Gui, 1:Add, Edit, w500 R20 -Wrap gType2 vMyText ,Type here what you want 
Gui, 1:Add, Text, , HotKey :
Gui, 1:Add, Edit, x+m yp limit1 gHotkey vHotkey, 0
Gui, 1:Add, CheckBox, x+m yp+5 gAllKey vAllKey, All Key
Gui, 1:Add, Text, x+m yp vIdx w200 , Current Index : %Cur% (T)
Gui, 1:Add, Text,xm , Method : 
Gui, 1:Add, Radio, vone x+m yp Checked, one by one
Gui, 1:Add, Radio, vline x+m yp, line
Gui, 1:Add, Radio, vrandom x+m yp, random
Gui, 1:Add, Radio, vsep x+m yp, sep :
Gui, 1:Add, Edit, x+1 yp limit1 vdelim,%A_Space%
Gui, 1:Add, Button,gRESET x+m yp-20 w50 h40, RESET
Gui, 1:Add, Button,gHelp x+m yp w50 h40, HELP
Gui, 1:Add, Text, x10, Setting : 
Gui, 1:Add, CheckBox,x+m yp vRepeat, Repeat
Gui, 1:Add, CheckBox,vNoDelim x+m yp , No-Delim

Gui, 1:Show,,Fast Typer
Gui, Submit, NoHide

Loop 95
{
   tmpHk := "$" . Chr(A_Index+31)
   HotKey %tmpHk%, Type 
   HotKey %tmpHk%, Off
}
Hk := 0
HotKey, $0, On
tmpHk := "$0"
prevHk := tmpHk


return

Help:
helpstr = 
(
안녕하세요 이 프로그램은 취미로 만들어 본 것입니다. 이름은 Fast Typer 라고 지었는데요.
좀 구리죠? 여튼 설명을 하겠습니다.

1. Type here~ 라고 써져있는 칸에 자기가 쓸 말을 미리 적습니다.

2. 다음은 밑에 HotKey인데요 그 옆에 지정해둔 문자를 누르면 미리 썻던 말들이 쳐집니다. 
   옆에 All Keys를 체크하시면 아무키나 누르셔도 됩니다. (그러나 너무 빨리 치면 꼬입니다.)

3. 그 다음 밑에 Method 가 있는데요. 

   one by one : 한글자 한글자씩 출력합니다.
   line : 줄 별로 출력합니다.
   random : 랜덤하게 1~5글자씩 출력합니다.
   sep : 옆에 지정한 문자를 구분자로 하여 출력합니다. 보통 스페이스바로 해놓는게 좋아요

지정한 키를 눌러서 출력이 될때마다 Current Index값이 증가하게 되는데 이는 컨트롤키 + 백스페이스
로 감소시키거나 RESET 버튼을 눌러서 초기화 시킬 수 있습니다. 
그 외 여러 체크박스 들이 있는데요.
   
   repeat : 마지막 까지 출력했을 시 처음으로 돌아갑니다.
   no-delim : sep 모드로 출력할 시 구분자는 출력하지 않습니다.


여담으로 Method를 sep으로 맞춘다음 학번과 수강번호등등을 미리 적어두면 수강 신청 매크로로도 쓸 수 있겠죠?

★ 왠만하면 출력할 곳의 한영 설정을 영어로 해두세요!★ 
)
Gui, 2:Add, Text, , %HelpStr%
Gui, 2:Show, , Help
return

AllKey:
Gui, Submit, NoHide
if(AllKey == 1)
{
GuiControl,Disable,HotKey

Loop 95
{
   tmpHk := "$" . Chr(A_Index+31)
   HotKey %tmpHk%, On
}

GuiControlGet, Hk, ,Hotkey
Hotkey, $%Hk%, On

Return 

}
else
{
GuiControl,Enable,HotKey

Loop 95
{
   tmpHk := "$" . Chr(A_Index+31)
   HotKey %tmpHk%, Off
}

GuiControlGet, Hk, ,Hotkey
Hotkey, $%Hk%, On

}

return

delim:
Gui, Submit, NoHide


return

RESET:
CurLine := 1
Cur := 1
Cur2 := 1
Gui, Submit, NoHide
ch := SubStr(myText, Cur , 1) 
IdxTxt := "Current Index : " . Cur . " (" . ch . ")"
GuiControl, ,Idx,%IdxTxt%
return

Hotkey:
Hotkey, %tmpHk%, Off
GuiControlGet, Hk, ,Hotkey
tmpHk := "$" . Hk

Try
{

    Hotkey, %tmpHk%, On

}
Catch e
{
MsgBox,,ㄷㄷ What the error, 아무래도 그 단축키는 적절하지 않은것 같군요`n(이 메세지는 자동으로 9초후 파괴됩니다`.),9
tmpHk := prevHk
return
}
prevHk := tmpHk
return

Type:
Gui, Submit, NoHide
if(one==1)
{
ch := SubStr(myText, Cur , 1) 
if(ch <> "")
{
ch2 := SubStr(myText, Cur+1 , 1) 
IdxTxt := "Current Index : " . Cur . " (" . ch2 . ")"
SendRaw , %ch%
GuiControl, ,Idx,%IdxTxt%
Cur += 1
}
else
{
 if(Repeat == 1)
{
Cur2 := 1
Cur := 1
}
}
}
if(line==1)
{
if(Cur2 <> 0)
{
 Cur2 := InStr(myText, "`n" , false, Cur, 1)
 if(Cur2 <> 0)
 {
 ch := SubStr(myText, Cur , Cur2 - Cur)
 Cur := Cur2+1
 }
 else
 {
 ch := SubStr(myText, Cur)
 if(Repeat == 1)
{
Cur2 := 1
Cur := 1
}
 }
SendRaw , %ch%
Send, `n
ch2 := SubStr(myText, Cur2+1 , 5)
IdxTxt := "Current Index : " . Cur . " (" . ch2 . "...)"
GuiControl, ,Idx,%IdxTxt%

}
}
if(random==1)
{
Random, RR , 1, 5
ch := SubStr(myText, Cur , RR) 
if(ch <> "")
{

ch2 := SubStr(myText, Cur+RR , 1) 
Cur += RR
IdxTxt := "Current Index : " . Cur . " (" . ch2 . ")"
SendRaw , %ch%
GuiControl, ,Idx,%IdxTxt%
}
else
{
 if(Repeat == 1)
{
Cur2 := 1
Cur := 1
}
}
}
if(sep==1)
{
if(Cur2 <> 0)
{
 Cur2 := RegExMatch(myText, delim , , Cur)
 if(Cur2 <> 0)
 {
 ch :=  SubStr(myText, Cur , NoDelim ? Cur2 - Cur : Cur2+1 - Cur)
 Cur := Cur2+1
 }
 else
 {
 ch := SubStr(myText, Cur)
 if(Repeat == 1)
{
Cur2 := 1
Cur := 1
}
 }
SendRaw , %ch%
ch2 := SubStr(myText, Cur2+1 , 5)
IdxTxt := "Current Index : " . Cur . " (" . ch2 . "...)"
GuiControl, ,Idx,%IdxTxt%

}

}
return

Type2:
Gui, Submit, NoHide


cLen := StrLen(myText)
if(cLen < Cur and 1 < Cur )
Cur := cLen

ch := SubStr(myText, Cur , 1)
IdxTxt := "Current Index : " . Cur . " (" . ch . ")"
GuiControl, ,Idx,%IdxTxt%
return

^BS::
Gui, Submit, NoHide
if(Cur > 1)
Cur -= 1
Send, {BS}
ch := SubStr(myText, Cur , 1)
IdxTxt := "Current Index : " . Cur . " (" . ch . ")"
GuiControl, ,Idx,%IdxTxt%
return

GuiClose:
Gui, Destroy
ExitApp
return
