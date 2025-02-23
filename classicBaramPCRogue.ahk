;오토 노획 on/off를 위한 변수. NoWheak() 에서 true면 노획사용
global AutoNoWheak := false


;자객 전까진 2 필살, 3비필(비영승보 + 필)
;자객부터는 2백호 3비백  4필살  e비필      5투명 6뢰진주(어그로용) 7노획   0 천공(솔플용)
;혹은 2백호 3필살 w비백,  e비필

;a 투평,  s 비투평,  d 비투평 투평  f 비투평 비투평 
;g 자동 필
;x 줍기  v 솔로잉 풀버프 


;도적은 PC에서 notebook으로 할 때 Insert 버프를 NumpadEnd로(파티용 무영보버), 솔로잉버프는 둘 다 v키. 사자후를 Del에서 '(홑따옴표)로
;원래 도적도 PC에서 End 버프였는데 도사랑 한 손 컨트롤 시 End는 필살검무(나중엔 백호검무)로 바꿨기 때문
;뭐 안 하겠지만 체력 높아져서 백필 쓰면 Del에는 필살, 사자후를 다른 걸로

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

; 지도 상태를 관리하는 변수 (처음엔 닫힌 상태로 초기화)
global isMapOpen := false

; 전역적으로 랜덤 값을 추가하는 함수 정의
CustomSleep(SleepTime) {
    Random, RandomValue, 1, 10
    Sleep, SleepTime + RandomValue
}

; 랜덤값 획득을 위한 함수
GetRandomValue(x, range) {
    Random, offset, -range, range ; -range ~ +range 사이의 랜덤 값 생성
    return x + offset
}


StopLoopCheck() {
    if (StopLoop)
        {            
            SendInput, {Esc}
            CustomSleep(20)   
            Exit  
        }
}


Pause::
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



;자동필을 `(1왼쪽 백틱키)키로 하고 중단은 F3, 2, End 즉 필동동에도 넣었는데 한 손으로만 할 때도 자동필을 켤 수 있게 해주고 싶다
;우측 쉬프트도 자동필 시작으로 해보자. 일단 더 필요하면 우측 pgup, pgdown키도 손보자
; 백호검무 배우면 쓸 때 동동주 마실 필요 없으니까 1차 이후에 End에 백호검무 + 정지하면 좋겠다
; pgdn 필살검무로 하려고 했는데 이는 체력 30만 이상으로 2차하고 진검쯤 되면 

+^`:: ;자동 필 ;무사방에서는 잘못 썼다가는 큰일아니 필요하기 전까진 봉인
AtPilGum()
return




RShift:: ;자동 필(한손컨을 위해)
AtBaekGum()()
return


AtPilGum() {
    StopLoop := false
    CustomSleep(30)
    Loop {
        if (StopLoop)
            {            
                Break
                CustomSleep(20)
            }
        SendInput, {Blind}8
        CustomSleep(30)
        DrinkDongDongJuTwoShot()
        CustomSleep(800)
    }
    return
}


AtBaekGum() {
    StopLoop := false
    CustomSleep(30)
    Loop, 18000{ ;하다가 기절할 수 있으므로 카운트 걸어놓자. 초당 10회. 30분 생각하자
        if (StopLoop)
            {            
                Break
                CustomSleep(20)
            }
        SendInput, {Blind}2
        NoWheak()
        ;CustomSleep(30)
        ;SendInput, {Ctrl Down}
        ;CustomSleep(20)
        ;SendInput,a
        ;CustomSleep(200)
        ;SendInput,a
        ;CustomSleep(20)
        ;SendInput,{Ctrl Up}
        ;CustomSleep(20)

        CustomSleep(50) ;동동주 마실 땐 800, 안 마실 땐 1180
        
    }
    return
}





;우측 컨트롤 키(키 히스토리로)
SC11D:: ;도적 한 손 드리블할 때. 우측 ctrl로 비영승보 사용. 투컴시 필요할까봐 말타기도 넣음
SendInput, {Blind}r 
CustomSleep(20)
SendInput, {Blind}1
return





AppsKey:: ;한손컨시 지도(우측 ctrl 왼쪽 키)
CustomSleep(100)
if (isMapOpen) {
    ; 지도가 열려 있다면 ESC로 닫기
    SendInput, {ESC}
    isMapOpen := false
} else {
    ; 지도가 닫혀 있다면 Shift + M으로 열기
    SendInput, {Shift Down}
    CustomSleep(30)
    SendInput, {M}
    CustomSleep(30)
    SendInput, {Shift Up}
    isMapOpen := true
}
return




