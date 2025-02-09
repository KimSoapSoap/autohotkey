;저주, 중독, 마비 혼마 등 돌리기 마법횟수 변수 (단일 사용 OO돌리기들 시전횟수 통일할 때 사용)
;기본 카운트 20, 
global magicCount := 16
;주술 꺼 가져왔는데 도사는 혼마 돌리기에 매개변수에 넣어주면 될 것 같다.

;PC 혹은 Notebook 에 따른 좌표 설정. -> 보통 pc에서 만들면 이미지는 물론 새로 캡쳐해야되고 notebook은 복붙해서 핫키를 바꿔줬는데 이미지 서칭할 때는 좌표와 이미지 경로도 바꿔줘야 한다.
;이미지는 물론 notebook에서 사용할 이미지 새로 캡쳐해서 따줘야 한다. (단, 1920x1200 125%로 pc와 거의 비슷한 해상도 사용시 그대로 사용)

; 좌표와 경로를 변수로 설정
; 경로는 PC가     \img\dosa\    노트북이   \img\dosa\notebook\     (앞에 현재 경로 설정인 A_ScriptDir . 붙여 준다. 점(.)은 문자열 덧셈)
; 좌표는 시전창, 상태창(체력, 마나)에 따라 좌표 설정값만 바꿔주면 될 것 같다.
; 노트북 현재 배율을 1920 x 1200에 125% 해서 PC와 엇비슷하긴 하다. 아래 노트북 설정값은 2560 x 1600에 150% 배율일 때이므로
; 노트북 배율을 1920 x 1200에 125%로 사용할 것 같으면 PC좌표로 설정해줘도 된다.(단 세로는 살짝 조정)
global startCastBarX := 1200
global startCastBarY := 500
;pc는 1200, 500 노트북은 1700, 850 (1920x1200 125% 사용시 PC좌표 그대로 사용) 

global startStatusBarX := 1300
global startStatusBarY := 700
;pc는 1300, 700 노트북은 1900, 1150 (1920x1200 125% 사용시 PC좌표 그대로 사용) 

;도사일 경우 tabtabChase 는 좌표 따로 확인 해준다.(채팅창에 외치기 색깔에도 이미지써칭이 반응해서 채팅창 제외한 좌표 범위 설정)
;노트북일 경우 tabtabOn 은 이미지서치 범위에서 끝 좌표를 현재창 가로 세로 길이로 설정해줬다.(dpi 배율에 따른 따른 scale문제인지 아닌지 일단 보류)

global imgFolder := A_ScriptDir . "\img\dosa\notebook\"
;global imgFolder : = A_ScriptDir . "\img\dosa\"
;pc는 "\img\dosa\""   이고   notebook은   "\img\dosa\notebook\"
;A_ScriptDir은 현재 스크립트의 폴더경로이고 점(.)은 오토핫키에서 문자열을 더하는(+) 부호이다. 시작부분을 그냥 가져왔으므로 A_ScriptDir는 맨 앞에 붙여놓고 . 으로 이어 놓으면 된다.



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


; 이 아래 변수는 pc주술에서 가져온 것이다.


; 지도 상태를 관리하는 변수 (처음엔 닫힌 상태로 초기화)
global isMapOpen := false

;입력대기를 사용할 때 활용할 변수
global isWaiting := false

;공력증강할 때 체력 절반정도 이상일 때 사용하게 하기 위함 -> 체력 절반쯤 까진 상태의 이미지 검색후 발견되면 절반 이하, 발견 안 되면 절반 이상
global isHalfHealth := false

;공력증강 성공여부 판별에 활용할 변수
global isFullMana := false

;마나가 거의 바닥인지 아닌지 판별에 활용할 변수(예를들면 헬파쓰고 0인지 페이백을 받아서 공증쓸 마나가 남았는지)
global isLowMana := false

;시전시 마나가 부족한지 확인
global notEnoughMana := false

;공증 썼는지(풀마나시 헬파 쿨이라서 공증 이후인지 헬파가 안 쿨이라서 그런지 판별위함)
global isRefreshed := false

;상태 대기 헬파 시전시 첫 루프인지 아닌지 판별할 때 사용할 변수
global waitingHellFireCount := 0

;걸리지 않는 대상에게 사용했는지 판별
global isWrongTarget := false

;말에 탄 상태 확인
global isRiding := false

;탭탭창 열려 있는지 확인
global isTabTabOn := false

;중독첨첨 혹은 중독사냥 중인지 확인
global isHunting := false

;마나 0인지 확인
;원래 이미지 검색 한 번에 하나의 변수만 바꾸줬는데 마나 관련해서는 마나가 조금이라도 존재하는(풀마나 혹은 마나존재) 것이 확인되면 isManaZero는 false로 초기화를 해주도록 하자
global isManaZero := false


