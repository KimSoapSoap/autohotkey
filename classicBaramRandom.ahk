﻿; 전역적으로 랜덤 값을 추가하는 함수 정의
CustomSleep(SleepTime) {
    Random, RandomValue, 1, 10
    Sleep, SleepTime + RandomValue
}

global StopLoop := false
;루프 중단을 위한 변수. 기본 false
;동작 중(예를 들면 루프) 다른 핫키를 쓰면 다른 핫키 동작 후 다시 기존 핫키로 돌아가는 Stack구조이므로
;핫키를 실행할 땐 변수를 false로, 끝날 땐 true로 해주고 루프구문(보통 루프 돌아가는 중에 다른 핫키 쓰기 때문) 내부의 시작에
;이 변수가 true일 때 break를 걸어준다. 
;그럼 이때 루프 시작에서 break되고 루프를 끝내고 나머지 코드를 실행한다. 나머지 코드는 esc 처리해주는 것이기 때문에 굳

;즉 루프 시작부분에는 StopLoop가 true면 break
; 핫키 시작할 땐 StopLoop := false(루프있다면 -> 루프 내부에 if (StopLoop) 조건이 있을 때 )
; 핫키 끝날 땐 StopLoop := true (동작 후 이전 핫키 루프를 중단하려면)
; 예를들면 동동주 마시는 건 4방향 마비걸 때 마력 없으면 동동주 먹어주면서 마력 보충할 수 있기 때문에 굳이 loopStop을 끝에 넣지 않는다.

Pause::
Suspend Off       ; Suspend 상태에서 동작하도록 강제로 해제
StopLoop := true
Reload
return

\:: ; 오토핫키 중단
Suspend, Toggle
StopLoop := true
return

;최소 sleep은 30은 해주자
;스킬 시전 이후는 70~90은 해야 시전후딜 가능
;shift 조합은 esc로 꼬임방지 이후 sleep 100~120은 해야 눌렀던 shift와 꼬이지 않음



#IfWinActive MapleStory Worlds-옛날바람

NumpadEnter:: ;스페이스 공격
SendInput, { space }
return

+NumpadEnter:: ;줍기
CustomSleep(30)
SendInput, ,
CustomSleep(30)
return



del:: ; 사자후
SendInput, {Esc}
CustomSleep(30)
SendInput, {shift down}
CustomSleep(60)
SendInput, { z }
CustomSleep(60)
SendInput, {shift up}
CustomSleep(60)
SendInput, z ;  z -> 사자후 술사
CustomSleep(40)
StopLoop := true
return



F1:: ; 숫자 1
SendInput, {Blind}1
return


 F2:: ; 동동주 마시기용, a에 동동주
     Loop, 1
     {
        SendInput, {Ctrl Down}
        CustomSleep(30)
        SendInput,a
        CustomSleep(20)
        SendInput,{Ctrl Up}
        CustomSleep(30)
     }
return

F3:: ;자신 선택 & StopLoop
SendInput, {Home}
CustomSleep(20)
StopLoop := true
return


 Numpad1:: ; 자힐 3틱
 SendInput, {Esc}
 CustomSleep(30)
StopLoop := false
     Loop, 4
     {
        if (StopLoop)
            {            
                Break
                CustomSleep(20)
            }
         SendInput, {Blind}1
         CustomSleep(30)
         SendInput, {Home}
         CustomSleep(30)
         SendInput, {Enter}
         CustomSleep(90)
     }
     SendInput, {Esc}
CustomSleep(20)
StopLoop := true
 return

; 자힐 + 첨 할 때 sendInput Esc 뒤에 CustomSleep(20) 하니까 탭탭이 씹히고 30으로 하니까 괜찮더라
;꼬임 방지 esc 뒤에 sleep은 최소 30으로 해준다.

