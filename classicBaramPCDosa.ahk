﻿global StopLoop := false
;루프 중단을 위한 변수. 기본 false
;동작 중(예를 들면 루프) 다른 핫키를 쓰면 다른 핫키 동작 후 다시 기존 핫키로 돌아가는 Stack구조이므로
;핫키를 실행할 땐 변수를 false로, 끝날 땐 true로 해주고 루프구문(보통 루프 돌아가는 중에 다른 핫키 쓰기 때문) 내부의 시작에
;이 변수가 true일 때 break를 걸어준다. 
;그럼 이때 루프 시작에서 break되고 루프를 끝내고 나머지 코드를 실행한다. 나머지 코드는 esc 처리해주는 것이기 때문에 굳

;각종 스킬구조를 함수로 바꿨고 단축키는 이 함수를 실행하는 것으로 바꿨는데
;StopLoop를 true로 해주는 건 함수 끝에 하면 종합 자동이 복잡하게 돼서 함수 실행하는 핫키에 넣어준다.(실행했을 때 이전 루프끝내려면)

; 즉 루프 시작부분에는 StopLoop가 true면 break
; 핫키 시작할 땐 StopLoop := false(루프있다면 -> 루프 내부에 if (StopLoop) 조건이 있을 때 )
; 핫키 끝날 땐 StopLoop := true (동작 후 이전 핫키 루프를 중단하려면)
; 예를들면 동동주 마시는 건 4방향 마비걸 때 마력 없으면 동동주 먹어주면서 마력 보충할 수 있기 때문에 굳이 loopStop을 끝에 넣지 않는다.

global ManaRefresh := 0
global FourWayMabi := 0


; 전역적으로 랜덤 값을 추가하는 함수 정의
CustomSleep(SleepTime) {
    Random, RandomValue, 1, 10
    Sleep, SleepTime + RandomValue
}


StopLoopCheck() {
    if (StopLoop)
        {            
            SendInput, {Esc}
            CustomSleep(20)   
            Exit  
        }
}


*::
Suspend Off       ; Suspend 상태에서 동작하도록 강제로 해제
StopLoop := true
Reload
return

\:: ; 오토핫키 중단, 중간에 단축키 중단하고 사자후 날릴 때 쓰려고 StopLoop는 제외함
Suspend, Toggle
;StopLoop := true    
return

CapsLock::
Pause
return


;최소 sleep은 30은 해주자. 누락 방지.
;스킬 시전 이후는 70~90은 해야 시전후딜 가능
;shift 조합은 esc로 꼬임방지 이후 sleep 100~120은 해야 눌렀던 shift와 꼬이지 않음

#IfWinActive MapleStory Worlds-옛날바람



; 중독사냥 종합
;보무, (4방향 마비저주주 + 중독 돌리기 4번) x4 이후 중독첨2 저주첨2 자힐첨2
;이것도 맨 처음 한 번은 중독2에 저주2 어떨까 싶음
v::
PoisonChumHunt()
StopLoop := true
return

