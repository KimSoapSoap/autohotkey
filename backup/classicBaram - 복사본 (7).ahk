Pause::
Suspend Off       ; Suspend 상태에서 동작하도록 강제로 해제
Reload
return

\:: ; 오토핫키 중단
Suspend, Toggle
return


;최소 sleep은 30은 해주자
;스킬 시전 이후는 70~90은 해야 시전후딜 가능
;shift 조합은 esc로 꼬임방지 이후 sleep 100~120은 해야 눌렀던 shift와 꼬이지 않음



#IfWinActive MapleStory Worlds-옛날바람

NumpadEnter:: ;스페이스 공격
SendInput, { space }
return

+NumpadEnter:: ;줍기
SendInput, ,
return

del:: ; 사자후
SendInput, {Esc}
sleep,30
SendInput, {shift down}
sleep, 60
SendInput, { z }
sleep, 60
SendInput, {shift up}
sleep, 60
SendInput, z ;  z -> 사자후 술사
sleep, 40
return



F1:: ; 숫자 1
SendInput, {Blind}1
return


 F2:: ; 동동주 마시기용, a에 동동주
     Loop, 1
     {
        SendInput, {Ctrl Down}
        Sleep, 30
        SendInput,a
        Sleep, 20
        SendInput,{Ctrl Up}
        Sleep, 30
     }
return

F3:: home ;자신 선택


 Numpad1:: ; 자힐 3틱
 SendInput, {Esc}
 sleep,30
     Loop, 4
     {
         SendInput, {Blind}1
         Sleep, 30
         SendInput, {Home}
         Sleep, 30
         SendInput, {Enter}
         Sleep, 90
     }
     SendInput, {Esc}
sleep,20
 return

; 자힐 + 첨 할 때 sendInput Esc 뒤에 sleep, 20 하니까 탭탭이 씹히고 30으로 하니까 괜찮더라
;꼬임 방지 esc 뒤에 sleep은 최소 30으로 해준다.