;죽었는지 확인
global isDead := false



;wingetPos를 CalPos() 라는 함수에서 사용해서 윈도우창의 시작 좌표를 구하는데 이를 전달해줄 변수
global winStartX := 0
global winStarty := 0


;wingetPos를 CalPos() 라는 함수에서 사용해서 윈도우창의 우측하단 좌표를 구하는데 이를 전달해줄 변수
;좌표계산할 때 활성화된 창 우측하단 좌표 구해서 저장할 변수. 기본값은 스크린 가로세로 길이
;바람 창이 최대화가 아닐 때 바탕화면 사진이나 뒤에 다른 창이 이미지 검색에 발견되는  경우 방지를 위해
global winEndX := A_ScreenWidth
global winEndY := A_ScreenHeight

;wingetPos를 CalPos() 라는 함수에서 사용해서 윈도우창의 가로 세로 길이를 전달해줄 변수
global winWidth := 0
global winHeight := 0







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
            isHunting := false ;Exit라서 초기화 못 시켜주는 건 여기서 초기화
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
SpreadHonmaLeft(magicCount)
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
        CustomSleep(10) ; 뒤에 사망확인 있으므로 후딜 40에서 10으로. 나머지 후딜 30은 유령확인이 담당해줌줌

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
        CustomSleep(10) ; 뒤에 아무것도 없으므로 후딜 10으로 바꿈꿈
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

t:: ; 공력주입(현재 탭탭대상상)
ManaInjection()
return 

+t:: ;공력주입
CustomSleep(130)
SendInput, {9}
return

+g:: ; 부활
CustomSleep(120)
SendInput, {0}
return



+e::  ;활력 돌리기 (shift + e -> 큐센 한 손 키보드 계산기모드)
SpreadVitality()
StopLoop := true
return


;공력주입
ManaInjection() {
    ;탭탭상태인지 확인 후 탭탭이면 바로 공력주입, 아니면 esc 눌러서(꼬임방지지) 탭탭 후 공력주입하고 다시 esc
    CheckTabTabOn()
    CustomSleep(20)
    if(isTabTabOn) {
        SendInput, {9}
        CustomSleep(60)
    } else {
        SendInput, {Esc}
        CustomSleep(20)
        SendInput, {Tab}
        CustomSleep(50)
        SendInput, {Tab}
        CustomSleep(50)
        SendInput, {9}
        CustomSleep(60)
        SendInput, {Esc}
        CustomSleep(20)
    }
    
    ;공력주입 후 동동주 한 번 마시고 공증}
    DrinkDongDongJu()
    CustomSleep(70)
    RestoreMana()    
    CustomSleep(20)
    return
}


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
        CustomSleep(60) ;후딜 60으로 바꿔봤다.
    }
    SendInput, {Esc}
    CustomSleep(30)
    SendInput, {Tab}
    CustomSleep(40)
    SendInput, {Tab}
    CustomSleep(40)
    return
}

SpreadHonmaRight(magicCount) { ;혼마 돌리기(오른쪽)
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

    loop, 330 ; 안전장치로 카운트 걸어둠. 어차피 맵 넘어갈 때 껐다 켜야되므로 걸어두는 것이 낫겠다. 거의 초당 1회다.
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
            CustomSleep(40)  ;후딜 80~90이었는데 탭탭이랑 왔다갔다 할 거기 때문에 혹시모를 꼬임 방지로 ESC 넣고 후딜 나눴음 50, 20에서 테스트 40,20
            SendInput, {Esc}
            CustomSleep(20) ; 후딜 30인데 금강이랑 나눠서 20, 10으로
            SendInput, {6} ;금강불체
            ;CustomSleep(10) ; 후딜 빼봄1
        }
        MouseMove, TabTabX, TabTabY, 1 ; 마우스 이동(우클 누른상태태). 탭탭추적은 탭탭 이후에만 가능했는데 이전 검색 좌표+@를 전달해서 마우스이동해서 긴 텀 보완
        SendInput, {Tab}
        CustomSleep(50)
        SendInput, {Tab}
        ;CustomSleep(10) ; 후딜 40인데 뒤에 추적있어서 후딜 10으로 낮춰봄. 후딜 빼봄2

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
            ;CustomSleep(10) ; 후딜 50인데 뒤에 추적있어서 후딜 10으로 낮춰봄; -> 후딜3개 뺸 이후에 힐 뒤에 추적있어서 후딜 빼봄4
            TabTabChase()
        }
        SendInput, {3} ;
        ;CustomSleep(10) ;공증 후딜 20이었는데 루프 순서상 다음에 뭐 있어서 걍 10 ;위에 후딜 2개 빼고 잘 됐다. 여기도 후딜 빼봄3. 안 되면 다시 롤백
        ;백호 뒤에 혼힐을 여기에 둬도 될 듯 한데 딜레이상 큰 차이는 없다.

        CheckEnoughMana() ; 만약 마나 부족하면 공증. 아주 가끔 마나부족 떠서 넣어봄.
        if(notEnoughMana) {
            RestoreMana()
        }


        

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
        CustomSleep(500)
        MouseMove, TabTabX, TabTabY, 1
    }
    SendInput, {Esc}
    CustomSleep(30)
    Click, Right up  ;추적 우클릭 해제 방지2
    return
}