PoisonChumHunt() {
SendInput, {Esc}
CustomSleep(30)
StopLoop := false
Loop,1 ;일단 한 번
    
    {
    StopLoopCheck()   
    SelfBoMu() ; 자신 보무
    CustomSleep(30),

    Loop , 4  ; 다음 과정 4번 반복 ((자힐x2+ 마비) x1 + 중독 돌리기 4번)

    {       
        StopLoopCheck()
        Loop, 1 ; 자힐 + 4방향 마비&저주 
            ;-> 4방향 마비저주 한 번만 해서 중독 애매하게 몇마리리 남은채로 다시 중독 돌리는 이슈
            { 
            StopLoopCheck()
            Loop, 2
            {
                SelfHeal() ; 자힐 3틱
                CustomSleep(50)
            }            
            ;FourWayCurseAndParalysis() ;4방향 마비
            CustomSleep(1500) ;위의 중독몹 몇마리 남은채로 다시 중독 돌리는 거 슬립시간으로 조정시도
        }
        

        Loop,4 ;중독 돌리는 회수
            {
            StopLoopCheck()
            SpreadPoison() ;중독만 돌리기
            CustomSleep(30)
            }
        CustomSleep(1000) ; 중독 좀 돌리고 다시 자힐하기 전 잠시 대기 ;원래 1200이었음
        }

    

        Loop, 1 ; (공증 + 중독첨 x2  + 저주첨x2, 공증) 1번 -> 중독첨2 저주첨2 중독첨1 자힐첨2로 변경경
            {                 


            Loop,2 ; 중독첨. 
            {
                StopLoopCheck()
                SpreadPoisonAndChum()() 
                CustomSleep(30)
            }
            Loop,2 ; 저주첨. 
                {
                    StopLoopCheck()
                    SpreadCurseAndChum()
                    CustomSleep(30)
                }

            Loop,1 ; 중독첨. 
                {
                    StopLoopCheck()
                    SpreadPoisonAndChum()() 
                    CustomSleep(30)
                }
            Loop, 1 ;공증
                {
                    StopLoopCheck()
                    DrinkDongDongJu()
                    CustomSleep(30)
                    SendInput, 3 ; 공증(실패해도 됨)
                    CustomSleep(30)
                    SelfHeal() ; 자힐 3틱
                    CustomSleep(50)
                }

            Loop,2 ; 자힐첨 -> 딸피 마무리
                {            
                StopLoopCheck()
                TabTabHeal() 
                CustomSleep(30)
                }
            }
    }
CustomSleep(30)
return
}




g:: ;중독첨첨 사냥 종합합
; 보무 걸고 (4방향 마비저주, 중독첨2, 저주첨2)x1   (공증, 중독첨2+자힐첨1)x4

SendInput, {Esc}
CustomSleep(30)
StopLoop := false
ManaRefresh := 0
FourWayMabi := 0