;자힐 + 첨 할 때 어쩓 첨이 계속 써지고 알트탭 해서 나갔다 와야 풀렸는데 ctrl + 5(넘패드5) 하니까 풀렸다

 `:: ; (자힐 3틱x4 + 첨 ) 4~5틱
 SendInput, {Esc}
 sleep,30
 SendInput, {Tab}
 sleep,30
 SendInput, {Home}
 Sleep, 30
 SendInput, {Tab}
sleep,30
     Loop, 20
     {
        Send, {1}
         Sleep, 50
         Send, {5}
         Sleep, 50
         Send, {1}
         Sleep, 50
         Send, {0}
         Sleep, 50
     }
     SendInput, {Esc}
     sleep,40
     Send,{Numpad5}
     sleep,20
 return
 
 

 Numpad5:: ; 극진첨 + 진첨
 Send, 5
 sleep,30
 Send, 0
 sleep,30
 return


 Numpad0:: ; 극진화열참주,  0은 진화열참주'첨을 5번키에 묶어서 쓸 거라서 numpad0누르면 일단 단일 원거리 마법사용으로
 SendInput, {Esc}
 sleep,30
 SendInput, {shift down}
 sleep, 30
 SendInput, { z }
 sleep, 30
 SendInput, {shift up}
 sleep, 30
 SendInput, {w} ;  w -> 극진화열참주
 sleep, 40
return



 NumpadRight:: ;절망 (마법자리 Q -> 대초원 가면 마비 안 통해서 마비와 절망 마법자리 교체. 마비=f,)
 SendInput, {Esc}
 sleep,30
 SendInput, {shift down}
 sleep, 60
 SendInput, { z }
 sleep, 100
 SendInput, {shift up}
 sleep, 100
 SendInput, q ;  q -> 절망
 sleep, 40
return







;NumpadDot::







;저주는 한 번만 돌리면 되니까 그냥 누르면 일단 저주만 돌리게 -> 체마 높아지면 저주 + 첨 돌리는 걸로
;shift 조합으로 저주 + 첨

;중독은 계속 돌려야 되니까 그냥 누르면 중독 + 첨
;shift 조합은 중독만

;shift 조합은 처음에 esc 누르고 sleep, 100~120정도 해주자. 그냥 누르는 건 30.  shift 누르고 sleep 짧게 하니까 자꾸 채팅 쳐짐


a::  ;마비만 돌리기
SendInput, {Esc}
sleep,30
loop, 20
{
    SendInput, 6
    sleep, 30
    SendInput, { left }
    sleep, 30
    SendInput, { enter }
    sleep, 90
}
SendInput, {Esc}
sleep,20
return


+a::  ;마비 돌리기 + 첨
SendInput, {Esc}
sleep,120
SendInput, {5 Down} ; 5키 눌림
sleep,20
SendInput, {0 Down} ; 0키 눌림
sleep,20
loop, 20
{
    SendInput, 6
    sleep, 30
    SendInput, { left }
    sleep, 30
    SendInput, { enter }
    sleep, 90
}
SendInput, {5 Up} ; 눌린 5 키 해제
sleep,20
SendInput, {0 Up} ; 눌린 5 키 해제
sleep,20
return



NumpadUp::  ;활력 돌리기 (shift + e -> 큐센 한 손 키보드 계산기모드)
SendInput, {Esc}
sleep,30
loop, 20
{
    SendInput, 8
    sleep, 30
    SendInput, { left }
    sleep, 30
    SendInput, { enter }
    sleep, 90
}
SendInput, {Esc}
sleep,20
return






NumpadDiv::  ;중독 돌리기 + 첨
SendInput, {Esc}
sleep,30
SendInput, {5 Down} ; 5키 눌림
sleep,20
SendInput, {0 Down} ; 0키 눌림
sleep,20
loop, 20
{
    SendInput, 7
    sleep, 30
    SendInput, { left }
    sleep, 30
    SendInput, { enter }
    sleep, 90
}
SendInput, {5 Up} ; 눌린 5 키 해제
sleep,20
SendInput, {0 Up} ; 눌린 5 키 해제
sleep,20
SendInput, {Esc}
sleep,20
return


;큐센 오피스 모드에서 중독+첨  s, 그냥 중독만 shift+s  저주만 d,  저주+첨  shift+d,  키 조합이었다
;(오피스 모드에서 s는 NumpadDiv, d는 NumpadMult c는 NumpadDot)
;일단 잠깐 바꿔서 중독 + 첨 s ,  그냥 중독만 d,  저주만 c  저주 + 첨 shift + c 이렇게 한다.
;이 상황에서 shift + s 와  shift + d 는 일단 비어 있다.

;shift 조합으로 하려니 새끼손가락 혹사시켜서 자주 쓰는 중독만 돌리는 걸 c로 했는데 저주 돌리기보다 빈도가 높아서
;일단 중독만 돌리기를 d로, 저주를 c, 저주 + 첨을 shift + c로 일단 옮겼다.
;한 번 몰아서 저주는 한 번씩만 돌려주면 되는데 중독은 중간에 마나 상황에 따라 첨 없이 그냥 중독만 돌려야하는 경우도 높아서



; +NumpadDiv 원래 그냥 중독 돌리기가 쉬프트 조합인데(큐센 오피스 +s) 손가락 편의를 위해 NumpadDot (큐센 오피스 모드에서 c키)
NumpadMult::  ;중독만 돌리기
SendInput, {Esc}
sleep,120
loop, 20
{
    SendInput, 7
    sleep, 30
    SendInput, { left }
    sleep, 30
    SendInput, { enter }
    sleep, 90
}
SendInput, {Esc}
sleep,20
return




NumpadDot:: ;저주만 돌리기
SendInput, {Esc}
sleep,30
loop, 20
{
    SendInput, 4
    sleep, 30
    SendInput, { left }
    sleep, 30
    SendInput, { enter }
    sleep, 90
}
SendInput, {Esc}
sleep,20
return



+NumpadDot:: ;저주 돌리기 + 첨
SendInput, {Esc}
sleep,120
SendInput, {5 Down} 
sleep,20
SendInput, {0 Down} 
sleep,20
loop, 20
{
    SendInput, 4
    sleep, 30
    SendInput, { left }
    sleep, 30
    SendInput, { enter }
    sleep, 90
}
SendInput, {5 Up} 
sleep,20
SendInput, {0 Up} 
sleep,20
SendInput, {Esc}
sleep,20
return




NumpadSub:: ;캐릭 4방위 저주 후 마비
SendInput, {Esc}
sleep,30

SendInput, 4
Sleep, 30
SendInput, {Home}
Sleep, 30
SendInput, {Left}
sleep, 30
SendInput, {Enter}
Sleep, 90
loop, 3
    {
        SendInput, 6
        Sleep, 30
        SendInput, {Enter}
        Sleep, 90
    }

SendInput, 4
Sleep, 30
SendInput, {Home}
Sleep, 30
SendInput,  {Right}
sleep, 30
SendInput, {Enter}
Sleep, 90


loop, 3
    {
        SendInput, 6
        Sleep, 30
        SendInput, {Enter}
        Sleep, 90
    }
SendInput, 4
Sleep, 30
SendInput, {Home}
Sleep, 30
SendInput, {Up}
sleep, 30
SendInput, {Enter}
Sleep, 90

loop, 3
    {
        SendInput, 6
        Sleep, 30
        SendInput, {Enter}
        Sleep, 90
    }
SendInput, 4
Sleep, 30
SendInput, {Home}
Sleep, 30
SendInput, {Down}
sleep, 30
SendInput, {Enter}
Sleep, 90

loop, 3
    {
        SendInput, 6
        Sleep, 30
        SendInput, {Enter}
        Sleep, 90
    }
    SendInput, {Esc}
sleep,20
    return






+NumpadSub:: ;캐릭 4방위 마비만 돌리기.
SendInput, {Esc}
sleep,120
    loop, 2
        {
            SendInput, 6
            Sleep, 30
            SendInput, {Home}
            Sleep, 30
            SendInput, {Left}
            sleep, 30
            SendInput, {Enter}
            Sleep, 80
        }
    
    loop, 2
        {
            SendInput, 6
            Sleep, 30
            SendInput, {Home}
            Sleep, 30
            SendInput, {Right}
            sleep, 30
            SendInput, {Enter}
            Sleep, 80
        }
    
    loop, 2
        {
            SendInput, 6
            Sleep, 30
            SendInput, {Home}
            Sleep, 30
            SendInput, {Up}
            sleep, 30
            SendInput, {Enter}
            Sleep, 80
        }
    
    loop, 2
        {
            SendInput, 6
            Sleep, 30
            SendInput, {Home}
            Sleep, 30
            SendInput, {Down}
            sleep, 30
            SendInput, {Enter}
            Sleep, 80
        }
        SendInput, {Esc}
sleep,20
return
    



end:: ; 셀프 보무 (대문자 X = 보호,  소문자 x = 무장)
SendInput, {Esc}
sleep,30
SendInput, {shift down}
sleep, 40
SendInput, { z }
sleep, 40
SendInput, { x } ; 대문자 x -> 보호, 쉬프트 up을 해주기 전에 x 눌러서 대문자임
sleep, 40
SendInput, {shift up}
sleep, 40
SendInput, { home }
sleep, 40
SendInput, { enter }
sleep, 70

SendInput, {shift down}
sleep, 40
SendInput, { z }
sleep, 40
SendInput, {shift up}
sleep, 40
SendInput, { x } ; 소문자 x -> 무장
sleep, 40
SendInput, { home }
sleep, 40
SendInput, { enter }
sleep, 70
SendInput, {Esc}
sleep,20
return


#If
    


/*
보관용
c는 NumpadDot이다


Numpad1:: ; 자힐 몇번
SendInput, {Esc}
sleep,20
    Loop, 4
    {
        SendInput, 1
        Sleep, 30
        SendInput, {Home}
        Sleep, 30
        SendInput, {Enter}
        Sleep, 90
    }
return


;아래에는 ctrl + 숫자키로 자기자신에게 시전이 가능할 때 사용하던 것


Numpad1:: ; 자힐 몇번
 SendInput, {Esc}
 sleep,20
     Loop, 4
     {
        SendInput, {Ctrl Down}
        Sleep, 30
        SendInput,1
        Sleep, 60
        SendInput,{Ctrl Up}
        Sleep, 60
     }
 return

 `:: ; 자힐 많이
 SendInput, {Esc}
 sleep,20
     Loop, 24
     {
        SendInput, {Ctrl Down}
        Sleep, 30
        SendInput,1
        Sleep, 60
        SendInput,{Ctrl Up}
        Sleep, 60
     }
     SendInput, {Esc}
     sleep,30
 return