;현재 활성화된 창의 우측하단 좌표 찾는 함수. 이거 안 쓰려면 바람 최대화 해놓고 winEndX, winEndY대신
;자체적으로 스크린 가로 세로 길이인 A_ScreenWidth, A_ScreenHeight  쓰면 됨
CalPos() {
    ;활성 창의 위치와 크기를 구합니다.
    ;winStartX, winStartY는 현재 활성화된 창의 시작 좌표. winWidth와 winHeight는 현재 활성화된 창의 가로 길이와 세로 길이이
    ;이 시작좌표와 끝 좌표가 화면상 좌표가 얼마인지 계산해준다. 시작좌표 + 가로길이하면 활성화된 창의 우측하단 끝점의 x좌표. y도 이렇게 구함
    ;단, 좌표는 0부터 시작하는 픽셀 인덱스이므로 크기만큼 더할 경우 1이 초과될 수 있으므로 -1을 해줘야 정확한 값이 나온다.
    WinGetPos, windowStartX, windowStartY, windowWidth, windowHeight, A

    
    ;이 함수에서 WinGetPos를 사용해서 winStartX, winStartY를 구해줬으므로 이를 전달해줄 변수에 담아준다.
    winStartX := windowStartX
    winStartY := windowStartY

    ;현재 활성화된 창의 우측하단 좌표를 계산해서 winEndX, winEndY에 저장.(글로벌 변수로 선언해둠)
    ;winStartX와 winStartY 그리고 winEndX, winEndY를 활용하면 현재 활성화된 창의 시작좌표, 끝좌표(우측하단) 알 수 있음
    winEndX := winStartX + windowWidth -1
    winEndY := winStartY + windowHeight -1

    ;윈도우 가로길이 세로길이 저장
    winWidth := windowWidth
    winHeight := windowHeight
    return
}





ImageSearchTest() {

    ;imgFolder 는 pc와 notebook 구분을 위해서 변수로 경로설정을 해놨다. global imgFolder : = A_ScriptDir . "\img\dosa\"

    CalPos() ;현재 활성창 우측하단 좌표 계산

    HalfHealthImgPath := imgFolder . "halfhealth.png"


    ;ImageSearch, FoundX2, FoundY2, startStatusBarX, startStatusBarY, A_ScreenWidth, A_ScreenHeight, %HalfHealthImgPath% ;체력 거의 절반쯤 이미지
    ImageSearch, FoundX2, FoundY2, startStatusBarX, startStatusBarY, winEndX, winEndY, %HalfHealthImgPath% ;체력 거의 절반쯤 이미지
    ImgResult2 := ErrorLevel ; 이미지가 검색되면 체력이 절반이 안 되는 것 -> 공력증강 상용시 위험
    if(ImgResult2 = 0) {
        MsgBox, 체력 절반 이하
    } else if(ImgResult2 = 1) {
        MsgBox, 체력 절반 이상
    } else {
        MsgBox, 기타 오류
    }
    return
}



F6:: ;이미지 서칭 테스트
ImageSearchTest()
return


+F6::
CheckFullMana()
if(isFullMana) {
    MsgBox, 풀마나
}
return

!F6::
CheckWrongTarget()
if(isWrongTarget) {
    MsgBox, 잘못된 대상
}
return

^F6::
CheckCastOnHorse()
if(isRiding) {
    MsgBox, 말에 탄상태
}
return

F7::
CheckEnoughMana()
if(notEnoughMana) {
    MsgBox, 마나부족
}
return

+F7::
CheckHalfHealth()
if(isHalfHealth) {
    MsgBox, 체력 절반 이상
}
return


^F7::
RestoreManaAtLow()
return

!F7::
SafeRestoreManaAtLow()
return

+^F7::
CheckTabTabOn()
if(isTabTabOn) {
    MsgBox, 탭탭창 열림
}
return

F8::
CheckManaZero()
if(isManaZero) {
    MsgBox, 마나 0
}
return


+F8::
DeathCheck()
if(isDead) {
    MsgBox, 유령상태
}
return

^F8:: 
TabTabChase()
return





