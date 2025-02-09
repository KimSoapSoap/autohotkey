;저주, 중독, 마비 돌리는 돌리기 마법횟수 변수 (단일 사용 OO돌리기들 시전횟수 통일할 때 사용)
;기본 카운트 20, 신극지방 갈 때는 깔끔하게 6정도
global magicCount := 12
;참고로 북방, 신극지방 갈 때 말 죽이면 안 되니까 자힐첨첨,자힐 주석처리도 바꿔줘야 한다.(#IfWinActive 아래에 있음)

;숲지대 갈 때 true로 바꿔주면 g:: 핫키에 ForestPoisonChumHunt() 실행. false면 그냥 흉가용 자동사냥 PoisonChumHunt()
;global isForest := true
global isForest := false 


;산적굴 갈 때는 중독 안 쓰니까 중독과 절망 자리 바꿔서 절망 활용.
;삼매 진형 만들어놨는데 마비가 25초 지속이므로 삼매쿨보다 짧게 남았다면 그 자리에 굳히기로 절망을 걸어두면 된다.



;PC 혹은 Notebook 에 따른 좌표 설정. -> 보통 pc에서 만들면 이미지는 물론 새로 캡쳐해야되고 notebook은 복붙해서 핫키를 바꿔줬는데 이미지 서칭할 때는 좌표와 이미지 경로도 바꿔줘야 한다.
;이미지는 물론 notebook에서 사용할 이미지 새로 캡쳐해서 따줘야 한다. (단, 1920x1200 125%로 pc와 거의 비슷한 해상도 사용시 그대로 사용)

; 좌표와 경로를 변수로 설정
; 경로는 PC가     \img\joosool    노트북이이   \img\joosool\notebook     (앞에 현재 경로 설정인 A_ScriptDir . 붙여 준다. 점(.)은 문자열 덧셈)
; 좌표는 시전창, 상태창(체력, 마나)에 따라 좌표 설정값만 바꿔주면 될 것 같다.
; 노트북 현재 배율을 1920 x 1200에 125% 해서 PC와 엇비슷하긴 하다. 아래 노트북 설정값은 2560 x 1600에 150% 배율일 때이므로
; 노트북 배율을 1920 x 1200에 125%로 사용할 것 같으면 PC좌표로 설정해줘도 된다.(단 세로는 살짝 조정)
global startCastBarX := 1200
global startCastBarY := 500
;pc는 1200, 500 노트북은 1700, 850 (1920x1200 125% 사용시 PC좌표 그대로 사용) 

global startStatusBarX := 1300
global startStatusBarY := 700
;pc는 1300, 700 노트북은 1900, 1150 (1920x1200 125% 사용시 PC좌표 그대로 사용) 


global imgFolder := A_ScriptDir . "\img\joosool\"
;global imgFolder : = A_ScriptDir . "\img\joosool\notebook\"
;pc는 "\img\joosool\""   이고   notebook은   "\img\joosool\notebook\"
;A_ScriptDir은 현재 스크립트의 폴더경로이고 점(.)은 오토핫키에서 문자열을 더하는(+) 부호이다. 시작부분을 그냥 가져왔으므로 A_ScriptDir는 맨 앞에 붙여놓고 . 으로 이어 놓으면 된다.


;StopLoopCheck로 break면 끝날 때 초기화 해주면 되는데 StopLoopExit()라는 함수는 Exit 이므로 중간에 Exit시킨다면 끝에 반드시 초기화 시킬 건 해줘야됨(isHunting같은)

;PC와 NoteBook의 차이는 보무가 End(PC) vs NumpadEnd(Notebook) 정도의 차이이다.
;PC에서 복붙해서 보무만 바꾸면 노트북이 된다, Reload도 다르다.

;컴파일하지 않고 관리자모드로 실행한다.
;기본적인 저주,마비, 중독 혹은 +첨 스킬들은 반복회수 매개변수 count를 전달해줘야 하는데 처음 설계할 때 회수 20으로 했어서
;조정하는 게 아니면 20을 전달해준다

;셀프힐은 4번 해줘야 힐 3틱이 되더라(후딜 50기준)
;꼬임 방지 esc 뒤에 sleep은 최소 30으로 해준다.

;기존
;` 탭탭자힐첨,  1 자힐 3틱(탭탭x)    2 헬파 3 공증 4저주 5극진첨
; 6 마비(q) 7중독(w) 8 활력 (e) 9혼돈(r)  0 진첨    t 극진 , shift + e 활력 돌리기
;a저주 돌리기,  s 중독첨,   d 중독돌리기,  f 4방향 마비저주 , shift + f 4방향 마비, g 첨첨 자동사냥
;c 마비 돌리기, v 중독자동사냥 b 중독쩔

; -> 중독첨도 잘 안 쓰기 때문에 shift + d로 빼는 것도 괜찮을 듯. 헬파 써야되므로 중독이나 저주 따로 돌리고 자힐첨으로 주로 피채움
; -> v 중독자동사냥도 이제 거의 안 쓰는 편. 첨첨자동사냥에 shift 붙여서 뺴는 것도 괜찮겠다. 중독 쩔도 바꾸던가 하자

;중독첨첨 자동사냥 g, 중독자동사냥 shift + g,  중독쩔은 alt + g로 변경했다.. 필요할 때 b와 잠깐 핫키 교체하면 될 듯
;그리고 s중독첨 돌리기도 잘 안 쓴다. -> shift + d로 변경. 


; s 입력대기 -> 입력대기중  d  :저주+헬파(말에서 내리고 쏘고 말타기) 공증 자힐. 첨첨사냥이나 중독사냥중 입력대기 + d는 단순 헬파만



;일단 s키에 헬파 입력대기를 만들어서 사용해보자.
;s 누르고 입력대기 할 때 원하는 키 누르면 저주 + 헬파 + 공증 + 자힐 몇번 쓰는 걸로
;취소키 & 타임아웃도 넣어서 취소키 누르거나 일정시간 안 쏘면 취소되게
;말타고 다니는 상황이라 가정하고 헬파 쏠 때 말에서 내리고 쏘고 다시 탐

;첨첨 사냥이나 중독사냥시에는 입력대기 후 헬파를 쏘면 단순 헬파만 쏘기



;주술용 wasd 이동은 신극지방 해보고 만들자. wasd이동 + 마우스 선택헬파같은 기능 추가해서.
;필요하다면 c를 저주돌리기, f를 마비 돌리기 shift + f를 4방향 저주마비 혹은 4방향마비(다른 하나는 ctrl + f)
;중독 돌리기는 g  이런식으로 빼고  키 확보 후 wasd를 이동으로 만들 수도 있다. 아니면  다른 기능을 넣든지.



;wasd 이동 버전도 따로 하나 만들어 주고 싶은 마음이긴 하다. 말타고 헬쏘고 다니는 곳은 wasd도 괜찮아 보여서
;c마비, f저주, v 중독 뭐 이런 식으로 하긴 하겠다만 일단 방향키 이동으로 해보고 만들어보던가 하자





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
global JjulCount := 0

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


;좌표계산할 때 활성화된 창 우측하단 좌표 구해서 저장할 변수. 기본값은 스크린 가로세로 길이
;바람 창이 최대화가 아닐 때 바탕화면 사진이나 뒤에 다른 창이 이미지 검색에 발견되는  경우 방지를 위해
global windowX := A_ScreenWidth
global windowY := A_ScreenHeight




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
            isHunting := false ;Exit라서 초기화 못 시켜주는 건 여기서 초기화
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

;저주 마비 중독 등 얼마나 돌릴지 신극지방 등 사냥터마다 단독 사용시 카운트를 다르게 해줘야 되므로 최상단에 배치
;몬스터들 제법 몰린 곳에서도 사용할 수 있게끔 기본 카운트 20, 신극지방 갈 때는 깔끔하게 6정도
;보통 통일 시키므로 magicCount라는 변수를 만들어서 사용. 필요하면 개별로



`:: ; (자힐 3틱x4 + 첨 ) 4~5회 ;북방파망 or 극지방 사냥시 셀프힐첨대신 셀프탭탭힐 사용(주석 이용)
SelfHealAndChum(20)
;SelfTapTapHeal(20)
StopLoop := true
return


a:: ;저주만 돌리기
SpreadCurse(magicCount)
StopLoop := true
return

+a:: ;저주 돌리기 + 첨
CustomSleep(190) ;쉬프트키 조합 눌렀다가 뗄 때 시간
SpreadCurseAndChum(magicCount)
StopLoop := true
return




d::  ;중독만 돌리기.
;입력대기 키로 사용할 것이므로 if로 조건 걸어줌 -> 입력대기중일 때는 또다른 동작 수행. 입력대기가 아닐 때는 원래 d키 동작 수행
if (IsWaiting) {
    ; 대기 상태일 때 동작. 이때 d를 누르면 Enter 입력이 되게 했다. SendInput 말고 Send를 사용해야됨
    Send, {d}
    return
}
; 일반적인 d 핫키 동작
SpreadPoison(magicCount)
StopLoop := true
return



;좌클릭도 입력대기시 일단 헬파이어로 만들어 봄
LButton::
;입력대기 키로 사용할 것이므로 if로 조건 걸어줌 -> 입력대기중일 때는 또다른 동작 수행. 입력대기가 아닐 때는 원래 d키 동작 수행
if (IsWaiting) {
    ; 대기 상태일 때 동작. 이때 d를 누르면 Enter 입력이 되게 했다. SendInput 말고 Send를 사용해야됨
    Send, {LButton}
    Send, {d}
    return
}

;일반적인 d 핫키 동작
Send, {LButton}
return






+d::  ;중독 돌리기 + 첨
CustomSleep(180) ; shift 조합 입력 방지용 딜레이
SpreadPoisonAndChum(magicCount)
StopLoop := true
return

c::  ;마비만 돌리기(6번을절망으로 바꾸면 절망 돌리기)
;입력대기시 동작
if (IsWaiting) {
    ; esc는 안 되므로 안 쓰는 키 p를 써서 이걸 취소로 사용하자.
    Send, {ESC}
    return
}
; 일반적인 d 핫키 동작
SpreadParalysis(magicCount)
StopLoop := true
return




+e::  ;활력 돌리기 (shift + e -> 큐센 한 손 키보드 계산기모드)
CustomSleep(180) ; shift + e 입력 방지용 딜레이
SpreadVitality(magicCount)
StopLoop := true
return

^s:: ; 상태창
CustomSleep(190) ; ctrl 조합키 떼는 딜레이
SendInput, {Blind}s
return





f:: ;캐릭 4방위 저주 후 마비
FourWayCurseAndParalysis()
StopLoop := true
return


+f:: ;캐릭 4방위 마비만 돌리기.
CustomSleep(170) ; shift + 키조합 떼는 딜레이
FourWayParalysis()
StopLoop := true
return


^f:: ;캐릭 4방위 활력 돌리기
CustomSleep(170) ; ctrl + 키조합 떼는 딜레이
FourWayVitality()
StopLoop := true
return



g:: ;중독첨첨 사냥 종합합
; 보무 걸고 (4방향 마비저주, 중독첨2, 저주첨2)x1   (공증, 중독첨2+자힐첨1)x4
;여기 중독 저주 등 x1 회수는 20이다.
if(isForest) {
    ForestPoisonChumHunt()
}
PoisonChumHunt()
StopLoop := true
return




; 중독사냥 종합(마지막에 첨첨 마무리). 원래 v였는데 자주 안 쓰므로 첨첨사냥인 g에서 shift 붙여서 shift + g로 변경
;보무, (4방향 마비저주주 + 중독 돌리기 4번) x4 이후 중독첨2 저주첨2 자힐첨2
;이것도 맨 처음 한 번은 중독2에 저주2 어떨까 싶음
+g::
CustomSleep(190) ; 쉬프트 + g 누르고 키 떼는 딜레이
PoisonHunt()
StopLoop := true
return




!g:: ;쩔용 중독 저주 마비 돌리기
PoisonJJul()
StopLoop := true
return



End:: ;  셀프보무
SelfBoMu()
StopLoop := true
return




~x:: ;줍기
getget() ;StopLoop 하면 안 되는 게 동작중에 뭘 주울 수도 있기 때문
return





;우측 컨트롤 키(키 히스토리로)
SC11D:: ;한 손 드리블할 때. 우측 ctrl로 뭘 쓸까? 도적은 비영승보인데 주술은 일단 투컴시 필요할까봐 말타기만 넣음
SendInput, {Blind}r 
;CustomSleep(20)
;SendInput, {Blind}1
return





AppsKey:: ;한손컨시 지도(우측 ctrl 왼쪽 키)
OpenMap()
return



':: ; 사자후
Shout()
return




Del:: ; 2컴할 때용 줍기. 사자후는 '(홑따움표) 키로
getget()
return



F1:: ; 숫자 1
SendInput, {Blind}1
CustomSleep(30)
return


F2:: ; 동동주 마시기용, a에 동동주
DrinkDongDongJu()
return




F3:: ;자신 선택 & StopLoop
SelfTargetAndStopLoop()
return



F4:: ;지도
OpenMap()
return

;맨 아래에 F6에 이미지 서치 테스트 핫키 있음


1:: ; 자힐 3틱
SelfHeal(4)
StopLoop := true
return


 5:: ; 극진첨 + 진첨이었는데 현사되고 삼매진화로. 첨첨은 자힐첨첨으로 쓰자
 ;ChumChum()
 SamMaeJinWha()
 return

 
 +1:: ;숫자1
 CustomSleep(130)
 SendInput, {Blind}1
 return

 +5:: ;숫자5
 CustomSleep(130)
 SendInput, {Blind}5
 return



q::6 ;마비
w::7 ;중독 ; 2차 달면 삼매진화로 바꾸고(겜 시스템상 없는 키 -> h,n 등 해야 안 꼬임 w했을 때 꼬였음) 중독은 shift + w로 변경
e::8 ;활력

r:: ;혼돈 ;주로 길 뚫는데 사용하므로 자동 home 누르는 걸로 하고 필요시 home 제거
SendInput, {9}
CustomSleep(30)
SendInput, {Home}
return

t:: ; 극진화열참주, 종합사냥중 어그로 끌 때 사용하기 위해 StopLoop 뺐다
UltimateBlazingSlash()
return



+q:: ;절망 (마법자리 Q -> 대초원 가면 마비 안 통해서 마비와 절망 마법자리 교체. 마비=f,)
CustomSleep(170) ;쉬프트 +q 누를 때 키 떼는 딜레이
Despair()
return





SelfTargetAndStopLoop() {    
    SendInput, {Home}
    CustomSleep(20)
    SendInput, {Blind}r ;북방 파밍할 때 말 편하게 타려고
    CustomSleep(20)
    StopLoop := true ; 각각의 함수들이 루프시작에 StopLoop가true일 경우 break를 해주기 때문에 중간에 썼을 때 멈추려면 써준다.
    return
}




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


SelfHeal(count) { ; 셀프힐 3틱.  반복 3번하면 2번만 나가고 4번해야 3틱이 나가더라.
    SendInput, {Esc}
    CustomSleep(30)
    StopLoop := false
    Loop, %count%
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



; ` 백틱 키는 위에 올려놨다. 신극지 북방 등 말 타고 다닐 때 자힐첨, 자힐 주석처리 바꿔야돼서
; 자힐 + 첨 할 때 sendInput Esc 뒤에 CustomSleep(20) 하니까 탭탭이 씹히고 30으로 하니까 괜찮더라
;자힐 + 첨 할 때 어쩔 때 첨이 계속 써지고 알트탭 해서 나갔다 와야 풀렸는데 ctrl + 5(넘패드5) 하니까 풀렸다
SelfHealAndChum(count) {
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
    Loop, %count%
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
    Send,{Numpad5} ; 셀프힐 + 첨 할 때 어떤 이유 때문이지는 모르겠지만 종료되고 나서도 계속 첨 써지는 것을 이거 추가하니 해결
    CustomSleep(20)
    return
}


SelfTapTapHeal(count) {
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
    Loop, %count%
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
        Send, {1}
        CustomSleep(50)
        
    }
    SendInput, {Esc}
    CustomSleep(30)
    return
}





;극진신수마법. 원래 딜 30씩 해줬는데 빨리 시전을 위해 20으로 해봄. 씹히면 30으로 롤백
 UltimateBlazingSlash() {
    SendInput, {Esc}
    CustomSleep(20)
    SendInput, {shift down}
    CustomSleep(20)
    SendInput, { z }
    CustomSleep(20)
    SendInput, {shift up}
    CustomSleep(20)
    SendInput, {y} ;  y -> 극진화열참주, w로 했었는데 w키가 템착용 단축키라서 꼬일 때가 있어서 없는 키로
    return
 }


 ChumChum() {
    Send, 5
    CustomSleep(30)
    Send, 0
    CustomSleep(30)
    return
}


;삼매진화. 씹히면 후딜 조절
SamMaeJinWha() {
    SendInput, {Esc}
    CustomSleep(20)
    SendInput, {shift down}
    CustomSleep(20)
    SendInput, {z} 
    CustomSleep(20)
    SendInput, {a} ;  A -> 삼매진화
    CustomSleep(20)
    SendInput, {shift up}
    return
 }




Despair() {  ;절망
    SendInput, {Esc}
    CustomSleep(30)
    SendInput, {shift down}
    CustomSleep(30)
    SendInput, { z }
    CustomSleep(30)
    SendInput, {shift up}
    CustomSleep(30)
    SendInput, q ;  q -> 절망
    return
 }



;shift 조합은 처음에 esc 누르고 CustomSleep(120)~170정도 해주자. 그냥 누르는 건 30.  shift 누르고 sleep 짧게 하니까 자꾸 채팅 쳐짐




SpreadVitality(count) { ;활력 돌리기
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
        SendInput, 8
        CustomSleep(30)
        SendInput, { left }
        CustomSleep(30)
        SendInput, { enter } ;원래 엔터후 후딜90인데 꼬임 방지를 위해 esc 넣고 후딜 60, 30으로 나눠줌
        CustomSleep(60)
        SendInput, {esc}
        CustomSleep(30)
    }
    SendInput, {Esc}
    CustomSleep(20)
    return
    }




SpreadParalysis(count) {
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
        SendInput, 6
        CustomSleep(30)
        SendInput, { left }
        CustomSleep(30)
        SendInput, { enter } ;원래 엔터후 후딜90인데 꼬임 방지를 위해 esc 넣고 후딜 60, 30으로 나눠줌
        CustomSleep(60)
        SendInput, {esc}
        CustomSleep(30)
    }
    SendInput, {Esc}
    CustomSleep(20)
    return
}



;마비첨은 거의 안 쓰였지만 일단 만들어 둠
SpreadParalysisAndChum(count) { ;마비 돌리기 + 첨
    SendInput, {Esc}
    CustomSleep(120)
    SendInput, {5 Down} ; 5키 눌림
    CustomSleep(20)
    SendInput, {0 Down} ; 0키 눌림
    CustomSleep(20)
    StopLoop := false
    loop, %count%
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
        SendInput, { enter } ;원래 엔터후 후딜90인데 꼬임 방지를 위해 esc 넣고 후딜 60, 30으로 나눠줌
        CustomSleep(60)
        SendInput, {esc}
        CustomSleep(30)
    }
    SendInput, {5 Up} ; 눌린 5 키 해제
    CustomSleep(20)
    SendInput, {0 Up} ; 눌린 5 키 해제
    CustomSleep(20)
    return
}




SpreadPoison(count) ;중독만 돌리기
{
    SendInput, {Esc}
    CustomSleep(120)
    StopLoop := false
    loop, %count%
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
        SendInput, { enter } ;원래 엔터후 후딜90인데 꼬임 방지를 위해 esc 넣고 후딜 60, 30으로 나눠줌
        CustomSleep(60)
        SendInput, {esc}
        CustomSleep(30)
    }
    SendInput, {Esc}
    CustomSleep(20)
    return
}






SpreadPoisonAndChum(count) ;중독 돌리기 + 첨
    {
    SendInput, {Esc}
    CustomSleep(30)
    SendInput, {5 Down} ; 5키 눌림
    CustomSleep(20)
    SendInput, {0 Down} ; 0키 눌림
    CustomSleep(20)
    StopLoop := false
    loop, %count%
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
        SendInput, { enter } ;원래 엔터후 후딜90인데 꼬임 방지를 위해 esc 넣고 후딜 60, 30으로 나눠줌
        CustomSleep(60)
        SendInput, {esc}
        CustomSleep(30)
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






SpreadCurse(count) { ;저주만 돌리기
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
        SendInput, 4
        CustomSleep(30)
        SendInput, { left }
        CustomSleep(30)
        SendInput, { enter } ;원래 엔터후 후딜90인데 꼬임 방지를 위해 esc 넣고 후딜 60, 30으로 나눠줌
        CustomSleep(60)
        SendInput, {esc}
        CustomSleep(30)
    }
    SendInput, {Esc}
    CustomSleep(20)
    return
}


SpreadCurseAndChum(count) { ;저주 돌리기 + 첨
    SendInput, {Esc}
    CustomSleep(120)
    SendInput, {5 Down} 
    CustomSleep(20)
    SendInput, {0 Down} 
    CustomSleep(20)
    StopLoop := false
    loop, %count%
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
        SendInput, { enter } ;원래 엔터후 후딜90인데 꼬임 방지를 위해 esc 넣고 후딜 60, 30으로 나눠줌
        CustomSleep(60)
        SendInput, {esc}
        CustomSleep(30)
    }
    SendInput, {5 Up} 
    CustomSleep(20)
    SendInput, {0 Up} 
    CustomSleep(20)
    SendInput, {Esc}
    CustomSleep(20)
    return
}





FourWayCurseAndParalysis() { ;캐릭 4방위 저주 후 마비
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
            SendInput, { enter } ;원래 엔터후 후딜90인데 꼬임 방지를 위해 esc 넣고 후딜 60, 30으로 나눠줌
            CustomSleep(60)
            SendInput, {esc}
            CustomSleep(30)
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
            SendInput, { enter } ;원래 엔터후 후딜90인데 꼬임 방지를 위해 esc 넣고 후딜 60, 30으로 나눠줌
            CustomSleep(60)
            SendInput, {esc}
            CustomSleep(30)
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
            SendInput, { enter } ;원래 엔터후 후딜90인데 꼬임 방지를 위해 esc 넣고 후딜 60, 30으로 나눠줌
            CustomSleep(60)
            SendInput, {esc}
            CustomSleep(30)
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
            SendInput, { enter } ;원래 엔터후 후딜90인데 꼬임 방지를 위해 esc 넣고 후딜 60, 30으로 나눠줌
            CustomSleep(60)
            SendInput, {esc}
            CustomSleep(30)
        }
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
                SendInput, { enter } ;원래 엔터후 후딜90인데 꼬임 방지를 위해 esc 넣고 후딜 60, 30으로 나눠줌
                CustomSleep(60)
                SendInput, {esc}
                CustomSleep(30)
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
                SendInput, { enter } ;원래 엔터후 후딜90인데 꼬임 방지를 위해 esc 넣고 후딜 60, 30으로 나눠줌
                CustomSleep(60)
                SendInput, {esc}
                CustomSleep(30)
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
                SendInput, { enter } ;원래 엔터후 후딜90인데 꼬임 방지를 위해 esc 넣고 후딜 60, 30으로 나눠줌
                CustomSleep(60)
                SendInput, {esc}
                CustomSleep(30)
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
                SendInput, { enter } ;원래 엔터후 후딜90인데 꼬임 방지를 위해 esc 넣고 후딜 60, 30으로 나눠줌
                CustomSleep(60)
                SendInput, {esc}
                CustomSleep(30)
            }
            SendInput, {Esc}
    CustomSleep(20)
    return
}



FourWayVitality() { ; 4방향 활력
    SendInput, {Esc}
    CustomSleep(120)
    StopLoop := false
        loop, 1
            {
                if (StopLoop)
                    {            
                        Break
                        CustomSleep(20)
                    }
                SendInput, 8
                CustomSleep(30)
                SendInput, {Home}
                CustomSleep(30)
                SendInput, {Left}
                CustomSleep(30)
                SendInput, { enter } ;원래 엔터후 후딜90인데 꼬임 방지를 위해 esc 넣고 후딜 60, 30으로 나눠줌
                CustomSleep(60)
                SendInput, {esc}
                CustomSleep(30)
            }
        
        loop, 1
            {
                if (StopLoop)
                    {            
                        Break
                        CustomSleep(20)
                    }
                SendInput, 8
                CustomSleep(30)
                SendInput, {Home}
                CustomSleep(30)
                SendInput, {Right}
                CustomSleep(30)
                SendInput, { enter } ;원래 엔터후 후딜90인데 꼬임 방지를 위해 esc 넣고 후딜 60, 30으로 나눠줌
                CustomSleep(60)
                SendInput, {esc}
                CustomSleep(30)
            }
        
        loop, 1
            {
                if (StopLoop)
                    {            
                        Break
                        CustomSleep(20)
                    }
                SendInput, 8
                CustomSleep(30)
                SendInput, {Home}
                CustomSleep(30)
                SendInput, {Up}
                CustomSleep(30)
                SendInput, { enter } ;원래 엔터후 후딜90인데 꼬임 방지를 위해 esc 넣고 후딜 60, 30으로 나눠줌
                CustomSleep(60)
                SendInput, {esc}
                CustomSleep(30)
            }
        
        loop, 1
            {
                if (StopLoop)
                    {            
                        Break
                        CustomSleep(20)
                    }
                SendInput, 8
                CustomSleep(30)
                SendInput, {Home}
                CustomSleep(30)
                SendInput, {Down}
                CustomSleep(30)
                SendInput, { enter } ;원래 엔터후 후딜90인데 꼬임 방지를 위해 esc 넣고 후딜 60, 30으로 나눠줌
                CustomSleep(60)
                SendInput, {esc}
                CustomSleep(30)
            }
            SendInput, {Esc}
    CustomSleep(20)
    return
}


FourWayCurse() { ; 4방향 저주
    SendInput, {Esc}
    CustomSleep(40)
    StopLoop := false
        loop, 1
            {
                if (StopLoop)
                    {            
                        Break
                        CustomSleep(20)
                    }
                SendInput, 4
                CustomSleep(30)
                SendInput, {Home}
                CustomSleep(30)
                SendInput, {Left}
                CustomSleep(30)
                SendInput, { enter } ;원래 엔터후 후딜90인데 꼬임 방지를 위해 esc 넣고 후딜 60, 30으로 나눠줌
                CustomSleep(60)
                SendInput, {esc}
                CustomSleep(30)
            }
        
        loop, 1
            {
                if (StopLoop)
                    {            
                        Break
                        CustomSleep(20)
                    }
                SendInput, 4
                CustomSleep(30)
                SendInput, {Home}
                CustomSleep(30)
                SendInput, {Right}
                CustomSleep(30)
                SendInput, { enter } ;원래 엔터후 후딜90인데 꼬임 방지를 위해 esc 넣고 후딜 60, 30으로 나눠줌
                CustomSleep(60)
                SendInput, {esc}
                CustomSleep(30)
            }
        
        loop, 1
            {
                if (StopLoop)
                    {            
                        Break
                        CustomSleep(20)
                    }
                SendInput, 4
                CustomSleep(30)
                SendInput, {Home}
                CustomSleep(30)
                SendInput, {Up}
                CustomSleep(30)
                SendInput, { enter } ;원래 엔터후 후딜90인데 꼬임 방지를 위해 esc 넣고 후딜 60, 30으로 나눠줌
                CustomSleep(60)
                SendInput, {esc}
                CustomSleep(30)
            }
        
        loop, 1
            {
                if (StopLoop)
                    {            
                        Break
                        CustomSleep(20)
                    }
                SendInput, 4
                CustomSleep(30)
                SendInput, {Home}
                CustomSleep(30)
                SendInput, {Down}
                CustomSleep(30)
                SendInput, { enter } ;원래 엔터후 후딜90인데 꼬임 방지를 위해 esc 넣고 후딜 60, 30으로 나눠줌
                CustomSleep(60)
                SendInput, {esc}
                CustomSleep(30)
            }
            SendInput, {Esc}
    CustomSleep(20)
    return
}





PoisonHunt() {
    SendInput, {Esc}
    CustomSleep(30)
    StopLoop := false
    isHunting := true
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
                selfheal(8) ; 
                CustomSleep(50)                     
                FourWayCurseAndParalysis() ;4방향 마비
                CustomSleep(1500) ;위의 중독몹 몇마리 남은채로 다시 중독 돌리는 거 슬립시간으로 조정시도
            }
            
    
            Loop,4 ;중독 돌리는 회수
                {
                StopLoopCheck()
                SpreadPoison(20) ;중독만 돌리기
                CustomSleep(30)
                }
            CustomSleep(1000) ; 중독 좀 돌리고 다시 자힐하기 전 잠시 대기 ;원래 1200이었음
            }
    
        
    
            Loop, 1 ; (공증 + 중독첨 x2  + 저주첨x2, 공증) 1번 -> 중독첨2 저주첨2 중독첨1 자힐첨2로 변경경
                {                 
    
    
                Loop,2 ; 중독첨. 
                {
                    StopLoopCheck()
                    SpreadPoisonAndChum(20)
                    CustomSleep(30)
                }
                Loop,2 ; 저주첨. 
                    {
                        StopLoopCheck()
                        SpreadCurseAndChum(20)
                        CustomSleep(30)
                    }
    
                Loop,1 ; 중독첨. 
                    {
                        StopLoopCheck()
                        SpreadPoisonAndChum(20)
                        CustomSleep(30)
                    }
                Loop, 1 ;공증
                    {
                        StopLoopCheck()
                        DrinkDongDongJu()
                        CustomSleep(30)
                        SendInput, 3 ; 공증(실패해도 됨)
                        CustomSleep(30)
                        selfheal(4) ; 자힐 3틱
                        CustomSleep(50)
                    }
    
                Loop,2 ; 자힐첨 -> 딸피 마무리
                    {            
                    StopLoopCheck()
                    SelfHealAndChum(20) 
                    CustomSleep(30)
                    }
                }
        }
    CustomSleep(30)
    isHunting := false
    return
    }



PoisonChumHunt() {
    SendInput, {Esc}
    CustomSleep(30)
    StopLoop := false
    isHunting := true
    ManaRefresh := 0
    FourWayMabi := 0

    CustomSleep(30)
 
        StopLoopCheck()   
        SelfBoMu() ; 자신 보무
        CustomSleep(30),

        ;일단 처음에는 저주 돌려야 하니까 4방향 마비&저주 걸고 중독2, 저주2 ; -> 중첨첨 사냥은 첫 시작을 중독첨2, 저주첨2        
        ; 초반 첫 4방향 저주마비 이후 중독첨2, 저주첨2로 딸피되기 때문에 다음턴 마비 없이 진행

        ;초반에도 헬파 쓰고 마력 부족할 수 있으므로 안전 공증 추가.
        ;중독첨이나 저주첨 기본 1회를 20번으로 해줬고 2회는 20 x2 루프돌리다가 매개변수 넣고 40으로 해줬는데
        ;중간에 마나량 확인을 위해 10으로 나눠서 하자.
        ;그리고 중간 헬파를 위해 체력이 부족하면 공증 넘어가는 게 아니라 체력좀 회복하고 공증 시도로?
        
            
        StopLoopCheck()
    
        FourWayCurseAndParalysis() ;4방향 마비저주 
        SelfHealAndChum(4) ;셀프힐&첨 3틱
        CustomSleep(30)
                       
        
        ;중독첨 x2.  기본 20회로 사용했으므로 x2는 40.  이를 나눠서 중간에 마나 부족시 안전한 공증
        Loop, 2 {
            StopLoopCheck()            
            SpreadPoisonAndChum(20)  
            CustomSleep(30)
            SafeRestoreManaAtLow()            
        }
          
        
        ;저주첨 x2.  기본 20회로 사용했으므로 x2는 40.  이를 나눠서 중간에 마나부족시 안전한 공증
        Loop,2 {
            StopLoopCheck()
            SpreadCurseAndChum(20) ; 저주첨 x2   기본 20회로 사용했으므로 x2는 40
            CustomSleep(30)
            SafeRestoreManaAtLow()
        }
        

        CustomSleep(100) ;원래 오토감지 방지용으로 1100 했는데 걍 100
            
        


        Loop , 4  { 
            ; 다음 과정 4번 반복 ((자힐x2+ 마비) x1 + 중독첨2 저주첨1 자힐첨1) x4
            ; 0으로 시작하는 FourWayMabi 변수가 중독첨2+저주첨+자힐첨1 반복마다 1씩 올라가는데 홀수일 때 마비 걸었는데(0이 시작이고 이땐 4방향 저주마비 걸기 때문에 패스) 뺐다. 첫 저주마비 이후 마비x
            ;맨 처음 4방향 마비저주 이후에는 그냥 마비 뺐다.
        ;   힐량증가 마력비례 1% 패치로 첫 4방향 마비저주 외에는 마비 없이 간다.
            ;그냥 중독사냥이 아니라 중독첨첨이라 빨리 잡는 것이 목적이므로 
            ;마비 딜레이 신경 안 써도 되니 첫 마비이후 중독첨2 자힐첨1로 딜레이 맞췄는데 이제는 중독첨2 저주첨1 자힐첨1 하면 될듯
              
            StopLoopCheck()
            SafeRestoreManaAtLow() ; 마나 부족시 공증
            ; 자힐 + 4방향 마비&저주 -> 마비 진행 일단 주석처리
          
            StopLoopCheck()         
            SelfHealAndChum(4)
            CustomSleep(50)         
            ;if (Mod(FourWayMabi, 2) == 1) { ;홀수 일 때만 마비 진행.                 
                ;FourWayCurseAndParalysis() ;4방향 마비
                ;CustomSleep(30)
            ;}                    
          
            ;중독첨x2 돌리기. 기본 20 x2라서  40으로 했는데 20으로 나눠서 마나확인
            Loop, 2 {
                StopLoopCheck()
                SpreadPoisonAndChum(20) 
                CustomSleep(30)
                SafeRestoreManaAtLow()   
            }
        
        
            ;저주첨x1 돌리기.(1회는  20회 )
            StopLoopCheck()
            SpreadCurseAndChum(20) 
            CustomSleep(30)
            SafeRestoreManaAtLow()
                                   
                    
            StopLoopCheck()
            SelfHealAndChum(20) ; 자힐첨x1
            CustomSleep(30)            
            SafeRestoreManaAtLow()
            CustomSleep(30)               
            
            
            ;공증 (루프 짝수마다 한 번씩 -> 체 절반 이상이면 성공시까지 공증 시도 해봄)
            ;자힐첨 2번 vs 공증 감소체력 + 피격체력  해서 자힐첨 2번으로 생존 가능해야 한다.
            ;만약 마력이 많이 높아지거나 하면 마력 부족할 때만 공증을 하거나
            ;루프 4번 중 공증을 3번 간격 혹은 4번 간격(mod 3  mod 4)으로 하거나 전체 한 번만 하거나 몇 번에 한 번 시도하는 공증을 없애거나 한다.
            if (Mod(ManaRefresh, 2) == 0)
                {            
                    SendInput, {Esc}
                   CustomSleep(20)  
                    StopLoopCheck()
                   CustomSleep(30)

                    ;원래 성공여부 상관없이 단순 공증 한 번이었는데 체 절반쯤 이상&성공시까지 n번 반복으로 보완해줌
                    SafeRestoreMana()
                }
            
              
            ManaRefresh++     
            FourWayMabi++
            CustomSleep(50) ; 매크로 체크방지 1초 -> 걍 100으로

        } ; (중독첨2 저주첨1 자힐첨1) x4 반복 루프 종료

        ;사실상 여기까지만 해도 어느정도 다 정리 됐음          

    
        StopLoopCheck()
        SpreadPoisonAndChum(20) ;중독첨x1 돌리기
        CustomSleep(30)
        SafeRestoreManaAtLow()
    
        StopLoopCheck()
        SpreadCurseAndChum(20) ; 저주첨x1 돌리기
        CustomSleep(30)
        SafeRestoreManaAtLow()      

                    
        StopLoopCheck()
        SelfHealAndChum(20)  ; 자힐첨x1
        CustomSleep(30)
        SafeRestoreManaAtLow()
            
                
       
    CustomSleep(30)
    StopLoop := true
    isHunting := false
    ManaRefresh := 0
    FourWayMabi := 0
    return
}



ForestPoisonChumHunt() {
    SendInput, {Esc}
    CustomSleep(30)
    StopLoop := false
    isHunting := true
    ManaRefresh := 0
    FourWayMabi := 0

    CustomSleep(30)
    StopLoopCheck()   
    SelfBoMu() ; 자신 보무
    CustomSleep(30)

  
    StopLoopCheck()         
    FourWayCurse() ;4방향 저주 
    SelfHealAndChum(6) ;셀프힐&첨 3틱
    CustomSleep(30)

    Loop, 10 {
        StopLoopCheck() 
        SafeRestoreMana() ; 안전공증(체력상관x)

        StopLoopCheck()            
        SpreadPoisonAndChum(20) ; 중독첨
        CustomSleep(30)
        SafeRestoreMana() ; 안전공증(체력상관x)
        
        
        StopLoopCheck()
        SpreadCurseAndChum(20) ; 저주첨
        CustomSleep(50)
        SafeRestoreMana() ; 안전공증(체력상관x) 
        
        
        StopLoopCheck()
        SelfHealAndChum(20)  ; 자힐첨
        CustomSleep(30)

        StopLoopCheck()
        SafeRestoreMana() ; 안전공증(체력상관x)
        CustomSleep(30)

        StopLoopCheck()
        SafeRestoreMana() ; 안전공증(체력상관x)
     
    }
    

    CustomSleep(30)
    StopLoop := true
    isHunting := false
    ManaRefresh := 0
    FourWayMabi := 0
    return
}



PoisonJJul() {
    SendInput, {Esc}
    CustomSleep(30)
    StopLoop := false
    JjulCount := 0
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
        
            selfheal(8) ; 자힐 3틱 x2
            CustomSleep(50)
                      
            ;FourWayCurseAndParalysis() ;4방향 마비
            CustomSleep(50) ;위의 중독몹 몇마리 남은채로 다시 중독 돌리는 거 슬립시간으로 조정시도. 중독 저주 마비 돌리느라 1500에서 50으로
        }
        

        Loop,3 ;중독 돌리는 회수
            {
            StopLoopCheck()
            SpreadPoison(20) ;중독만 돌리기
            CustomSleep(30)
            }

        if (Mod(JjulCount, 2) == 0) {
            Loop,2 ;마비 돌리는 회수
                {
                StopLoopCheck()
                SpreadParalysis(20) ;마비만 돌리기
                CustomSleep(30)
                }
        }

        if (Mod(JjulCount, 2) == 1) {
            Loop,2 ;저주 돌리는 회수
                {
                StopLoopCheck()
                SpreadCurse(20) ;저주만 돌리기
                CustomSleep(30)
                }
        }
        JjulCount++
        CustomSleep(50) ; 4방향 마비를 위한 후딜 조정. 원래 1200이었음
        }
    }
    CustomSleep(30)
    JjulCount := 0
    StopLoop := true
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


CastHellFire() { ; 다른 동작중 저주 + 헬파이어 시전하기. 탭탭인지 아닌지에 따라서 헬파이어 시전 후 탭탭 원상복구
    SendInput, {4} ; 저주
    CustomSleep(30)
    SendInput, {Enter}
    CustomSleep(100)
    SendInput, {Blind}2 ; 헬파 
    CustomSleep(30)
    SendInput, {Enter}
    CustomSleep(90) 

}




s::  ;입력대기.
InputWaiting()
return




;V: 키 입력 값을 저장하지 않고, 단순히 입력 이벤트를 감지합니다.
;L1: 한 번의 키 입력만 대기합니다.
;T5: 5초의 입력대기 시간. 시간 변경 가능. 입력대기를 하지 않으려면 T5 구문 자체를 빼버리면 됨

;키 입력이 발생하면 ErrorLevel에 입력된 키 정보가 저장됩니다.
;예를 들어, Enter를 누르면 ErrorLevel은 EndKey:Enter가 됩니다.( if(ErrorLevel = "EndKey:o") {...} 이런 식으로 사용)
;대기시간 설정 안 할 거면 아래와 같이 T부분은 뺀다.
;Input, UserInput, V L1, {Enter}{Esc} ; Enter 또는 ESC를 대기

;입력감지에 방향키, insert, del, home, end, PgUp, PgDn, 이런 키는 안 먹히더라
;ESC는 입력감지 이름을 ESCAPE라고 해야 한다.
;Enter키는 특이하게도 입력감지에는 인식이 되는데 Enter키 감지시 내부 로직에 Enter키 입력이 있으면 안 먹히더라
;입력감지를 O키로 바꿔서 d를 누르면 o를 누르는 걸로 하고 해당 로직에 Enter키를 넣어서 시전을 해준다.

;isWaiting := true일 때, 즉 입력대기 상태일 때 d키를 누르면 d:: 에서 아무 연관없는 o키 입력하고 입력대기중 o키 누르면 헬파 나가게 했는데
;그냥 Send, {d} 하니까 d키 입력도 인식이 돼서 o키 연계 말고 d키 인식으로 했다.
;c키는 취소인데 ESC 누를 때도 취소돼야 하고 c키 누를 때도 취소돼야 하기 때문에 입력대기시 c 누르면 ESC키를 send하게 유지.

;즉 정리하자면 s를 누르면 말타기(타고 있으면 내리기)-저주 타겟창 등 로직 수행 뒤 입력대기상태에 걸리는데(isWaiting 변수활용)
;입력대기상태에서 ;d를 누르면 해당 타겟에 저주 - 헬파 - 공증 -자힐 - 말타기 로직을 수행하고
;esc(대기상태에서 c를 누르면 esc입력됨)감지되면 취소로직 -> esc눌러서 말타기 로직 수행
;이런 식이다.

;이거 활용하면 헬파이어 뿐만 아니라 
;d 누르면 헬파로직, a누르면 삼매로직, c누르면 취소 이런식으로 활용하면 좋을듯
;일단은 s(말내리고)대기 d 저주헬파 공증 자힐,   c는 취소 이렇게 하자
;a로 삼매한다면 해당 타겟박스 위치 좌표저장하고 해당 좌표에 저주 -> 해당위치, 상하좌우 저주 돌리고 해당 좌표에 다시 삼매 던지면될듯




;s : 입력대기 // c, esc: 취소 // d, 좌클릭 : 저주 헬파 공증 자힐
InputWaiting() {    
    IsWaiting := true    ;대기 상태 true

    StopLoop := false ;초기화
    isRefreshed := false
    waitingHellFireCount := 0
    isWrongTarget := false
    isRiding := false
    notEnoughMana := False
    isTabTabOn := false


    ;-> 첫 헬파시 풀마나 아니어도 헬파 시전할 것인지 혹은 마나 부족시 공증 후 풀마나로 헬파 쓸 것인지 정하진 않았지만
    ; 적어도 첫 루프에서 공증만 하고 자힐하는 것은 방지할 수 있다. 자힐 후 break 조건에 이 변수도 넣으면 풀마나로 시전
    ; 현재 마나로 헬파 시전은 앞에 로직 추가해줌

    if(isHunting) { ;첨첨사냥 혹은 중독사냥 중이면 탭탭이 열려 있는지 확인 해두기
        CheckTabTabOn()
        CustomSleep(30)
    }

    ;입력대기시 미리 내려서 타겟 지정후 마법시전보다 말탄 상태에서 타겟 선택하고(저주로 대상 정하는 것)
    ;마법을 시전할 때 내려서 지정했던 타겟에 마법을 시전한다면 타겟박스가 말을 가로질러가며 한 번 더 누르는 것을 방지 가능
    ;훨씬 편할 것이다.

    SendInput, {esc} 
    CustomSleep(30)   
    SendInput, {4} ;저주 타겟박스 띄워서 타겟 선택하는 용도.
    CustomSleep(30)

    ; Enter와 d 키 입력 대기 (10초 타임아웃)
    Input, UserInput, V L1 T10, {d}{ESC}
    CustomSleep(20)    
    ;입력대기중 헬파이어.
    if (ErrorLevel = "EndKey:d") { ; 입력대기중 d키 눌렀을 때 헬파이어 -> 입력대기중에는 isWaiting 변수를 활용하여 d키 입력시 o가 입력되게 해서 연동. 마우스클릭도 o가 입력되게.
        ;MsgBox, Enter was pressed!
        ; Enter를 눌렀을 때 실행할 로직 추가


        if(isHunting) { ;첨첨 사냥중에는 단순 저주 + 헬파이어 시전만(탭탭창 열려 있는 상태면 탭탭창 복구)
            SendInput, {Esc}
            CustomSleep(30)
            SendInput, {4} ;저주
            CustomSleep(50)
            SendInput, {Enter} 
            CustomSleep(100)
            SendInput, {Blind}2 ; 헬파 
            CustomSleep(30)
            SendInput, {Enter}
            CustomSleep(90) 
            if(isTabTabOn) { ; 탭탭 상태였다면 탭탭으로 원상복구
                SendInput, {Esc}
                CustomSleep(30)
                SendInput, {Tab}
                CustomSleep(50)
                SendInput, {Tab}
                CustomSleep(50)
                IsWaiting := false
                Exit
            }
        }



        ;저주 -> 헬파 -> 공증(마나 감지될 때까지 계속 시도) -> 자힐 3틱
        ;헬파쓰고 페이백 받으면 마나 오링(바닥)상태를 기존 마나량 이미지로 서치해서는 판별할 수가 없다.
        ;페이백으로 마나가 남았는지 공증 성공했는지 판별 불가.
        ;그래서 페이백 못 받았을 경우와 페이백 받았을 경우 모두를 고려해야 한다.

        ;공증 성공여부는 풀마나가 되므로 풀마나 이미지로 공증성공 확인.
        ;만약 페이백을 못 받았을 경우 동동주 먹고 공력증강 시전
        SendInput, {Esc}
        CustomSleep(50)         

        SendInput, {Blind}r ;말에서 타고 있으면 말에서 내리기. 내리고 나서 말에 마비거는 건 어떨까 싶음(방향 확인 로직 필요)
        CustomSleep(150) ; 이 딜레이를 짧게하면 말을 타고 있다고 하므로 이 문구 뜨면 늘리자. 귀찮으면 말타기를 입력대기쪽 저주 앞으로 이동

        SendInput, {4} ;저주
        CustomSleep(50)
        SendInput, {Enter} ; 
        CustomSleep(100)
        ;헬파가 씹히는 경우가 생겨서 후딜을 늘리고 후딜 늘리는 걸로는 고장나는 경우가 생겨서 반복 재시전을 만들었다.
        
        ; -> 헬파가 씹히던 이유는 바람을 오래켜놔서 쿨타임 애드온 타이머가 고장나서 그랬던 거였고 반복 재시전을 만들었으나
        ; 재부팅 하니까 고쳐졌다. 하지만 덕분에 반복 재시전을 만들어서 괜찮다고 생각한다.  

        Loop ,20 { ;루프 횟수없으면 만약 말에서 내린 상태에서 s->d를 해버릴 때 말에 타버리면 말탄 상태에서 무한 공증시도를 하게 된다.
                   ; -> 말타고 시전하면 멈추는 로직 만들엇음.
            StopLoopCheck()
            CustomSleep(20)
            CheckFullMana() ; 풀마나 확인             
            CustomSleep(20)
            CheckWrongTarget() ; 걸리지 않는 잘못된 대상이면 중단
            CustomSleep(20) 
            CheckCastOnHorse() ; 말에 탄 상태에서 시전하면 중단
            CustomSleep(20)
            ;원래는 잘못된 대상과 말탄상태 둘 다 or 조건으로 묶어서 break 걸었는데
            ;말 탄 상태에서 자기 자신에게 시전할 때 말에서 내려서 저주를 거는데 잘못된 대상이면 다시 말에 타야되므로 r 넣어줬다.
            if(isWrongTarget) {
                SendInput, {Blind}r
                CustomSleep(20)
                break
                CustomSleep(20)
            } else if(isRiding) { ;헬파 쓸 때 말에 타버려서 말 탄 상태 시전하면 루프 탈출
                break
                CustomSleep(20)
            }

            ;풀마나 -> 공증하고 온 거면 힐 쓰고 마무리. 공증 안 하고 온 것 -> 헬파 안 썼음 -> 헬파 시전
            ;마나 낮음 -> 마나 조금이라도 있으면 그냥 공증. 마나 바닥이면 동동주 마시고 공증
            ;공증은 마나 낮음 체크 후 공력증강 or 동동주 마시고 공력증강 반복하고 풀마나이면 break걸면 되는데
            ;루프 위쪽에 풀마나 검증하는 것이 있으므로 그냥 공증 실패해도 다시 공증으로 내려보낸다.

            if(isFullMana) { ; 풀마나 상태일 때 (공력증강 or 헬파 씹힘)
                ;풀마나가 공증하고 온 것인지 헬파를 쓰지 않은 상태인지 판별. 공증하고 왔으면 자힐 후 말타고 break
                ;첫 헬파이어 시도시 풀마나가 아닐 때 공증 후 자힐하고 빠져나가는 것을 방지하기 위해 waitingHellFireCount 변수 조건 붙임
                ;0부터 시작해서 헬파이어 시도할 때 +1씩 해준다. 공증 후 풀마나로 와서 헬파이어 시도 안 했으면 조건에 따라 헬파이어 시전
                ;만약 현재 마나로 헬파이어 바로 시전하고 싶다면 if(isFullMana)조건 위에 if(waitingHellFireCount==0) 조건으로 헬파 시전
                if(isRefreshed && waitingHellFireCount > 0) { 
                    SelfTapTapHeal(3)
                    CustomSleep(20)
                    ;이때 말 타고 있었으면 말에 다시 타게 r키 탑승
                    SendInput, {Blind}r
                    Break
                } else { ;풀마나인데 공증 거친 것이 아니면 헬파 시전 안 된 것이므로 다시 루프 반복되면서 자힐로 안 가고 헬파로 다시 온다.            

                    if(waitingHellFireCount >0) { ;첫 헬파쐈는데 공증 없이 다시 풀마나로 왔다는 것은 쿨타임이라는 것이다. 쿨일시 마비(혹은 절망) 쏘고 헬파
                        ;어차피 마비나 절망 돌려놓고 할 가능성이 높은데 일단 써보고 별로면 이 if문은 빼자.
                        loop, 2{
                            SendInput, {6}
                            CustomSleep(30)
                            SendInput, {Enter}
                            CustomSleep(90)                          
                        }
                    }
                    SendInput, {Blind}2 ; 헬파 
                    CustomSleep(30)
                    SendInput, {Enter}                                        
                    CustomSleep(150)  ; 원래 후딜 90 -> 150으로 늘림. 헬파를 사용하고 마나를 소모했어도 루프 돌아가서 위에 CheckFullMana()에서 아직 풀마나로 인지해서 다시 헬파로 들어와서 후딜 150(아래 CheckManaZero()도 마찬가지)
                    CheckManaZero() ; 마나 0 확인(페이백x인지 확인) 원래 헬파 뒤에 두는 게 맞는데 한 번 페이백 없이 isManaZero가 true가 되면 공증 성공 이후에도 true로 남아서 아래 동동주 공증 더하게 됨.                    
                    CustomSleep(20)
                    
                    waitingHellFireCount++
                    isRefreshed := false
                }                 
            } else {  ;풀마나 아닐 때(현재 로직으로는 헬파 썼는지 알 수 없음). 공증 -> 마나부족하면 -> 동동주 마시고 다시 공증
                ;즉 현재 로직으로는 풀마나 아니면 내려와서 공증을 써버리고 풀마나 되면 자힐후 종료.
                ;풀마나 아닐시 공증 후 헬파이어 쓸지 그냥 헬파 쏘고 공증할지 정하자.
                ; 헬파 썼는지 알 수 있게  waitingHellFireCount 변수 만들고 0부터 시작해서 헬파 시전시 1씩 카운팅 올라가게 했다. 0이면 아직 시전 안 됨.
                ; 1이상부터 한 번 시도 했음(1이상부터는 쿨탐이었다는 의미). 즉 카운트가 0이면 공증하고 왔어도 풀마나 아니라서 공증이 된 것.
                ; 풀마나 아닐 시 헬파 카운트 0이면 공증 할 것이므로 안전상 마비 넣어줬다(혼돈으로 바꿔도 굳)
                
                ;풀마나 아니라서 공증하고 헬파 날릴 때 공증 하기 전 마비(혹은 혼돈으로 바꾸든가)x3 걸고 공증 시도
                if(waitingHellFireCount==0) {
                    loop, 2{
                        SendInput, {6}
                        CustomSleep(30)
                        SendInput, {Enter}
                        CustomSleep(90)
                    }
                }
               SendInput, {3} ;공증
               CustomSleep(150) ; 공증 이후에 그냥 30 이정도 후딜만 줬었는데 마나량 확인할 때는 공증 성공시 마나 회복한 것을 인지할 후딜을 150은 줘야한다(헬파 사용시에도 마찬가지)
               CheckEnoughMana()
               CustomSleep(20)               
               if(notEnoughMana || isManaZero) { ; 마나가 부족하다면 혹은 마나가 0이라면(헬파 페이백x)동동주 마시고 다시 공력증강 시전
                   DrinkDongDongJu()
                   CustomSleep(70)
                   SendInput, {3}
                   CustomSleep(150) ; 공증 이후 루프 반복될 때 풀마나인지 확인하는 함수가 있는데 공증 성공시 회복된 마나 인지할 정도의 후딜을 줬다. 기존 50 -> 100
               }           
                ;공증 성공인지 실패인지는 모르지만 어쨌든 공력증강 사용                
                isRefreshed := true
                
            }
            
            
        }
    } else if (ErrorLevel = "EndKey:ESCAPE") { ; 취소
        ;MsgBox, esc was pressed!
        ;Esc를 눌렀을 때 실행할 로직 추가 (대기상태에서 c키 눌러도 esc임)

        ;취소하면 말에 다시 탑승
        CustomSleep(30)
        SendInput, {Blind}r

    } else if (ErrorLevel = "Timeout") {
        ;MsgBox, Time out! No key was pressed.
        ; 타임아웃 시 실행할 로직 추가
    } else {
        ;MsgBox, Unexpected input: %ErrorLevel%  ;혹시 모를 디버깅을 위해 일단 놔뒀다가 다시 주석처리하고 탈것 다시 타도록
        CustomSleep(30)
        SendInput, {Blind}r
    }
    
    IsWaiting := false ;초기화
    isRefreshed := false
    SendInput, {Esc}
    CustomSleep(30)
    return
}



;현재 활성화된 창의 우측하단 좌표 찾는 함수. 이거 안 쓰려면 바람 최대화 해놓고 windowX, windowY대신
;자체적으로 스크린 가로 세로 길이인 A_ScreenWidth, A_ScreenHeight  쓰면 됨
CalPos() {
    ;활성 창의 위치와 크기를 구합니다.
    ;winX, winY는 현재 활성화된 창의 시작 좌표 
    WinGetPos, winX, winY, winWidth, winHeight, A

    ;현재 활성화된 창의 우측하단 좌표를 계산해서 windowX, windowY에 저장.(글로벌 변수로 선언해둠)
    ;winX와 winY 그리고 windowX, windowY를 활용하면 현재 활성화된 창의 시작좌표, 끝좌표(우측하단) 알 수 있음
    windowX := winX + winWidth
    windowY := winY + winHeight
    return
}





ImageSearchTest() {

    ;imgFolder 는 pc와 notebook 구분을 위해서 변수로 경로설정을 해놨다. global imgFolder : = A_ScriptDir . "\img\joosool"

    CalPos() ;현재 활성창 우측하단 좌표 계산

    HalfHealthImgPath := imgFolder . "halfhealth.png"


    ;ImageSearch, FoundX2, FoundY2, startStatusBarX, startStatusBarY, A_ScreenWidth, A_ScreenHeight, %HalfHealthImgPath% ;체력 거의 절반쯤 이미지
    ImageSearch, FoundX2, FoundY2, startStatusBarX, startStatusBarY, windowX, windowY, %HalfHealthImgPath% ;체력 거의 절반쯤 이미지
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
    ; 대신 활성화된 창의 시작 좌표를 구하는 자체 변수는 있다. winX와 winY다.
    
    ; 활성 창의 위치와 크기를 구해서
    ;WinGetPos, winX, winY, winWidth, winHeight, A
    ; 우측하단의 x좌표와 y좌표는 오른쪽 아래 좌표를 계산해서 WindowX와 WindowY를 사용. (시작좌표는 winX와 winY 사용)
    ;windowX := winX + winWidth
    ;windowY := winY + winHeight

    ; 활성화된 창의 좌표를 이용할 경우 위에 코드를 쓰고 이렇게 활용하면 된다.(아니면 최대화 시켜놓고 하자)
    ; ImageSearch, FoundX, FoundY, winX, winY, WindowX, WindowY, *100 %ImagePath%    

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
    ImageSearch, FoundX1, FoundY1, startStatusBarX, startStatusBarY, windowX, windowY, %HalfHealthImgPath% ;체력 거의 절반쯤 이미지
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
    ImageSearch, FoundX1, FoundY1, startStatusBarX, startStatusBarY, windowX, windowY, %ManaImgPath% ; 마나존재 이미지
    ImgResult1 := ErrorLevel  ;이미지가 검색되면 마나가 존재하는 것이고 찾지 못 하면 거의 바닥이라 공력증강 필요
    CustomSleep(10)

    ImageSearch, FoundX2, FoundY2, startStatusBarX, startStatusBarY, windowX, windowY, %HalfHealthImgPath% ;체력 거의 절반쯤 이미지.     
    ImgResult2 := ErrorLevel ; ;체력 절반쯤 깎인 이미지 이므로 검색되면 절반쯤 이하, 검색 안 되면 절반쯤 이상인 것. 즉, 검색 안 될 때 안전한 공증 ㄱㄱ


    if (ImgResult1 = 1 && ImgResult2 = 1) ;마나 거의 없고 피 절반쯤 이상일 때
                        ; -> 내 이미지는 파란색 마나가 남아 있는 것으로 발견되지 않을 경우, 즉 1일 경우에 공력증강 사용하자
        {            
            Loop, 30 { ;혹시 몰라서 횟수제한 걸어둠
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
    ImageSearch, FoundX1, FoundY1, startStatusBarX, startStatusBarY, windowX, windowY, %ManaImgPath% ; 마나존재 이미지
    ImgResult1 := ErrorLevel  ;이미지가 검색되면 마나가 존재하는 것이고 찾지 못 하면 거의 바닥이라 공력증강 필요
    if (ImgResult1 = 1) { ;마나 거의 없을 때(체력 상관x)
    ;   -> 내 이미지는 파란색 마나가 남아 있는 것으로 발견되지 않을 경우, 즉 1일 경우에 공력증강 사용        
            Loop, 30 { ;혹시 몰라서 횟수제한 걸어둠
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


    ImageSearch, FoundX1, FoundY1, startStatusBarX, startStatusBarY, windowX, windowY, %HalfHealthImgPath% ;체력 거의 절반쯤 이미지
    ImgResult1 := ErrorLevel ; 이미지가 검색되면 체력이 절반이 안 되는 것 -> 공력증강 상용시 위험


    if (ImgResult1 = 1) ;체력 절반쯤 이상일 때.  체력 절반쯤 깎인 이미지 이므로 검색되면 절반쯤 이하, 검색 안 되면 절반쯤 이상인 것
        {            
            Loop, 30 { ;혹시 몰라서 횟수제한 걸어둠
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
    ImageSearch, FoundX1, FoundY1, startStatusBarX, startStatusBarY, windowX, windowY, %ManaImgPath% ; 마나존재 이미지
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
    ImageSearch, FoundX1, FoundY1, startStatusBarX, startStatusBarY, windowX, windowY, *180 %FullManaImgPath% ; 마나존재 이미지
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
    
    ImageSearch, FoundX1, FoundY1, startCastBarX, startCastBarY, windowX, windowY, %WrongTargetImgPath% ; 잘못된대상 이미지
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
    
    ImageSearch, FoundX1, FoundY1, startCastBarX, startCastBarY, windowX, windowY, %CastOnHorseImgPath% ; 말에 타서 스킬 시전
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
    
    ImageSearch, FoundX1, FoundY1, startCastBarX, startCastBarY, windowX, windowY, %NotEnoughManaImgPath% ; 시전시 마나 충분한지 확인
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
    
    ImageSearch, FoundX1, FoundY1, startCastBarX, startCastBarY, windowX, windowY, %ManaZeroImgPath% ; 마나 0인지 확인
    ImgResult1 := ErrorLevel  
    if (ImgResult1 = 0) { ;이미지가 검색되면 마나 0인 것
        isManaZero = true  ;마나량 0       
    }
    return
}


;AutoHotkey 1.0에는 현재 창의 너비와 높이를 나타내는 내장 변수(예: A_WindowWidth, A_WindowHeight)가 없다
;따라서 특정 창에서 이미지 검색을 하려면, 먼저 그 창의 위치와 크기를 얻어와야 합니다. 이를 위해 WinGetPos 명령을 사용할 수 있습니다.
CheckTabTabOn() {
    isTabTabOn := false ;초기화

    CalPos() ;현재 활성창 우측하단 좌표 계산

    tabtab :=imgFolder . "tabtab4.png" ;탭탭4번 그림으로
    
    ImageSearch, FoundX1, FoundY1, winX, winY, windowX, windowY,*30 %tabtab% ;탭탭라인 검색
    ImgResult1 := ErrorLevel ; 탭탭창 열려 있는지 확인하기 위함
    if(ImgResult1 = 0) {        
        isTabTabOn := true
    } 
}


#If  ;IfWinActive 조건부 종료


    