;마비 중독 저주 돌릴 때 그냥 돌리는 거 백업
;지금 사용하는 건 첨첨사냥을 위해 첨첨 버튼 누른 상태로 만듦


 

a::  ;마비 돌리기
SendInput, {Esc}
sleep,20
loop, 20
{
    SendInput, 6
    sleep, 30
    SendInput, { left }
    sleep, 30
    SendInput, { enter }
    sleep, 90
}
return

NumpadUp::  ;활력 돌리기
SendInput, {Esc}
sleep,20
loop, 20
{
    SendInput, 8
    sleep, 30
    SendInput, { left }
    sleep, 30
    SendInput, { enter }
    sleep, 90
}
return


NumpadDiv::  ;중독 돌리기
SendInput, {Esc}
sleep,20
loop, 20
{
    SendInput, 7
    sleep, 30
    SendInput, { left }
    sleep, 30
    SendInput, { enter }
    sleep, 90
}
return


NumpadMult:: ;저주 돌리기
SendInput, {Esc}
sleep,20
loop, 20
{
    SendInput, 4
    sleep, 30
    SendInput, { left }
    sleep, 30
    SendInput, { enter }
    sleep, 90
}
return






NumpadSub:: ;캐릭 4방위 활력 저주 후 마비
SendInput, {Esc}
sleep,30