;**이미지 서칭**
    ; 화면의 특정 영역에서 이미지 검색    
    ; ImageSearch, OutputX, OutputY, X1, Y1, X2, Y2, ImageFile(변수사용은 %%로 감싸서 %ImagePath%)
    ; 이미지 경로는 ImagePath := A_ScriptDir . "\img\joosool\image.png"  이런식인데  A_ScriptDir는 스크립트 현재 폴더이고 오토핫키에서 문자열 더하기는 점(.) 으로 이어준다 ( + 아님)
    ; 이미지를 검색하고 나서 결과는 ErrorLevel에 저장되는데 이를 다른 이름의 변수에 넣어서 활용해도 된다.( ImageResult1 := ErrorLevel 이런식으로)
    ; ErrorLevel = 0은 이미지가 발견o, 1은 발견x, 2는 이미지 경로를 찾을 수 없음
    ; 만약 이미지 일치정도를 조절하려면
    ; ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *100 %ImagePath% 
    ;-> 이미지파일 앞에 *숫자는 일치허용범위 조절 가능 0~255까지 가능하며 기본0(완전 동일한 것을 검색) 높을 수록 유사도가 낮아도 매칭됨
    ; 0~150정도로 ㄱㄱ
    ; *숫자 말고 *TransColor: 특정 색상을 무시 ( 예: *Trans0xFFFFFF  -> 흰색 배경 무시)

    ; imgFolder 는 pc와 notebook 구분을 위해서 변수로 경로설정을 해놨다. global imgFolder : = A_ScriptDir . "\img\joosool"    

    ; ImageSearch 에서 FoundX와 FoundY는 찾은 이미지의 x좌표와 y좌표 변수 이름 지어준 것이고
    ; 검색범위는 0,0에서 A_ScreenWidth(화면 가로길이), A_ScreenHeight(화면 세로길이) 사이에서 검색한다.
    ; 이때 활성화된 우측 하단의 좌표는 직접 구하는 것은 오토핫키 v1에는 없다. 구하는 방법은 아래와 같다.
    ; 대신 활성화된 창의 시작 좌표를 구하는 자체 변수는 있다. winStartX와 winStartY다.
    
    ; 활성 창의 위치와 크기를 구해서
    ;WinGetPos, windowStartX, windowStartY, windowWidth, windowHeight, A
    ; 우측하단의 x좌표와 y좌표는 오른쪽 아래 좌표를 계산해서 winEndX와 winEndY를 사용. (시작좌표는 winStartX와 winStartY 사용)
    ;winEndX := winStartX + windowWidth
    ;winEndY := winStartY + windowHeight

    ; 활성화된 창의 좌표를 이용할 경우 위에 코드를 쓰고 이렇게 활용하면 된다.(아니면 최대화 시켜놓고 하자)
    ; ImageSearch, FoundX, FoundY, winStartX, winStartY, winEndX, winEndY, *100 %ImagePath%    

    ;시간 되면 위의 코드를 함수로 만들어서 사용하자. 깔끔하게


;아래 RestoreMana는 마나가 조금 남아 있는 이미지를 검색해서 못 찾을 경우(마나가 거의 바닥)공력증강을 사용하는 것이다.
;(Safe는 체력이 절반쯤 이상일 때)
;스킬을 사용하다가 마나가 거의 바닥이 되면 이를 인지하고 공력증강을 사용하는 것인데 헬파 쓰고 마나가 남은 이미지를 못 찾은 것은
;페이백을 받지 못해서 마나가 0 (혹은 그에 근접할 정도로 극미량의 페이백)이 되는 것이므로 동동주 마시고 공력증강 사용하면 된다.
;하지만 아래에 만들어 둔 것은 자동첨첨사냥할 때 스킬을 사용하다가 마나가 바닥일 경우 공증을 쓰기 위함이기 때문에
;아무래도 이미지가 감지 안 될정도로 마나가 낮아졌지만 마나통이 큰 만큼 공증을 사용할만큼의 마나는 몇백 남아있기 때문에
;굳이 여기다가 동동주 마시고 공증을 해줄 필요는 없다.

;헬파쓰고 나서는 CheckLowMana()를 하나 만들어서 mana 이미지가 감지되면 페이백, 못 받았다면 0이라 본다(첨첨사냥시에는 0은 아니지만 CheckEnoughMana()로 마나량 확인)
;각각의 경우에 따라 isLowMana를 변경해주고 동동주 마시고 공증할지 그냥 공증할지 정하면 될 것이다.
;isLowMana로 판별하지만 미세하게 마나가 남아 있을 수도 있다. 이때는 CheckEnoughMana로 시전시 마나량 충분여부를 판별