CustomSleep(30)
Loop,1 ;일단 한 번
    
    {
    StopLoopCheck()   
    SelfBoMu() ; 자신 보무
    CustomSleep(30),

    Loop, 1 ; 일단 처음에는 저주 돌려야 하니까 4방향 마비&저주 걸고 중독2, 저주2
            ; -> 중첨첨 사냥은 중독첨2, 저주첨2
            ; 초반 첫 4방향 저주마비 이후 중독첨2, 저주첨2로 딸피되기 때문에 다음턴 마비 없이 진행
            ; 0으로 시작하는 FourWayMabi 변수가 중독첨2+자힐첨1 반복마다 1씩 올라가는데
            ; 홀수일 때 마비 건다. 0이 시작이고 이때는 첫 4방향 마비저주 걸린 상태므로 패스.
        {       
            StopLoopCheck()
            Loop, 1 ; 자힐 + 4방향 마비&저주
                { 
                StopLoopCheck()
                Loop, 1
                    {
                    SelfHeal() ; 자힐 3틱
                    CustomSleep(50)
                    }            
                ;FourWayCurseAndParalysis() ;4방향 마비, 마비 삑날까봐
                CustomSleep(50)
                }
            
            Loop,2 ;중독첨 돌리는 횟수
                {
                StopLoopCheck()
            
                SpreadPoisonAndChum() ; 중독첨2
                CustomSleep(30)
                }

            Loop,2 ;저주첨 돌리는 횟수
                {
                StopLoopCheck()
                SpreadCurseAndChum() ; 저주첨2
                CustomSleep(30)
                }

            CustomSleep(1100) 
        }
    


    Loop , 4  ; 다음 과정 4번 반복 ((자힐x2+ 마비) x1 + 중독첨2 저주첨1 자힐첨1) x4
        ;그냥 중독사냥이 아니라 중독첨첨이라 빨리 잡는 것이 목적이므로 
    ;   힐량증가 마력비례 1% 패치로 첫 4방향 마비저주 외에는 마비 없이 간다.
        ;마비 딜레이 신경 안 써도 되니 첫 마비이후 중독첨2 자힐첨1로 딜레이 맞췄는데 이제는 중독첨2 저주첨1 자힐첨1 하면 될듯
    {       
        StopLoopCheck()
        Loop, 1 ; 자힐 + 4방향 마비&저주 -> 마비 진행 일단 주석처리
            { 
            StopLoopCheck()
            
            Loop, 2 ; 자힐 횟수
            {
                SelfHeal() ; 자힐 3틱
                CustomSleep(50)
            }
             ;if (Mod(FourWayMabi, 2) == 1) ;홀수 일 때만 마비 진행.
                ;{  
                ;FourWayCurseAndParalysis() ;4방향 마비, 마비 삑날까봐
                ;}
            CustomSleep(100)
        }
        

        Loop,2 ;중독첨
            {
            StopLoopCheck()
            SpreadPoisonAndChum() ;중독첨 돌리기
            CustomSleep(30)
            }

        Loop,1 ;저주첨 
            {
            StopLoopCheck()
            SpreadCurseAndChum() ; 저주첨 돌리기
            CustomSleep(30)
            }


            
        Loop, 1 ; 공증 (짝수마다 하려고 했는데 마나 부족해서 그냥 매번 하다가 마비 홀수만 해서 공증도 홀수만 맞춤)
            ;공증 실패하면 마나 부족 이슈
            ;   
            {
            if (Mod(ManaRefresh, 2) == 1)
                {            
                    SendInput, {Esc}
                    CustomSleep(20)  
                    StopLoopCheck()
                    CustomSleep(30)
                    SendInput, 3 ; 공증(실패해도 됨)
                    CustomSleep(30)
                    SelfHeal() ; 자힐 3틱
                    CustomSleep(50)    
                }

            ManaRefresh++     
            }

        Loop,1 ; 자힐첨
            {            
            StopLoopCheck()
            TabTabHeal() 
            CustomSleep(30)
            }

        FourWayMabi++
        CustomSleep(1100) ; 매크로 체크방지 1초
        }

        Loop, 1 ; (공증 + 중독&첨 x4  + 자힐첨x2) 1번
            {
            StopLoopCheck()
            DrinkDongDongJu()
            CustomSleep(30)
            SendInput, 3 ; 공증(실패해도 됨)
            CustomSleep(30)
            SelfHeal() ; 자힐 3틱
            CustomSleep(50)


            Loop,4 ; 중독첨. 풀피상태여서 자힐첨 2번보다 중독첨2 + 자힐첨1 이렇게 가자.
            {
                StopLoopCheck()
                SpreadPoisonAndChum()() 
                CustomSleep(30)
            }

            Loop,2 ; 셀프힐 + 첨 횟수 조정(일단 1) -> 딸피 마무리
                {            
                StopLoopCheck()
                TabTabHeal() 
                CustomSleep(30)
                }
            }
    }
CustomSleep(30)
StopLoop := true
ManaRefresh := 0
FourWayMabi := 0
return




