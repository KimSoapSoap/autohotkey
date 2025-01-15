; 혼힐 할 때 혼 3마리 돌리고 힐하고 하면 거의 힐틱 딜레이 로스되지 않고 힐 할 수 있다
; 단지 혼 돌리고 힐 하기 때문에 힐틱최대치인 3회는 아니고 2회만 회복시킨다
; 1차하고 백호의 희원 배우고 2차하고 신령의 기원까지 배우면 2회 회복 + 백호의 희원으로 제법 많이 회복할 수 있다

; 만약 마우스로 이동한다면 밀대힐 대신에 혼힐 반복하면 움직이면서 혼 + 회복도 걸어줄 수 있다(참고)
; -> 이건 내가 PC로 도사 플레이할 때 가능하다





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


global StopHonHeal := false

global ManaRefresh := 0
global FourWayMabi := 0
global MildaeHeal := false
;혼힐할 때 밀대힐 중이면 힐 틱당 힐 마무리 하고 혼 돌리기, 밀대힐 아니면 바로 혼 돌리기 하려고

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


NumpadMult::  ; 넘패드 *키키
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


;----------------------------밀대용 키 세팅---------------------------------------------

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
            ;SendInput, { right }
            SendInput, { left }
            CustomSleep(30)
            SendInput, { enter }
            CustomSleep(50)  ;아주 살짝 밀리길래 10 줄임
            SendInput, {Esc}
            CustomSleep(20) ;아주 살짝 밀리길래 10 줄임
        }
        SendInput, {Tab}
        CustomSleep(40)
        SendInput, {Tab}
        CustomSleep(40)

        Loop, 4 {
            SendInput, {Blind}1
            CustomSleep(50)
        }
        SendInput, {3}
        CustomSleep(20)

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


`:: ; 자힐 3틱
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
;e::8 ;백호의희원


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


r::9 ;공력주입
t::0 ;부활

 +r::
 CustomSleep(120)
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







 TabTabHealRefresh() {
    MildaeHeal := true
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
        Loop, 3 {
            Send, {1}
            CustomSleep(50)        
            Send, {1}
            CustomSleep(50)        
            Send, {1}
            CustomSleep(50)     
            }
        Send, {3}
        CustomSleep(50)
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










#If
    