CheckHalfHealth() { ;체력 절반쯤인지 확인. -> 체력 절반 까진 이미지 검색해서 검색되면 절반 이하, 검색 안 되면 절반 이상인 것
    isHalfHealth := false ; 초기화

    CalPos() ;현재 활성창 우측하단 좌표 계산

    ; imgFolder 는 pc와 notebook 구분을 위해서 변수로 경로설정을 해놨다. global imgFolder : = A_ScriptDir . "\img\joosool"
    HalfHealthImgPath := imgFolder . "halfhealth.png"
    ImageSearch, FoundX1, FoundY1, startStatusBarX, startStatusBarY, winEndX, winEndY, %HalfHealthImgPath% ;체력 거의 절반쯤 이미지
    ImgResult1 := ErrorLevel ; 이미지가 검색되면 체력이 절반이 안 되는 것. 검색 안 되면 절반 이상
    if (ImgResult1 = 1) { ; 발견 안 되면 체력 절반 이상
        isHalfHealth := true 
    }

}



;SafeRestoreManaAtLow() 만든 이후에 CheckHalfHealth()를 만든 것이다. SafeRestoreManaAtLow()는 이미지 서칭2개 예제로 그냥 남겨둠

SafeRestoreManaAtLow() { ; 체력 절반쯤 이상(안전한 공력증강) + 마나가 거의 바닥이면 공력증강

    CalPos() ;현재 활성창 우측하단 좌표 계산

      ; 이미지 경로 설정 (실행한 스크립트의 상대경로)
      ManaImgPath := imgFolder . "mana.png"
      HalfHealthImgPath := imgFolder . "halfhealth.png"


    ;원래 마나는 1400, 800으로 했지만 그냥 1300, 700으로 체력이랑 통일 시켰다. 오류가 생기면 그냥 이전에 쓰던 1400, 800으로 롤백
    ImageSearch, FoundX1, FoundY1, startStatusBarX, startStatusBarY, winEndX, winEndY, %ManaImgPath% ; 마나존재 이미지
    ImgResult1 := ErrorLevel  ;이미지가 검색되면 마나가 존재하는 것이고 찾지 못 하면 거의 바닥이라 공력증강 필요
    CustomSleep(10)

    ImageSearch, FoundX2, FoundY2, startStatusBarX, startStatusBarY, winEndX, winEndY, %HalfHealthImgPath% ;체력 거의 절반쯤 이미지.     
    ImgResult2 := ErrorLevel ; ;체력 절반쯤 깎인 이미지 이므로 검색되면 절반쯤 이하, 검색 안 되면 절반쯤 이상인 것. 즉, 검색 안 될 때 안전한 공증 ㄱㄱ


    if (ImgResult1 = 1 && ImgResult2 = 1) ;마나 거의 없고 피 절반쯤 이상일 때
                        ; -> 내 이미지는 파란색 마나가 남아 있는 것으로 발견되지 않을 경우, 즉 1일 경우에 공력증강 사용하자
        {            
            Loop, 30 { ;혹시 몰라서 횟수제한 걸어둠
                if (StopLoop) {            
                    Break
                    CustomSleep(20)
                }
                ; 공력증강
                SendInput, {3}
                CustomSleep(100)

                CheckEnoughMana()
                CustomSleep(50)
                if(notEnoughMana) {
                    DrinkDongDongJu()
                    CustomSleep(100)
                    SendInput, {3}
                    CustomSleep(100)                    
                }
                CheckFullMana()
                CustomSleep(50)
                if(isFullMana) {
                    break
                    CustomSleep(30)
                }
            }
            
        }
    return
}


RestoreManaAtLow() {    

    CalPos() ;현재 활성창 우측하단 좌표 계산

    ManaImgPath := imgFolder . "mana.png"
    ImageSearch, FoundX1, FoundY1, startStatusBarX, startStatusBarY, winEndX, winEndY, %ManaImgPath% ; 마나존재 이미지
    ImgResult1 := ErrorLevel  ;이미지가 검색되면 마나가 존재하는 것이고 찾지 못 하면 거의 바닥이라 공력증강 필요
    if (ImgResult1 = 1) { ;마나 거의 없을 때(체력 상관x)
    ;   -> 내 이미지는 파란색 마나가 남아 있는 것으로 발견되지 않을 경우, 즉 1일 경우에 공력증강 사용        
            Loop, 30 { ;혹시 몰라서 횟수제한 걸어둠
                if (StopLoop) {            
                    Break
                    CustomSleep(20)
                }
                ; 공력증강
                SendInput, {3}
                CustomSleep(100)
                
                CheckEnoughMana()
                CustomSleep(50)
                if(notEnoughMana) {
                    DrinkDongDongJu()
                    CustomSleep(100)
                    SendInput, {3}
                    CustomSleep(100)
                }
                CheckFullMana()
                CustomSleep(50)
                if(isFullMana) {
                    break
                    CustomSleep(30)
                }
            }
    }
    return
}