;자힐 + 첨 할 때 어쩓 첨이 계속 써지고 알트탭 해서 나갔다 와야 풀렸는데 ctrl + 5(넘패드5) 하니까 풀렸다

 `:: ; (자힐 3틱x4 + 첨 ) 4~5틱
 SendInput, {Esc}
 CustomSleep(30)
 SendInput, {Tab}
 CustomSleep(30)
 SendInput, {Home}
 CustomSleep(30)
 SendInput, {Tab}
CustomSleep(30)
StopLoop := false
CustomSleep(20)
     Loop, 20
     {
        if (StopLoop)
            {                
                Break
                CustomSleep(20)
            }
        Send, {1}
         CustomSleep(50)
         Send, {5}
         CustomSleep(50)
         Send, {1}
         CustomSleep(50)
         Send, {0}
         CustomSleep(50)
     }
     SendInput, {Esc}
     CustomSleep(40)
     Send,{Numpad5}
     CustomSleep(20)
     StopLoop := true
 return
 
 

 Numpad5:: ; 극진첨 + 진첨
 Send, 5
 CustomSleep(30)
 Send, 0
 CustomSleep(30)
 return


 Numpad0:: ; 극진화열참주,  0은 진화열참주'첨을 5번키에 묶어서 쓸 거라서 numpad0누르면 일단 단일 원거리 마법사용으로
 SendInput, {Esc}
 CustomSleep(30)
 SendInput, {shift down}
 CustomSleep(30)
 SendInput, { z }
 CustomSleep(30)
 SendInput, {shift up}
 CustomSleep(30)
 SendInput, {w} ;  w -> 극진화열참주
 CustomSleep(40)
 StopLoop := true
return



 NumpadRight:: ;절망 (마법자리 Q -> 대초원 가면 마비 안 통해서 마비와 절망 마법자리 교체. 마비=f,)
 SendInput, {Esc}
 CustomSleep(30)
 SendInput, {shift down}
 CustomSleep(60)
 SendInput, { z }
 CustomSleep(100)
 SendInput, {shift up}
 CustomSleep(100)
 SendInput, q ;  q -> 절망
 CustomSleep(40)
 StopLoop := true
return







;NumpadDot::







;저주는 한 번만 돌리면 되니까 그냥 누르면 일단 저주만 돌리게 -> 체마 높아지면 저주 + 첨 돌리는 걸로
;shift 조합으로 저주 + 첨

;중독은 계속 돌려야 되니까 그냥 누르면 중독 + 첨
;shift 조합은 중독만

;shift 조합은 처음에 esc 누르고 CustomSleep(100)~120정도 해주자. 그냥 누르는 건 30.  shift 누르고 sleep 짧게 하니까 자꾸 채팅 쳐짐



;원래는 a였다. (큐센 계산기 모드 c랑 자리 바꿈)
NumpadDot::  ;마비만 돌리기(6번을절망으로 바꾸면 절망 돌리기)
SendInput, {Esc}
CustomSleep(30)
StopLoop := false
loop, 20
{
    if (StopLoop)
        {            
            Break
            CustomSleep(20)
        }
    SendInput, 6
    CustomSleep(30)
    SendInput, { left }
    CustomSleep(30)
    SendInput, { enter }
    CustomSleep(90)
}
SendInput, {Esc}
CustomSleep(20)
StopLoop := true
return

;원래는 +a(shift + a)였다. (큐센 계산기 모드 shift + c랑 자리 바꿈)
NumpadDel::  ;마비 돌리기 + 첨 (6번을절망으로 바꾸면 절망 돌리기 + 첨)
SendInput, {Esc}
CustomSleep(120)
SendInput, {5 Down} ; 5키 눌림
CustomSleep(20)
SendInput, {0 Down} ; 0키 눌림
CustomSleep(20)
StopLoop := false
loop, 20
{
    if (StopLoop)
        {            
            Break
            CustomSleep(20)
        }
    SendInput, 6
    CustomSleep(30)
    SendInput, { left }
    CustomSleep(30)
    SendInput, { enter }
    CustomSleep(90)
}
SendInput, {5 Up} ; 눌린 5 키 해제
CustomSleep(20)
SendInput, {0 Up} ; 눌린 5 키 해제
CustomSleep(20)
StopLoop := true
return



NumpadUp::  ;활력 돌리기 (shift + e -> 큐센 한 손 키보드 계산기모드)
SendInput, {Esc}
CustomSleep(30)
StopLoop := false
loop, 20
    if (StopLoop)
        {            
            Break
            CustomSleep(20)
        }
{
    SendInput, 8
    CustomSleep(30)
    SendInput, { left }
    CustomSleep(30)
    SendInput, { enter }
    CustomSleep(90)
}
SendInput, {Esc}
CustomSleep(20)
StopLoop := true
return






NumpadDiv::  ;중독 돌리기 + 첨
SendInput, {Esc}
CustomSleep(30)
SendInput, {5 Down} ; 5키 눌림
CustomSleep(20)
SendInput, {0 Down} ; 0키 눌림
CustomSleep(20)
StopLoop := false
loop, 20
{
    if (StopLoop)
        {            
            Break
            CustomSleep(20)
        }
    SendInput, 7
    CustomSleep(30)
    SendInput, { left }
    CustomSleep(30)
    SendInput, { enter }
    CustomSleep(90)
}
SendInput, {5 Up} ; 눌린 5 키 해제
CustomSleep(20)
SendInput, {0 Up} ; 눌린 5 키 해제
CustomSleep(20)
SendInput, {Esc}
CustomSleep(20)
StopLoop := true
return




;큐센 오피스 모드에서 중독+첨  s, 그냥 중독만 shift+s  저주만 d,  저주+첨  shift+d,  키 조합이었다
;(오피스 모드에서 s는 NumpadDiv, d는 NumpadMult c는 NumpadDot, shift + c는 NumpadDel, a키는 그냥 a다)
;일단 잠깐 바꿔서 중독 + 첨 s ,  그냥 중독만 d,  저주만 c  저주 + 첨 shift + c 이렇게 한다.
;이 상황에서 shift + s 와  shift + d 는 일단 비어 있다.
;왼손 검지가 공증, 활력, 혼돈, 중독만, 저주만, 4방향 마비 등 사용하는 게 많아서 c 저주만 돌리기와 shift조합으로 첨 조합을 a로
;a는 원래 마비돌리기인데 생각보다 잘 안 써서 c로 내리고 a를 저주만 돌리기로 옮긴다.

;나중에 a마비(절망)돌리기, s중독 돌리기, d 저주 돌리기로 정상화 시켜 주던가 하자.



;shift 조합으로 하려니 새끼손가락 혹사시켜서 자주 쓰는 중독만 돌리는 걸 c로 했는데 저주 돌리기보다 빈도가 높아서
;일단 중독만 돌리기를 d로, 저주를 c, 저주 + 첨을 shift + c로 일단 옮겼다.
;한 번 몰아서 저주는 한 번씩만 돌려주면 되는데 중독은 중간에 마나 상황에 따라 첨 없이 그냥 중독만 돌려야하는 경우도 높아서



; +NumpadDiv 원래 그냥 중독 돌리기가 쉬프트 조합인데(큐센 오피스 +s) 손가락 편의를 위해 NumpadDot (큐센 오피스 모드에서 c키)
NumpadMult::  ;중독만 돌리기
SendInput, {Esc}
CustomSleep(120)
StopLoop := false
loop, 20
{
    if (StopLoop)
        {            
            Break
            CustomSleep(20)
        }
    SendInput, 7
    CustomSleep(30)
    SendInput, { left }
    CustomSleep(30)
    SendInput, { enter }
    CustomSleep(90)
}
SendInput, {Esc}
CustomSleep(20)
StopLoop := true
return



;NumpadDot (큐센 계산기모드) c 였었다.  a와(마비 돌리기) 잠시 교체
a:: ;저주만 돌리기
SendInput, {Esc}
CustomSleep(30)
StopLoop := false
loop, 20
{
    if (StopLoop)
        {            
            Break
            CustomSleep(20)
        }
    SendInput, 4
    CustomSleep(30)
    SendInput, { left }
    CustomSleep(30)
    SendInput, { enter }
    CustomSleep(90)
}
SendInput, {Esc}
CustomSleep(20)
StopLoop := true
return


;NumpadDel (큐센 계산기모드) shift + c 였다. shift + a(마비돌리기 + 첨)와 잠시 교체
+a:: ;저주 돌리기 + 첨
SendInput, {Esc}
CustomSleep(120)
SendInput, {5 Down} 
CustomSleep(20)
SendInput, {0 Down} 
CustomSleep(20)
StopLoop := false
loop, 20
{
    if (StopLoop)
        {            
            Break
            CustomSleep(20)
        }
    SendInput, 4
    CustomSleep(30)
    SendInput, { left }
    CustomSleep(30)
    SendInput, { enter }
    CustomSleep(90)
}
SendInput, {5 Up} 
CustomSleep(20)
SendInput, {0 Up} 
CustomSleep(20)
SendInput, {Esc}
CustomSleep(20)
StopLoop := true
return




NumpadSub:: ;캐릭 4방위 저주 후 마비
SendInput, {Esc}
CustomSleep(30)

SendInput, 4
CustomSleep(30)
SendInput, {Home}
CustomSleep(30)
SendInput, {Left}
CustomSleep(30)
SendInput, {Enter}
CustomSleep(90)
StopLoop := false
loop, 3
    {
        if (StopLoop)
            {            
                Break
                CustomSleep(20)
            }
        SendInput, 6
        CustomSleep(30)
        SendInput, {Enter}
        CustomSleep(90)
    }

SendInput, 4
CustomSleep(30)
SendInput, {Home}
CustomSleep(30)
SendInput,  {Right}
CustomSleep(30)
SendInput, {Enter}
CustomSleep(90)


loop, 3
    {
        if (StopLoop)
            {            
                Break
                CustomSleep(20)
            }
        SendInput, 6
        CustomSleep(30)
        SendInput, {Enter}
        CustomSleep(90)
    }
SendInput, 4
CustomSleep(30)
SendInput, {Home}
CustomSleep(30)
SendInput, {Up}
CustomSleep(30)
SendInput, {Enter}
CustomSleep(90)

loop, 3
    {
        if (StopLoop)
            {            
                Break
                CustomSleep(20)
            }
        SendInput, 6
        CustomSleep(30)
        SendInput, {Enter}
        CustomSleep(90)
    }
SendInput, 4
CustomSleep(30)
SendInput, {Home}
CustomSleep(30)
SendInput, {Down}
CustomSleep(30)
SendInput, {Enter}
CustomSleep(90)

loop, 3
    {
        if (StopLoop)
            {            
                Break
                CustomSleep(20)
            }
        SendInput, 6
        CustomSleep(30)
        SendInput, {Enter}
        CustomSleep(90)
    }
    SendInput, {Esc}
CustomSleep(20)
StopLoop := true
    return






+NumpadSub:: ;캐릭 4방위 마비만 돌리기.
SendInput, {Esc}
CustomSleep(120)
StopLoop := false
    loop, 2
        {
            if (StopLoop)
                {            
                    Break
                    CustomSleep(20)
                }
            SendInput, 6
            CustomSleep(30)
            SendInput, {Home}
            CustomSleep(30)
            SendInput, {Left}
            CustomSleep(30)
            SendInput, {Enter}
            CustomSleep(80)
        }
    
    loop, 2
        {
            if (StopLoop)
                {            
                    Break
                    CustomSleep(20)
                }
            SendInput, 6
            CustomSleep(30)
            SendInput, {Home}
            CustomSleep(30)
            SendInput, {Right}
            CustomSleep(30)
            SendInput, {Enter}
            CustomSleep(80)
        }
    
    loop, 2
        {
            if (StopLoop)
                {            
                    Break
                    CustomSleep(20)
                }
            SendInput, 6
            CustomSleep(30)
            SendInput, {Home}
            CustomSleep(30)
            SendInput, {Up}
            CustomSleep(30)
            SendInput, {Enter}
            CustomSleep(80)
        }
    
    loop, 2
        {
            if (StopLoop)
                {            
                    Break
                    CustomSleep(20)
                }
            SendInput, 6
            CustomSleep(30)
            SendInput, {Home}
            CustomSleep(30)
            SendInput, {Down}
            CustomSleep(30)
            SendInput, {Enter}
            CustomSleep(80)
        }
        SendInput, {Esc}
CustomSleep(20)
StopLoop := true
return
    



end:: ; 셀프 보무 (대문자 X = 보호,  소문자 x = 무장)
SendInput, {Esc}
CustomSleep(30)
SendInput, {shift down}
CustomSleep(40)
SendInput, { z }
CustomSleep(40)
SendInput, { x } ; 대문자 x -> 보호, 쉬프트 up을 해주기 전에 x 눌러서 대문자임
CustomSleep(40)
SendInput, {shift up}
CustomSleep(40)
SendInput, { home }
CustomSleep(40)
SendInput, { enter }
CustomSleep(70)

SendInput, {shift down}
CustomSleep(40)
SendInput, { z }
CustomSleep(40)
SendInput, {shift up}
CustomSleep(40)
SendInput, { x } ; 소문자 x -> 무장
CustomSleep(40)
SendInput, { home }
CustomSleep(40)
SendInput, { enter }
CustomSleep(70)
SendInput, {Esc}
CustomSleep(20)
StopLoop := true
return


#If
    
