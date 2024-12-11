Pause::
Suspend Off       ; Suspend 상태에서 동작하도록 강제로 해제
Reload
return

\:: ; 오토핫키 중단
Suspend, Toggle
return


#IfWinActive MapleStory Worlds-옛날바람

NumpadEnter:: ;스페이스 공격
SendInput, { space }
return

+NumpadEnter:: ;줍기
SendInput, ,
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


 NumpadRight:: ;절망 (마법자리 Q -> 대초원 가면 마비 안 통해서 마비와 절망 마법자리 교체. 마비=f,)
 SendInput, {Esc}
 sleep,30
 SendInput, {shift down}
 sleep, 60
 SendInput, { z }
 sleep, 100
 SendInput, {Q} ;  q -> 절망
 sleep, 100
 SendInput, {shift up}
 sleep, 40
return




 NumpadHome:: ;혼돈(마법자리 W)
 SendInput, {Esc}
 sleep,30
 SendInput, {shift down}
 sleep, 60
 SendInput, { z }
 sleep, 100
 Send, {w} ;  w -> 혼돈
 sleep, 100
  SendInput, {shift up}
 sleep, 40
return


;NumpadDot::







;지금 사용하는 건 첨첨사냥을 위해 첨첨 버튼 누른 상태로 만듦



a::  ;마비 돌리기 + 첨
SendInput, {Esc}
sleep,30
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

+a::  ;마비만 돌리기
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

NumpadUp::  ;활력 돌리기 (shift + e -> 큐센 한 손 키보드 계산기모드)
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


+NumpadDiv::  ;중독만 돌리기
SendInput, {Esc}
sleep,30
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



NumpadMult:: ;저주 돌리기 + 첨
SendInput, {Esc}
sleep,30
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

+NumpadMult:: ;저주만 돌리기
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
sleep,30
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