b:: ;쩔용 중독 저주 마비 돌리기
SendInput, {Esc}
CustomSleep(30)
StopLoop := false
Loop,1 ;일단 한 번
    
    {
    StopLoopCheck()   
    SelfBoMu() ; 자신 보무
    CustomSleep(30),

    Loop , 6  ; 다음 과정 6번 반복. 중독 마비 저주

    {       
        StopLoopCheck()
        Loop, 1 ; 자힐 (쩔용 전체 마비 들어가므로 4방향 마비&저주 임시 제외)            
            { 
            StopLoopCheck()
            Loop, 2
            {
                SelfHeal() ; 자힐 3틱
                CustomSleep(50)
            }            
            ;FourWayCurseAndParalysis() ;4방향 마비
            CustomSleep(50) ;위의 중독몹 몇마리 남은채로 다시 중독 돌리는 거 슬립시간으로 조정시도. 중독 저주 마비 돌리느라 1500에서 50으로
        }
        

        Loop,2 ;중독 돌리는 회수
            {
            StopLoopCheck()
            SpreadPoison() ;중독만 돌리기
            CustomSleep(30)
            }
        Loop,2 ;저주 돌리는 회수
            {
            StopLoopCheck()
            SpreadParalysis() ;마비만 돌리기
            CustomSleep(30)
            }

        Loop,2 ;저주 돌리는 회수
            {
            StopLoopCheck()
            SpreadHonmaLeft() ;저주만 돌리기
            CustomSleep(30)
            }

        CustomSleep(50) ; 4방향 마비를 위한 후딜 조정. 원래 1200이었음
        }
    }
    CustomSleep(30)
    StopLoop := true
    return








~x:: ;줍기
CustomSleep(30)
SendInput, {ShiftDown}
CustomSleep(30)
SendInput, {,}
CustomSleep(30)
SendInput, {ShiftUp}
CustomSleep(30)
return




+space:: ;줍기
CustomSleep(30)
SendInput, ,
CustomSleep(30)
return



Del:: ; 사자후
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
return



F1:: ; 숫자 1
SendInput, {Blind}1
CustomSleep(30)
return


 F2:: ; 동동주 마시기용, a에 동동주
 DrinkDongDongJu()
 return

 DrinkDongDongJu() { ;동동주 마시기용, a에 동동주
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
 }


F3:: ;자신 선택 & StopLoop
SendInput, {Home}
CustomSleep(20)
StopLoop := true ; 각각의 함수들이 루프시작에 StopLoop가true일 경우 break를 해주기 때문에 중간에 썼을 때 멈추려면 써준다.
return


1:: ; 자힐 3틱
SelfHeal()
StopLoop := true
return

 SelfHeal() {
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
    return
}


+1::
SendInput, {Blind}1
return

+2::
SendInput, {Blind}2
return

; sendInput Esc 뒤에 CustomSleep(20) 하니까 탭탭이 씹히고 30으로 하니까 괜찮더라
;꼬임 방지 esc 뒤에 sleep은 최소 30으로 해준다.

;도사용 탭탭힐

2:: ; 빨탭 탭탭힐
TabTabHeal()
StopLoop := true
return

 TabTabHeal() {
    SendInput, {Esc}
    CustomSleep(30)
    SendInput, {Tab}
    CustomSleep(30)
    SendInput, {Tab}
    CustomSleep(30)
    StopLoop := false
    CustomSleep(20)

    Loop, 30
    {
        if (StopLoop)
            {                
                Break
                CustomSleep(20)
            }
        Send, {1}
        CustomSleep(50)
        ;Send, {5}
        ;CustomSleep(50)
        Send, {1}
        CustomSleep(50)
        ;Send, {0}
        ;CustomSleep(50)
        Send, {1}
        CustomSleep(50)
    }
    SendInput, {Esc}
    CustomSleep(40)
    return
}
 
 

 

q::6 ;마비
w::7 ;중독
e::8 ;활력


+e::  ;활력 돌리기 (shift + e -> 큐센 한 손 키보드 계산기모드)
SpreadVitality()
StopLoop := true
return


SpreadVitality() { ;활력 돌리기
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
return
}


r::9 ;혼돈

 +r::
 CustomSleep(120)
 SendInput, {Blind}r
 return



 t:: ; 극진화열참주,  0은 진화열참주'첨을 5번키에 묶어서 쓸 거라서 numpad0누르면 일단 단일 원거리 마법사용으로
 UltimateBlazingSlash()
 StopLoop := true
 return
 

 UltimateBlazingSlash() {
    SendInput, {Esc}
    CustomSleep(40)
    SendInput, {shift down}
    CustomSleep(40)
    SendInput, { z }
    CustomSleep(40)
    SendInput, {shift up}
    CustomSleep(40)
    SendInput, {w} ;  w -> 극진화열참주
    CustomSleep(40)
    StopLoop := true
    return
 }



 +q:: ;절망 (마법자리 Q -> 대초원 가면 마비 안 통해서 마비와 절망 마법자리 교체. 마비=f,)
 Despair()
 return

