﻿;자객 전까진 2 필살, 3비필(비영승보 + 필)
;자객부터는 2백호 3비백  4필살  e비필      5투명 6천공(솔플용) 7노획
;혹은 2백호 3필살 w비백,  e비필


global StopLoop := false
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



':: ; 사자후
SendInput, {Esc}
CustomSleep(30)
SendInput, {shift down}
CustomSleep(60)
SendInput, { z }
CustomSleep(60)
SendInput, {shift up}
CustomSleep(60)
SendInput, z ;  z -> 사자후 도사
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




2:: ;필동동
SendInput, {Blind}2
CustomSleep(30)
DrinkDongDongJu()
return





3:: ;비영 + 필
SendInput, {Blind}1
CustomSleep(30)
SendInput, {Blind}2
CustomSleep(30)
DrinkDongDongJu()
return


    

+2::
CustomSleep(120)
SendInput, {Blind}2
return 

+3::
CustomSleep(120)
SendInput, {Blind}3
return 

 

q::6 ; 천공
w::7 ; 노획
e::8 ;나중에 1차 이후 비영 필살 예정
r::9 ;망각
t::0 ;뢰진주

 +r::
 CustomSleep(120)
 SendInput, {Blind}r
 return






 +q:: ;바다의빛
 CustomSleep(120)
 VisionRecovery()
 return

VisionRecovery() {  ;바다의빛
    SendInput, {Esc}
    CustomSleep(30)
    SendInput, {shift down}
    CustomSleep(60)
    SendInput, { z }
    CustomSleep(100)
    SendInput, {shift up}
    CustomSleep(100)
    SendInput, w ;  w -> 바다의빛
    CustomSleep(40)
    return
 }




 a:: ;투평
SendInput, {5}
CustomSleep(50)
SendInput, {Space}
return

s:: ;비투평
SendInput, {1}
CustomSleep(50)
SendInput, {5}
CustomSleep(50)
SendInput, {Space}
return


d:: ; 비투평투평
SendInput, {1}
CustomSleep(50)
SendInput, {5}
CustomSleep(50)
SendInput, {Space}
CustomSleep(100)
SendInput, {5}
CustomSleep(410)
SendInput, {Space}
Return

f:: ; 비투평 비투평으로 고개 돌리는 타이밍을 이용해 한 턴에 뒤에서 투평을 두 번 넣으려고 했는데 초당 시전회수때문에 빠르게는 불가.
;비투평 비투평 안 되면 비투평투비로 변경
SendInput, {1}
CustomSleep(50)
SendInput, {5}
CustomSleep(50)
SendInput, {Space}
CustomSleep(700) ; 평타 후 다음 투평이나 비영은 후딜 500정도 필요했음. 다시 비영으로 넘어갈 땐 500으로 하니 고개 돌리기 전에 써져서 600
SendInput, {Blind}1
CustomSleep(200) ;처음 비투평은 딜레이 50으로 해도 되는데 초당 시전회수 때문에 재비영 후 투명 딜레이를 계속 늘려나가봄.
;우선 공격 후 750, 비영후 200 쓰고 있었음
SendInput, {5}
CustomSleep(50)
SendInput, {Space}
Return




^s:: ; 상태창
CustomSleep(190)
SendInput, {Blind}s
return



SelfNeutralize() {
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
        SendInput, {Blind}7
        CustomSleep(30)
        SendInput, {Home}
        CustomSleep(30)
        SendInput, {Enter}
        CustomSleep(90)
    }
    SendInput, {Esc}
    CustomSleep(20)    
    }
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




+^v:: ; 빨탭 힐+공증 반복 (밀대용)
TabTabHealRefresh()
StopLoop := true
return

 TabTabHealRefresh() {
    SendInput, {Esc}
    CustomSleep(30)
    SendInput, {Tab}
    CustomSleep(40)
    SendInput, {Tab}
    CustomSleep(30)
    StopLoop := false
    CustomSleep(20)

    Loop  ;, 30  ;원래 30이었다. 일단 횟수없이 반복으로.
    {
        if (StopLoop)
            {                
                Break
                CustomSleep(20)
            }
        Send, {1}
        CustomSleep(50)        
        Send, {1}
        CustomSleep(50)        
        Send, {1}
        CustomSleep(50)
        Send, {3}
        CustomSleep(50)
        Send, {3}
        CustomSleep(50)
    }
    SendInput, {Esc}
    CustomSleep(40)
    return
}









NumpadEnd:: ;  셀프버프 ;pc는 end, 노트북은 넘패드end 인데 pc지만 일단 만들어가는 중이므로 임시로 노트북용
SelfBuff()
StopLoop := true
return


SelfBuff() { ; 셀프 버프 (대문자 X = 무영보법,  소문자 x = n중공격격)
    SendInput, {Esc}
    CustomSleep(30)
    SendInput, {shift down}
    CustomSleep(40)
    SendInput, { z }
    CustomSleep(40)
    SendInput, { x } ; 대문자 x -> 무영보법법, 쉬프트 up을 해주기 전에 x 눌러서 대문자임
    CustomSleep(40)
    SendInput, {shift up}
    CustomSleep(70)

    SendInput, {shift down}
    CustomSleep(40)
    SendInput, { z }
    CustomSleep(40)
    SendInput, {shift up}
    CustomSleep(40)
    SendInput, { x } ; 소문자 x -> n중공격격
    CustomSleep(40)
    SendInput, {Esc}
    CustomSleep(20)
    return
}










#If
    

