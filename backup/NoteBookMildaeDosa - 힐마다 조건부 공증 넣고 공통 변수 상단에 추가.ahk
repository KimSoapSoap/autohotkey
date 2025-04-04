﻿;저주, 중독, 마비 혼마 등 돌리기 마법횟수 변수 (단일 사용 OO돌리기들 시전횟수 통일할 때 사용)
;기본 카운트 20, 
global magicCount := 16
;주술 꺼 가져왔는데 도사는 혼마 돌리기, 시력회복 돌리기, 파혼술 돌리기 매개변수에 넣어주면 될 것 같다.


;힐틱 몇 번 쓰고 공증 시도할 것인지 정할 변수.  5면 힐틱 5번 싸이클 돌리고 공증시도 한다.(mod 이용용)
;TabTabHealRefresh()같이 힐+백호만 쓰는 것은 힐 1틱당 싸이클이 2번 돌아가므로 변수x2를 해줘야되고
;혼도 같이 돌리는 HonHeal(), ChaseHonHeal(), StandingHonHeal() 이 함수들은 그냥 변수 그대로 넣어주면 된다.
global ManaRefreshPerHealTick := 5


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

;TabTab창 색깔 찾는 TabTabChase()나 CheckTabTabOn()은 아이템창 왼쪽, 채팅창 위쪽으로 좌표를 제한해야 한다.
;템은 혹시 몰라서고 채팅창 외치기 색깔이 tabtab으로 인식이 된다.
;일단 pc와 노트북 공통으로 1430, 830 범위로 해놨다.(현재 환경에선 공통적용 가능) 혹시 오작동 하면 pc나 노트북 좌표는 따로 설정해주자

global imgFolder := A_ScriptDir . "\img\dosa\notebook\"
;global imgFolder : = A_ScriptDir . "\img\dosa\"
;pc는 "\img\dosa\""   이고   notebook은   "\img\dosa\notebook\"
;A_ScriptDir은 현재 스크립트의 폴더경로이고 점(.)은 오토핫키에서 문자열을 더하는(+) 부호이다. 시작부분을 그냥 가져왔으므로 A_ScriptDir는 맨 앞에 붙여놓고 . 으로 이어 놓으면 된다.



; 혼힐 할 때 혼 3마리 돌리고 힐하고 하면 거의 힐틱 딜레이 로스되지 않고 힐 할 수 있다
; 단지 혼 돌리고 힐 하기 때문에 힐틱최대치인 3회는 아니고 2회만 회복시킨다
; 1차하고 백호의 희원 배우고 2차하고 신령의 기원까지 배우면 2회 회복 + 백호의 희원으로 제법 많이 회복할 수 있다

; -> 이제는 혼 돌리고 3회 회복시킬 수 있다. 혼 돌리고 탭탭 후 힐이 한 번 씹히는 경우가 생겨서
; 기원3 백호1은 기원이 2번만 들어가는 경우가 생겼다. 혼 돌리고 후딜 40안 주고 후딜 10만 주고 기원4 백호1 설정했다. 백호 뒤에 기원1은 씹힘 보완
; 그래서 단순 밀대힐은 탭탭 풀 일이 없기 때문에 탭탭하고 바로 힐 넣을 때 씹히는 경우가 첫 한 번 뿐이기 때문에 3번만 넣어줬다(4번 넣으면 백호가 씹힘)



; 만약 마우스로 이동한다면 밀대힐 대신에 혼힐 반복하면 움직이면서 혼 + 회복도 걸어줄 수 있다(참고)
; -> 이건 내가 PC로 도사 플레이할 때 가능하다


;단축키에 컨트롤 조합은 밀대힐 중에도 사용할 수도 있는 함수일 때 사용한다.(시력회복 돌리기, 신령지익진, 파력무참진, 셀프시력회복 등)
;쉬프트 조합은 밀대힐 중 쉬프트 누르는 순간 쉬프트 + 1, 2 같은 인겜 내부 외치기, 문파대화 등이 동작되어 불가능 하다.

;단축키 설정 고민인 부분이 shift 조합은 탭탭힐 상황에서는 사용할 수 없으므로 ctrl 조합으로 해두면
;평소에도 사용할 수 있고 탭탭힐 중에도 필요시 수동으로 탭탭 대상에게 사용할 수도 있다. 
;참고로 탭탭힐 중에도 탭탭 대상에게 사용가능한 것이지 탭탭힐 도중 탭탭 대상이 아닌 다른 곳에 사용하려면 입력대기를 사용해야한다.


;단축키 설정
;wasd 이동
;f2 자신선택 및 동동주   f3 자신선택 및 말타기 및 중지(StopLoop = true를 이용해 중지 후 마무리 -> Exit로 빠져나오는 StopLoopCheck()와는 다르다.)
;1 그냥 힐(탱커모드시 공력증강 빈도 감소소) 백호의히원 반복 (무빙가능)   2 정지   3 추적혼힐  4 제자리 혼힐(탱커모드시 공력증강 빈도 감소),5 백호의희원첨
;q 입력대기(아래에서 자세히) e 짧은 혼힐 돌리기, f 적당한 혼힐 돌리기(탱커모드시 4방향 혼) c 긴 혼마 돌리기, r 선택혼, t탭탭대상 공력주입
;v: 탭탭대상 보호+무장  b유령체크해서 부활  g 금강(힐 중에는 자동사용)

;ctrl + q : 본인 각종회복(시력회복,파혼술,해독 + 보호)// ctrl + w : 시력회복 돌리기
;ctrl + e : 지진돌리기기(지진이 극진처럼 후딜 1초쯤 있어서 완전히 돌리기는 안 될 듯) //ctrl + r : 시력회복 // ctrl + t:해독
; ctrl + a:신령지익진// ctrl + s : 상태창// ctrl + d : 파력무참진  //ctrl + f : 퇴마주 // ctrl + g : 파혼술술
; ctrl + space : 미정

;shift + q :무력화 // shift + t 공력주입 //shift + g :탭탭대상과 본인부활


;입력대기 단축키(입력대기 상태에서)
;e지진, r시력회복, t해독  f퇴마주, g파혼술 space부활 + 힐3틱 + 보호   


;입력대기  t에 공주넣고 g에 파혼+해독 넣을까? 생각중

;예정 단축키
; 5백호의희원 첨



;토글 설정
; alt + c 추적시 상하 랜덤좌표on/off (기본 on)
; alt + s  탱커모드 -> 공증을 힐 5틱에 한 번씩(count 적어줄 때 그냥 밀대힐은 싸이클 2번씩 도므로 원하는 틱 빈도의 x2, 제자리 혼힐은 x1)
                    ;  f키가 4방향 혼이다 (삼매진화를 위해)
; alt + w 무사의 방 모드 -> 힐에 시력회복, 파혼술 넣었음 (해독은 번호가 아니라서 사용하기 좀 애매하다. 고민해보자). 입력대기 부활에는 해독까지 넣음


;원래 9번이 공력주입, 0번이 부활이어서 공주가 r키, 부활이 T키 였는데
;r키에 선택혼(마우스 포인트 위치의 몹에 혼마 걸기) 넣고 t키에 공력주입으로 바꿨다
;그럼 원래 부활이었던 T키는? 쉬프트+g 같은 다른 키로 변경했음. -> g키가 탭탭부활(격수부활) 그리고 본인부활 후 다시 탭탭 사용중이므로
;어쨌든 원래 qwert 키가 fghij 마법을 67890 눌러서 스킬 쓰는 것인데 자리를 이렇게 저렇게 봐꿨지만
;공력주입이 9번(i) 부활이 0번(j) 인 건 그냥 그대로 놔두고 쓰자.


;5번 차폐는 거의 안 쓰니 다른 걸로 바꾸든지 하자. 예를들면 파혼, 시력회복 등


;입력대기중 스페이스가 부활+힐이다. 이때 클릭도 부활+힐로 된 상태인데
;나중에 입력대기 파혼,시력회복,퇴마주,해독 등 추가하고 나서는 클릭으로 부활을 빼던가 하자.
;어차피 클릭하고 스페이스 누르면 되고 나머지 스킬들도 클릭으로 빠른 타겟 선택 가능할 수 있어야 하기 때문이다.



;나와 탭탭 대상 부활 말고 다른 사람을 부활 시킬 때 선택을 해야되므로 힐을 멈추고 해야된다.
;밀대도사에도 입력대기를 도입해서 부활(대상 선택후 특정키 입력 혹은 대상 클릭하면 시전), 취소(c키 혹은 esc키)
;이렇게 입력대기에 부활을 도입하고(힐 중에도 잠시 멈췄다가 가능. 그냥하면 부활 대상 선택하기 전에 코드 다 실행하고 다시 힐로 돌아가버림)


; 보통 저주계열 돌릴 때 후딜 70 ~ 90 으로 하고 중간에 다른 거 쓸 때 꼬임 방지용으로 후딜을 나눠서
;enter 이후 esc 입력으로  후딜을 예를들면 90을   엔터 후딜 60,  esc 후딜 30 이렇게 꼬임방지용으로 나눠놨다
;그런데 honheal과 StandingHonHeal에서 혼마가 씹히는 경우가 생겨서 70 20 으로 해줬다.
;60, 30일 때는 뭔가 enter로 시전되기 전에esc가 입력돼서 씹힌 게 아닌가 싶은 느낌






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


;혼힐할 때 밀대힐 중이면 힐 틱당 힐 마무리 하고 혼 돌리기, 밀대힐 아니면 바로 혼 돌리기 하려고
global isMildaeHealOn := false


;따라가기에 사용하는 변수.
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
global isHuntingOn := false


;마나 0인지 확인
;원래 이미지 검색 한 번에 하나의 변수만 바꾸줬는데 마나 관련해서는 마나가 조금이라도 존재하는(풀마나 혹은 마나존재) 것이 확인되면 isManaZero는 false로 초기화를 해주도록 하자
global isManaZero := false


;죽었는지 확인
global isDead := false


;추적상태인지 확인. 예를들면 추적혼힐 때 공력주입을 쓰고 RestoreMana()를 쓸 때
;공증이 계속 실패하면 이전에 추적된 좌표에 마우스 우클이동 고정이라서 엉뚱한 곳으로 갈 수 있기 때문.
;RestoreMana()에 추적중이면 TabTabChase() 하나 넣어줬다.
global isChasing := false

;탭탭추적시 상하 랜덤좌표 on/off에 사용할 변수
global noRandomPos := true

;탱커모드 on/off에 사용할 변수
global isTankerModOn := false


;무사의 방 모드 on/off에 사용할 변수
global isAtMooSaRoom := false



;입력대기에 타이머 추가 후 이 변수를 확인 후 true면 {Esc}를 입력해서 취소하게 만들기 위한 변수
global CancelInput := false





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