Despair() {  ;절망
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
    return
 }







;NumpadDot::







;저주는 한 번만 돌리면 되니까 그냥 누르면 일단 저주만 돌리게 -> 체마 높아지면 저주 + 첨 돌리는 걸로
;shift 조합으로 저주 + 첨

;중독은 계속 돌려야 되니까 그냥 누르면 중독 + 첨
;shift 조합은 중독만

;shift 조합은 처음에 esc 누르고 CustomSleep(100)~120정도 해주자. 그냥 누르는 건 30.  shift 누르고 sleep 짧게 하니까 자꾸 채팅 쳐짐



;지금은 c(큐센 계산기 모드. 원래는 a였다.)
c::  ;마비만 돌리기(6번을절망으로 바꾸면 절망 돌리기)
SpreadParalysis()
StopLoop := true
return

SpreadParalysis() {
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
    return
}


; shift + c (큐센 계산기 모드. 원래는 shift + a였다)
+c::  ;마비 돌리기 + 첨 (6번을절망으로 바꾸면 절망 돌리기 + 첨)
SpreadParalysisAndChum()
StopLoop := true
return

SpreadParalysisAndChum() { ;마비 돌리기 + 첨
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
    return
}






^s:: ; 상태창
CustomSleep(190)
SendInput, {Blind}s
return


SpreadPoisonAndChum() ;중독 돌리기 + 첨
    {
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
    return
}



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




SpreadPoison() ;중독만 돌리기
{
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
    return
}




a:: ;혼마만 돌리기(왼쪽)
SpreadHonmaLeft()
StopLoop := true
return

d:: ;혼마만 돌리기(오른쪽)
SpreadHonmaRight()
StopLoop := true
return


SpreadHonmaLeft() { ;혼마 돌리기(왼쪽)
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
    return
}

SpreadHonmaRight() { ;혼마 돌리기(오른쪽)
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
        SendInput, { Right }
        CustomSleep(30)
        SendInput, { enter }
        CustomSleep(90)
    }
    SendInput, {Esc}
    CustomSleep(20)
    return
}

;NumpadDel (큐센 계산기모드) shift + c 였다. shift + a(마비돌리기 + 첨)와 잠시 교체
+a:: ;저주 돌리기 + 첨
SpreadCurseAndChum()
StopLoop := true
return

SpreadCurseAndChum() { ;저주 돌리기 + 첨
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
    return
}










FourWayParalysis() { ; 4방향 마비
    SendInput, {Esc}
    CustomSleep(120)
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
                SendInput, {Home}
                CustomSleep(30)
                SendInput, {Left}
                CustomSleep(30)
                SendInput, {Enter}
                CustomSleep(90)
            }
        
        loop, 3
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
                CustomSleep(90)
            }
        
        loop, 3
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
                CustomSleep(90)
            }
        
        loop, 3
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
                CustomSleep(90)
            }
            SendInput, {Esc}
    CustomSleep(20)
    return
}






f:: ;  탭탭 대상 보무
TabTabBoMu()
StopLoop := true
return

TabTabBoMu() { ; 탭탭 대상 보무 (대문자 X = 보호,  소문자 x = 무장)
    SendInput, {Esc}
    CustomSleep(30)
    SendInput, {Tab}
    CustomSleep(30)
    SendInput, {Tab}
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
    return
}


End:: ;  셀프보무
SelfBoMu()
StopLoop := true
return


SelfBoMu() { ; 셀프 보무 (대문자 X = 보호,  소문자 x = 무장)
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
    return
}










#If
    