~x:: ;줍기
getget()
return

getget() { ; 줍기
    CustomSleep(30)
    SendInput, {ShiftDown}
    CustomSleep(30)
    SendInput, {,}
    CustomSleep(30)
    SendInput, {ShiftUp}
    CustomSleep(30)
    return
}




+space:: ;줍기
CustomSleep(30)
SendInput, ,
CustomSleep(30)
return


;도적은 DEL키 쓴다고 그냥 PC도 '키로 해보자
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





Insert:: ;무영보법 버프만 ;pc는 insert 노트북은 NumpadEnd
SelfBuffParty()
StopLoop := true
return


Del:: ; 줍기
getget()
return


;한 손 컨 위함. 대신 버프는 Insert로
End:: ;백호검무
Critical
SendInput, {Blind}2
NoWheak()
;CustomSleep(20)
;Loop, 1 {
;SendInput, {Ctrl Down}
;CustomSleep(20)
;SendInput,a
;CustomSleep(200)
;SendInput,a
;CustomSleep(20)
;SendInput,{Ctrl Up}
;CustomSleep(20)
;}
StopLoop := true
return


F1:: ; 숫자 1
SendInput, {Blind}1
CustomSleep(30)
return


F2:: ; 자신선택 & 동동주 마시기용, a에 동동주  (타겟박스 있을 때는 자신선택이고 동동주 안 마셔지고, 타겟박스 없을 땐 동동주 마시기)
SendInput, {Home}
CustomSleep(30)
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

 ;동동주 2번 먹는 거 90부터 올려봤는데 한 번씩 씹혀서 거의 안 씹히는 딜레이까지 올림
 DrinkDongDongJuTwoShot() {     
           SendInput, {Ctrl Down}
           CustomSleep(20)
           SendInput,a
           CustomSleep(200)
           SendInput,a
           CustomSleep(20)
           SendInput,{Ctrl Up}
           CustomSleep(20)
    return
 }


F3:: ;자신 선택 & StopLoop
StopLoop := true ; 각각의 함수들이 루프시작에 StopLoop가true일 경우 break를 해주기 때문에 중간에 썼을 때 멈추려면 써준다.
SendInput, {Home}
CustomSleep(20)
SendInput, {Blind}r ;북방 파밍할 때 말 편하게 타려고
return


F4:: ;지도
SendInput, {shift down}
CustomSleep(30)
SendInput, {m}
CustomSleep(30)
SendInput, {shift Up}
return



2:: ;백검 ;마 좀 올릴 때까지 동동주 먹어준다
Critical
;PilDongDong()  ;필살검무
SendInput, {Blind}2  ;백호검무
NoWheak()
;CustomSleep(30)
;DrinkDongDongJuTwoShot()
StopLoop := true
return


PilDongDong() {
    SendInput, {Blind}8
    CustomSleep(30)
    DrinkDongDongJuTwoShot()
    return
}






3:: ;비영 + 백호검무
SendInput, {Blind}1
CustomSleep(30)
SendInput, {Blind}2
;CustomSleep(20)
;DrinkDongDongJuTwoShot()
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



NoWheak() { ; 노획 바로 뒤(후딜 앞에)에 붙여준다.
    if(AutoNoWheak) {     
        CustomSleep(10)   
        SendInput, {7}
    }
}



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








v:: ;  솔로잉 풀버프 
SelfBuffSolo()
StopLoop := true
return



SelfBuffParty() { ; 셀프 버프 (대문자 X = 무영보법,  소문자 x = n중공격격)
    SendInput, {Esc}
    CustomSleep(30)
    SendInput, {shift down}
    CustomSleep(40)
    SendInput, { z }
    CustomSleep(40)
    SendInput, { x } ; 대문자 x -> 무영보법, 쉬프트 up을 해주기 전에 x 눌러서 대문자임
    CustomSleep(40)
    SendInput, {shift up}
    CustomSleep(70)
    return
}



SelfBuffSolo() { ; 셀프 버프 (대문자 X = 무영보법,  소문자 x = n중공격격)
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
    CustomSleep(70)

    SendInput, {shift down}
    CustomSleep(40)
    SendInput, { z }
    CustomSleep(40)
    SendInput, {shift up}
    CustomSleep(40)
    SendInput, {Blind}v  ;소문자 v -> 분신
    CustomSleep(40)
    SendInput, {Esc}
    CustomSleep(20)
    return
}










#If
    