SafeRestoreMana() { ; 체력 절반쯤 이상(안전한 공력증강)일 때 남은 마나 상관없이 공력증강

    CalPos() ;현재 활성창 우측하단 좌표 계산


    HalfHealthImgPath := imgFolder . "halfhealth.png"


    ImageSearch, FoundX1, FoundY1, startStatusBarX, startStatusBarY, winEndX, winEndY, %HalfHealthImgPath% ;체력 거의 절반쯤 이미지
    ImgResult1 := ErrorLevel ; 이미지가 검색되면 체력이 절반이 안 되는 것 -> 공력증강 상용시 위험


    if (ImgResult1 = 1) ;체력 절반쯤 이상일 때.  체력 절반쯤 깎인 이미지 이므로 검색되면 절반쯤 이하, 검색 안 되면 절반쯤 이상인 것
        {            
            Loop, 30 { ;혹시 몰라서 횟수제한 걸어둠
                if (StopLoop) {            
                    Break
                    CustomSleep(20)
                }

                ; 공력증강
                SendInput, {3}
                CustomSleep(150) ;후딜 150정도는 해주고 나서 마나 관련 이미지 체크해야된다. 아니면 공증으로 마나 회복 전에 인식돼서 꼬일 수 있음

                CheckEnoughMana()
                CustomSleep(50)
                if(notEnoughMana) {
                    DrinkDongDongJu()
                    CustomSleep(100)
                    SendInput, {3}
                    CustomSleep(150) ;후딜 150정도는 해주고 나서 마나 관련 이미지 체크해야된다. 아니면 공증으로 마나 회복 전에 인식돼서 꼬일 수 있음                 
                }
                CheckFullMana()
                CustomSleep(50)
                if(isFullMana) {
                    break
                    CustomSleep(30)
                }
            }
            
        }
    return
}



RestoreMana() {    ;체력 상관없는 공력증강 시도
    Loop, 30 { ;혹시 몰라서 횟수제한 걸어둠
        if (StopLoop) {            
            Break
            CustomSleep(20)
        }
        ; 공력증강
        SendInput, {3}
        CustomSleep(150) ;후딜 150정도는 해주고 나서 마나 관련 이미지 체크해야된다. 아니면 공증으로 마나 회복 전에 인식돼서 꼬일 수 있음
        
        CheckEnoughMana()
        CustomSleep(50)
        if(notEnoughMana) {
            DrinkDongDongJu()
            CustomSleep(100)
            SendInput, {3}
            CustomSleep(150) ;후딜 150정도는 해주고 나서 마나 관련 이미지 체크해야된다. 아니면 공증으로 마나 회복 전에 인식돼서 꼬일 수 있음
        }
        CheckFullMana()
        CustomSleep(50)
        if(isFullMana) {
            break
            CustomSleep(30)
        }
    }
    return
}



;마나가 조금이라도 있는지 확인. 마나가 조금 있는 이미지 검색 후 발견되면 조금이라도 있는 것(헬파 페이백 혹은 조금 마나리젠 된 것)
;이미지가 발견 안 되면 마나가 아예 바닥인 것
;(헬파 이후 페이백 받았는지 아닌지 판별용도로 유용 첨첨사냥시 CheckLowMana()체크하고 false면  CheckEnoughMana()로 시전가능 연계하면 굳)
;마나량 확인시에는 스킬 사용이후 후딜 150은 줘야 삑 안 나고 확인 가능하다
CheckLowMana() {
    isLowMana := false ;초기화    

    CalPos() ;현재 활성창 우측하단 좌표 계산

    
    ManaImgPath := imgFolder . "mana.png"
    ImageSearch, FoundX1, FoundY1, startStatusBarX, startStatusBarY, winEndX, winEndY, %ManaImgPath% ; 마나존재 이미지
    ImgResult1 := ErrorLevel  ;이미지가 검색되면 마나존재 -> 헬파 이후 페이백 받은 것, 안 되면 페이백 못 받고 마나 0
    if (ImgResult1 = 0) { ;마나 발견 -> 페이백 혹은 어느정도 마나가 존재하는 것
        isLowMana := false

        ;원래 이미지 검색 한 번에 하나의 변수만 바꾸줬는데 마나 관련해서는 마나가 조금이라도 존재하는(풀마나 혹은 마나존재) 것이 확인되면 isManaZero는 false로 초기화를 해주도록 하자
        isManaZero := false
    } else { ;발견 안 됨 -> 마나 바닥 -> 시전시 마나량 충분한지 확인은 필요시 해당 로직에서 checkEnoughtMana로 처리
       isLowMana := true       
    }
    return
}