SendInput, 8
Sleep, 30
SendInput, {Home}
Sleep, 30
SendInput, {Left}
sleep, 30
SendInput, {Enter}
Sleep, 100
SendInput, 4
sleep, 30
SendInput, {Enter}
Sleep, 90
loop, 3
    {
        SendInput, 6
        Sleep, 30
        SendInput, {Enter}
        Sleep, 90
    }

SendInput, 8
Sleep, 30
SendInput, {Home}
Sleep, 30
SendInput,  {Right}
sleep, 30
SendInput, {Enter}
Sleep, 100
SendInput, 4
sleep, 30
SendInput, {Enter}
Sleep, 90


loop, 3
    {
        SendInput, 6
        Sleep, 30
        SendInput, {Enter}
        Sleep, 90
    }
SendInput, 8
Sleep, 30
SendInput, {Home}
Sleep, 30
SendInput, {Up}
sleep, 30
SendInput, {Enter}
Sleep, 100
SendInput, 4
sleep, 30
SendInput, {Enter}
Sleep, 90

loop, 3
    {
        SendInput, 6
        Sleep, 30
        SendInput, {Enter}
        Sleep, 90
    }
SendInput, 8
Sleep, 30
SendInput, {Home}
Sleep, 30
SendInput, {Down}
sleep, 30
SendInput, {Enter}
Sleep, 100
SendInput, 4
sleep, 30
SendInput, {Enter}
Sleep, 90

loop, 3
    {
        SendInput, 6
        Sleep, 30
        SendInput, {Enter}
        Sleep, 90
    }
    SendInput, {Esc}
sleep,20
    return




NumpadSub:: ;캐릭 4방위 활력 후 마비
SendInput, {Esc}
sleep,20

SendInput, 8
Sleep, 30
SendInput, {Home}
Sleep, 30
SendInput, {Left}
sleep, 30
SendInput, {Enter}
Sleep, 90
loop, 3
    {
        SendInput, 6
        Sleep, 30
        SendInput, {Enter}
        Sleep, 90
    }

SendInput, 8
Sleep, 30
SendInput, {Home}
Sleep, 30
SendInput,  {Right}
sleep, 30
SendInput, {Enter}
Sleep, 90

loop, 3
    {
        SendInput, 6
        Sleep, 30
        SendInput, {Enter}
        Sleep, 90
    }
SendInput, 8
Sleep, 30
SendInput, {Home}
Sleep, 30
SendInput, {Up}
sleep, 30
SendInput, {Enter}
Sleep, 90

loop, 3
    {
        SendInput, 6
        Sleep, 30
        SendInput, {Enter}
        Sleep, 90
    }
SendInput, 8
Sleep, 30
SendInput, {Home}
Sleep, 30
SendInput, {Down}
sleep, 30
SendInput, {Enter}
Sleep, 90

loop, 3
    {
        SendInput, 6
        Sleep, 30
        SendInput, {Enter}
        Sleep, 90
    }
    return






+NumpadSub:: ;캐릭 4방위 마비만.
    loop, 2
        {
            SendInput, 6
            Sleep, 30
            SendInput, {Home}
            Sleep, 30
            SendInput, {Left}
            sleep, 30
            SendInput, {Enter}
            Sleep, 80
        }
    
    loop, 2
        {
            SendInput, 6
            Sleep, 30
            SendInput, {Home}
            Sleep, 30
            SendInput, {Right}
            sleep, 30
            SendInput, {Enter}
            Sleep, 80
        }
    
    loop, 2
        {
            SendInput, 6
            Sleep, 30
            SendInput, {Home}
            Sleep, 30
            SendInput, {Up}
            sleep, 30
            SendInput, {Enter}
            Sleep, 80
        }
    
    loop, 2
        {
            SendInput, 6
            Sleep, 30
            SendInput, {Home}
            Sleep, 30
            SendInput, {Down}
            sleep, 30
            SendInput, {Enter}
            Sleep, 80
        }
return
    



end:: ; 셀프 보무
SendInput, {Esc}
sleep,30
SendInput, {shift down}
sleep, 40
SendInput, { z }
sleep, 40
SendInput, { x } ; 대문자 x -> 보호, 쉬프트 up을 해주기 전에 x 눌러서 대문자임
sleep, 40
SendInput, {shift up}
sleep, 40
SendInput, { home }
sleep, 40
SendInput, { enter }
sleep, 70

SendInput, {shift down}
sleep, 40
SendInput, { z }
sleep, 40
SendInput, {shift up}
sleep, 40
SendInput, { x } ; 소문자 x -> 무장
sleep, 40
SendInput, { home }
sleep, 40
SendInput, { enter }
sleep, 70
return


*/
