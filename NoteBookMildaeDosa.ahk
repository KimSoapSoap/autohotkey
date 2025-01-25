; 혼힐 할 때 혼 3마리 돌리고 힐하고 하면 거의 힐틱 딜레이 로스되지 않고 힐 할 수 있다
; 단지 혼 돌리고 힐 하기 때문에 힐틱최대치인 3회는 아니고 2회만 회복시킨다
; 1차하고 백호의 희원 배우고 2차하고 신령의 기원까지 배우면 2회 회복 + 백호의 희원으로 제법 많이 회복할 수 있다

; 만약 마우스로 이동한다면 밀대힐 대신에 혼힐 반복하면 움직이면서 혼 + 회복도 걸어줄 수 있다(참고)
; -> 이건 내가 PC로 도사 플레이할 때 가능하다


;백호의 희원은 2번이다. 노트북 밀대로 할 때는 2번이 중지고 백호의 희원 2번은 밀대힐에 자동 설정
;pc로 할 때는 원하는 타이밍에 백호 주기 위해 밀대힐에 2번 빼놓는다. (일단 해보고 넣든가 하자) F3이 정지

;원래 9번이 공력주입, 0번이 부활이어서 공주가 r키, 부활이 T키 였는데
;r키에 선택혼(마우스 포인트 위치의 몹에 혼마 걸기) 넣고 t키에 공력주입으로 바꿨다
;그럼 원래 부활이었던 T키는? 쉬프트+g 같은 다른 키로 변경했음. -> g키가 탭탭부활(격수부활) 그리고 본인부활 후 다시 탭탭 사용중이므로
;어쨌든 원래 qwert 키가 fghij 마법을 67890 눌러서 스킬 쓰는 것인데 자리를 이렇게 저렇게 봐꿨지만
;공력주입이 9번(i) 부활이 0번(j) 인 건 그냥 그대로 놔두고 쓰자.

;2번 백호의 희원(노트북 밀대는 2번이 정지, 백호의 희원은 밀대힐에서 자동 사용) 3공증 4혼마 5차폐
;q금강 wasd 이동(밀대는 편하게 한손으로 하려고, pc는 마우스 우클로 이동하면서 이동혼힐 가능)
;e매우짧혼, f중간혼 (e왕 f는 힐 돌리면서 혼마 3개씩 돌리기를 짧게, 길게) c 혼마만 돌리기
;r 선택혼 ,t공주 , g 탭탭부활 본인부활 후 다시 탭탭  v보무 b 셀프 무력화 3틱
;선택혼은 r키로 마우스 오버하면 클릭해서 혼마 건다. 밀대힐중(탭탭힐리프레쉬) 좌클릭, 휠업, 휠다운해도 선택혼 가능하다.




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


;클릭, 휠업, 휠다운은 밀대힐 도중 좌클, 휠업다운시 선택 혼마 사용하게끔.
;r키도 선택혼인데 손가락 하나 부담을 줄이기 위해서임
global LButtonClicked := false
global WheelUpDetected := false
global WheelDownDetected := false
global ListenMouseEventCooldown := false


global StopHonHeal := false

global ManaRefresh := 0
global FourWayMabi := 0
global MildaeHeal := false
;혼힐할 때 밀대힐 중이면 힐 틱당 힐 마무리 하고 혼 돌리기, 밀대힐 아니면 바로 혼 돌리기 하려고

global TabTabX := 0
global TabTabY := 0


; 전역적으로 랜덤 값을 추가하는 함수 정의
CustomSleep(SleepTime) {
    Random, RandomValue, 1, 10
    Sleep, SleepTime + RandomValue
}