;풀마나 확인(공력증강 성공)
;마나량 확인시에는 스킬 사용이후 후딜 150은 줘야 삑 안 나고 확인 가능하다
CheckFullMana() {
    isFullMana := false ;초기화

    CalPos() ;현재 활성창 우측하단 좌표 계산

    FullManaImgPath := imgFolder . "fullmana.png"
    ;이미지검색 *n을 *한 *120쯤으로 하면 힐 3틱정도만 허용.
    ;*160으로 한 것은 힐3틱하고 마비같은 거 돌렸을 때 마나 3프로쯤 소모된 것도 풀마나라고 해준다. -> 안정적
    ;*180으로 한 것은 10프로쯤 소모된 것도 풀마나라고 해주는데 가끔 절반 소모해도 풀마나로 인지해서 불안정적이다. 160 추천

    ; -> 알고봤더니 불안정한 것은 검색 범위가 스크린인데 창 바깥에 바닷가 푸른색 배경화면 때문에 오작동한 것이었다.
    
    ;숫자를 더 올리면 허용 범위가 넓어진다. 헬파 사냥시 한 방 컷 혹은 페이백 마나를 고려해서 수치 조정 해주자
    ImageSearch, FoundX1, FoundY1, startStatusBarX, startStatusBarY, winEndX, winEndY, *180 %FullManaImgPath% ; 마나존재 이미지
    ImgResult1 := ErrorLevel  ;이미지가 검색되면 풀마나
    if (ImgResult1 = 0) { ; 이미지 검색됐으므로 풀마나. 즉 공력증강 성공           
        isFullMana = true
        ;MsgBox, 풀마나

        ;원래 이미지 검색 한 번에 하나의 변수만 바꾸줬는데 마나 관련해서는 마나가 조금이라도 존재하는(풀마나 혹은 마나존재) 것이 확인되면 isManaZero는 false로 초기화를 해주도록 하자
        isManaZero := false 
    }
    return
}

;잘못된 대상에게 사용한 것 판별
CheckWrongTarget() {
    isWrongTarget := false ;초기화

    CalPos() ;현재 활성창 우측하단 좌표 계산

    WrongTargetImgPath := imgFolder . "wrongtarget.png"
    
    ImageSearch, FoundX1, FoundY1, startCastBarX, startCastBarY, winEndX, winEndY, %WrongTargetImgPath% ; 잘못된대상 이미지
    ImgResult1 := ErrorLevel  
    if (ImgResult1 = 0) { ;이미지가 검색되면 잘못된 대상에게 마법 사용
        isWrongTarget = true
        ;MsgBox, 잘못된 대상
    }
    return
}

;말에 탄 상태에서 시전
CheckCastOnHorse() {
    isRiding := false ;초기화

    CalPos() ;현재 활성창 우측하단 좌표 계산

    CastOnHorseImgPath := imgFolder . "castonhorse.png"
    
    ImageSearch, FoundX1, FoundY1, startCastBarX, startCastBarY, winEndX, winEndY, %CastOnHorseImgPath% ; 말에 타서 스킬 시전
    ImgResult1 := ErrorLevel  
    if (ImgResult1 = 0) { ;이미지가 검색되면 말에 탄 상태에서 스킬 시전한 것
        isRiding = true
        ;MsgBox, 말에 탄 상태
    }
    return
}



;시전에 필요한 마나가 충분한지 판별. 마력이 부족합니다에서 마 라는 메시지 스캔
;마나량 확인시에는 스킬 사용이후 후딜 150은 줘야 삑 안 나고 확인 가능하다
CheckEnoughMana() {
    notEnoughMana := false ;초기화.

    CalPos() ;현재 활성창 우측하단 좌표 계산

    NotEnoughManaImgPath := imgFolder . "notEnoughMana.png"
    
    ImageSearch, FoundX1, FoundY1, startCastBarX, startCastBarY, winEndX, winEndY, %NotEnoughManaImgPath% ; 시전시 마나 충분한지 확인
    ImgResult1 := ErrorLevel  
    if (ImgResult1 = 0) { ;이미지가 검색되면 시전시 필요한 마나 부족한 것
        notEnoughMana = true  ;마나량 부족        
    }
    return
}


;마나가 0인지 판별. 주술의 경우 헬파시전 이후 페이백 없을 때(도사에 사용한다면 공력주입 이후)
;마나량 확인시에는 스킬 사용이후 후딜 150은 줘야 삑 안 나고 확인 가능하다
CheckManaZero() {
    isManaZero := false ;초기화.

    CalPos() ;현재 활성창 우측하단 좌표 계산

    ManaZeroImgPath := imgFolder . "manazero.png"
    
    ImageSearch, FoundX1, FoundY1, startCastBarX, startCastBarY, winEndX, winEndY, %ManaZeroImgPath% ; 마나 0인지 확인
    ImgResult1 := ErrorLevel  
    if (ImgResult1 = 0) { ;이미지가 검색되면 마나 0인 것
        isManaZero = true  ;마나량 0       
    }
    return
}