;시작히 false를 해주는 함수들은 자체 초기화를 해주기 때문에 상관없지만
;자동사냥, 헬파원샷, 헬파자동사냥 등 함수 사용시 true로 해주는 변수들은 false로 초기화를 해준다.
StopLoopCheck() {
    if (StopLoop)
        {            
            SendInput, {Esc}
            CustomSleep(20)  
            CancelInput := true ; 입력대기 취소
            isMildaeHealOn := false ;밀대힐 취소
            isHuntingOn := false ;Exit라서 초기화 못 시켜주는 건 여기서 초기화
            Click, Right up ;추적 우클릭이동 해제
            Exit  
        }
}


pause::  ; 리로드 ;노트북은 NumpadMult
Suspend Off       ; Suspend 상태에서 동작하도록 강제로 해제
StopLoop := true
Reload
return


NumpadMult::  ; 리로드(노트북용)
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
!c:: ;탭탭추적에 상하 랜덤좌표 on/off 토글글
ToggleNoRandomPos() 
return

!s:: ;탱커모드 -> 공증을 1틱마다 하지 않고 여러틱마다 시도한다. -> TabTabHealRefresh(), StandingHonHeal() 에 해당
ToggleTankerMode()
return

!w:: ;무사의 방 모드 -> 공증 전 탭탭 대상에게 파혼술과 시력회복을 걸어준다.
ToggleMooSaRoomMode()
return


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



;혼힐을 수정혼 + 적당한 개체수일 때 사용용

;혼힐(a,b)는  힐은 기본적으로 3틱시전.  혼 a만큼 돌리고 나서 힐3틱 과정정을 b만큼 반복. 혼2번시(a = 2) 힐 3틱 최대시전. 혼3번부터 힐로스
; a가 2일 땐 너무 숫자가 낮아서 다른 딜레이 10씩 내리고 a 3으로 해서 힐틱 딜레이 로스 거의 안 밀리게 했다. 그래서 3으로 사용

;그래도 격수 피통이 높아지면 혼힐이 나을까 싶기도 하고 hps때문에 혼힐로

;수정혼 + 적은 몹수
e:: ;혼힐 -> 수정혼 느낌으로
;입력대기시 해당키 입력 할당
if(isWaiting) {
    send,{e} ;지진
    return
}
HonHeal(3,2)
return


;수정혼 + 적당한 몹수
;탱커 모드에서는  2배로 해주자. 주로 1번 TabTabHealRefresh() 쓰면서 이동하므로 따로 4번 StandingHonHeal() 쓰고 다시 1번쓰고 하면서 안 하려고고
f:: ; 
;입력대기시 해당키 입력 할당
if(isWaiting) {
    send,{f} ;퇴마주
    return
}
if(isTankerModOn) {
    ;HonHeal(3,8) ;원래는 혼힐을 조금 더 길게하는 거였는데 산적 삼매 몸빵을 위해 4방향 혼으로
    FourWayHonma()
    return
}
HonHeal(3,4)
return


;e로 정말 짧은 혼은 비슷한 코드로 감지되지 않게 혼 격수힐 번갈아가면서하는 거 혹은 꾹 누르는 걸로로



;현재 부활 코드에서 마지막에 탭탭으로 다시 격수지정할 때 마지막 탭 이후 커스텀슬립이 안 붙어 있음





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
    ;isMildaeHealOn := true  ;밀대힐 아닐 때도 쓰려면 넣어주자. 일단은 빼놨다

    if (isMildaeHealOn) ; 밀대힐 중이면 틱당 힐 더 돌리고 혼 돌리러 감 -> 힐 끊기지 않는 용도지만 미리 다 입력이 돼있을 것이므로 잠시 뺀다.
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

        HonmaLeftForHonHeal(HonCount)

        SendInput, {Blind}6  ;금강불체. 탭탭힐 리프레쉬에서 공격이 나가서 blind 6으로 했다. 혼마 루프 내부에서 밖으로 뺐다.
        CustomSleep(10) 
        SendInput, {Tab}
        CustomSleep(40)
        SendInput, {Tab}
        CustomSleep(10) ; 뒤에 사망확인 있으므로 후딜 40에서 10으로 좀 줄임

        DeathCheck() ; 탭탭하고 나서 도사 유령확인 넣어봄 힐틱 밀리면 이거 뺀다

        StopLoopCheck()
        Loop, 1 {
            SendInput, {Blind}1 ;백호 앞 기원 후딜 50으로 3번에서 4번으로 하나 늘림(혼마 돌리고 탭탭 후딜 10이라서 한 번 씹히는 경우 생겨서)
            CustomSleep(50)
            SendInput, {Blind}1
            CustomSleep(50)
            SendInput, {Blind}1
            CustomSleep(50)
            SendInput, {Blind}1
            CustomSleep(50)
            SendInput, {Blind}2 ;백호
            CustomSleep(50)
            SendInput, {Blind}1 ;백호 쿨일 때 생명 3틱 쓰려고. 틱당 3회 회복은 50후딜로는 4번 해야되더라
            ;CustomSleep(50)
            ;SendInput, {Blind}1 ;백호 쿨일 때 생명2번만 나가더라. 혼마랑 같이 써져서 제한때문인지 테스트 후 힐틱 밀리면 빼던가 하자
            ;CustomSleep(50)
        }
        StopLoopCheck()

        if(isTankerModOn) { ; 혼힐도 탱커모드일 때는 ManaRefresh 수치에 따라 공증 시도 -> TabTabHealRefresh()나 StandingHonHeal() 의 ManaRefresh 값 사용(테스트 필요)
            ConditionalManaRefresh(ManaRefreshPerHealTick) ; 4의 배수. 즉 힐4틱에 한 번만 공증 시도 -> 실제로 1초에 한 싸이클이 아니므로 8로 해보자. 마나부족하면 줄인다.
        } else {
            SendInput, {Blind}3
        }
        CustomSleep(10) ; 뒤에 아무것도 없으므로 후딜 10으로 바꿈꿈
        ;SendInput, {Blind}2 공증 뒤 백호는 잠시 뺐음. 여기선 마법 1회를 아껴야 돼서 힐 뒤에 백호 한 번만
        ;CustomSleep(20)

    }
    return
}





~x:: ;줍기
getget()
return





':: ; 사자후
Shout()
return

c:: ; 긴혼left.  20정도도 -> 15로 변경함
if(IsWaiting) { ;입력대기시 취소입력을 위함
    Send, {ESC}
    return
}
SpreadHonmaLeft(magicCount)
return

+c:: ;파혼 left
CustomSleep(180) ; 쉬프트키 떼는 후딜
SpreadPaHon(magicCount)
return


^1:: ;추적 밀대
CustomSleep(150)
ChaseMildae()
return

^2:: ;따라가기
CustomSleep(150)
ChaseOnly()
return


F1:: ; 추적혼힐
ChaseHonHeal()
return

F2:: ; 자신선택 & 동동주 마시기용, a에 동동주  (타겟박스 있을 때는 자신선택이고 동동주 안 마셔지고, 타겟박스 없을 땐 동동주 마시기)
SendInput, {Home}
CustomSleep(30)
DrinkDongDongJu()
return

 


F3:: ;StopLoop
SendInput, {Blind}r
CustomSleep(20)
CancelInput := true ; 입력대기 취소
StopLoop := true ; 각각의 함수들이 루프시작에 StopLoop가true일 경우 break를 해주기 때문에 중간에 썼을 때 멈추려면 써준다.
return