; 랜덤 좌표값을 위함
GetRandomValue(x, minRange, maxRange) {
    Random, offset, minRange, maxRange ;  x값에 minRange, maxRange 설정해서  x값에 더해주는 것 (음수 가능)
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


NumpadMult::  ; 리로드 ;노트북은 NumpadMult
Suspend Off       ; Suspend 상태에서 동작하도록 강제로 해제
StopLoop := true
Reload
return

\:: ; 오토핫키 중단, 중간에 단축키 중단하고 사자후 날릴 때 쓰려고 StopLoop는 제외함
Suspend, Toggle
;StopLoop := true    
return


F5:: ; 오토핫키 중단, 한 손 키보드에 필요
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


;----------------------------밀대용 키 세팅--------------------------------------------
;pc에서는 wasd 안 쓰려고 했다. 만약 무빙으로 뭘 해보려면 우클릭 이동인데 이때는 wasd이동하고 오른손은 마우스 괜찮겠다
;한 번 해볼까?
; pc에서 wasd 안 쓸 거면 그냥 wasd 지우고 여기에 다른 키들 넣어도 된다.
;근데 무빙 컨트롤 재밌겠는데..?
;일단 wasd 놔두고 키보드로 하다가 마우스 이동으로도 한 번 해보자
;혼 안 걸린 거 마우스 찍어서 써줄 수도 있다

;일단 wasd 안 지우고 한 번 해보고 바꾸자

;왼쪽 이동
a::left

;오른쪽 이동
d::right

 ;위쪽 이동
w::up

 ;아래쪽 이동
s::down


f4:: ; 부활스킬 등 타겟팅 스킬 시전용
SendInput, {Enter}
return

1::
TabTabHealRefresh()
return


c:: ; 긴혼left.  20정도도 -> 15로 변경함
SpreadHonmaLeft(15)
return

;혼힐을 수정혼 + 적당한 개체수일 때 사용용

;혼힐(a,b)는  힐은 기본적으로 3틱시전.  혼 a만큼 돌리고 나서 힐3틱 과정정을 b만큼 반복. 혼2번시(a = 2) 힐 3틱 최대시전. 혼3번부터 힐로스
; a가 2일 땐 너무 숫자가 낮아서 다른 딜레이 10씩 내리고 a 3으로 해서 힐틱 딜레이 로스 거의 안 밀리게 했다. 그래서 3으로 사용

;그래도 격수 피통이 높아지면 혼힐이 나을까 싶기도 하고 hps때문에 혼힐로

;수정혼 + 적당한 몹수
f:: ; 
HonHeal(3,4)
return

;수정혼 + 적은 수수
e:: ;혼힐 -> 수정혼 느낌으로
HonHeal(3,2)
return

;e로 정말 짧은 혼은 비슷한 코드로 감지되지 않게 혼 격수힐 번갈아가면서하는 거 혹은 꾹 누르는 걸로로



;현재 부활 코드에서 마지막에 탭탭으로 다시 격수지정할 때 마지막 탭 이후 커스텀슬립이 안 붙어 있음



; 밀대힐은 일단 기본적으로 밀대 힐+공증 반복이다 (1차하면 백호 추가가)

;-------------------------------------------------------------------------

;이렇게 하고 ahk파일 자체를 관리자 실행하니까 된다. 컴파일 하면 될지 안 될지 모르겠지만
;맨 앞에 딜레이 120 붙이니까(주술도 몇개는 이렇게 붙였었네) 감지 안 된 것일 수도 있겠다

; 혼힐에 혼2번 돌려야 힐이 틱 따라가고 혼3번 돌리니 틱을 못 따라가고 조금씩 밀리는 느낌
;그래서 f키가 짧혼인데 조금 애매하다 짧게 혼 돌려도 나중엔 hps가 체를 못 따라가니까 힐 계속 하는 게 나은 느낌인데
;아예 몰려 있으 때는 그냥 a로 돌리고
;일단 한 번 해보면서 조율하자

;혼힐 짧은혼 -> 혼2번만 돌리고 힐을 하면 힐틱을 따라갈 수 있다. 적은 몹에 괜찮다. 3번부터는 좀 못 따라가는 느낌낌
;틱당 마법시전회수가 있어서 혼2번 돌리고 해도 생명기원은 틱 최대인 3회가 아니라 2회가 시전되더라
;혼 2회 시전시 서버 틱에 대한 딜레이 로스는 없지만(매 틱당 안 밀리고 시전 가능하다는 의미) 기원 시전은 2번밖에 안 된다는 것이다
;혼 3회 시전시 혼마 1회가 추가되어 그 딜레이만큼 서버 틱을 따라가지 못하고 조금씩 밀리면서 기원시전을 하는 것.
;그렇다면 수정혼을 혼힐로 (2,n)으로 길게 하면 안 될 것 같다
;그래도 2,n으로 했을 때 뭔가 그냥 밀대힐 하는 것처럼 틱 딜레이 로스가 안 나서 큰 위화감은 없었다(내 체력이 낮아서 회복량을 인지 못한 듯?)
HonHeal(HonCount, LoopCount) { 
    StopLoop := false
    StopHonHeal := false
    ;MildaeHeal := true  ;밀대힐 아닐 때도 쓰려면 넣어주자. 일단은 빼놨다

    if (MildaeHeal) ; 밀대힐 중이면 틱당 힐 더 돌리고 혼 돌리러 감 -> 힐 끊기지 않는 용도지만 미리 다 입력이 돼있을 것이므로 잠시 뺀다.
                    ; 이것때문에 타이밍 엇나가서 빼도 괜찮을 것 같았는데 이거 빼면 힐 할 타이밍에 쓰면 힐 안 쓰고 혼 돌려서 넣자.
        {            
            Loop, 3 {
                SendInput, {Blind}1
                CustomSleep(50)
            }
        }

    loop, %LoopCount%
    {
        if (StopLoop || StopHonHeal)
            {            
                Break
                CustomSleep(20)
            }

        Loop, %HonCount% {
            SendInput, {Esc}
            CustomSleep(20)
            SendInput, 4
            CustomSleep(30)
            SendInput, { left }
            CustomSleep(30)
            SendInput, { enter }
            CustomSleep(50)  ;후딜 80~90이었는데 탭탭이랑 왔다갔다 할 거기 때문에 혹시모를 꼬임 방지로 ESC 넣고 후딜 나눴음
            SendInput, {Esc}
            CustomSleep(20) ;원래 후딜 30이었는데 금강불체 넣고 20, 10으로 나눔
            SendInput, {Blind}6  ;금강불체. 탭탭힐 리프레쉬에서 공격이 나가서 blind 6으로 했다.
            CustomSleep(10) 
        }
        SendInput, {Tab}
        CustomSleep(50)
        SendInput, {Tab}
        CustomSleep(40)

        DeathCheck() ; 탭탭하고 나서 도사 유령확인 넣어봄 힐틱 밀리면 이거 뺀다
        Loop, 1 {
            SendInput, {Blind}1
            CustomSleep(50)
            SendInput, {Blind}1
            CustomSleep(50)
            SendInput, {Blind}1
            CustomSleep(50)
            SendInput, {Blind}2 ;백호
            CustomSleep(50)
            SendInput, {Blind}1 ;백호 쿨일 때 생명 3틱 쓰려고. 틱당 3회 회복은 50후딜로는 4번 해야되더라
            CustomSleep(50)
            ;SendInput, {Blind}1 ;백호 쿨일 때 생명2번만 나가더라. 혼마랑 같이 써져서 제한때문인지 테스트 후 힐틱 밀리면 빼던가 하자
            ;CustomSleep(50)
        }
        SendInput, {3} ;
        CustomSleep(20)
        ;SendInput, {Blind}2 공증 뒤 백호는 잠시 뺐음. 여기선 마법 1회를 아껴야 돼서 힐 뒤에 백호 한 번만
        ;CustomSleep(20)

    }
    return
}









~x:: ;줍기
CustomSleep(30)
SendInput, {ShiftDown}
CustomSleep(30)
SendInput, {,}
CustomSleep(30)
SendInput, {ShiftUp}
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
SendInput, z ;  z -> 사자후 술사
CustomSleep(40)
return


^1:: ;추적 밀대
CustomSleep(150)
ChaseMildae()
return

^2:: ;따라가기
CustomSleep(150)
ChaseOnly()
return

+space:: ;제자리 혼힐
CustomSleep(150)
StandingHonHeal()
return

F1:: ; 추적혼힐
ChaseHonHeal()
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
StopLoop := true ; 각각의 함수들이 루프시작에 StopLoop가true일 경우 break를 해주기 때문에 중간에 썼을 때 멈추려면 써준다.
SendInput, {Home}
CustomSleep(20)
SendInput, {Blind}r
return


`:: ; 자힐 3틱
SelfHeal()
;StopLoop := true ;중단 안 하는쪽으로 가기 위해 주석처리
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
    SendInput, {Tab} ;격수 힐 중이었을 때를 대비해 마지막에 탭탭
    CustomSleep(50)
    SendInput, {Tab}
    CustomSleep(40)
    return
}



;도사는 자힐보다 격수 탭탭힐을 많이 써서 `를 자힐 3틱, 1은 격수 탭탭힐 반복으로



 TabTabHeal() {
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


;도사는 StopLoop를 빠르게 사용할 일이 많아서 2번에도 넣어뒀다.
2:: ; 루프 정지
StopLoop := true
return


+1::
CustomSleep(120)
SendInput, {Blind}1
return

+2::
CustomSleep(120)
SendInput, {Blind}2
return



; sendInput Esc 뒤에 CustomSleep(20) 하니까 탭탭이 씹히고 30으로 하니까 괜찮더라
;꼬임 방지 esc 뒤에 sleep은 최소 30으로 해준다.

;도사용 탭탭힐







 

 

q::6 ;금강불체
;w::7 ;무력화

t::9 ; 공력주입
+g:: ; 부활
CustomSleep(120)
SendInput, {0}
return



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


r:: ; 선택혼
SelectionHon()
return

SelectionHon() {
    SendInput, {Esc}
    CustomSleep(30)
    SendInput, {4}
    CustomSleep(30)
    SendInput, {Click}
    CustomSleep(30)
    SendInput, {Enter}
    CustomSleep(60)  ; 원래 후딜90인데 아래 ESC와 나눠서 함. 60, 30이어야 하는데 esc 뒤에 여유있게 50줌. 이걸 다시 금강이랑 30, 20으로 나눔.(금강노쿨이라)
    SendInput, {Esc} ; 이미 타겟박스인 것을 클릭하면 엔터칠 필요 없이 바로 시전된다. 그때 엔터키 닫기
    CustomSleep(30)
    SendInput, {Blind}6  ;금강불체. 탭탭힐리프레쉬에서 그냥6으로 하니까 공격이 나가서 Blind 6으로 했다
    CustomSleep(20)
    SendInput, {Tab}
    CustomSleep(70)
    SendInput, {Tab}
    CustomSleep(30)
return
}


 +r:: ;말타기
 CustomSleep(100)
 SendInput, {Blind}r
 return






 +q:: ;시력회복
 CustomSleep(120)
 VisionRecovery()
 return

VisionRecovery() {  ;시력회복
    SendInput, {Esc}
    CustomSleep(30)
    SendInput, {shift down}
    CustomSleep(60)
    SendInput, { z }
    CustomSleep(100)
    SendInput, {shift up}
    CustomSleep(100)
    SendInput, w ;  w -> 시력회복
    CustomSleep(40)
    return
 }





b::
SelfNeutralize()
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


^s:: ; 상태창
CustomSleep(190)
SendInput, {Blind}s
return


;이동방향 입력키 겹치지 않으면서 타겟박스 이동이 순방향이면 돌리면서 이동가능함(구멍은 좀 생김)
;left와 up은 타겟박스 왼쪽으로 이동하고 막히면 타겟박스 위로 이동
;right와 down은 타겟박스 오른쪽으로 이동하고 막히면 타겟박스 아래로 이동
;그래서 위쪽 무빙할 때는 left키로 혼 돌리면 위로 이동하지만 up키와 같은 효과인 left로 혼 돌리기 때문에 무빙혼 가능
;마찬가지로 왼쪽 무빙할 때는 up키로 혼 돌리면 타겟박스 이동방향은 같지만 키가 겹치지 않아서 무빙혼 가능한 것
;근데 문제는 a,d만 있을 때는 감지가 안 됐는데 s,f에 혼마 돌리기 추가하니까 비정상 앱이 자꾸 감지됨
;코드의 문제인걸까? 모르겠다 일단 빼고 진행







SpreadHonmaLeft(count) { ;혼마 돌리기(왼쪽)
    SendInput, {Esc}
    CustomSleep(30)
    StopLoop := false
    loop, %count%  ;긴혼은 20이었다
    {
        if (StopLoop)
            {            
                Break
                CustomSleep(20)
            }
        SendInput, {Esc}
        CustomSleep(30) 
        ;혼 돌리다 죽었을 때 부활 후 혼 돌아가고 있으면 꼬여서 숫자만 나온다. 그거 방지하기 위해 맨 앞에 esc하고 후딜30
        ;혼 돌리고 엔터고 후딜이 90이었는데 엔터 치고 후딜 60주고 맨 앞에 꼬임방지용 esc넣고 여기 후딜 30줘서 혼쓰고 합산 후딜 90

        SendInput, 4
        CustomSleep(30)
        SendInput, { left }
        CustomSleep(30)
        SendInput, { enter }
        ;CustomSleep(90)
        CustomSleep(60)
    }
    SendInput, {Esc}
    CustomSleep(30)
    SendInput, {Tab}
    CustomSleep(40)
    SendInput, {Tab}
    CustomSleep(40)
    return
}

SpreadHonmaRight(count) { ;혼마 돌리기(오른쪽)
    SendInput, {Esc}
    CustomSleep(30)
    StopLoop := false
    loop, %count%  ;긴혼20, 짧혼 7정도도
    {
        if (StopLoop)
            {            
                Break
                CustomSleep(20)
            }
        SendInput, 4
        CustomSleep(30)
        SendInput, { right }
        CustomSleep(30)
        SendInput, { enter }
        CustomSleep(90)
    }
    SendInput, {Esc}
    CustomSleep(30)
    SendInput, {Tab}
    CustomSleep(40)
    SendInput, {Tab}
    CustomSleep(30)
    return
}



;힐 공증 반복시 클릭 or 휠업 or 휠다운시 선택혼 사용하기 위함
;밀대힐 중 좌클, 휠업, 휠다운 감지해서 동작을 하면 선택혼 날린다.
;이때 휠업다운은 드르륵 하면 연타로 들어가서 꼬일 수 있으므로 쿨다운 0.5초
~LButton::
    LButtonClicked := true  ; 좌클릭 감지 변수 설정
return

; 휠 업 감지 핫키
~WheelUp::
    WheelUpDetected := true  ; 휠 업 감지
return

; 휠 다운 감지 핫키
~WheelDown::
    WheelDownDetected := true  ; 휠 다운 감지
return

; 쿨타임 해제 타이머를 위함
ResetListenMouseEventCooldown:
    ListenMouseEventCooldown := false
return


ListenMouseEvent() {
    if (LButtonClicked || WheelUpDetected || WheelDownDetected) {
        LButtonClicked := false  ; 상태 초기화
        WheelUpDetected := false
        WheelDownDetected := false

        if (ListenMouseEventCooldown) {
            return  ; 쿨타임 중이면 바로 종료
        }
        
        SelectionHon()    

        ; 쿨타임 시작 -> 꼬임방지를 위해서 쿨을 앞에 놔둠
        ListenMouseEventCooldown := true
        SetTimer, ResetListenMouseEventCooldown, -350  ; 350ms 후 쿨타임 해제



    }
    return
}


;힐 공증 반복하기
 TabTabHealRefresh() {
    MildaeHeal := true
    LButtonClicked := false  ; 상태 초기화
    WheelUpDetected := false
    WheelDownDetected := false

    StopLoop := false

    SendInput, {Esc}
    CustomSleep(30)
    SendInput, {Tab}
    CustomSleep(40)
    SendInput, {Tab}
    CustomSleep(50)

    Loop  ;, 30  ;원래 30이었다. 일단 횟수없이 반복으로.
    {
        if (StopLoop)
            {                
                Break
                CustomSleep(20)
            }
        DeathCheck()
        SendInput, {Blind}6  ;금강불체. 그냥 6하니까 공격이 나가더라라
        CustomSleep(20)
        Loop, 1 { ;왜 3회 반복으로 해놨지? 다른 별다른 로직이 없어서 그런가.  -> 결론은 루프3에 생명3+백호1 사용
            ; 루프1. 즉 반복 없을 때는 힐3틱 주려면 힐스킬 4번 넣어야 된다. 후딜 50으로 생명3번 넣으면 2번만 시전하고 한 번씩 백호 패스함.
            ; 생명x3 + 백호1에서 마지막에 생명 하나 더 넣어놔야 백호 쿨 있을 때 생명2백호1, 없을 때 생명3 시전 가능
            ; 루프3 이면 그냥 힐3 백호1만 넣어줘도 많이 시도하므로 힐틱이 밀리지 않고 백호도 꼬박꼬박 잘 쓴다.

            ;아니면 루프1로 하고 앞에 기원3번을 후딜70으로 하면 괜찮았다.

            ;좌클릭,휠 업다운 감지 시 로직 수행      
            ListenMouseEvent()
            CustomSleep(20)
            Send, {1}
            CustomSleep(70)        
            Send, {1}
            CustomSleep(70)        
            Send, {1}
            CustomSleep(70)     
            Send, {2} ; 백호
            CustomSleep(50)  
            Send, {1}
            CustomSleep(20)                     
            
            }

        ListenMouseEvent()
        CustomSleep(20)
        Send, {3}
        CustomSleep(20) ; 공증 후 후딜 50이었는데 금강하고 나누고 후딜 30, 20 (뭔가 밀리면 30 20을 20 10으로)
        SendInput, {Blind}6  ;금강불체
        CustomSleep(20)
        
    }
    MildaeHeal := false
    SendInput, {Esc}
    CustomSleep(30)
    return
}



g:: ; 둘다 부활 후 탭탭
Rev()
Return


Rev() {
    SendInput, {Esc}
    CustomSleep(30)
    SendInput, {Tab}
    CustomSleep(40)
    SendInput, {Tab}
    CustomSleep(30)
    SendInput, {0}
    CustomSleep(200)
    SendInput, {Esc}


    SendInput, {0}
    CustomSleep(40)
    SendInput, { home }
    CustomSleep(40)
    SendInput, { enter }
    CustomSleep(200)
    SendInput, {Tab}
    CustomSleep(40)
    SendInput, {Tab}
    CustomSleep(40)
}



v:: ;  탭탭 대상 보무
TabTabBoMu()
return

TabTabBoMu() { ; 탭탭 대상 보무 (대문자 X = 보호,  소문자 x = 무장)
    SendInput, {Esc}
    CustomSleep(30)
    SendInput, {Tab}
    CustomSleep(40)
    SendInput, {Tab}
    CustomSleep(30)

    SendInput, {shift down}
    CustomSleep(40)
    SendInput, { z }
    CustomSleep(40)
    SendInput, { x } ; 대문자 x -> 보호, 쉬프트 up을 해주기 전에 x 눌러서 대문자임
    CustomSleep(40)
    SendInput, {shift up}
    CustomSleep(100)

    SendInput, {shift down}
    CustomSleep(40)
    SendInput, { z }
    CustomSleep(40)
    SendInput, {shift up}
    CustomSleep(40)
    SendInput, { x } ; 소문자 x -> 무장
    CustomSleep(100)
    ;SendInput, {Esc}
    ;CustomSleep(20)
    return
}


NumpadEnd:: ;  셀프보무 ;pc는 end, 노트북은 넘패드end 인데 pc지만 일단 만들어가는 중이므로 임시로 노트북용
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


ChaseMildae() {
    MildaeHeal := true
    LButtonClicked := false  ; 상태 초기화
    WheelUpDetected := false
    WheelDownDetected := false

    StopLoop := false
    SendInput, {Esc}
    CustomSleep(30)
    SendInput, {Tab}
    CustomSleep(40)
    SendInput, {Tab}
    CustomSleep(50)

    Loop  ;, 30  ;원래 30이었다. 일단 횟수없이 반복으로.
    {
        if (StopLoop)
            {                
                Break
                CustomSleep(20)
                Click, Right up ;추적 우클릭이동 해제
            }

           ; 좌클릭 감지 시 로직 수행      
        DeathCheck()
        TabTabChase()
        SendInput, {Blind}6  ;금강불체
        CustomSleep(20)
        Loop, 1 {
            SendInput, {Blind}1
            CustomSleep(50)
            SendInput, {Blind}1
            CustomSleep(50)
            SendInput, {Blind}1
            CustomSleep(50)
            SendInput, {Blind}2 ;백호
            CustomSleep(50) 
            SendInput, {Blind}1 ; 백호 쿨일 때 생명 3번 쓰라고 넣음. 후딜50으로는 생명4번 넣어야 기원 힐틱 3번 가능. 백호 쿨 있으면 생명2백호1, 없으면 생명3
            CustomSleep(10) ; 후딜 50인데 뒤에 추적있어서 후딜 10으로 낮춰봄
        }
        TabTabChase()
        ListenMouseEvent()
        Send, {3} ;공력증강
        CustomSleep(20)
        SendInput, {Blind}6  ;금강불체
        CustomSleep(20)
    }
    MildaeHeal := false
    SendInput, {Esc}
    CustomSleep(30)
    Click, Right up  ;추적 우클릭 해제 방지2
    return
}



ChaseHonHeal() {  ;추적 혼힐
    MildaeHeal := true
    LButtonClicked := false  ; 상태 초기화
    WheelUpDetected := false
    WheelDownDetected := false

    StopLoop := false
    StopHonHeal := false
    chaseCount := 0

    SendInput, {Esc} ;여기 탭탭부분 첫 추적에 필요해서 넣음
    CustomSleep(30)
    SendInput, {Tab}
    CustomSleep(40)
    SendInput, {Tab}
    CustomSleep(50)

    loop
    {
        if (StopLoop || StopHonHeal)
            {            
                Break
                CustomSleep(20)
                Click, Right up ;추적 우클릭이동 해제
            }

        DeathCheck()
        ;TabTabChase() ;공증 이후 혼 돌리기 전 한 번 추가. 이거 넣으니까 힐틱 살짝 밀려서 뺌. 대신 이동은 훨씬 낫긴 하다(방 통과 등)
        Loop, 3 {
            SendInput, {Esc}
            CustomSleep(20)
            SendInput, 4
            CustomSleep(30)
            SendInput, { left }
            CustomSleep(30)
            SendInput, { enter }
            CustomSleep(50)  ;후딜 80~90이었는데 탭탭이랑 왔다갔다 할 거기 때문에 혹시모를 꼬임 방지로 ESC 넣고 후딜 나눴음
            SendInput, {Esc}
            CustomSleep(20) ; 후딜 30인데 금강이랑 나눠서 20, 10으로
            SendInput, {6} ;금강불체
            CustomSleep(10)
        }
        MouseMove, TabTabX, TabTabY, 1 ; 마우스 이동(우클 누른상태태). 탭탭추적은 탭탭 이후에만 가능했는데 이전 검색 좌표+@를 전달해서 마우스이동해서 긴 텀 보완
        SendInput, {Tab}
        CustomSleep(50)
        SendInput, {Tab}
        CustomSleep(10) ; 후딜 40인데 뒤에 추적있어서 후딜 10으로 낮춰봄

        TabTabChase()
        Loop, 1 {
            SendInput, {Blind}1
            CustomSleep(50)
            SendInput, {Blind}1
            CustomSleep(50)
            SendInput, {Blind}1
            CustomSleep(50)
            SendInput, {Blind}2 ;백호
            CustomSleep(50) 
            SendInput, {Blind}1 ; 백호 쿨일 때 생명 3번 쓰라고 넣음. 후딜50으로는 생명4번 넣어야 기원 힐틱 3번 가능. 백호 쿨 있으면 생명2백호1, 없으면 생명3
            CustomSleep(10) ; 후딜 50인데 뒤에 추적있어서 후딜 10으로 낮춰봄
            TabTabChase()
        }
        SendInput, {3} ;
        CustomSleep(10) ;공증 후딜 20이었는데 루프 순서상 다음에 뭐 있어서 걍 10
        ;백호 뒤에 혼힐을 여기에 둬도 될 듯 한데 딜레이상 큰 차이는 없다.
        

    }
    SendInput, {Esc} ; 정지 이전에 격수가 다음 맵으로 넘어갔을 때 내게 걸린 흰박스나 탭탭박스 닫기. 어차피 다시 쓸 때 탭탭하니까.
    CustomSleep(20)
    Click, Right up  ;추적 우클릭 해제 방지2       
    return
}





StandingHonHeal() { ;제자리 혼힐힐
    MildaeHeal := true
    LButtonClicked := false  ; 상태 초기화
    WheelUpDetected := false
    WheelDownDetected := false

    StopLoop := false
    StopHonHeal := false

    SendInput, {Esc}
    CustomSleep(30)
    SendInput, {Tab}
    CustomSleep(40)
    SendInput, {Tab}
    CustomSleep(50)

    loop
    {
        if (StopLoop || StopHonHeal)
            {            
                Break
                CustomSleep(20)
                Click, Right up ;추적 우클릭이동 해제
            }

        DeathCheck()
        Loop, 3 {
            SendInput, {Esc}
            CustomSleep(20)
            SendInput, 4
            CustomSleep(30)
            SendInput, { left }
            CustomSleep(30)
            SendInput, { enter }
            CustomSleep(50)  ;후딜 80~90이었는데 탭탭이랑 왔다갔다 할 거기 때문에 혹시모를 꼬임 방지로 ESC 넣고 후딜 나눴음
            SendInput, {Esc}
            CustomSleep(20)  ;후딜 30이었는데 금강불체랑 나눠서 20, 10
            SendInput, {6} ;금강불체  
            CustomSleep(10) 
        }
        SendInput, {Tab}
        CustomSleep(50)
        SendInput, {Tab}
        CustomSleep(40)

        Loop, 1 {
            SendInput, {Blind}1 ;탭탭추적 빼니까 한 번씩 백호 건너띈다. 너무 빨리 힐틱이 돌아서 그런듯 그래서 앞에 생명3 후딜70으로 하니까 괜찮아졌다.
            CustomSleep(70)
            SendInput, {Blind}1
            CustomSleep(70)
            SendInput, {Blind}1
            CustomSleep(70)
            SendInput, {Blind}2 ;백호
            CustomSleep(50) 
            SendInput, {Blind}1 ; 백호 쿨일 때 생명 3번 쓰라고 넣음. 후딜50으로는 생명4번 넣어야 기원 힐틱 3번 가능. 백호 쿨 있으면 생명2백호1, 없으면 생명3
            CustomSleep(50) ; 
        }
        SendInput, {3} ;
        CustomSleep(20)

    }
    CustomSleep(20)
    Click, Right up  ;추적 우클릭 해제 방지2
    return
}







ChaseOnly() {
    LButtonClicked := false  ; 상태 초기화
    WheelUpDetected := false
    WheelDownDetected := false

    StopLoop := false
    SendInput, {Esc}
    CustomSleep(30)
    SendInput, {Tab}
    CustomSleep(40)
    SendInput, {Tab}
    CustomSleep(50)

    Loop  ;, 30  ;원래 30이었다. 일단 횟수없이 반복으로.
    {
        if (StopLoop)
            {                
                Break
                CustomSleep(20)
                Click, Right up ;추적 우클릭이동 해제
            }

           ; 좌클릭 감지 시 로직 수행      
        DeathCheck()
        CustomSleep(30)       
        ListenMouseEvent()
        CustomSleep(30)
        TabTabChase()
        CustomSleep(50)
    }
    SendInput, {Esc}
    CustomSleep(30)
    Click, Right up  ;추적 우클릭 해제 방지2
    return
}







F6:: ;이미지 서칭 테스트
TabTabChase()
return

TabTabChase() {
    ;Click, Right up ;우클 해제. 어차피 계속 따라다닐 거면 중지할 때만 해제해주면 되지 않나?. 여기서 우클 해제는 이걸 빼보자.
    ;우선 x좌표는 딱 중간쯤이라 좌우로는 캐릭이 중간에 잘 선다. y좌표만 길통과할 때 편의를 위해서 랜덤으로 박스 조금 위, 아래에도 위치할 수 있게 했다.
    ;보통 좌측하단이 검색돼서 상단으로 80만큼, 하단으로 50만큼 해서 캐릭터 탭탭박스 살짝 위 아래로를 벗어나는 데까지 범위가 들어가게 해줬다. 위아래로 이동을 위해
    ;좌우 이동 랜덤은 조금 더 지켜보고 해보자.

    RX := GetRandomValue(30,-20, 70)
    RY := GetRandomValue(50,-110, 80) ;y좌표에 사용할 것이므로 찾은 좌표에서 -를 해주면 위로, +해주면 아래로 가는 것에 주의.(기존 50, -80,50)
    ;TestY ;혼힐추적할 때 y값을 50 + (-100 ~ 70) 랜덤값을 하지 않고 아예 -50 or 120 이런식으로 캐릭터 위 or 아래로 클릭하게 해볼까?
    ;global 변수 chaseCount 하나 만들고 추적함수 실행시 초기화, 추적함수 끝날 때 ++ 하고 홀수짝수 일 때마다 특정 값을 리턴해주면 될 듯듯
    ;해보니까 딜레이 좀 넣어줘야되고 이동이 그닥 자연스럽지는 않더라.

    ;변수값 만들어서 두 번은 검색좌표 + 고정값으로 탭탭추적, 한 번은 검색좌표 + x는 고정값 y는 랜덤값으로 좌표 전달후 중간에 마우스 이동만 넣어줌
    ;혼과 힐 사이 탭탭추적 텀이 좀 있었는데 그 사이에 탭탭 하기 전에 (탭탭 추적은 탭탭 이후에만 가능) 이전에 탭탭 추적시 찾은 좌표에 랜덤값 전달해서
    ;마우스 이동만 추가 해주니 혼과 힐 사이 텀이 조금 보완돼서 이동이 좀 자연스러워졌다
    

    tabtab := A_ScriptDir . "\img\dosa\tabtab4.png" ;탭탭4번 그림으로

    ImageSearch, FoundX1, FoundY1, 0, 0, A_ScreenWidth, A_ScreenHeight,*30 %tabtab% ;탭탭라인 검색
    ImgResult1 := ErrorLevel ; 탭탭된 캐릭터 따라가기 위함
    if(ImgResult1 = 0) {
        ;SendInput, {Blind}1 ;확인용 코드
        MouseMove, FoundX1+ 30, FoundY1 + 40, 1  ;x값은 +30해두면 위아래는 우클이동시 중간에 잘 붙음 y값이 +50이었는데 랜덤값줘서 우클이동시 뒤아래로 움직이게
        Click, Right down ;우클 이동
        ;CustomSleep(10) ; 원래 50 했었고 힐틱 밀리는 원인일까 싶어 빼놨다


    } else if(ImgResult1 = 1) {
        ;SendInput, {2} ;확인용 코드
    } else {
        ;SendInput, 3 ;확인용 코드
    }

    ;힐틱 밀림 방지를 위해서 2번은 탭탭추적, 한 번은 검색한 좌표 + 랜덤Y값을 변수에 넘겨서 마우스만 이동시키기 위함
    TabTabX := FoundX1 + 30
    TabTabY := FoundY1 + RY

return
}







F7::
DeathCheck()
return

DeathCheck() {
    SendInput, {Blind}0 ; 도사 본인 유령 체크하는 것이라서 격수는 알 수 없기에 일단 부활 시전 한 번 하고(탭탭상황) 도사 유령확인. 꼬이면 뺸다
    death := A_ScriptDir . "\img\dosa\death.png"

    ImageSearch, FoundX1, FoundY1, 1400, 800, A_ScreenWidth, A_ScreenHeight, %death% ;유령상태
    ImgResult1 := ErrorLevel ; 
    if(ImgResult1 = 0) {
        Rev()
    } else if(ImgResult1 = 1) {
    } else {
    }
}
return





#If
    