;AutoHotkey 1.0에는 현재 창의 너비와 높이를 나타내는 내장 변수(예: A_winWidth, A_winHeight)가 없다
;따라서 특정 창에서 이미지 검색을 하려면, 먼저 그 창의 위치와 크기를 얻어와야 합니다. 이를 위해 WinGetPos 명령을 사용할 수 있습니다.
CheckTabTabOn() {
    isTabTabOn := false ;초기화

    CalPos() ;현재 활성창 우측하단 좌표 계산

    tabtab :=imgFolder . "tabtab4.png" ;탭탭4번 그림으로
    
    ;ImageSearch, FoundX1, FoundY1, winStartX, winStartY, winEndX, winEndY,*30 %tabtab% ;탭탭라인 검색

    ;원래 위에 주석처리 해둔 걸로 했다. CalPos()로 winEndX, winEndY에 현재 활성화된 창의 우측하단 끝 좌표를 구해서 활성창의 시작과 끝을 구해서
    ;활성화된 창 내에서만 검색하려고 했다. 실제로 예를들어 활성화된 창의 가로 길이가 1896이라고 한다면 이 창이 가운데 있고 최대가 아니기에
    ;화면 좌측에서 살짝 떨어져 있었고(예를들어 50만큼) 실제로 활성화된 창 x좌표는 떨어진 50 + 가로길이 1896 해서 1946이라고 할 수 있다.
    ;그러면 가로 검색범위는 스크린의 50 ~ 1946 범위에서 검색한다면 현재 활성화된 창의 가로 길이 내에서만 이미지 서칭을 한다.
    ;그런데 화면 밖에서 이미지가 검색이 되었고 좌표를 확인하니  1963 이었고 window좌표는 1907이었다.
    ;노트북이라서 scale 때문인가.. dpi 120이고 스케일 1.25배인 상태다. 아무튼 노트북에서는 창의 가로 세로 길이까지 검색으로 해주면 될 듯듯
    ;뭔가 이미지 서치가 스크린 전체라지만 잘 안 먹히는 것 같다. 일단 다음에 스케일링 조정 해주고 일단은 탭탭체크만
    ;CalPos()에서 창의 가로길이 세로 길이를 변수에 저장해서 tabtabOn() 여기서만 범위를 가로세로 길이까지만.

    ImageSearch, FoundX1, FoundY1, winStartX, winStartY, winWidth, winHeight,*30 %tabtab% ;탭탭라인 검색
    ImgResult1 := ErrorLevel ; 탭탭창 열려 있는지 확인하기 위함
    if(ImgResult1 = 0) {        
        isTabTabOn := true
    } 
    return
}






TabTabChase() {

    ; 활성 창의 위치와 크기를 구합니다.
    ;WinGetPos, winStartX, winStartY, winWidth, winHeight, A

    ; 오른쪽 아래 좌표를 계산합니다.
    ;winEndX := winStartX + winWidth
    ;winEndY := winStartY + winHeight


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
    

    tabtab := imgFolder . "tabtab4.png" ;탭탭4번 그림으로

    ;일단 창 크기 계산은 세로는 280쯤 빼주자(해상도에 따라 더 조절 필요할 수도도). 외치기 색에 탭탭색이 검색된다
    ImageSearch, FoundX1, FoundY1, winStartX, winStartY, 1430, 850,*30 %tabtab% ;가로는 아이템창 이전쯤, 세로는 채팅창 이전쯤 까지만. 외치기에 검색되더라
    ;ImageSearch, FoundX1, FoundY1, winStartX, winStartY, winEndX, winEndY,*30 %tabtab% ;탭탭라인 검색  ;바람창 내부에서만 검색
    ;ImageSearch, FoundX1, FoundY1, 0, 0, A_ScreenWidth, A_ScreenHeight,*30 %tabtab% ;탭탭라인 검색 오리지널(바람 창 최대화 혹은 뒤에 다른 창x)
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








DeathCheck() {
    isDead := false
    CalPos() ;현재 활성창 우측하단 좌표 계산

    SendInput, {Blind}0 ; 도사 본인 유령 체크하는 것이라서 격수는 알 수 없기에 일단 부활 시전 한 번 하고(탭탭상황) 도사 유령확인. 꼬이면 뺸다
    death := imgFolder . "healthzero.png"

    ImageSearch, FoundX1, FoundY1, startStatusBarX, startStatusBarY, winEndX, winEndY, %death% ;유령상태
    ImgResult1 := ErrorLevel ; 
    if(ImgResult1 = 0) {
        isDead := true
    } 
    return
}






#If
    