`:: ; 자힐 3틱
SelfHeal()
;StopLoop := true ;중단 안 하는쪽으로 가기 위해 주석처리
return



1:: ;밀대힐
TabTabHealRefresh()
return



;도사는 StopLoop를 빠르게 사용할 일이 많아서 2번에도 넣어뒀다.
2:: ; 루프 정지
CancelInput := true ; 입력대기 취소
StopLoop := true
return


3:: ;추적혼힐
ChaseHonHeal()
return


4:: ;제자리 혼힐
StandingHonHeal()
return

+1::
CustomSleep(120)
SendInput, {Blind}1
return

+2::
CustomSleep(120)
SendInput, {Blind}2
return

+3::
CustomSleep(120)
SendInput, {Blind}3
return

+4::
CustomSleep(120)
SendInput, {Blind}4
return



; sendInput Esc 뒤에 CustomSleep(20) 하니까 탭탭이 씹히고 30으로 하니까 괜찮더라
;꼬임 방지 esc 뒤에 sleep은 최소 30으로 해준다.





;입력대기  (c키와 esc는 취소, space부활+힐+보호   e지진   r시력회복 t해독 f퇴마주 g파혼술술)
q:: 
InputWaiting()
return


+q:: ;무력화
CustomSleep(180)
Neutralize()
return

r:: ; 선택혼
;입력대기시 해당키 입력 할당
if(isWaiting) {
    send,{r} ;시력회복
    return
}
SelectionHon()
return


t:: ; 공력주입(현재 탭탭대상상)
;입력대기시 해당키 입력 할당
if(isWaiting) {
    send,{t} ;해독
    return
}
ManaInjectionAndManaRefresh()
return 

+t:: ;공력주입
CustomSleep(200) ;쉬프트 눌렀다 뗄 때 딜레이. 쉬프트 떼기 전에 동작하므로 딜레이가 낮으면 쉬프트 누른채로 sendInput이 동작해서 먹통됨(숫자 입력일 경우 더 여유를 줘야함)
ManaInjection()
return



g:: ; 금강불체 (입력대기 파혼술술)
;입력대기시 해당키 입력 할당
if(isWaiting) {
    send,{g} ;파혼술술
    return
}
SendInput, {6}
return 



^q:: ;셀프 시력회복, 파혼술, 해독(뺄까말까 고민중중)
CustomSleep(180)
SelfTotalRecovery()
return


^w:: ;시력회복 돌리기
CustomSleep(200)
SpreadVisionRecovery(magicCount)
return



^e::  ; 지진돌리기기
CustomSleep(180)
SpreadEarthQuake(magicCount)
return



^r:: ;시력회복
CustomSleep(180)
SendInput, {7}
return

^t:: ;해독
CustomSleep(160)
Detox()
return


^f::  ;퇴마주. 주술이 저주 잘못 넣었을 때 사용
CustomSleep(180)
Exorcism()
return

^g::  ; 파혼술
CustomSleep(180)
SendInput, {8}
return






^a:: ;신령지익진 예정
CustomSleep(170)
Return

^s:: ; 상태창
CustomSleep(190)
SendInput, {Blind}s
return

^d:: ;파력무참진 예정
CustomSleep(170)
return







b:: ;유령 부활
CancelInput := true ; 입력대기 취소
GhostCheck()
return





+g:: ; 나와 탭탭대상 둘다 부활 후 탭탭(모든 자동힐에 나와 격수 자동 부활 넣어놨으므로 쉬프트 조합으로 했다.)
CancelInput := true ; 입력대기 취소
CustomSleep(200)
Rev()
Return


v:: ;  탭탭 대상 보무
CancelInput := true ; 입력대기 취소
TabTabBoMu()
return


NumpadEnd:: ;  셀프보무 ;pc는 end, 노트북은 넘패드end 인데 pc지만 일단 만들어가는 중이므로 임시로 노트북용
CancelInput := true ; 입력대기 취소
SelfBoMu()
return

End:: ;  셀프보무 ;pc는 end, 노트북은 넘패드end 인데 pc지만 일단 만들어가는 중이므로 임시로 노트북용
CancelInput := true ; 입력대기 취소
SelfBoMu()
return




SelfTargetAndStopLoop() {    
    SendInput, {Home}
    CustomSleep(20)
    SendInput, {Blind}r ;북방 파밍할 때 말 편하게 타려고
    CustomSleep(20)
    StopLoop := true ; 각각의 함수들이 루프시작에 StopLoop가true일 경우 break를 해주기 때문에 중간에 썼을 때 멈추려면 써준다.
    return
}



; 줍기
getget() { 
    CustomSleep(30)
    SendInput, {ShiftDown}
    CustomSleep(30)
    SendInput, {,}
    CustomSleep(30)
    SendInput, {ShiftUp}
    CustomSleep(30)
    return
}


;사자후
Shout() {
    SendInput, {Esc}
    CustomSleep(30)
    SendInput, {shift down}
    CustomSleep(60)
    SendInput, { z }
    CustomSleep(60)
    SendInput, {shift up}
    CustomSleep(60)
    SendInput, z ;  z -> 사자후 
    CustomSleep(40)
    return
}


;지도 열고 닫기 토글
OpenMap() {
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
}

;집중 추적모드 -> 탭탭추적에 상하 랜덤값을 주지 않는다.(흉가처럼 문이 많은 곳이 아닌 곳에서 유용용)
ToggleNoRandomPos() {
    if (noRandomPos) {
        ; 탭탭추적시 상하 랜덤좌표 끄지
        noRandomPos := false
        MsgBox, 탭탭추적 상하 랜덤좌표 on
    } else {
        ; 탭탭추적시 상하 랜덤좌표 켜기기
        noRandomPos := true
        MsgBox, 탭탭추적 상하 랜덤좌표 Off
    }
    return
}

;탱커모드 하면 밀대힐이랑 스탠딩혼힐 때 뭘 바꿔주려고 하는데 아직은 딱히 바꿔줄 게 없다.
ToggleTankerMode() {
    if (isTankerModOn) {
        ; 탱커모드 끄기기
        isTankerModOn := false
        MsgBox, 탱커모드 OFF
    } else {
        ; 탱커모드 켜기기
        isTankerModOn := true
        MsgBox, 탱커모드 ON
    }
    return
}



;무사의 방 모드
;탭탭 대상에게 공증 전 파혼술과 시력회복을 걸어준다.
ToggleMooSaRoomMode() {
    if (isAtMooSaRoom) {
        ; 무사의 방 모드 끄기
        isAtMooSaRoom := false
        MsgBox, 무사의 방 모드 OFF
    } else {
        ; 무사의 방 모드 켜기
        isAtMooSaRoom := true
        MsgBox, 무사의 방 모드 ON
    }
    return
}


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
    CustomSleep(40)
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



;단축키 말고 shift + z로 시전하는 마법 후딜을 20으로 했는데 잘 씹히면 전부 40으로


;무력화
Neutralize() {  ;무력화
    SendInput, {Esc}
    CustomSleep(30)
    SendInput, {shift down}
    CustomSleep(30)
    SendInput, { z }
    CustomSleep(30)
    SendInput, {shift up}
    CustomSleep(30)
    SendInput, q ;  q -> 무력화
    CustomSleep(30)
    return
 }


Exorcism() {  ;퇴마주
    ;SendInput, {Esc} ;탭탭힐 중에도 쓸 수 있어야 하므로 esc 뻈다.
    ;CustomSleep(20)
    SendInput, {shift down}
    CustomSleep(20)
    SendInput, { z }
    CustomSleep(20)
    SendInput, {shift up}
    CustomSleep(20)
    SendInput, s ;  s -> 퇴마주
    CustomSleep(30)
    return
 }


Detox() {  ;해독
    ;SendInput, {Esc} ;탭탭힐 중에도 쓸 수 있어야 하므로 esc 뻈다.
    ;CustomSleep(20)
    SendInput, {shift down}
    CustomSleep(20)
    SendInput, { z }
    CustomSleep(20)
    SendInput, {shift up}
    CustomSleep(20)
    SendInput, r ;  r -> 해독
    CustomSleep(30)
    return
 }

ManaInjection() {  ;공력주입
    ;SendInput, {Esc} ;탭탭힐 중에도 쓸 수 있어야 하므로 esc 뻈다.
    ;CustomSleep(20)
    SendInput, {shift down}
    CustomSleep(20)
    SendInput, { z }
    CustomSleep(20)
    SendInput, {s} ;  대문자 S -> 공력주입
    CustomSleep(20)
    SendInput, {shift up}
    CustomSleep(30)
    return
 }


 
ManaInjectionAndManaRefresh() { ;공력주입&공력증강강
    CustomSleep(20)
    ;탭탭상태인지 확인 후 탭탭이면 바로 공력주입, 아니면 esc 눌러서(꼬임방지지) 탭탭 후 공력주입하고 다시 esc
    CheckTabTabOn()
    CustomSleep(20)
    if(isTabTabOn) {
        ManaInjection()
        CustomSleep(60)
    } else {
        SendInput, {Esc}
        CustomSleep(20)
        SendInput, {Tab}
        CustomSleep(50)
        SendInput, {Tab}
        CustomSleep(50)
        ManaInjection()
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











;셀프 각종 회복(시력회복, 파혼, 해독 + 보호) -> 필요하면 퇴마 추가. 지금은 퇴마가 필요 없어서
SelfTotalRecovery() {
    SendInput, {Esc}
    CustomSleep(30)
    StopLoop := false
    Loop, 1
    {
        if (StopLoop)
            {            
                Break
                CustomSleep(20)
            }
        SendInput, {7} ; 시력회복
        CustomSleep(30)
        SendInput, {Home}
        CustomSleep(30)
        SendInput, { enter }
        CustomSleep(30)
        SendInput, { esc }
        CustomSleep(30)
        SendInput, {8} ; 파혼술
        CustomSleep(30)
        SendInput, {Home}
        CustomSleep(30)
        SendInput, { enter }
        CustomSleep(30)
        SendInput, { esc }
        CustomSleep(30)

        SendInput, {shift down}
        CustomSleep(40)
        SendInput, { z }
        CustomSleep(40)
        SendInput, {shift up}
        CustomSleep(40)
        SendInput, {blind}r ; r -> 해독
        CustomSleep(40)
        SendInput, {Home}
        CustomSleep(30)
        SendInput, { enter }
        CustomSleep(30)
        SendInput, { esc }
        CustomSleep(30)

        SendInput, {shift down}
        CustomSleep(40)
        SendInput, { z }
        CustomSleep(40)
        SendInput, {blind}x ; 대문자 X -> 보호
        CustomSleep(40)
        SendInput, {shift up}
        CustomSleep(40)
        SendInput, {Home}
        CustomSleep(30)
        SendInput, { enter }
        CustomSleep(30)
        SendInput, { esc }
        CustomSleep(30)
    }
    SendInput, {Esc}
    CustomSleep(30)
    SendInput, {Tab}
    CustomSleep(40)
    SendInput, {Tab}
    CustomSleep(40)
    }
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
        SendInput, { enter } ; 원래 enter 이후 후딜 90이었고 esc와(꼬임방지) 나눠서 60, 30 이었는데 그냥 spread하는 건 30 30도 괜찮은듯듯
        CustomSleep(30)
        SendInput, { esc }
        CustomSleep(30)
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
        SendInput, { enter } ; 원래 enter 이후 후딜 90이었고 esc와(꼬임방지) 나눠서 60, 30 이었는데 그냥 spread하는 건 30 30도 괜찮은듯듯
        CustomSleep(30)
        SendInput, { esc }
        CustomSleep(30)
    }
    SendInput, {Esc}
    CustomSleep(30)
    SendInput, {Tab}
    CustomSleep(40)
    SendInput, {Tab}
    CustomSleep(30)
    return
}



SpreadPaHon(count) { ; 파혼술 돌리기
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

        SendInput, 8
        CustomSleep(30)
        SendInput, { left }
        CustomSleep(30)
        SendInput, { enter } ; 원래 enter 이후 후딜 90이었고 esc와(꼬임방지) 나눠서 60, 30 이었는데 그냥 spread하는 건 30 30도 괜찮은듯듯
        CustomSleep(30)
        SendInput, { esc }
        CustomSleep(30)
    }
    SendInput, {Esc}
    CustomSleep(30)
    SendInput, {Tab}
    CustomSleep(40)
    SendInput, {Tab}
    CustomSleep(40)
    return
}



SpreadVisionRecovery(count) { ;시력회복 돌리기
    SendInput, {Esc}
    CustomSleep(30)
    StopLoop := false
    loop, %count%
        {
        if (StopLoop)
            {            
                Break
                CustomSleep(20)
            }

        SendInput, {7}
        CustomSleep(30)
        SendInput, { left }
        CustomSleep(30)
        SendInput, { enter } ; 원래 enter 이후 후딜 90이었고 esc와(꼬임방지) 나눠서 60, 30 이었는데 그냥 spread하는 건 30 30도 괜찮은듯듯
        CustomSleep(30)
        SendInput, { esc }
        CustomSleep(30)
    }
    SendInput, {Esc}
    CustomSleep(30)
    SendInput, {Tab}
    CustomSleep(40)
    SendInput, {Tab}
    CustomSleep(40)
return
}


SpreadEarthQuake(count) { ;지진 돌리기(극진처럼 후딜 있어서 빠르게는 못 돌림)
    SendInput, {Esc}
    CustomSleep(30)
    StopLoop := false
    loop, %count%
        {
        if (StopLoop)
            {            
                Break
                CustomSleep(20)
            }

        SendInput, {9}
        CustomSleep(30)
        SendInput, { left }
        CustomSleep(30)
        SendInput, { enter } ; 원래 enter 이후 후딜 90이었고 esc와(꼬임방지) 나눠서 60, 30 이었는데 그냥 spread하는 건 30 30도 괜찮은듯듯
        CustomSleep(30)
        SendInput, { esc }
        CustomSleep(30)
    }
    SendInput, {Esc}
    CustomSleep(30)
    SendInput, {Tab}
    CustomSleep(40)
    SendInput, {Tab}
    CustomSleep(40)
return
}




;힐 공증 반복시 클릭 or 휠업 or 휠다운시 선택혼 사용하기 위함
;밀대힐 중 좌클, 휠업, 휠다운 감지해서 동작을 하면 선택혼 날린다.
;이때 휠업다운은 드르륵 하면 연타로 들어가서 꼬일 수 있으므로 쿨다운 0.5초

;입력대기 부활을 추가하기 위해 isWaiting에 따라 동작 방식 변경
~LButton::
if(isWaiting) {
    ; 대기 상태일 때 동작. 클릭시 특정 동작 하게 하려고 했는데 입력대기 스킬이 늘어서 클릭시 동작 주석처리. SendInput 말고 Send를 사용
    ;Send,{Space}
} else {
    LButtonClicked := true  ; 좌클릭 감지 변수 설정
}
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


;마우스 이벤트 감지를 해서 클릭,휠업다운이 눌러졌으면 선택혼 시전. 휠업다운은 내부쿨을 두고 드르륵 돌릴 때 연속실행 방지
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
    isMildaeHealOn := true
    LButtonClicked := false  ; 상태 초기화
    WheelUpDetected := false
    WheelDownDetected := false

    ManaRefresh := 1 ;몸빵할 때 힐 몇틱에 한 번씩 공증 시도할 거냐를 위한 변수

    StopLoop := false

    SendInput, {Esc}
    CustomSleep(30)
    SendInput, {Tab}
    CustomSleep(40)
    SendInput, {Tab}
    CustomSleep(50)

    Loop, 1260  ;안전장치로 카운트 걸어둠. 루프가 빨리 돌기 때문에 1초에 2회쯤이다. 추적혼힐과 스탠딩혼힐은 혼 돌리는 게 있어서 1당 1초쯤.
    {
        if (StopLoop)
            {                
                Break
                CustomSleep(20)
            }
        DeathCheck()
        SendInput, {Blind}6  ;금강불체. 그냥 6하니까 공격이 나가더라라
        CustomSleep(20)

        StopLoopCheck()
        Loop, 1 { ;왜 3회 반복으로 해놨지? 다른 별다른 로직이 없어서 그런가.  -> 결론은 루프3에 생명3+백호1 사용
            ; 루프1. 즉 반복 없을 때는 힐3틱 주려면 힐스킬 4번 넣어야 된다. 후딜 50으로 생명3번 넣으면 2번만 시전하고 한 번씩 백호 패스함.
            ; 생명x3 + 백호1에서 마지막에 생명 하나 더 넣어놔야 백호 쿨 있을 때 생명2백호1, 없을 때 생명3 시전 가능
            ; 루프3 이면 그냥 힐3 백호1만 넣어줘도 많이 시도하므로 힐틱이 밀리지 않고 백호도 꼬박꼬박 잘 쓴다.

            ;아니면 루프1로 하고 앞에 기원3번을 후딜70으로 하면 괜찮았다.
            ;백호 앞 기원 4번 후딜 50으로 바꿈 -> 혼 안 돌리고 해서 그런지 백호가 안 나갈 때도 있더라
            ;그러고 보니 탭탭 해제하는 일이 없어서 후딜 50으로 힐 3번 해도 안 밀리나 보다.
            ;혼힐추적이나 혼힐에서는 힐틱 밀릴까봐 탭탭 후 후딜 10하고 DeathCheck() 하고 바로 힐이라서 이때 후딜 10이 짧아서 밀리는듯
            ;다시 후딜 70으로 해서 3번으로 바꿈

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
        StopLoopCheck()

        ListenMouseEvent()
        CustomSleep(20)

        if(isAtMooSaRoom) {
            SendInput, {7}
            CustomSleep(30)
            SendInput, {8}
            CustomSleep(30)
        }

        if(isTankerModOn) {
            ;스탠딩혼힐과는 다르게 힐 1틱에 2사이클 반복이기 때문에 5틱당 한 번 공증시도 하려면 그 2배인 mod 10
            ConditionalManaRefresh(ManaRefreshPerHealTick*2)
        } else {
            ;SendInput, {Blind}3
            ;탱크모드에서 하듯이 매번 공증 안 하고 조건부 공증 사용. 일단 탱크모드랑 같은 수치로로
            ConditionalManaRefresh(ManaRefreshPerHealTick*2)
        }

        CustomSleep(20) ; 공증 후 후딜 50이었는데 금강하고 나누고 후딜 30, 20 (뭔가 밀리면 30 20을 20 10으로)
        SendInput, {Blind}6  ;금강불체
        CustomSleep(20)
        
    }
    isMildaeHealOn := false
    ManaRefresh := 1
    SendInput, {Esc}
    CustomSleep(30)
    return
}





Rev() { ;rev에 탭탭 대상 부활과 본인부활후 다시 탭탭
    SendInput, {Esc}
    CustomSleep(30)
    SendInput, {Tab}
    CustomSleep(50)
    SendInput, {Tab}
    CustomSleep(40)
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



TabTabBoMu() { ; 탭탭 대상 보무 (대문자 X = 보호,  소문자 x = 무장)
    SendInput, {Esc}
    CustomSleep(30)
    SendInput, {Tab}
    CustomSleep(50)
    SendInput, {Tab}
    CustomSleep(40)

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
    isMildaeHealOn := true
    isChasing := true
    LButtonClicked := false  ; 상태 초기화
    WheelUpDetected := false
    WheelDownDetected := false

    StopLoop := false
    SendInput, {Esc}
    CustomSleep(30)
    SendInput, {Tab}
    CustomSleep(40)
    SendInput, {Tab}
    CustomSleep(40)

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
        StopLoopCheck()
        Loop, 1 {
            SendInput, {Blind}1
            CustomSleep(70)
            SendInput, {Blind}1
            CustomSleep(70)
            SendInput, {Blind}1
            CustomSleep(70)
            SendInput, {Blind}2 ;백호
            CustomSleep(50) 
            SendInput, {Blind}1 ; 백호 쿨일 때 생명 3번 쓰라고 넣음. 후딜50으로는 생명4번 넣어야 기원 힐틱 3번 가능. 백호 쿨 있으면 생명2백호1, 없으면 생명3
            CustomSleep(10) ; 후딜 50인데 뒤에 추적있어서 후딜 10으로 낮춰봄
        }
        StopLoopCheck()

        ;TabTabChase()  ;탭탭추적 힐 전 후로 하나씩 있었는데 만약 조금 더 활동적인 움직임을 원한다면 힐 뒤에는 마우스 무브 넣어주자(주석해둠)
        MouseMove, TabTabX, TabTabY, 1     ;탭탭추적 대신 마우스무브는 탭탭추적시 발견한 좌표에 상하 랜덤값을 더해줘서 좀 더 활동적인 움직임
        ListenMouseEvent()

        if(isAtMooSaRoom) {
            SendInput, {7}
            CustomSleep(30)
            SendInput, {8}
            CustomSleep(30)
        }

        
        ConditionalManaRefresh(ManaRefreshPerHealTick*2)

        CustomSleep(20)
        SendInput, {Blind}6  ;금강불체
        CustomSleep(20)
    }
    isMildaeHealOn := false
    isChasing := false
    SendInput, {Esc}
    CustomSleep(30)
    Click, Right up  ;추적 우클릭 해제 방지2
    return
}



ChaseHonHeal() {  ;추적 혼힐
    isMildaeHealOn := true
    isChasing := true
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

        ;DeathCheck() 여기 놔두니까 부활하고 혼 돌리고 힐 주기 때문에 부활하고 다시 죽는 경우가 생김.
        ;일단 원래는 여기 있었다는 거 확인차 주석처리 해놓고 DeathCheck()를 혼마 뒤로 옮김
        ;TabTabChase() ;공증 이후 혼 돌리기 전 한 번 추가. 이거 넣으니까 힐틱 살짝 밀려서 뺌. 대신 이동은 훨씬 낫긴 하다(방 통과 등)
        HonmaLeftForHonHeal(3)

        SendInput, {6} ;금강불체. 혼마 마지막이 씹혀서 금강을 혼마 루프 밖으로 뺐다 -> 안 씹힘힘
        CustomSleep(10)
        ;MouseMove, TabTabX, TabTabY, 1 ; 마우스 이동(우클 누른상태태). 탭탭추적은 탭탭 이후에만 가능했는데 이전 검색 좌표+@를 전달해서 마우스이동해서 긴 텀 보완
        ;힐 뒤에 마지막에 탭탭추적 넣어서 여기는 주석처리
        SendInput, {Tab}
        CustomSleep(40)
        SendInput, {Tab}
        CustomSleep(10)
        DeathCheck() ; 혼마 앞에 있던 것을 뒤로 옮겼다. tab tab 끝에 후딜 없었는데 10을 줬고 부활 후 탭탭대상 회복 잘 된다.
        ;CustomSleep(10) ; 후딜 40인데 뒤에 추적있어서 후딜 10으로 낮춰봄. 후딜 빼봄2 -> 탭탭 하고 인식되기까지 후딜 70은 필요하다.
        ;conditionalChase() 의 예로 탭탭 뒤에 후딜 10주고 추적하니 안 되고 50도 안 되고 70하니까 되길래 여기에 잠시 후딜 70을 넣어본다.

        ;후딜 70넣으니까 TabTabChase()가 제대로 작동하면서 힐틱이 조금 밀리는 느낌이 든다. 이전까지는 탭탭 뒤에 후딜이 부족해서 인식을 못해서
        ;tabtabChase()가 동작을 안 했던 것 것이고 탭탭추적은 하나만 사용하고 있었던 것이다.(거기에 이전 좌표에 마우스 이동 1개개)
        ;만약 중간 추적이 필요하다면 어떻게 힐틱이 안 밀릴지 고민좀 해보자.
        ;일단은  혼마와 힐 중간의 탭탭추적은 넣어놨지만 후딜부족으로 동작 안 하는 상태로 잘 써왔으니 이대로 가자.
        ;단 탭탭 뒤에 후딜 안 넣어줘도 미리 입력?(지연 시전?) 개념으로 힐은 잘 들어가는 것 같다. (필요하면 후딜 살짝 추가)
        ;이를 기반으로 다른 추적들도 손봐주자.(단순 추적과 혼 안 돌리는 추적밀대는 탭탭추적에 후딜 제대로 주고 사용하면 될 듯)
        ;CustomSleep(70)  
        ;TabTabChase()

        ; DeatchCheck()를 혼 뒤로 옮기고 자세히 보니(이전에도 그랬는지 알 수 없음) 신령 2번만 들어가길래 기원4 백호1 기원1로 해봤다. 힐틱 안 밀리고 기원3 들어감
        ; 평타가 1틱에 한 방인데 평타 누르고 있는 상태에서 힐 넣는 거 보니까 힐틱이 밀리지 않고 신령 3번 잘 들어가더라
        ; 탭탭 뒤에 후딜 10이라서 힐이 한 번 밀렸던 것 같다. 탭탭 후딜 40 넣고 다시 기원3백호1기원1 해보자
        ; 근데 한 번씩 씹힐 때도 있어서 그냥 다시 탭탭 뒤에 후딜10 -> 기원4 백호1 기원1로 했다.

        StopLoopCheck()
        Loop, 1 {
        TabTabChase()

            ;탭탭추적으로 인해 힐틱지연이 생긴다. 힐 후딜을 50-> 40으로 줄여서 테스트 해보자 -> 힐이 세 번이 아니라 2번만 들어간다. 다시 50으로
            SendInput, {Blind}1
            CustomSleep(50)
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
        }
        StopLoopCheck()

        if(isAtMooSaRoom) {
            SendInput, {7}
            CustomSleep(30)
            SendInput, {8}
            CustomSleep(30)
        }

        ConditionalManaRefresh(ManaRefreshPerHealTick) ; 혼 돌리는 거면 수치만큼 힐틱 뒤에 공증 시도, 단순 힐 백호면 수치의 절반만큼의 힐틱 뒤에 공증시도도
        ;SendInput, {3} ;
        ;CustomSleep(10) ;공증 후딜 20이었는데 루프 순서상 다음에 뭐 있어서 걍 10 ;위에 후딜 2개 빼고 잘 됐다. 여기도 후딜 빼봄3. 안 되면 다시 롤백
        ;백호 뒤에 혼힐을 여기에 둬도 될 듯 한데 딜레이상 큰 차이는 없다.

        CheckEnoughMana() ; 만약 마나 부족하면 공증. 아주 가끔 마나부족 떠서 넣어봄.
        if(notEnoughMana) {
            RestoreMana()
        }

        TabTabChase()

        

    }
    isMildaeHealOn := false
    isChasing := false
    SendInput, {Esc} ; 정지 이전에 격수가 다음 맵으로 넘어갔을 때 내게 걸린 흰박스나 탭탭박스 닫기. 어차피 다시 쓸 때 탭탭하니까.
    CustomSleep(20)
    Click, Right up  ;추적 우클릭 해제 방지2       
    return
}





StandingHonHeal() { ;제자리 혼힐
    isMildaeHealOn := true
    LButtonClicked := false  ; 상태 초기화
    WheelUpDetected := false
    WheelDownDetected := false
    ManaRefresh := 1 ;몸빵할 때 힐 몇틱에 한 번씩 공증 시도할 거냐를 위한 변수

    StopLoop := false
    StopHonHeal := false

    SendInput, {Esc}
    CustomSleep(30)
    SendInput, {Tab}
    CustomSleep(40)
    SendInput, {Tab}
    CustomSleep(50)

    loop, 630 ;안전장치로 카운트 걸어둠. 10분 30초. 추적혼힐은 맵 넘어가야돼서 5분 안팍이고 스탠딩은 시즈모드라서 10분쯤
    {
        if (StopLoop || StopHonHeal)
            {            
                Break
                CustomSleep(20)
                Click, Right up ;추적 우클릭이동 해제
            }

        ;DeathCheck() ;혼마 뒤로 옮긴다.
        HonmaLeftForHonHeal(3)        

        SendInput, {Blind}6  ;금강불체. 탭탭힐 리프레쉬에서 공격이 나가서 blind 6으로 했다. 원래 혼마 루프 내부에 있었는데 뺐다.
        CustomSleep(10) 
        SendInput, {Tab}
        CustomSleep(40)
        SendInput, {Tab}
        CustomSleep(20) ; 사망확인이 있어서 살짝 후딜 줄임. 추적혼힐에서는 10으로 했는데 여기선 추적이 없으므로 20
        DeathCheck() ; 혼마 앞에 있던 것을 뒤로 옮겼다. tab tab 끝에 후딜 없었는데 10을 줬고 부활 후 탭탭대상 회복 잘 된다.
        StopLoopCheck()

        ; DeatchCheck()를 혼 뒤로 옮기고 자세히 보니(이전에도 그랬는지 알 수 없음) 신령 2번만 들어가길래 기원4 백호1 기원1로 해봤다. 힐틱 안 밀리고 기원3 들어감
        ; 평타가 1틱에 한 방인데 평타 누르고 있는 상태에서 힐 넣는 거 보니까 힐틱이 밀리지 않고 신령 3번 잘 들어가더라
        ; 탭탭 뒤에 후딜 10이라서 힐이 한 번 밀렸던 것 같다. 탭탭 후딜 40 넣고 다시 기원3백호1기원1 해보자
        ; 근데 한 번씩 씹힐 때도 있어서 그냥 다시 탭탭 뒤에 후딜10 -> 기원4 백호1 기원1로 했다.
        Loop, 1 {
            SendInput, {Blind}1 ;탭탭추적 빼니까 한 번씩 백호 건너띈다. 너무 빨리 힐틱이 돌아서 그런듯? 백호 앞 기원 3번 후딜70에서 기원 4번 후딜50으로 바꿈
            CustomSleep(50)
            SendInput, {Blind}1
            CustomSleep(50)
            SendInput, {Blind}1
            CustomSleep(50)
            SendInput, {Blind}1
            CustomSleep(50)
            SendInput, {Blind}2 ;백호
            CustomSleep(50) 
            SendInput, {Blind}1 ; 백호 쿨일 때 생명 3번 쓰라고 넣음. 후딜50으로는 생명4번 넣어야 기원 힐틱 3번 가능. 백호 쿨 있으면 생명2백호1, 없으면 생명3
            CustomSleep(50) ; 
        }
        StopLoopCheck()
        if(isAtMooSaRoom) {
            SendInput, {7}
            CustomSleep(30)
            SendInput, {8}
            CustomSleep(30)
        }
        
        if(isTankerModOn) {        
            ;힐 싸이클 5번당, 즉 5틱당 한 번 공증 시도.  mod 5로 전달. TabTabHealRefresh()와는 달리 1틱당 1싸이클 반복이라 mod 5로 해준다.
            ConditionalManaRefresh(ManaRefreshPerHealTick)
        } else {
            ;SendInput, {Blind}3
            ConditionalManaRefresh(ManaRefreshPerHealTick)

        }

        CustomSleep(30)

    }
    isMildaeHealOn := false
    ManaRefresh := 1
    CustomSleep(20)
    Click, Right up  ;추적 우클릭 해제 방지2
    return
}



HonmaLeftForHonHeal(count) {
    Loop, %count% { ; 후딜 20~30짜리들 조금 깎아봤다. 후딜 10으로 하니 그 다음키가 씹히는 경우가 생겼다. (혼마 없이 왼쪽 눌러져서 이동됨)
        ;그리고 엔터가 씹혀서 시전 안 되는 경우도 생긴듯? 후딜 깎기 전으로 복구
        StopLoopCheck()
        SendInput, {Esc}
        CustomSleep(20) ;원래 20
        SendInput, 4
        CustomSleep(30) ;원래 30
        SendInput, { left }
        CustomSleep(30) ;원래 30
        SendInput, { enter }
        CustomSleep(40)  ;후딜 90. 꼬임 방지로 ESC 넣고 후딜 나눴음. 60도 괜찮아서 60을 40, 20으로 나눔
        SendInput, {Esc}
        CustomSleep(20)  ;원래 20
    }
return    
}









ChaseOnly() {
    isChasing := true

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
    isChasing := false
    SendInput, {Esc}
    CustomSleep(30)
    Click, Right up  ;추적 우클릭 해제 방지2
    return
}



;공력주입같은 것은 탭탭힐 중인지 혼마 돌리는 중인지 몰라서 이때 사용할 조건부추적 함수를 만들었다.
;공력주입 후 공증을 반드시 해주는데(RestoreMana() 사용용) 공증 실패 후 공증을 반복하다 보면 추적혼힐 중이었을 경우 마우스 좌표 고정이다.
; 이전에 찾았던 좌표에 우클릭 이동 고정상태이므로 엉뚱한 곳 가는 것 방지하려고 RestoreMana()공증 함수에 넣어줄 것. 추적중이면 조건부추적함수 사용
;탭탭 상태면 그냥 추적, 탭탭이 아니라면 탭탭 켜고 추적 한 번 하고 esc

; -> 탭탭 상태인지를 백호의희원이 이펙트로 가리면 감지 안 되는 경우가 생기기 때문에 탭탭상태시 그냥 추적은 꼬일 수도 있음에 유의.
; 뭐 여기선 탭탭추적하는 것이므로 꼬이진 않고 추적 실패가 뜰 것 같다.
ConditionalChase() {
    if(isChasing) { ;추적상태라면 탭탭chase 한 번 해준다. 따라다니는 추적 함수에서 true 해주는 변수.                    
        if(isTabTabOn) {
        TabTabChase()
        CustomSleep(20)
        } else {
            SendInput, {Tab}
            CustomSleep(50)
            SendInput, {Tab}
            CustomSleep(70) ; 원래 후딜 40~50인데 탭탭추적 동작하면서 후딜 40정도를 대신하려고 후딜 10하니까 안 됨(너무 빨리 사라짐)
                            ; 후딜 50으로 해도 안 됨. 호딜 70으로 하니까 잘 된다. 삑나면 조금 올려주자.
                            ; 그렇다면 추적혼힐에 탭탭 뒤에 후딜 대신하려고 후딜10으로 한 곳 있는데 70으로 바꿔볼까?
            TabTabChase()
            CustomSleep(20)
            SendInput, {Esc} ; 탭탭 아닐 때 탭탭하고 추적했으니 다시 탭탭 꺼줌줌
            CustomSleep(20)
        }
    }
}


;조건부 공증.
;예를들어 탱커모드일 때는 힐틱 5사이클 돌고 공증 시도
;TabTabHealRefresh()와 StandingHonHeal() 이 2곳에서 탱커모드시 공증을 빈도를 조절중이다.
;TabTabHealRefresh() 에서는 1틱당 2싸이클이 도므로 5틱 마다 공증 시도 하려면 그 2배인 10으로 mod를 해줘야 한다. 
;StandingHonHeal() 에서는 1틱당 1싸이클이므로 5틱당 공증 시도 하려면 5로 mod를 해주면 된다.
ConditionalManaRefresh(count) {
    if (Mod(ManaRefresh, count) == 0) {
        SendInput, {Blind}3
    }   
    ManaRefresh++
    return
}




; 4방향 스킬. 키와 방향 적어줘야 됨 (6, "Left" 이런식으로)
;AutoHotkey에서 함수 호출 시 리터럴 문자열은 반드시 따옴표로 감싸야 한다.
FourWayMagic(key, Arrow, Count) {  ;횟수 3에서 2로 내림. 삑 자주나면 다시 3으로
    SendInput, {Esc}
    CustomSleep(20) ;후딜 10은 뒤에 다른 입력키가 있으면 뒤에 키가 가끔 씹히는 것 같다.
    StopLoop := false
        loop, %Count% ;마비 100퍼 인 것 같아서 마비는 1회만 해주면 된다.
            {
                if (StopLoop)
                    {            
                        Break
                        CustomSleep(20)
                    }
                SendInput, %key%
                CustomSleep(30)
                SendInput, {Home}
                CustomSleep(30)
                SendInput, {%Arrow%}
                CustomSleep(30)
                SendInput, { enter } ;원래 엔터후 후딜90인데 꼬임 방지를 위해 esc 넣고 후딜 60, 30으로 나눠줌. 30 30로 해봄
                CustomSleep(40)
                SendInput, {esc}
                CustomSleep(30)
            }        
        StopLoopCheck()   ; StopLoop true면 Exit
    return
}


;현재 타겟 위치에 마법 시전 (6, "Left" 이런식으로)
;AutoHotkey에서 함수 호출 시 리터럴 문자열은 반드시 따옴표로 감싸야 한다.
InPlaceMagic(key, Count) {
    SendInput, {Esc}
    CustomSleep(20) ;20~30인데 후딜 때문에 좀 느려져서 10으로 해봤다. 안 되면 20으로
    StopLoop := false
    loop, %Count%
        {
            if (StopLoop)
                {            
                    Break
                    CustomSleep(20)
                }
            SendInput, %key%
            CustomSleep(30)
            SendInput, { enter } ;원래 엔터후 후딜90인데 꼬임 방지를 위해 esc 넣고 후딜 60, 30으로 나눠줌. 30 30로 해봄
            CustomSleep(40)
            SendInput, {esc}
            CustomSleep(20)
        }
    StopLoopCheck()
}



;4방향 혼마
FourWayHonma() {
    FourWayMagic(4, "Left", 1)
    FourWayMagic(4, "Right", 1)
    FourWayMagic(4, "Up", 1)
    FourWayMagic(4, "Down", 1) 
    CustomSleep(30)  
    SendInput, {tab} ;탭탭 복구
    CustomSleep(50)
    SendInput, {tab}
    CustomSleep(50)
    return
}






;g : 입력대기 // c, esc: 취소 // space, 좌클릭 : 부활
;g키가 입력대기 핫키라서 변수에 따라서도 g키가 안 먹혀서 o키와 연계했는데 단순히 그런 문제가 아니었다.
;g키에 if else로 isWaiting변수에 따라 o키 입력 혹은 inputWaiting()을 실행해줬는데 이미 inputWaiting을 실행하고 여기서 대기중이면
;하나의 쓰레드에서 이미 g 핫키가 실행중이라서 다시 g를 눌러도 안 먹히는 것이다.
;즉 단일 쓰레드에서는 g로 inputWaiting()을 실행하고 진행중이기 때문에 다시 g키를 눌러서 동작시킬 수는 없는 것이다.
;wasd는 방향키로 타겟 이동, c는 취소이므로 이 외의 키로 동작키를 설정해주도록 하자.
;한손 키보드 혹은 일반 키보드로 할 떄 부활 스킬 후 타겟선택을 wasd로 움직여서(마우스는 잠시 논외) 선택을 해줘야 한다.
;wasd 누르고 대상 확정을 편한 손으로 할 건데 스페이스할까 e할까 하다가 일단 Space로 해줬다.
;엄지 아프면 e키로 해보자.(isWaiting 변수에 따라 e 핫키 동작을 다르게) 물론 좌클릭으로도 가능하게 하려면 좌클릭도(LButton) isWaiting에 따라 동작변경
InputWaiting() {    
    IsWaiting := true    ;대기 상태 true

    CancelInput := false ; 취소 플래그. 유저 입력대기중 특정 시간마다 이 변수를 확인해서 true시 입력대기 취소하게 만듦
    
    StopLoop := false ;초기화
    isWrongTarget := false
    isRiding := false
    notEnoughMana := False
    isTabTabOn := false


    ;밀대힐 중이면 탭탭on인지 확인한다. -> 사실 도사는 격수를 탭탭하고 있는 경우가 많아서 딱히 isMildaeHealOn 조건이 아니어도
    ;탭탭on인지 확인해주자
    ;-> 탭탭on인지 확인하려고 해도 백호의희원 이펙트 때 확인이 안 된다. 그래서 CheckTabTabOn()으로 확인 안 하고 그냥 끝날 땐 탭탭해준다.

    ;if(isMildaeHealOn) { ;밀대힐 중이면 탭탭온 확인
    ;   CheckTabTabOn()
    ;   CustomSleep(30)        
    ;}
    CustomSleep(50)
    CheckTabTabOn() ;탭탭on 상태 확인
    CustomSleep(30)      

    ;주술은 저주 헬파를 입력대기로 사용해서 저주로 타겟박스 잡았는데 도사는.. 부활로 하는 게 낫겠지?
    ;일단 해보고 필요하면 변경

    SendInput, {esc} 
    CustomSleep(30)   
    SendInput, {0} ;부활 타겟박스 띄워서 타겟 선택하는 용도.
    CustomSleep(30)

    ; 100ms마다 CancelInput 플래그를 확인하는 타이머 설정
    SetTimer, CheckCancelInput, 100


    ;키 입력 대기 (10초 타임아웃)
    Input, UserInput, V L1 T10, {space}{ESC}{e}{r}{t}{f}{g}
    CustomSleep(20)


     ; Input 종료 후 타이머 끄기
     SetTimer, CheckCancelInput, Off


    ;---------------------입력대기중 수동부활------------------------------------------------------

    ;도사는 tabtabOn 복구가 많아서 이걸 따로 함수로 만들어서 사용하든가 하자

    if (ErrorLevel = "EndKey:SPACE") { ; 입력대기중 g키, 좌클릭 눌렀을 때 o가 입력되게 해서 해당 로직 실행. g키로 하려니까 시작핫키라 그런지 안 먹히더라
        ;MsgBox, Enter was pressed!
        ; Enter를 눌렀을 때 실행할 로직 추가
        
        ;부활을 타겟박스로 했으므로 다시 g키 누르는 것은 부활 시전이므로 바로 시전
        SendInput, {Enter}
        CustomSleep(70)        

        ;부활 후 힐좀 채워줄까. 5번 하면 3번 시전
        Loop, 5{            
            SendInput, {1}
            CustomSleep(30)
            SendInput, {Enter}
            CustomSleep(50)
        }

        ;무사의 방에서는 사람에게 파혼술 돌린다고 spread파혼술 하면 몹들도 파혼걸리니 수동부활에 시력회복하고 같이 넣어뒀다.
        ;무사방 외에 다른 곳에서도 파혼 시력회복 해독 등 필요한 곳이 나오면 무사방 조건을 빼주자

        ;수동 부활의 경우 한 번 무사 조건을 빼보자
         ;if(isAtMooSaRoom) {
            SendInput, {7} ;시력회복
            CustomSleep(30)
            SendInput, {Enter}
            CustomSleep(30)
            SendInput, {Esc}
            CustomSleep(30)
            SendInput, {8} ; 파혼술
            CustomSleep(30)
            SendInput, {Enter}
            CustomSleep(30)
            SendInput, {Esc}
            CustomSleep(30)

            SendInput, {shift down}
            CustomSleep(40)
            SendInput, { z }
            CustomSleep(40)
            SendInput, {shift up}
            CustomSleep(40)
            SendInput, {blind}r ; r -> 해독
            CustomSleep(40)
            SendInput, { enter }
            CustomSleep(30)
            SendInput, { esc }
            CustomSleep(30)
        ;}

        SendInput, {shift down}
        CustomSleep(40)
        SendInput, { z }
        CustomSleep(40)
        SendInput, {x} ; 대문자 X -> 보호
        CustomSleep(40)
        SendInput, {shift up}
        CustomSleep(40)
        SendInput, { enter }
        CustomSleep(30)
        SendInput, { esc }
        CustomSleep(30)
        
    } else if(ErrorLevel = "EndKey:e") {
        SendInput, {Enter} ;일단 부활로 타겟잡은 거 엔터하고
        CustomSleep(200)
        SendInput, {9}    ; 지진.  선딜 150까지 올려도 가끔 씹히네. 일단 선딜 200까지 올려봤다. 일단 안 씹힘.
        CustomSleep(30)
        SendInput, {Enter}
        CustomSleep(30)
        SendInput, {Esc}
        CustomSleep(30)


    } else if(ErrorLevel = "EndKey:r") {
        SendInput, {Enter} ;일단 부활로 타겟잡은 거 엔터하고
        CustomSleep(60)   
        SendInput, {7}    ; 시력회복
        CustomSleep(30)
        SendInput, {Enter}
        CustomSleep(30)
        SendInput, {Esc}
        CustomSleep(30)


    } else if(ErrorLevel = "EndKey:t") {
        SendInput, {Enter} ;일단 부활로 타겟잡은 거 엔터하고
        CustomSleep(160)   

        Detox() ;해독

        SendInput, {Enter}
        CustomSleep(30)
        SendInput, {Esc}
        CustomSleep(30)


    } else if(ErrorLevel = "EndKey:f") {
        SendInput, {Enter} ;일단 부활로 타겟잡은 거 엔터하고
        CustomSleep(60)   

        Exorcism() ;퇴마주
        
        SendInput, {Enter}
        CustomSleep(30)
        SendInput, {Esc}
        CustomSleep(30)


    }  else if(ErrorLevel = "EndKey:g") {
        SendInput, {Enter} ;일단 부활로 타겟잡은 거 엔터하고
        CustomSleep(60)   
        SendInput, {8}    ; 파혼술
        CustomSleep(30)
        SendInput, {Enter}
        CustomSleep(30)
        SendInput, {Esc}
        CustomSleep(30)


    } else if (ErrorLevel = "EndKey:ESCAPE") { ; 취소
        ;MsgBox, esc was pressed!
        ;Esc를 눌렀을 때 실행할 로직 추가 (대기상태에서 c키 눌러도 esc임)
    } else if (ErrorLevel = "Timeout") {
        ;MsgBox, Time out! No key was pressed.
        ; 타임아웃 시 실행할 로직 추가
    } else {
        ;MsgBox, Unexpected input: %ErrorLevel%  ;혹시 모를 디버깅을 위해 일단 놔뒀다가 다시 주석처리  
    }    

    SendInput, {Esc}
    CustomSleep(50) ;꼬임방지
    
    ;밀대힐로 사용하다가 탭탭으로 돌아가면 가끔 탭탭아닌채로 1이 눌러져서 대상은? 하고 흰 타겟박스가 남는다.
    ;추적혼힐과 스탠딩혼힐은 혼에 esc가 있어서 이렇게 떠도 잡아주지만 밀대힐은(TabTabHealRefresh) 그냥 탭탭 대상에게
    ; 1번힐과 백호의희원 반복이라서 esc가 없어서 꼬임 방지가 안 된다.
    ;여러가지 테스트해본 결과 탭탭on 체크가 탭탭을 못 찾았을 경우(탭탭 상태일 때 백호의 희원 이펙트로 탭탭이 가려지면 탭탭 인식이 안 됨) 
    ;아예 isTabTabOn 조건에 참으로 안 들어와서 탭탭창을 열지 않고 밀대힐로 돌아가서 1이 눌러져서 그랬던 것이다.
    
    ;일단은 그냥 혼힐마냥 끝에는 탭탭으로 마무리 하자
    ;if(isTabTabOn) { ; 탭탭 상태였다면 탭탭으로 원상복구
    ;    SendInput, {Tab}
    ;    CustomSleep(70)
    ;    SendInput, {Tab}
    ;    CustomSleep(70)
    ;} 

    ;일단 조건없이 탭탭으로 마무리 하는 걸로
    SendInput, {Tab}
    CustomSleep(50)
    SendInput, {Tab}
    CustomSleep(50)


    IsWaiting := false ;초기화
    return
}



;입력대기시 CanceelInput 변수를 확인해서 취소할 때 사용하기 위한 구문.
;입력대기에서 사용자의 input입력대기시 타이머를 통해 변수를 확인해서 입력대기를 취소하게 만듦 (Send 사용)
;입력대기중 급하게 사용할 4방위 마비같은 핫키에 CancelInput을 true로 만드는 구문을 넣어주자.

;우선 4방위 마비 돌리기인 f:: 에만 넣어줬는데 이는 입력대기중 키 연계시 f키는 포기한 것. 그럴만한 것이 4방위 마비라서 급할 때 유용
CheckCancelInput:
    if (CancelInput) {
        Send, {o}  ; 플래그가 세팅되면 o키를 전송하여 Input에서 정해진 키 이외의 else 조건이 되게 해서 취소하게 만듦
        ;esc로 해서 입력키가 escape일 때 취소되게 하려고 했는데 다른 핫키 사용시 ESC 입력이 끼어들어 꼬이게 돼서 상관없는 키로.
        ;참고로 o 말고 c로 해도 괜찮더라. 단 이때는 c:: 핫키가 동작하는 게 아닌 것 같다 (else 조건 작동) 그래서 걍 o키로 함
        CancelInput := false ; 타이머마다 Esc입력이 끼어드므로 한 번 입력되면 플래그(flag)인 CancelInput을 false로 만들어 준다
    }
return




;도사는 isTabTabOn 상황에 따라 탭탭 복구가 많으므로 입력대기에 사용할 탭탭 복구 함수를 따로 만들었긴 한데 아직 안 쓰는 중
ReturnTabTabOn() {
    if(isTabTabOn) { ; 탭탭 상태였다면 탭탭으로 원상복구
        SendInput, {Esc}
        CustomSleep(50)
        SendInput, {Tab}
        CustomSleep(50)
        SendInput, {Tab}
        CustomSleep(50)
    }   
    Return
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
    ;아래 winWidth쪽 설명대로 잠시 windowWidth와 height를 대입하고 이상하면 롤백
    ;winEndX := winStartX + windowWidth -1
    ;winEndY := winStartY + windowHeight -1

    winEndX := windowWidth
    winEndY := windowHeight

    ;윈도우 가로길이 세로길이 저장 -> 이게 현재 윈도우 우측하단 x,y 좌표를 찾아주더라.
    ;현재 활성화된 윈도우에서 길이 구하니 당연히 끝 좌표가 나오는 건가? 아무튼 이걸 winEndX, winEndY에 넣고 오작동하면 롤백
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


!F8::
GhostCheck()
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
    ; 배경색 애매한 건 그냥 그림판에서 특정색깔로 다 칠해주고 배경무시 해주는 방법도 유용하다.
    ; 색상무시와 유사도 조정도 같이 사용 가능

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
    StopLoop := false ;초기화
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
                ConditionalChase()
                CustomSleep(20)
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
    StopLoop := false ;초기화
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
                ConditionalChase()
                CustomSleep(20)
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
    StopLoop := false ;초기화. 루프 넣고 루프탈출 넣었으니 초기화 해줘야한다.
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
                ConditionalChase()
                CustomSleep(20)
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
    StopLoop := false ;초기화
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
        ConditionalChase()
        CustomSleep(20)
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
    

    ;CalPos()로 winEndX, winEndY에 현재 활성화된 창의 우측하단 끝 좌표를 구해서 활성창의 시작과 끝을 구해서
    ;활성화된 창 내에서만 검색하려고 했다. 실제로 예를들어 활성화된 창의 가로 길이가 1896이라고 한다면 이 창이 가운데 있고 최대가 아니기에
    ;화면 좌측에서 살짝 떨어져 있었고(예를들어 50만큼) 실제로 활성화된 창 x좌표는 떨어진 50 + 가로길이 1896 해서 1946이라고 할 수 있다.
    ;그러면 가로 검색범위는 스크린의 50 ~ 1946 범위에서 검색한다면 현재 활성화된 창의 가로 길이 내에서만 이미지 서칭을 한다.
    ;그런데 화면 밖에서 이미지가 검색이 되었고 좌표를 확인하니  1963 이었고 window좌표는 1907이었다.
    ;노트북이라서 scale 때문인가.. dpi 120이고 스케일 1.25배인 상태다. 아무튼 노트북에서는 창의 가로 세로 길이까지 검색으로 해주면 될 듯듯
    ;뭔가 이미지 서치가 스크린 전체라지만 잘 안 먹히는 것 같다. 일단 다음에 스케일링 조정 해주고 일단은 탭탭체크만
    ;CalPos()에서 창의 가로길이 세로 길이를 변수에 저장해서 tabtabOn() 여기서만 범위를 가로세로 길이까지만.

    ;ImageSearch, FoundX1, FoundY1, winStartX, winStartY, winEndX, winEndY,*30 %tabtab% ;탭탭라인 검색
    ;탭탭라인 검색 -> 채팅창에 거래채팅이 tabtab으로 인식돼서 거래창 위로 범위를 잡아줘야한다.(혹시 몰라 템창도 템창 왼쪽으로). 노트북 기준이다.
    ImageSearch, FoundX1, FoundY1, winStartX, winStartY, 1430, 830,*30 %tabtab% 
    ImgResult1 := ErrorLevel ; 탭탭창 열려 있는지 확인하기 위함
    if(ImgResult1 = 0) {        
        isTabTabOn := true
        mouseMove, FoundX1, FoundY1, 1
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
    ImageSearch, FoundX1, FoundY1, winStartX, winStartY, 1430, 830,*30 %tabtab% ;가로는 아이템창 이전쯤, 세로는 채팅창 이전쯤 까지만. 외치기에 검색되더라
    ;ImageSearch, FoundX1, FoundY1, winStartX, winStartY, winEndX, winEndY,*30 %tabtab% ;탭탭라인 검색  ;바람창 내부에서만 검색
    ;ImageSearch, FoundX1, FoundY1, 0, 0, A_ScreenWidth, A_ScreenHeight,*30 %tabtab% ;탭탭라인 검색 오리지널(바람 창 최대화 혹은 뒤에 다른 창x)
    ImgResult1 := ErrorLevel ; 탭탭된 캐릭터 따라가기 위함
    if(ImgResult1 = 0) {
        ;SendInput, {Blind}1 ;확인용 코드
        ;원래 x에 +30, y에 +40이었다. 기본 좌측 하단이 검색되므로 중간쯤 가리키게 하려면
        if(noRandomPos) { ;랜덤좌표 토글값 on/off에 따른 이동좌표
            ;마우스 이동 속도를 0으로 해서 힐틱 지연을 최소한으로. 원래는 1
            MouseMove, FoundX1+ 20, FoundY1 + 40, 0  ;x값은 +30해두면 위아래는 우클이동시 중간에 잘 붙음 y값이 +50이었는데 랜덤값줘서 우클이동시 뒤아래로 움직이게(다시 +40으로)
        } else {
            MouseMove, FoundX1+ 20, FoundY1 + RY, 0  ;x값은 +30해두면 위아래는 우클이동시 중간에 잘 붙음 y값이 +50이었는데 랜덤값줘서 우클이동시 뒤아래로 움직이게(다시 +40으로)
        }
        Click, Right down ;우클 이동
        ;CustomSleep(10) ; 원래 50 했었고 힐틱 밀리는 원인일까 싶어 빼놨다


    ;탭탭 발견 안 되면 격수가 다른 방 갔다고 보고 Exit와 우클해제 해봄. 다른 방 안 갔는데도 Exit 되면 다시 아무 코드도 없는 걸로 롤백
    ;-> 다른 방 가는 순간 타이밍에 의해 될 때도 있고 안 될 때도 있어서 그냥 지움
    } else if(ImgResult1 = 1) {
        ;SendInput, {2} ;확인용 코드
        ;발견 안 되면 격수가 순간 다른 방 간 것이고 이때 exit를 하든 뭐를 하든 한 번 해보자.
        ;Click, Right up ;우클 이동 해제
        ;SendInput, {Esc}
        ;CustomSleep(20)
        ;Exit
    } else {
        ;SendInput, 3 ;확인용 코드
    }

    ;힐틱 밀림 방지를 위해서 2번은 탭탭추적, 한 번은 검색한 좌표 + 랜덤Y값을 변수에 넘겨서 마우스만 이동시키기 위함
    TabTabX := FoundX1 + 20

    ;상하 랜덤좌표는 모드에 따라 on/off. 기본이 랜덤좌표 사용이다.
    if(noRandomPos) {
        TabTabY := FoundY1 + 40 ;이미지 서칭에 있는 기본값
    } else {
        TabTabY := FoundY1 + RY
    }


return
}


;유령확인. 유령시 머리 위에 하얀 링 검색. -> pc와 노트북에서 보이는 이미지가 살짝 다르다.
;유령확인 후 부활 스킬을 대상 마우스 클릭으로 선택해서 부활시키는데 못 찾으면 입력대기 수동부활 적극활용
;부활 후 힐 잠깐 주려면 힐 추가
GhostCheck() {

    ;탭탭 상태인지 확인(탭탭힐 중이면 끝나고 탭탭 복구 해주기 위함) -> 백호의희원 이펙트에 가리면 인식이 안 된다.
    ;지속적은 탭탭체크는 한 번 씹혀도 괜찮지만 여기서는 단발성이므로 인식이 안 되면 탭탭이 안 되므로 힐 스킬 1이 눌러지면 대상은? 하고
    ;흰 타겟박스가 뜬다. 추적혼힐이나 스탠딩혼힐은 혼에 esc로 꼬임방지가 있어서 괜찮지만 탭탭이 유지되는 밀대힐은 탭탭 복구 안 되고 1이 눌러지면
    ;타겟박스 뜬 채로 꼬이게 된다. 그래서  탭탭on 확인 빼고 항상 탭탭으로 복귀하는 걸로 하자.
    ;CheckTabTabOn() 
    ;CustomSleep(20)

    if(isChasing) { ;만약 추적중이었으면 움직이면서 좌표 검색 후 잘못된 위치를 클릭 가능하므로 이동 정지. 아래에서 추적중이었으면 다시 탭탭이동동
        Click, Right up
        CustomSleep(20)
    }
    

    Ghost1 := imgFolder . "ghost1.png"  ; 유령 머리위에 링 배경제거 한 것
    Ghost2 := imgFolder . "ghost2.png"  ; 유령 머리위에 링 배경제거 한 것
    Ghost3 := imgFolder . "ghost3.png"  ; 유령 머리위에 링 배경제거 한 것
    Ghost4 := imgFolder . "ghost4.png"  ; 유령 머리위에 링 배경제거 한 것

    ;일단 창 크기 계산은 세로는 280쯤 빼주자(해상도에 따라 더 조절 필요할 수도). 
    ;배경색 애매한 건 그냥 그림판에서 특정색깔로 다 칠해주고 배경무시 해줬다.(아래 ED1C24는 그림판 빨강색이다)
    ;130하면 가끔 다른 곳으로 튀더라. 100~110 해줬는데 안 먹힐 때도 제법 됨. 다음에 보완하자.

    ;110이 마지노선인 것 같다. 120으로 하면 벽이고 바닥이고 막 튄다 -> 115 하니까 중간지점인 것
    ImageSearch, FoundX1, FoundY1, winStartX, winStartY, 1430, 830, *Trans0xED1C24 *115 %Ghost1% ;가로는 아이템창 이전쯤, 세로는 채팅창 이전쯤 까지만.
    ImgResult1 := ErrorLevel ; 본인과 탭탭대상 제외한 타인 부활을 위함함
    ImageSearch, FoundX2, FoundY2, winStartX, winStartY, 1430, 830, *Trans0xED1C24 *115 %Ghost2% ;가로는 아이템창 이전쯤, 세로는 채팅창 이전쯤 까지만.
    ImgResult2 := ErrorLevel ; 본인과 탭탭대상 제외한 타인 부활을 위함함
    ImageSearch, FoundX3, FoundY3, winStartX, winStartY, 1430, 830, *Trans0xED1C24 *115 %Ghost3% ;가로는 아이템창 이전쯤, 세로는 채팅창 이전쯤 까지만.
    ImgResult3 := ErrorLevel ; 본인과 탭탭대상 제외한 타인 부활을 위함함
    ImageSearch, FoundX4, FoundY4, winStartX, winStartY, 1430, 830, *Trans0xED1C24 *115 %Ghost4% ;가로는 아이템창 이전쯤, 세로는 채팅창 이전쯤 까지만.
    ImgResult4 := ErrorLevel ; 본인과 탭탭대상 제외한 타인 부활을 위함함
    


    ;이미지3이 제일 흔한 것 같아서 3부터 -> 확실히 3부터 하니까 정말 잘 인식한다. 다음에 좀 더 보완해보자
    if(ImgResult1 = 0) {        
        SendInput, {Esc}
        CustomSleep(20)
        SendInput, {0} ;부활
        CustomSleep(30)
        MouseClick, Left, FoundX1 +10, FoundY1 + 10, 1  ;y + 10해서 링 살짝 아래로 마우스 포인트 이동동
        CustomSleep(50)        
        SendInput, {Enter}
        CustomSleep(70)
        SendInput, {Esc}
        CustomSleep(20)
        ;MsgBox, 고스트1 검색
    } else if(ImgResult2 = 0) {
        SendInput, {Esc}
        CustomSleep(20)
        SendInput, {0} ;부활
        CustomSleep(30)
        MouseClick, Left, FoundX2 +10, FoundY2 + 10, 1  ;y + 10해서 링 살짝 아래로 마우스 포인트 이동동
        CustomSleep(50)        
        SendInput, {Enter}
        CustomSleep(70)
        SendInput, {Esc}
        CustomSleep(20)
        ;MsgBox, 고스트2 검색
    } else if(ImgResult3 = 0) {
        SendInput, {Esc}
        CustomSleep(20)
        SendInput, {0} ;부활
        CustomSleep(30)
        MouseClick, Left, FoundX3 +10, FoundY3 + 10, 1  ;y + 10해서 링 살짝 아래로 마우스 포인트 이동동
        CustomSleep(50)        
        SendInput, {Enter}
        CustomSleep(70)
        SendInput, {Esc}
        CustomSleep(20)
        ;MsgBox, 고스트3 검색
    } else if(ImgResult4 = 0) {
        SendInput, {Esc}
        CustomSleep(20)
        SendInput, {0} ;부활
        CustomSleep(30)
        MouseClick, Left, FoundX4 +10, FoundY4 + 10, 1  ;y + 10해서 링 살짝 아래로 마우스 포인트 이동동
        CustomSleep(50)        
        SendInput, {Enter}
        CustomSleep(70)
        SendInput, {Esc}
        CustomSleep(20)
        ;MsgBox, 고스트4 검색
    } else {
        ;MsgBox, 못찾음
        ;못 찾으면 GhostCheckSecond() 실행. second에서 마무리 수행 해줄 것이므로 여기선 return하고 마무리를 해주지 않는다.
        GhostCheckSecond()
        Return
    }
    CustomSleep(30) ; 꼬임방지지
    ;if(isTabTabOn) { ;도사라 탭탭힐 중이었으면 다시 탭탭 -> 항상 탭탭으로 복구할 것이므로 주석처리
    SendInput, {Esc}
    CustomSleep(50)
    SendInput, {Tab}
    CustomSleep(50)
    SendInput, {Tab}
    CustomSleep(70)
    ;}

    if(isChasing) { ;만약 추적중이었으면 움직이면서 놓치지 않게 추적적
        TabTabChase()
        CustomSleep(20)

    }
    return
}









;유령확인 테스트. -> 기본 유령확인 안 되면 테스트 이미지로 해보는데 7이 잘 되는 느낌. 가끔6도 작동.  5는 별로면 교체하자
;아예 테스트가 아니라 Second로 해놓고 GhostCheck() 에서 안 되면 못찾을 경우 GhostCheckSecond() 실행하는 걸로 해놨다
GhostCheckSecond() {

    ;탭탭 상태인지 확인(탭탭힐 중이면 끝나고 탭탭 복구 해주기 위함) -> 백호의희원 이펙트에 가리면 인식이 안 된다.
    ;지속적은 탭탭체크는 한 번 씹혀도 괜찮지만 여기서는 단발성이므로 인식이 안 되면 탭탭이 안 되므로 힐 스킬 1이 눌러지면 대상은? 하고
    ;흰 타겟박스가 뜬다. 추적혼힐이나 스탠딩혼힐은 혼에 esc로 꼬임방지가 있어서 괜찮지만 탭탭이 유지되는 밀대힐은 탭탭 복구 안 되고 1이 눌러지면
    ;타겟박스 뜬 채로 꼬이게 된다. 그래서  탭탭on 확인 빼고 항상 탭탭으로 복귀하는 걸로 하자.
    ;CheckTabTabOn() 
    ;CustomSleep(20)

    if(isChasing) { ;만약 추적중이었으면 움직이면서 좌표 검색 후 잘못된 위치를 클릭 가능하므로 이동 정지. 아래에서 추적중이었으면 다시 탭탭이동동
        Click, Right up
        CustomSleep(20)
    }
    

    Ghost1 := imgFolder . "ghost5.png"  ; 유령 머리위에 링 배경제거 한 것
    Ghost2 := imgFolder . "ghost6.png"  ; 유령 머리위에 링 배경제거 한 것
    Ghost3 := imgFolder . "ghost7.png"  ; 유령 머리위에 링 배경제거 한 것

    ;일단 창 크기 계산은 세로는 280쯤 빼주자(해상도에 따라 더 조절 필요할 수도). 
    ;배경색 애매한 건 그냥 그림판에서 특정색깔로 다 칠해주고 배경무시 해줬다.(아래 ED1C24는 그림판 빨강색이다)
    ;130하면 가끔 다른 곳으로 튀더라. 100~110 해줬는데 안 먹힐 때도 제법 됨. 다음에 보완하자.

    ;원래 *110이었다.
    ImageSearch, FoundX1, FoundY1, winStartX, winStartY, 1430, 830, *Trans0xED1C24 *120 %Ghost1% ;가로는 아이템창 이전쯤, 세로는 채팅창 이전쯤 까지만.
    ImgResult1 := ErrorLevel ; 본인과 탭탭대상 제외한 타인 부활을 위함함
    ImageSearch, FoundX2, FoundY2, winStartX, winStartY, 1430, 830, *Trans0xED1C24 *120 %Ghost2% ;가로는 아이템창 이전쯤, 세로는 채팅창 이전쯤 까지만.
    ImgResult2 := ErrorLevel ; 본인과 탭탭대상 제외한 타인 부활을 위함함
    ImageSearch, FoundX3, FoundY3, winStartX, winStartY, 1430, 830, *Trans0xED1C24 *120 %Ghost3% ;가로는 아이템창 이전쯤, 세로는 채팅창 이전쯤 까지만.
    ImgResult3 := ErrorLevel ; 본인과 탭탭대상 제외한 타인 부활을 위함함
    


    ;이미지3이 제일 흔한 것 같아서 3부터 -> 확실히 3부터 하니까 정말 잘 인식한다. 다음에 좀 더 보완해보자
    if(ImgResult1 = 0) {        
        SendInput, {Esc}
        CustomSleep(20)
        SendInput, {0} ;부활
        CustomSleep(30)
        MouseClick, Left, FoundX1 +10, FoundY1 + 10, 1  ;y + 10해서 링 살짝 아래로 마우스 포인트 이동동
        CustomSleep(50)        
        SendInput, {Enter}
        CustomSleep(70)
        SendInput, {Esc}
        CustomSleep(20)
        ;MsgBox, 고스트5 검색
    } else if(ImgResult2 = 0) {
        SendInput, {Esc}
        CustomSleep(20)
        SendInput, {0} ;부활
        CustomSleep(30)
        MouseClick, Left, FoundX2 +10, FoundY2 + 10, 1  ;y + 10해서 링 살짝 아래로 마우스 포인트 이동동
        CustomSleep(50)        
        SendInput, {Enter}
        CustomSleep(70)
        SendInput, {Esc}
        CustomSleep(20)
        ;MsgBox, 고스트6 검색
    } else if(ImgResult3 = 0) {
        SendInput, {Esc}
        CustomSleep(20)
        SendInput, {0} ;부활
        CustomSleep(30)
        MouseClick, Left, FoundX3 +10, FoundY3 + 10, 1  ;y + 10해서 링 살짝 아래로 마우스 포인트 이동동
        CustomSleep(50)        
        SendInput, {Enter}
        CustomSleep(70)
        SendInput, {Esc}
        CustomSleep(20)
        ;MsgBox, 고스트7 검색
    } else {
        ;MsgBox, 못찾음
    }
    CustomSleep(30) ;꼬임방지
    
    ;if(isTabTabOn) { ;도사라 탭탭힐 중이었으면 다시 탭탭 -> 항상 탭탭으로 복구할 것이므로 주석처리
    SendInput, {Esc}
    CustomSleep(50)
    SendInput, {Tab}
    CustomSleep(50)
    SendInput, {Tab}
    CustomSleep(70)
    ;}

    if(isChasing) { ;만약 추적중이었으면 움직이면서 놓치지 않게 추적적
        TabTabChase()
        CustomSleep(20)

    }
    return
}





;사망확인. 일단 탭탭대상한테는 무조건 부활을 일딴 쓰고 도사 본인은 체력 0인 상태 확인 하고 셀프부활 시전
DeathCheck() {
    isDead := false
    CalPos() ;현재 활성창 우측하단 좌표 계산
    
    SendInput, {Blind}0 ; 도사 본인 유령 체크하는 것이라서 격수는 알 수 없기에 일단 부활 시전 한 번 하고(탭탭상황) 도사 유령확인. 꼬이면 뺸다
    death := imgFolder . "healthzero.png"

    ImageSearch, FoundX1, FoundY1, startStatusBarX, startStatusBarY, winEndX, winEndY, %death% ;유령상태
    ImgResult1 := ErrorLevel ; 
    if(ImgResult1 = 0) {
        isDead := true
        ;도사는 Rev 함수를 써준다.
        Rev()
    }
    return
}






#If
    

