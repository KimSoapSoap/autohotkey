;저주, 중독, 마비 돌리는 돌리기 마법횟수 변수 (단일 사용 OO돌리기들 시전횟수 통일할 때 사용)
;기본 카운트 20, 신극지방 갈 때는 깔끔하게 6정도
global magicCount := 6
;참고로 북방, 신극지방 갈 때 말 죽이면 안 되니까 자힐첨첨,자힐 주석처리도 바꿔줘야 한다.(#IfWinActive 아래에 있음)


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

;자동사냥 b로 바꿈 -> 중독자동사냥 shift + b,  중독쩔은 alt + b로 해뒀다. 필요할 때 b와 잠깐 핫키 교체하면 될 듯
;그리고 d중독돌리기도 잘 안 쓴다. 숲지대하면 좀 쓰려나? 중독을 g로 바꾸려고 했는데 일단 보류
;s 중독첨을 shift + 중독키(현재는 d)로 바꿨으므로   s키, g키, v키가 남는다.

;일단 s키에 헬파 입력대기를 만들어서 사용해보자.
;s 누르고 입력대기 할 때 원하는 키 누르면 저주 + 헬파 + 공증 + 자힐 몇번 쓰는 걸로
;취소키 & 타임아웃도 넣어서 취소키 누르거나 일정시간 안 쏘면 취소되게
;말타고 다니는 상황이라 가정하고 키 누르면 말에서 내기도록 하고 가능하다면 첫 4방향 마비 빠르게 돌리고 말 마비시켜둔 채로
;헬파 쏘고 나면 다시 말 타는 걸로?
;일단 


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



`:: ; (자힐 3틱x4 + 첨 ) 4~5틱 ;북방파망 or 극지방 사냥시 셀프힐첨대신 셀프탭탭힐 사용(주석 이용)
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


d::  ;중독만 돌리기
SpreadPoison(magicCount)
StopLoop := true
return

+d::  ;중독 돌리기 + 첨
SpreadPoisonAndChum(magicCount)
StopLoop := true
return

c::  ;마비만 돌리기(6번을절망으로 바꾸면 절망 돌리기)
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



b:: ;중독첨첨 사냥 종합합
; 보무 걸고 (4방향 마비저주, 중독첨2, 저주첨2)x1   (공증, 중독첨2+자힐첨1)x4
;여기 중독 저주 등 x1 회수는 20이다.
PoisonChumHunt()
StopLoop := true
return




; 중독사냥 종합(마지막에 첨첨 마무리). 원래 v였는데 자주 안 쓰므로 첨첨사냥인 g에서 shift 붙여서 shift + g로 변경
;보무, (4방향 마비저주주 + 중독 돌리기 4번) x4 이후 중독첨2 저주첨2 자힐첨2
;이것도 맨 처음 한 번은 중독2에 저주2 어떨까 싶음
+b::
CustomSleep(190) ; 쉬프트 + g 누르고 키 떼는 딜레이
PoisonHunt()
StopLoop := true
return




!b:: ;쩔용 중독 저주 마비 돌리기
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
SendInput, {Home}
CustomSleep(20)
SendInput, {Blind}r ;북방 파밍할 때 말 편하게 타려고
CustomSleep(20)
StopLoop := true ; 각각의 함수들이 루프시작에 StopLoop가true일 경우 break를 해주기 때문에 중간에 썼을 때 멈추려면 써준다.
return

F4:: ;지도
OpenMap()
return


1:: ; 자힐 3틱
SelfHeal(4)
StopLoop := true
return




 5:: ; 극진첨 + 진첨
 ChumChum()
 return



q::6 ;마비
w::7 ;중독 ; 2차 달면 삼매진화로 바꾸고(겜 시스템상 없는 키 -> h,n 등 해야 안 꼬임 w했을 때 꼬였음) 중독은 shift + w로 변경
e::8 ;활력
r::9 ;혼돈

t:: ; 극진화열참주, 종합사냥중 어그로 끌 때 사용하기 위해 StopLoop 뺐다
UltimateBlazingSlash()
return



+q:: ;절망 (마법자리 Q -> 대초원 가면 마비 안 통해서 마비와 절망 마법자리 교체. 마비=f,)
CustomSleep(170) ;쉬프트 +q 누를 때 키 떼는 딜레이
Despair()
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






 UltimateBlazingSlash() {
    SendInput, {Esc}
    CustomSleep(30)
    SendInput, {shift down}
    CustomSleep(30)
    SendInput, { z }
    CustomSleep(30)
    SendInput, {shift up}
    CustomSleep(30)
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
        SendInput, { enter }
        CustomSleep(90)
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
        SendInput, { enter }
        CustomSleep(90)
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
        SendInput, { enter }
        CustomSleep(90)
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
        SendInput, { enter }
        CustomSleep(90)
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
        SendInput, { enter }
        CustomSleep(90)
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
            SendInput, {Enter}
            CustomSleep(90)
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
            SendInput, {Enter}
            CustomSleep(90)
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
            SendInput, {Enter}
            CustomSleep(90)
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
            SendInput, {Enter}
            CustomSleep(90)
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
                SendInput, {Enter}
                CustomSleep(90)
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
                SendInput, {Enter}
                CustomSleep(90)
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
                SendInput, {Enter}
                CustomSleep(90)
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
                SendInput, {Enter}
                CustomSleep(90)
            }
            SendInput, {Esc}
    CustomSleep(20)
    return
}



PoisonHunt() {
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
    return
    }



PoisonChumHunt() {

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
                ; -> 중첨첨 사냥은 첫 시작을 중독첨2, 저주첨2
                ; 초반 첫 4방향 저주마비 이후 중독첨2, 저주첨2로 딸피되기 때문에 다음턴 마비 없이 진행
                ; 0으로 시작하는 FourWayMabi 변수가 중독첨2+자힐첨1 반복마다 1씩 올라가는데
                ; 홀수일 때 마비 건다. 0이 시작이고 이때는 첫 4방향 마비저주 걸린 상태므로 패스.
            {       
                StopLoopCheck()
                Loop, 1 ;
                    { 
                    StopLoopCheck()         
                    FourWayCurseAndParalysis() ;4방향 마비저주 
                    SelfHealAndChum(4) ;셀프힐&첨 3틱
                    CustomSleep(30)
                    }            
                Loop,2 ;중독첨 돌리는 횟수
                    {
                    StopLoopCheck()            
                    SpreadPoisonAndChum(20) ; 중독첨2
                    CustomSleep(30)
                    }
                Loop,2 ;저주첨 돌리는 횟수
                    {
                    StopLoopCheck()
                    SpreadCurseAndChum(20) ; 저주첨2
                    CustomSleep(30)
                    }

                CustomSleep(100) ;원래 오토감지 방지용으로 1100 했는데 걍 100
            }
        


        Loop , 4  ; 다음 과정 4번 반복 ((자힐x2+ 마비) x1 + 중독첨2 저주첨1 자힐첨1) x4
            ;맨 처음 4방향 마비저주 이후에는 그냥 마비 뺐다.
        ;   힐량증가 마력비례 1% 패치로 첫 4방향 마비저주 외에는 마비 없이 간다.
            ;그냥 중독사냥이 아니라 중독첨첨이라 빨리 잡는 것이 목적이므로 
            ;마비 딜레이 신경 안 써도 되니 첫 마비이후 중독첨2 자힐첨1로 딜레이 맞췄는데 이제는 중독첨2 저주첨1 자힐첨1 하면 될듯
        {       
            StopLoopCheck()
            SafeRestoreMana() ; 마나 부족시 공증
            Loop, 1 ; 자힐 + 4방향 마비&저주 -> 마비 진행 일단 주석처리
                { 
                StopLoopCheck()         
                SelfHealAndChum(4)
                CustomSleep(50)         
                ;if (Mod(FourWayMabi, 2) == 1) ;홀수 일 때만 마비 진행.
                    ;{  
                    ;FourWayCurseAndParalysis() ;4방향 마비
                    ;}
                CustomSleep(100)
            }          
            ;원래 SafeRestoreMana()를 이자리처럼 OO첨 시작전에 넣었었는데 그냥 루프 안으로 넣어줬다
            Loop,2 ;중독첨
                {
                    StopLoopCheck()
                    SpreadPoisonAndChum(20) ;중독첨 돌리기
                    CustomSleep(30)
                    SafeRestoreMana()    
                }
            Loop,1 ;저주첨 
                {
                    StopLoopCheck()
                    SpreadCurseAndChum(20) ; 저주첨 돌리기
                    CustomSleep(30)
                    SafeRestoreMana()    
            }
            Loop,1 ; 자힐첨
                {            
                    StopLoopCheck()
                    SelfHealAndChum(20) 
                    CustomSleep(30)
                    SafeRestoreMana()
            }
            Loop, 1 ; 공증 (짝수마다 하려고 했는데 마나 부족해서 그냥 매번 하다가 마비 홀수만 해서 공증도 홀수만 맞춤)
            ;공증 실패하면 마나 부족 이슈
            ;원래는 자힐첨 앞에서 홀수마다 한 번씩 공증했는데 자힐첨 뒤에 짝수마다(첫 번째에도 공증 시도)로 잠시 바꿔봄
                {
                if (Mod(ManaRefresh, 2) == 0)
                    {            
                        SendInput, {Esc}
                        CustomSleep(20)  
                        StopLoopCheck()
                        CustomSleep(30)
                        SendInput, 3 ; 공증(실패해도 됨)
                        CustomSleep(30)               
                    }
                ManaRefresh++     
                }

            FourWayMabi++
            CustomSleep(100) ; 매크로 체크방지 1초 -> 걍 100으로
            } ; (중독첨2 저주첨1 자힐첨1) x4 반복 루프 종료


            Loop, 1 ; (공증 + 중독&첨 x4  + 자힐첨x2) 1번
                {
                StopLoopCheck()
                CustomSleep(30)
                SafeRestoreMana()
                SelfHealAndChum(4) ; 자힐첨 3틱
                CustomSleep(50)

                Loop,4 ; 중독첨. 풀피상태여서 자힐첨 2번보다 중독첨2 + 자힐첨1 이렇게 가자.
                {
                    StopLoopCheck()
                    SpreadPoisonAndChum(20) 
                    CustomSleep(30)
                    SafeRestoreMana()
                }

                Loop,2 ; 셀프힐 + 첨 횟수 조정(일단 1) -> 딸피 마무리
                    {            
                    StopLoopCheck()
                    SelfHealAndChum(20) 
                    CustomSleep(30)
                    SafeRestoreMana()
                    }
                }
        }
    CustomSleep(30)
    StopLoop := true
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


F6:: ;이미지 서칭 테스트
HalfHealthImgPath := A_ScriptDir . "\img\joosool\halfhealth.png"

ImageSearch, FoundX2, FoundY2, 1300, 700, A_ScreenWidth, A_ScreenHeight, %HalfHealthImgPath% ;체력 거의 절반쯤 이미지
ImgResult2 := ErrorLevel ; 이미지가 검색되면 체력이 절반이 안 되는 것 -> 공력증강 상용시 위험
if(ImgResult2 = 0) {
    SendInput, {Blind}0
} else if(ImgResult2 = 1) {
    SendInput, {Blind}1
} else {
    SendInput, 2
}
return



SafeRestoreMana() { ; 체력 절반쯤 이상이면 공력증강(안전한 공력증강)
      ; 이미지 경로 설정 (실행한 스크립트의 상대경로)
      ManaImgPath := A_ScriptDir . "\img\joosool\mana.png"
      HalfHealthImgPath := A_ScriptDir . "\img\joosool\halfhealth.png"

    ; 화면의 특정 영역에서 이미지 검색    
    ; ImageSearch, OutputX, OutputY, X1, Y1, X2, Y2, ImageFile(변수사용은 %%로 감싸서 %ImagePath%)
    ; 이미지를 검색하고 나서 결과는 ErrorLevel에 저장되는데 이를 다른 이름의 변수에 넣어서 활용해도 된다.( ImageResult1 := ErrorLevel 이런식으로)
    ; ErrorLevel = 0은 이미지가 발견o, 1은 발견x, 2는 이미지 경로를 찾을 수 없음
    ; 만약 이미지 일치정도를 조절하려면
    ; ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *100 %ImagePath% 
    ;-> 이미지파일 앞에 *숫자는 일치허용범위 조절 가능 0~255까지 가능하며 기본0(완전 동일한 것을 검색) 높을 수록 유사도가 낮아도 매칭됨
    ; 0~150정도로 ㄱㄱ
    ; *숫자 말고 *TransColor: 특정 색상을 무시 ( 예: *Trans0xFFFFFF  -> 흰색 배경 무시)
    ImageSearch, FoundX1, FoundY1, 1400, 800, A_ScreenWidth, A_ScreenHeight, %ManaImgPath% ; 마나존재 이미지
    ImgResult1 := ErrorLevel  ;이미지가 검색되면 마나가 존재하는 것이고 찾지 못 하면 거의 바닥이라 공력증강 필요
    CustomSleep(10)
    ImageSearch, FoundX2, FoundY2, 1300, 700, A_ScreenWidth, A_ScreenHeight, %HalfHealthImgPath% ;체력 거의 절반쯤 이미지
    ImgResult2 := ErrorLevel ; 이미지가 검색되면 체력이 절반이 안 되는 것 -> 공력증강 상용시 위험


    if (ImgResult1 = 1 && ImgResult2 = 1) ;마나 거의 없고 피 절반쯤 이상일 때
                        ; -> 내 이미지는 파란색 마나가 남아 있는 것으로 발견되지 않을 경우, 즉 1일 경우에 공력증강 사용하자
        {            
            ; 공력증강
            SendInput, {3}
            CustomSleep(30)
        }
    return
}


RestoreMana() {
    ManaImgPath := A_ScriptDir . "\img\joosool\mana.png"
    ImageSearch, FoundX1, FoundY1, 1400, 800, A_ScreenWidth, A_ScreenHeight, %ManaImgPath% ; 마나존재 이미지
    ImgResult1 := ErrorLevel  ;이미지가 검색되면 마나가 존재하는 것이고 찾지 못 하면 거의 바닥이라 공력증강 필요
    if (ImgResult1 = 1) { ;마나 거의 없을 때(체력 상관x)
    ;   -> 내 이미지는 파란색 마나가 남아 있는 것으로 발견되지 않을 경우, 즉 1일 경우에 공력증강 사용
        
        ; 공력증강
        SendInput, {3}
        CustomSleep(30)
    }
    return
}






#If
    

