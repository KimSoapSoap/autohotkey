;저주, 중독, 마비 돌리는 돌리기 마법횟수 변수 (단일 사용 OO돌리기들 시전횟수 통일할 때 사용)
;기본 카운트 20, 신극지방 갈 때는 깔끔하게 6정도
global magicCount := 12
;참고로 북방, 신극지방 갈 때 말 죽이면 안 되니까 자힐첨첨,자힐 주석처리도 바꿔줘야 한다.(#IfWinActive 아래에 있음)
;-> 입력대기 헬파쏘고 자힐하므로 굳이 자힐첨첨 자힐 바꿀 필요 없다.

;토글
; -> 승마사냥 : alt + r    기본 false (isRidingHunt를 변경)   
; -> 숲지대 : alt + f    기본 false (isAtForest 를 변경) -> 참고로 입력대기 헬파시 마비가 절망으로 변함
; -> 무사방 : alt + w 기본 false(isAtMoosa를 변경) -> 마비가 안 걸리지만 직접 삼매각을 만들어야 돼서 마비x 절망x인 곳에서 사용
; -> 입력대기 헬파,삼매후 자힐(원샷헬파에도 적용) : alt + s  기본 사용 (inputWaitingSelfHeal 을 변경)
; -> 헬파 자동사냥인 HellFireHunt() 사용시 헬파쏘고 마비 돌리기  alt + c : 기본 사용 (ParalysisAfterAutoHellFire 을 변경). 원샷헬파는 x

;참고로 숲지대는 마비가 안 걸려서 마비대신 절망을 써야되는 곳을 통칭함
;무사방은 마비가 안 걸리지만 절망을 개별적으로 넣지 않고 수동으로 넣는 곳을 통칭(유인하면서 무빙 헬파는 쓰지만 절망은 수동으로)
;그리고 숲지대도 무사방도 아니면 마비를 돌리는 것으로 한다.(입력대기 헬파, HellFireForAuto() 에서 )



;삼매 진형 만들어놨는데 마비가 25초 지속이므로 삼매쿨보다 짧게 남았다면 그 자리에 굳히기로 절망을 걸어두면 된다.
;지금 산적 가기 전 d가 중독 돌리기인데 산적 이후 삼매각 잡을 때 q로 마비 걸거나 w로 절망 걸어놓는데
;d키를 일단 산적 기준으로 마비시킨 몹에 절망, 저주 거는 용도로 저주 + 절망 거는 걸로 하자. 중독 돌리는 건 g키로 하든가(자동사냥은 b로)

; 자동사냥중에 입력대기 s 누르면 첨첨 버튼 5번 0번 누르게 해놨는데 첨첨 단축키 뺄 때 이거 수정해주자
; -> 추가해야되는데 안 되네? 일단 보류


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

;TabTab창 색깔 찾는 TabTabChase()나 CheckTabTabOn()은 아이템창 왼쪽, 채팅창 위쪽으로 좌표를 제한해야 한다.
;템은 혹시 몰라서고 채팅창 외치기 색깔이 tabtab으로 인식이 된다.
;일단 pc와 노트북 공통으로 1430, 830 범위로 해놨다.(현재 환경에선 공통적용 가능) 혹시 오작동 하면 pc나 노트북 좌표는 따로 설정해주자

global imgFolder := A_ScriptDir . "\img\joosool\"
;global imgFolder : = A_ScriptDir . "\img\joosool\notebook\"
;pc는 "\img\joosool\""   이고   notebook은   "\img\joosool\notebook\"
;A_ScriptDir은 현재 스크립트의 폴더경로이고 점(.)은 오토핫키에서 문자열을 더하는(+) 부호이다. 시작부분을 그냥 가져왔으므로 A_ScriptDir는 맨 앞에 붙여놓고 . 으로 이어 놓으면 된다.


;StopLoopCheck로 break면 끝날 때 초기화 해주면 되는데 StopLoopExit()라는 함수는 Exit 이므로 중간에 Exit시킨다면 끝에 반드시 초기화 시킬 건 해줘야됨(isHuntingOn같은)

;PC와 NoteBook의 차이는 보무가 End(PC) vs NumpadEnd(Notebook) 정도의 차이이다.
;PC에서 복붙해서 보무만 바꾸면 노트북이 된다, Reload도 다르다.

;컴파일하지 않고 관리자모드로 실행한다.
;기본적인 저주,마비, 중독 혹은 +첨 스킬들은 반복회수 매개변수 count를 전달해줘야 하는데 처음 설계할 때 회수 20으로 했어서
;조정하는 게 아니면 20을 전달해준다

;셀프힐은 4번 해줘야 힐 3틱이 되더라(후딜 50기준)
;꼬임 방지 esc 뒤에 sleep은 최소 30으로 해준다.

;기존 
; F2 Home(타겟박스 있을 때 적용) + 동동주(타겟박스 없을 때만 마심)  F3 말타기 + StopLoop(루프 중단변수)  ->일반 키보드에선 F1, F2키
; 참고로 노트북과 한 손 키보드에는 F1이 숫자1키 위에 있어서 F2,F3이고 일반 키보드에서는 F1이 숫자2키 위에 있어서 F1, F2로 해주자
; 원래 F3이 자신선택 + 중단이었는데 이제 자신선택은 F2(동동주 마시기 겸용)F3은 말타기 혹은 중단으로.

;` 탭탭자힐첨,  1 자힐 3틱(탭탭x)    2 헬파 3 공증 4저주 5극진첨
; 6 마비(q) 7중독(w) 8 활력 (e) 9혼돈(r)  0 진첨    t 극진 , shift + e 활력 돌리기
;a저주 돌리기,  s 중독첨,   d (솔플대비 절망 + 저주 예정 -> 마비 건 몹에 사용할.),  f 4방향 마비 , shift + f 4방향 마비 저주, 
;g중독 돌리기 c 마비 돌리기, v 4방향 활력+마비(마비 갱신) b헬파자동사냥 shift + b첨첨자동사냥, ctrl + shift+b 중독자동사냥 alt+b 중독쩔
;insert 셀프보무,  End : 몹한테 자동 헬파 한 방만.   Rshift  헬파자동사냥 (투컴으로 한손컨 할 때)  RCtrl 말타기 + StopLoop(한손컨시 중단)

;아니면 d는 q,w,e,r(r키는 애매) 마비 절망 활력을 편하게 쓰기 위해 Enter키로 써도 될 듯 (절망 걸고 저주는 한 번 싹 돌리면 되니까)
;그러면 왼손 검지에 부담 가려나? 일단 입력대기 헬파에 자동저주 있으니까 전체 저주 안 돌리고 일단 d를 절망 + 저주로 해보자

; -> 중독첨도 잘 안 쓰기 때문에 shift + d로 빼는 것도 괜찮을 듯. 헬파 써야되므로 중독이나 저주 따로 돌리고 자힐첨으로 주로 피채움
; -> v 중독자동사냥도 이제 거의 안 쓰는 편. 첨첨자동사냥에 shift 붙여서 뺴는 것도 괜찮겠다. 중독 쩔도 바꾸던가 하자


;현사되고 삼매쓸 때 삼매각 만들기 위해 지속이 긴 절망도 제법 쓰는 편이고 중독을 단독으로 쓰는 일은 잘 없어서
;f마비 g중독 h활력 i혼돈 이었는데 혼돈은 따로 함수로 사용하고 g절망, i중독.
;키보드 q마비 w절망 e활력 r혼돈 이므로 중독은 단독 잘 안 쓰기 때문에 일단 shift + q에 놔둠

;나중에 첨첨도 거의 안 쓰게 되는 시점에 첨 하나는 빼고 혼돈을 넣던가 해주자(원활한 혼돈 사용을 위함)

; s 입력대기 -> 입력대기중  d  :저주+헬파(말에서 내리고 쏘고 말타기) 공증 자힐. 첨첨사냥이나 중독사냥중 입력대기 + d는 단순 헬파만
; 입력대기중 다가오는 적에게 home + 헬파 시전하려고 F3을 누르니까 StopLoop가 있어서 입력대기가 제대로 작동 안 한다.
; 이때 들었던 생각이 동동주는 타겟박스 없을 때만 마실 수 있는데 F2 동동주에도 home을 넣어줄까. 아니면 입력대기일 때만 home을 쓸까
; 결론은 동동주 마시기 앞에 home 넣어주면 될 것 같다. -> F3은 그냥 중단만 해주는 걸로..? 일단 F3에도 home 유지
; 흉가에서 첨첨사냥시 마나 부족할 때 4방향 마비 돌리면서 동종주 마시면서 마비걸던 건 옛적이므로
; 만약에 저렙키울 때 이런 긴박할 때 마비 걸면서 동동주 마시는 게 필요하다면 home키가 마비 대상을 바꾸는 것이 문제이므로
; 마비쓰고 방향키로 움직인 상태에서는 home 안 써지게 해주면 될 것이다. 즉 타겟박스가 본인 캐릭에 왔을 때 먹게끔.


;일단 s키에 헬파 입력대기를 만들어서 사용해보자.
;s 누르고 입력대기 할 때 원하는 키 누르면 저주 + 헬파 + 공증 + 자힐 몇번 쓰는 걸로
;취소키 & 타임아웃도 넣어서 취소키 누르거나 일정시간 안 쏘면 취소되게
;말타고 다니는 상황이라 가정하고 헬파 쏠 때 말에서 내리고 쏘고 다시 탐

;첨첨 사냥이나 중독사냥시에는 입력대기 후 헬파를 쏘면 단순 헬파만 쏘기



;s 입력대기 후 d 헬파, a 삼매진화 c 취소(esc도 취소)  이렇게 만들었다.

;다음 추가할 것은 q마비 w절망 e활력 r혼돈, f 네방향 마비 이렇게 있는데
;삼매 진형 만들 때 좀 더 편하게 할 수 있는 걸 추가해보자.
;s 입력대기 후 f 네방향 활력 재마비 이런 거 괜찮을 듯

;v키가 비어서 편하게 쓰려고 4방향 활력 후 마비 넣어줬다.







global StopLoop := false
;루프 중단을 위한 변수. 기본 false
;동작 중(예를 들면 루프) 다른 핫키를 쓰면 다른 핫키 동작 후 다시 기존 핫키로 돌아가는 Stack구조이므로
;핫키를 실행할 땐 변수를 false로, 끝날 땐 true로 해주고 루프구문(보통 루프 돌아가는 중에 다른 핫키 쓰기 때문) 내부의 시작에
;이 변수가 true일 때 break를 걸어준다. 
;그럼 이때 루프 시작에서 break되고 루프를 끝내고 나머지 코드를 실행한다. 나머지 코드는 esc 처리해주는 것이기 때문에 굳

;각종 스킬구조를 함수로 바꿨고 단축키는 이 함수를 실행하는 것으로 바꿨는데
;StopLoop를 true로 해주는 건 함수 끝에 하면 종합 자동이 복잡하게 돼서 함수 실행하는 핫키에 넣어준다.(실행했을 때 이전 루프끝내려면)

; 즉 루프 시작부분에는 StopLoop가 true면 break
; 함수 시작할 땐 StopLoop := false(루프있다면 -> 루프 내부에 if (StopLoop) 조건이 있을 때 )
; 핫키에서는 동작 후 이전 핫키 루프를 중단하려면 끝날 땐 StopLoop := true
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
global isHuntingOn := false

;마나 0인지 확인
;원래 이미지 검색 한 번에 하나의 변수만 바꾸줬는데 마나 관련해서는 마나가 조금이라도 존재하는(풀마나 혹은 마나존재) 것이 확인되면 isManaZero는 false로 초기화를 해주도록 하자
global isManaZero := false

;죽었는지 확인
global isDead := false


;승마사냥 토글용 변수
;true면 입력대기 스킬 중 삼매진화, 헬파이어 사용시 스킬 사용 전 r키를 눌러서 말에서 내리게 해준다.
global isRidingHunt := false



;숲지대 사냥 토글용 변수.  원래 true false로 수동으로 바꿔줬지만 토글 함수 추가
;true로 바꿔주면 g:: 핫키에 ForestPoisonChumHunt() 실행. false면 그냥 흉가용 자동사냥 PoisonChumHunt()
;참고로 입력대기 헬파시 마비가 절망으로 변함
global isAtForest := false 


;무사방에서 마비는 안 걸리지만 몹 드리블 하면서 헬파 쏘는 경우가 있다.
;이때 마비 안 걸린다고 절망을 걸어버리면 삼매각이 안 나온다. 부활 때문에 삼매각을 직접 만들어야 되기 때문에
;오토헬파나 헬파원샷, 입력대기 헬파에 절망을 걸면 안되기 때문에 따로 무사방인지 여부 변수를 만들어서
;숲지대(마비 안 걸리는 곳 통칭 -> 마비대신 절망)
;무사방(마비는 안 걸리지만 절망을 날리면 안 되는 곳 통칭 -> 마비, 절망 모두 안 씀)
;그리고 나머지(마비)
;이렇게경우에 따라서 마비, 절망, 혹은 둘다x 경우를 나누기 위함이다.
global isAtMoosa := false


;입력대기 헬파이어, 삼매진화 사용 후 셀프힐 사용여부. 기본 사용이다.
global inputWaitingSelfHeal := true



;오토 헬파 이후 마비 돌리기 사용여부. 기본 사용이다.(산적굴 막굴같은 한 방 안 나오는 곳에서 꺼주자)
global ParalysisAfterAutoHellFire := true


;원샷헬파이어 시작을 알리는변수와 HellFireForAuto() 시전 카운트
;HellFireForAuto() 에서 헬파이어를 시전하면 카운트가 1 올라가고 OneShotHellFire() 에서는 카운트가 1이면 종료(헬파 한 방만 날리는 함수이므로)
;즉 본인이나 다른 유저가 타겟잡혔을 땐 헬파이어를 시전하지 않고 break되므로 카운팅이 올라가지 않는다.
;헬파 자동사냥인 HellFireHunt() 에서도HellFireForAuto()를 호출해서 헬파를 시전하므로
;HellFireForAutoCount만으로는 헬파 자동사냥시 온전하게 마비 돌리는 옵션을 넣어줄 수 없다.
;그래서 원샷 헬파이어 시작 변수를 추가해서 HellFireForAuto()에서 카운트와 시작변수를 함께 조건으로 걸어서 원샷헬파이어 사용시 마비 사용유무 전에 return

global isOneShotHellFireOn := false
global HellFireForAutoCount := 0


; HellFireHunt()의 시작을 알리는 변수
; 헬파 자동사냥인 HellFireHunt()를 사용할 때 헬파시전은 HellFireForAuto()를 호출하는데 이때 헬파 시전 이후 셀프힐 사용여부 결정.
; 한 방만 그냥 바로 날리는 OneShotHellFire()는 입력대기 헬파이어 시전 이후 셀프힐 사용여부를 결정하는
; inputWaitingSelfHeal에 따라 셀프힐 사용옵션을 넣어주기로 했고 이때 HellFireForAuto()를 루프 돌린 헬파 자동사냥(헬파헌트)을 할 때는
; 셀프힐 빼줄까 싶어서 변수를 추가했다. 원샷헬파나 헬파자동사냥(헬파이어헌트)는 입력대기 헬파에서 헬파를 가져와서 변형한 HellFireForAuto()를 사용하는데
; 여기서 헬파 시전 이후 inputWaitingSelfHeal의 true false에 따라 자힐을 하게 해주는데 헬파자동사냥시 isHellFireHuntOn변수를 넣어서
; true면 자힐 안 하도록 설정
global isHellFireHuntON := false



;입력대기에 타이머 추가 후 이 변수를 확인 후 true면 {Esc}를 입력해서 취소하게 만들기 위한 변수
global CancelInput := false






;따라가기에 사용하는 변수
global TabTabX := 0
global TabTabY := 0




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


;StopLoop를 가지고 break가 아닌 Exit로 마무리 안 하고 즉시 종료기 때문에
;시작히 false를 해주는 함수들은 자체 초기화를 해주기 때문에 상관없지만
;자동사냥, 헬파원샷, 헬파자동사냥 등 함수 사용시 true로 해주는 변수들은 false로 초기화를 해준다.
StopLoopCheck() {    
    if (StopLoop)
        {            
            SendInput, {Esc}
            CustomSleep(20)   
            CancelInput := true ; 입력대기 취소
            isHuntingOn := false ;Exit라서 초기화 못 시켜주는 건 여기서 초기화
            isHellFireHuntON := false
            isOneShotHellFireOn := false
            Exit  
        }
    return
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

;승마사냥 토글 -> 입력지연시 스킬 시전할 때 말타기+후딜 사용on/off 이다. (후딜 150이므로 말 안 타고 다닐 땐 끄자)
!r::
ToggleRidingHunt()
return

;숲지대 사냥 토글 -> 중독첨첨 사냥시 헬파시전하면 공증없이 그냥 종료
!f::
ToggleForestHunt()
return

;입력대기 헬파, 삼매 시전시 자힐 사용여부
;원샷헬파이어와 헬파이어헌트에도 적용할지 고민(이 둘은 HellFireForAuto()라는 입력대기에서 헬파만 가져와서 만든 함수를 사용)
;일단 원샷헬파는 자주 쓰므로 솔플시 필요하다고 봐서 넣었고 오토 헬파는 원샷헬파를 루프 돌린건데 일단 분리해놨다.
!s::
ToggleInputWaitingSelfHeal()
return


;오토 헬파 사용 이후 마비 돌리기 사용여부
!c::
ToggleParalysisAfterAutoHellFire()
return


;무사방 사냥. 마비가 안 걸리지만 절망을 쓰지 않는 곳 -> 수동으로 절망 사용
!w::
ToggleMoosaHunt()
return


;저주 마비 중독 등 얼마나 돌릴지 신극지방 등 사냥터마다 단독 사용시 카운트를 다르게 해줘야 되므로 최상단에 배치
;몬스터들 제법 몰린 곳에서도 사용할 수 있게끔 기본 카운트 20, 신극지방 갈 때는 깔끔하게 6정도
;보통 통일 시키므로 magicCount라는 변수를 만들어서 사용. 필요하면 개별로



`:: ; (자힐 3틱x4 + 첨 ) 4~5회 ;북방파망 or 극지방 사냥시 셀프힐첨대신 셀프탭탭힐 사용(주석 이용)
CancelInput :=true ;입력대기 취소
SelfHealAndChum(20)
return


a:: ;저주만 돌리기
if (IsWaiting) {
    ; 대기 상태일 때 동작. 이때 a를 누르면 삼매진화 로직 사용.Send를 사용해야됨
    Send, {a} ; 대기상태일 때 삼매진화 로직
    return
}
SpreadCurse(magicCount)
StopLoop := true
return

+a:: ;저주 돌리기 + 첨
CustomSleep(190) ;쉬프트키 조합 눌렀다가 뗄 때 시간
SpreadCurseAndChum(magicCount)
StopLoop := true
return




d::  ;절망 + 저주.
;바로 절망과 저주를 거는 것이므로 타겟팅 애매할 땐 다른 타겟스킬(q가 손이 편할듯)써서 타겟 확인 후 d키 누르면 된다(esc 넣어둠)

;입력대기 헬파 시전 동작키로 사용할 것이므로 if로 조건 걸어줌 -> 입력대기중일 때 헬파 동작 수행.입력대기가 아닐 때는 원래 d키 동작 수행
if (IsWaiting) {
    ; 대기 상태일 때 동작. 이때 d를 누르면 헬파이어 로직 사용.  Send를 사용
    Send, {d}
    return
}
SendInput, {Esc} ;타겟확인시 끄고나서 절망 저주 시전을 위한 ESC키
CustomSleep(30)
SendInput, {7} ; 절망
CustomSleep(30)
SendInput, {Enter}
CustomSleep(30)
SendInput, {Esc}
CustomSleep(30)
SendInput, {4} ;저주
CustomSleep(30)
SendInput, {Enter}
CustomSleep(30)
SendInput, {Esc}
CustomSleep(30)
;절망 + 저주
StopLoop := true
return



;좌클릭도 입력대기시 일단 헬파이어로 만들어 봄
~LButton::
;입력대기 키로 사용할 것이므로 if로 조건 걸어줌 -> 입력대기중일 때는 또다른 동작 수행. 입력대기가 아닐 때는 원래 d키 동작 수행
if (IsWaiting) {
    ; 대기 상태일 때 동작. 이때 d를 누르면 Enter 입력이 되게 했다. SendInput 말고 Send를 사용해야됨
    Send, {d}
    return
}
return


;입력대기시 엔터키도 헬파시전으로.
Enter::
if (IsWaiting) {
    ; 대기 상태일 때 동작. 이때 d를 누르면 Enter 입력이 되게 했다. SendInput 말고 Send를 사용해야됨
    Send, {d}
    return
} 
SendInput, {Enter}
return


g::  ;중독만 돌리기.
SpreadPoison(magicCount)
StopLoop := true
return


+g::  ;중독 돌리기 + 첨
CustomSleep(180) ; shift 조합 입력 방지용 딜레이
SpreadPoisonAndChum(magicCount)
StopLoop := true
return




c::  ;마비만 돌리기. 입력대기 상태에서는 취소. 숲지대 모드(마비 안 통하는 곳 통칭.)에서는 절망 돌리기
;입력대기시 동작 -> 취소 동작
if (IsWaiting) {
    ; esc는 안 되므로 안 쓰는 키 p를 써서 이걸 취소로 사용하자.
    Send, {ESC}
    return
}
;입력대기가 아닐 때 숲지대 혹은 무사방이면 마비 대신 절망 돌린다.
if(isAtForest || isAtMoosa) {
    SpreadDespair(magicCount)
    return
}
; 일반적으로 숲지대 혹은 무사방이 아닐 때는 마비 돌리기
SpreadParalysis(magicCount)
return


+c:: ;활력 후 마비 돌리기
CustomSleep(160) ; 쉬프트 조합 방지 후딜 (쉬프트 떼는 시간)
SpreadVitalityAndParalysis(magicCount)
return





^s:: ; 상태창
CustomSleep(190) ; ctrl 조합키 떼는 딜레이
SendInput, {Blind}s
return


;현사 되고는 삼매각 만들기 위해 빠른 마비를 쓰려고 저주후 마비와 자리 교체해서 f가 그냥 마비, +f가 저주후 마비
;f는 4방향 긴급하게 마비 돌리는 것이기 때문에 입력대기 중일 때도 무시하고 사용 가능
;아니면 입력대기 중에 f 조합을 4방위 마비로 만들어도 괜찮긴 하겠다.
f:: ;캐릭 4방위 마비만 돌리기.
CancelInput :=true
FourWayParalysis()
return


+f:: ;캐릭 4방위 저주 후 마비
CustomSleep(170) ; shift 떼는 딜레이
FourWayCurseAndParalysis()
return





^f:: ;캐릭 4방위 활력 돌리기
CustomSleep(170) ; ctrl + 키조합 떼는 딜레이
FourWayVitality()
return



v::  ;캐릭 4방위 활력후 마비 돌리기. 마비시간 애매할 때 생존보장을 위함
FourWayVitalityAndParalysis()
return


b:: ; 자동 헬파 사냥 -> 입력대기에서 헬파 가져와서 사용
HellFireHunt()
return

;자동 헬파이어 사냥

    

+b:: ;중독첨첨 사냥 종합합
; 보무 걸고 (4방향 마비저주, 중독첨2, 저주첨2)x1   (공증, 중독첨2+자힐첨1)x4
;여기 중독 저주 등 x1 회수는 20이다.
if(isAtForest) {
    ForestPoisonChumHunt()
} else {
    PoisonChumHunt()
}
StopLoop := true
return




!b:: ;쩔용 중독 저주 마비 돌리기
PoisonJJul()
StopLoop := true
return



; 중독사냥 종합(마지막에 첨첨 마무리). 
;보무, (4방향 마비저주주 + 중독 돌리기 4번) x4 이후 중독첨2 저주첨2 자힐첨2
;이것도 맨 처음 한 번은 중독2에 저주2 어떨까 싶음
+^b::
CustomSleep(190) ; 쉬프트 + g 누르고 키 떼는 딜레이
PoisonHunt()
StopLoop := true
return



;셀프보무 임시로 insert로 보내고 End는 헬파 한 방 딸깍 날리는 걸로.
End::
OneShotHellFire()
return

Insert:: ;  셀프보무
SelfBoMu()
;StopLoop := true
return




~x:: ;줍기
getget() ;StopLoop 하면 안 되는 게 동작중에 뭘 주울 수도 있기 때문
return



RShift::  ;한손컨시 자동헬파. 일단 명인 투컴 사냥할 때라서 쓰는데 떱헬가고 할 때는 채팅하다 삼매각 날릴 수 있으니 뺀다.
;그때는 투컴쓸 때 자리 잡으면 b 눌러서 자동 고
HellFireHunt()
return



;우측 컨트롤(ctrl) 키(키 히스토리로)
SC11D:: ;한 손 드리블할 때. 우측 ctrl로 뭘 쓸까? 도적은 비영승보인데 주술은 일단 투컴시 필요할까봐 말타기만 넣음
SendInput, {Blind}r 
;CustomSleep(20)
;SendInput, {Blind}1
StopLoop := true  ;한손컨 할 때 F3으로 정지대신 사용할 용도
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


F2:: ; 자신선택 & 동동주 마시기용, a에 동동주  (타겟박스 있을 때는 자신선택이고 동동주 안 마셔지고, 타겟박스 없을 땐 동동주 마시기)
SendInput, {Home}
CustomSleep(30)
DrinkDongDongJu()
return




F3:: ;말타기 And StopLoop  (중단이니까 입력대기 취소도 가능하게 해준다.)
CancelInput :=true  ;입력대기 취소
RideAndStopLoop()
return



F4:: ;지도
OpenMap()
return

;맨 아래에 F6에 이미지 서치 테스트 핫키 있음


1:: ; 자힐 3틱
SelfHeal(4)
StopLoop := true
return


 5:: ; 극진첨 + 진첨이었는데 현사되고 삼매진화로(마법 A키). 첨첨은 자힐첨첨으로 쓰자
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
w::7 ;절망 
e::8 ;활력


r:: ;혼돈 ;주로 길 뚫는데 사용하므로 자동 home 누르는 걸로 하고 필요시 home 제거
Chaos()
;CustomSleep(30) 
;SendInput, {Home} ;삼매 진형 만들 때 몇칸 떨어진 몹한테 걸 때 홈 안 쓰는 게 편하더라
return

t:: ; 극진화열참주, 종합사냥중 어그로 끌 때 사용하기 위해 StopLoop 뺐다
UltimateBlazingSlash()
return





+q:: ;중독. 
CustomSleep(180) ;쉬프트 누르고 뗄 때 후딜(짧으면 함수 실행될 때 shift 조합으로 입력돼서 오작동)
SendInput, {9}
return



+w::  ;절망 돌리기 
CustomSleep(180)  ;쉬프트 누르고 뗄 때 후딜(짧으면 함수 실행될 때 shift 조합으로 입력돼서 오작동)
SpreadDespair(magicCount)
StopLoop := true  
return


+e::  ;활력 돌리기
CustomSleep(180) ;쉬프트 누르고 뗄 때 후딜(짧으면 함수 실행될 때 shift 조합으로 입력돼서 오작동)
SpreadVitality(magicCount)
StopLoop := true
return






;셀프타겟은 이제 F2에서 동동주 마시기 or 셀프타겟(어차피 타겟창 있을 땐 동동주 안 마셔지고 타겟창 없을 땐 동동주 마심) 하고
;F3은 말타기 or StopLoop로 하자 (StopLoop := true 이면 중단, 급한 건 StopLoopCheck()에서 강제종료 시키는 메커니즘)
RideAndStopLoop() {    
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

;입력대기 스킬에서 승마사냥이면 타기/내리기 입력, 아니면 패스 ( 후딜이 150쯤 필요하기 때문이다)
ToggleRidingHunt() {
    if (isRidingHunt) {
        ; 말타기 사냥 끄기                
        isRidingHunt := false
        MsgBox, 승마사냥 OFF
    } else {
        ; 말타고 사냥 켜기
        isRidingHunt := true
        MsgBox, 승마사냥 ON
    }
    return
}


; 숲지대 사냥인지 아닌지 설정(마비가 안 걸리는 곳이므로 마비대신 절망을 사용하는 곳)
; 현재 g:: 핫키(자동 첨첨 사냥)에서 true면 ForestPoisonChumHunt(), false면 그냥 PoisonChumHunt() 함수 실행
ToggleForestHunt() {
    if (isAtForest) {
        ; 숲지대 사냥 끄기
        isAtForest := false
        MsgBox, 숲지대 사냥 OFF
    } else {
        ; 숲지대 사냥 켜기
        isAtForest := true
        MsgBox, 숲지대 사냥 ON
    }
    return
}

; 무사방 사냥인지 아닌지 설정.(마비가 안 걸리지만 절망도 사용하지 않을 곳 -> 수동으로 절망 사용할 곳)
ToggleMoosaHunt() {
    if (isAtMoosa) {
        ; 숲지대 사냥 끄기
        isAtMoosa := false
        MsgBox, 무사방 사냥 OFF
    } else {
        ; 숲지대 사냥 켜기
        isAtMoosa := true
        MsgBox, 무사방 사냥 ON
    }
    return
}

;입력대기 헬파, 삼매 시전 후 자힐 사용여부
ToggleInputWaitingSelfHeal() {
    if (inputWaitingSelfHeal) {
        ; 입력대기 헬파, 삼매 사용후 자힐 끄기
        inputWaitingSelfHeal := false
        MsgBox, 입력대기 헬파, 삼매 사용후 자힐OFF
    } else {
         ; 입력대기 헬파, 삼매 사용후 자힐 켜기
         inputWaitingSelfHeal := true
         MsgBox, 입력대기 헬파, 삼매 사용후 자힐ON
    }
    return
}

;오토헬파 사용시 헬파시전 후 마비 돌리기 여부
ToggleParalysisAfterAutoHellFire() {
    if (ParalysisAfterAutoHellFire) {
        ; 오토 헬파 시전 이후 마비 돌리기 끄기
        ParalysisAfterAutoHellFire := false
        MsgBox, 오토 헬파 시전 이후 마비 돌리기OFF
    } else {
         ; 오토 헬파 시전 이후 마비 돌리기 끄기
         ParalysisAfterAutoHellFire := true
         MsgBox, 오토 헬파 시전 이후 마비 돌리기ON
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


 ;혼돈(원래 혼돈이 i고 절망이 q였는데 절망을 i에 넣고 혼돈을 q로). 빨리 시전을 위해 20으로 해봄. 씹히면 30으로 롤백()
 Chaos() {
    SendInput, {Esc}
    CustomSleep(20)
    SendInput, {shift down}
    CustomSleep(20)
    SendInput, { z }
    CustomSleep(20)
    SendInput, {shift up}
    CustomSleep(20)
    SendInput, {q} ;  q -> 혼돈
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



;shift 조합은 처음에 esc 누르고 CustomSleep(160) ~ 180정도 해주자. shift 누르고 떼는 후딜을 줘야됨




; 4방향 스킬은 전후좌우 4방향 시전이기 때문에 몇개 시전을 안 해서 후딜을 30 30 으로 해도 되지만
;Spread처럼 뿌리는 것은 엔터, esc의 후딜을 60, 30 으로 해서 틱당 시전횟수를 너무 벗어나지 않게 해준다.(씹힘 방지)
;테스트 해보니까 Spread처럼 뿌리는 것도 스킬버튼과 방향키 누를 때 후딜이 있어서 엔터 esc를 30 30 해도 되는 것 같다.(안전빵 40 30)
;일단 활력 마비같은 거 말고 저주 돌리기 마비돌리기 이런 건 40, 30 해보고 씹히면 60, 30으로 복구


;근데 확실히 활력 후 마비같이 스킬 쓰고 뒤에 방향키 없이 단순 스킬 엔터로 이어서 쓰는 건 
;30 30 하면 활력 마비 활력 마비가 아니라 중간에 활력 활력 이런식으로 마비가 씹히는 것이 확인됐다. 50 30해도 마찬가지. 60 30이 안전빵
;그럼 활력 마비에서 활력은 60 30하고 뒤에 마비는 30 30 해도 되려나? -> 마비마비가 생기더라. 60 30 ㄱㄱ


;절망 돌리기
SpreadDespair(count) {
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
        SendInput, 7
        CustomSleep(30)
        SendInput, { left }
        CustomSleep(30)
        SendInput, { enter } ;원래 엔터후 후딜90인데 꼬임 방지를 위해 esc 넣고 후딜 60, 30으로 나눠줌
        CustomSleep(40)
        SendInput, {esc}
        CustomSleep(30)
    }
    SendInput, {Esc}
    CustomSleep(20)
    return
}



;마비 돌리기
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
        CustomSleep(40)
        SendInput, {esc}
        CustomSleep(30)
    }
    SendInput, {Esc}
    CustomSleep(20)
    return
}


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
        CustomSleep(40)
        SendInput, {esc}
        CustomSleep(30)
    }
    SendInput, {Esc}
    CustomSleep(20)
    return
}


SpreadVitalityAndParalysis(count) {
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
        SendInput, 8 ;활력
        CustomSleep(30)
        SendInput, { left }
        CustomSleep(30)
        SendInput, { enter } ;원래 엔터후 후딜90인데 꼬임 방지를 위해 esc 넣고 후딜 60, 30으로 나눠줌
        CustomSleep(60)
        SendInput, {esc}
        CustomSleep(30)

        SendInput, 6 ;마비
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
        CustomSleep(40)
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
        SendInput, 9 ;중독이 g에서 i로 바뀌면서 7-> 9
        CustomSleep(30)
        SendInput, { left }
        CustomSleep(30)
        SendInput, { enter } ;원래 엔터후 후딜90인데 꼬임 방지를 위해 esc 넣고 후딜 60, 30으로 나눠줌
        CustomSleep(40)
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
        SendInput, 9  ;중독이 g에서 i로 바뀌면서 7-> 9
        CustomSleep(30)
        SendInput, { left }
        CustomSleep(30)
        SendInput, { enter } ;원래 엔터후 후딜90인데 꼬임 방지를 위해 esc 넣고 후딜 60, 30으로 나눠줌
        CustomSleep(40)
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




;저주만 돌리기
SpreadCurse(count) { 
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
        CustomSleep(40)
        SendInput, {esc}
        CustomSleep(30)
    }
    SendInput, {Esc}
    CustomSleep(20)
    return
}


;저주 돌리기 + 첨
SpreadCurseAndChum(count) { 
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
        CustomSleep(40)
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



;4방향 마비같은 경우 원래 마비2번 혹은 3번 걸어서 마비 안 걸리는 거 방지했는데 요즘 100퍼 걸리는 것 같아서 그냥 한 번씩만.


; 4방향 저주
FourWayCurse() { 
    FourWayMagic(4, "Left", 1)
    FourWayMagic(4, "Right", 1)
    FourWayMagic(4, "Up", 1)
    FourWayMagic(4, "Down", 1)   
    SendInput, {Esc}
    CustomSleep(20)
    return
}



;캐릭 4방위 저주 후 마비
FourWayCurseAndParalysis() { 
       ;4저주,  6마비
       FourWayMagic(4, "Left", 1)
       InPlaceMagic(6, 1)
   
       FourWayMagic(4, "Right", 1)
       InPlaceMagic(6, 1)
   
       FourWayMagic(4, "Up", 1)
       InPlaceMagic(6, 1)
   
       FourWayMagic(4, "Down", 1)
       InPlaceMagic(6, 1)
    SendInput, {Esc}
    CustomSleep(20)
    return
}



; 4방향 마비
FourWayParalysis() {  ;마비 100% 된 것 같아서 횟수 2->1로 함
    ;6마비
    FourWayMagic(6, "Left", 1)
    FourWayMagic(6, "Right", 1)
    FourWayMagic(6, "Up", 1)
    FourWayMagic(6, "Down", 1)   
    SendInput, {Esc}
    CustomSleep(20)
    return
}


; 4방향 활력
FourWayVitality() { 
    FourWayMagic(8, "Left", 1)
    FourWayMagic(8, "Right", 1)
    FourWayMagic(8, "Up", 1)
    FourWayMagic(8, "Down", 1)   
    SendInput, {Esc}
    CustomSleep(20)
    return
}


;캐릭 4방위 활력 후 마비. 
FourWayVitalityAndParalysis() {  ;마비 100% 된 것 같아서 횟수 2->1로 함

    ;8활력,  6마비
    FourWayMagic(8, "Left", 1)
    InPlaceMagic(6, 1)

    FourWayMagic(8, "Right", 1)
    InPlaceMagic(6, 1)

    FourWayMagic(8, "Up", 1)
    InPlaceMagic(6, 1)

    FourWayMagic(8, "Down", 1)
    InPlaceMagic(6, 1)
    
    SendInput, {Esc}
    CustomSleep(20)
    return
}







; 4방향 스킬은 전후좌우 4방향 시전이기 때문에 몇개 시전을 안 해서 후딜을 30 30 으로 해도 되지만
;Spread처럼 뿌리는 것은 엔터, esc의 후딜을 60, 30 으로 해서 틱당 시전횟수를 너무 벗어나지 않게 해준다.(씹힘 방지)
;테스트 해보니까 Spread처럼 뿌리는 것도 스킬버튼과 방향키 누를 때 후딜이 있어서 엔터 esc를 30 30 해도 되는 것 같다.(안전빵 40 30)
;일단 활력 마비같은 거 말고 저주 돌리기 마비돌리기 이런 건 40, 30 해보고 씹히면 60, 30으로 복구


;근데 확실히 활력 후 마비같이 스킬 쓰고 뒤에 방향키 없이 단순 스킬 엔터로 이어서 쓰는 건 
;30 30 하면 활력 마비 활력 마비가 아니라 중간에 활력 활력 이런식으로 마비가 씹히는 것이 확인됐다. 50 30해도 마찬가지. 60 30이 안전빵
;그럼 활력 마비에서 활력은 60 30하고 뒤에 마비는 30 30 해도 되려나? -> 마비마비가 생기더라. 60 30 ㄱㄱ


; 4방향 스킬. 키와 방향 적어줘야 됨 (6, "Left" 이런식으로)
;AutoHotkey에서 함수 호출 시 리터럴 문자열은 반드시 따옴표로 감싸야 한다.
FourWayMagic(key, Arrow, Count) {  ;횟수 3에서 2로 내림. 삑 자주나면 다시 3으로
    SendInput, {Esc}
    CustomSleep(10)
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
                CustomSleep(30)
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
    CustomSleep(10) ;20~30인데 후딜 때문에 좀 느려져서 10으로 해봤다. 안 되면 20으로
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
            CustomSleep(30)
            SendInput, {esc}
            CustomSleep(30)
        }
    StopLoopCheck()
}








;중독사냥
PoisonHunt() {
    SendInput, {Esc}
    CustomSleep(30)
    StopLoop := false
    isHuntingOn := true
    Loop,1 ;일단 한 번
        
        {
        StopLoopCheck()   
        SelfBoMu() ; 자신 보무
        CustomSleep(30),
    
        StopLoopCheck()

        Loop , 4  ; 다음 과정 4번 반복 ((자힐x2+ 마비) x1 + 중독 돌리기 4번)
    
        {       
            StopLoopCheck()

            Loop, 1 ; 자힐 + 4방향 마비&저주 
                ;-> 4방향 마비저주 한 번만 해서 중독 애매하게 몇마리리 남은채로 다시 중독 돌리는 이슈
                { 
                selfheal(8) ; 
                StopLoopCheck()          
                CustomSleep(50)                     
                FourWayCurseAndParalysis() ;4방향 마비
                CustomSleep(1500) ;위의 중독몹 몇마리 남은채로 다시 중독 돌리는 거 슬립시간으로 조정시도
                StopLoopCheck()
            }
            
            StopLoopCheck()

            Loop,4 ;중독 돌리는 회수
                {
                SpreadPoison(20) ;중독만 돌리기
                CustomSleep(30)
                StopLoopCheck()
                }
            CustomSleep(1000) ; 중독 좀 돌리고 다시 자힐하기 전 잠시 대기 ;원래 1200이었음
            }
    
        
            StopLoopCheck()
    
            Loop, 1 ; (공증 + 중독첨 x2  + 저주첨x2, 공증) 1번 -> 중독첨2 저주첨2 중독첨1 자힐첨2로 변경경
                {                 
    
    
                Loop,2 ; 중독첨. 
                {
                    SpreadPoisonAndChum(20)
                    CustomSleep(30)
                    StopLoopCheck()
                }

                StopLoopCheck()

                Loop,2 ; 저주첨. 
                    {
                        SpreadCurseAndChum(20)
                        CustomSleep(30)
                        StopLoopCheck()
                    }
                StopLoopCheck()

    
                Loop,1 ; 중독첨. 
                    {
                        SpreadPoisonAndChum(20)
                        CustomSleep(30)
                    }

                StopLoopCheck()
                

                Loop, 1 ;공증
                    {
                        StopLoopCheck()
                        DrinkDongDongJu()
                        CustomSleep(30)
                        SendInput, 3 ; 공증(실패해도 됨)
                        CustomSleep(30)
                        selfheal(4) ; 자힐 3틱
                        CustomSleep(50)
                        StopLoopCheck()

                    }

                StopLoopCheck()
                
    
                Loop,2 ; 자힐첨 -> 딸피 마무리
                    {            
                        SelfHealAndChum(20) 
                        CustomSleep(30)
                        StopLoopCheck()
                    }
                }
        }
    CustomSleep(30)
    isHuntingOn := false
    return
    }


;중독첨첨 사냥
;StopLoopCheck() 를 중간중간에 집어 넣은 것은 함수들을 종합적으로 모은 사냥이고
;이때 하나의 함수라면 StopLoop := true가 되면 break 걸고 반복 루프를 빠녀나와서 마지막에 필요한 처리 해주고 return이 되지만
;여기서는 중간중간 loop안에 함수들이 있기 때문에 해당 함수에서 빠져나와서 다음 함수로 간다.(종료가 아니라 하나씩 건너뜀)
; 이때 StopLoopCheck() 를 통해서 StopLoop를 감지하고 true면 Exit를 해서 중독첨첨 함수를 끝낸다.
PoisonChumHunt() {
    SendInput, {Esc}
    CustomSleep(30)
    StopLoop := false
    isHuntingOn := true
    ManaRefresh := 0
    FourWayMabi := 0

    CustomSleep(30) 
    StopLoopCheck()   
    SelfBoMu() ; 자신 보무
    CustomSleep(30)

    ;일단 처음에는 저주 돌려야 하니까 4방향 마비&저주 걸고 중독2, 저주2 ; -> 중첨첨 사냥은 첫 시작을 중독첨2, 저주첨2        
    ; 초반 첫 4방향 저주마비 이후 중독첨2, 저주첨2로 딸피되기 때문에 다음턴 마비 없이 진행

    ;초반에도 헬파 쓰고 마력 부족할 수 있으므로 안전 공증 추가.
    ;중독첨이나 저주첨 기본 1회를 20번으로 해줬고 2회는 20 x2 루프돌리다가 매개변수 넣고 40으로 해줬는데
    ;중간에 마나량 확인을 위해 10으로 나눠서 하자.
    ;그리고 중간 헬파를 위해 체력이 부족하면 공증 넘어가는 게 아니라 체력좀 회복하고 공증 시도로?
    
        
    StopLoopCheck()    
    FourWayCurseAndParalysis() ;4방향 마비저주 
    StopLoopCheck()
    SelfHealAndChum(4) ;셀프힐&첨 3틱
    CustomSleep(30)
                    
    
    ;중독첨 x2.  기본 20회로 사용했으므로 x2는 40.  이를 나눠서 중간에 마나 부족시 안전한 공증
    ;루프를 사용하니 F3 눌러서 종료해도 해당 함수만 종료되고 다시 루프 반복되더라.
    ;해결 필요
    StopLoopCheck()            
    Loop, 2 {
        SpreadPoisonAndChum(20)  
        CustomSleep(30)
        StopLoopCheck()
        SafeRestoreManaAtLow()            
        StopLoopCheck()
    }
    StopLoopCheck()
    
    ;저주첨 x2.  기본 20회로 사용했으므로 x2는 40.  이를 나눠서 중간에 마나부족시 안전한 공증
    Loop,2 {
        SpreadCurseAndChum(20) ; 저주첨 x2   기본 20회로 사용했으므로 x2는 40
        CustomSleep(30)
        StopLoopCheck()
        SafeRestoreManaAtLow()
        StopLoopCheck()
    }
    StopLoopCheck()
        

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
        
        StopLoopCheck()


        ;중독첨x2 돌리기. 기본 20 x2라서  40으로 했는데 20으로 나눠서 마나확인
        Loop, 2 {
            SpreadPoisonAndChum(20) 
            CustomSleep(30)
            StopLoopCheck()
            SafeRestoreManaAtLow() 
            StopLoopCheck()

        }
    
        StopLoopCheck()
    

        ;저주첨x1 돌리기.(1회는  20회 )
        SpreadCurseAndChum(20) 
        CustomSleep(30)
        StopLoopCheck()
        SafeRestoreManaAtLow()
                                                
        StopLoopCheck()

        SelfHealAndChum(20) ; 자힐첨x1
        CustomSleep(30)            
        StopLoopCheck()
        SafeRestoreManaAtLow()        
        
        StopLoopCheck()
        
        
        
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
    StopLoopCheck()
    SafeRestoreManaAtLow()

    StopLoopCheck()
    SpreadCurseAndChum(20) ; 저주첨x1 돌리기
    CustomSleep(30)
    StopLoopCheck()
    SafeRestoreManaAtLow()      

                
    StopLoopCheck()
    SelfHealAndChum(20)  ; 자힐첨x1
    CustomSleep(30)
    StopLoopCheck()
    SafeRestoreManaAtLow()
        
                
       
    CustomSleep(30)
    isHuntingOn := false
    ManaRefresh := 0
    FourWayMabi := 0
    return
}


;숲지대 중독첨첨사냥
ForestPoisonChumHunt() {
    SendInput, {Esc}
    CustomSleep(30)
    isHuntingOn := true
    StopLoop := false
    ManaRefresh := 0
    FourWayMabi := 0

    StopLoopCheck()   
    SelfBoMu() ; 자신 보무
    CustomSleep(30)

  
    StopLoopCheck()         
    FourWayCurse() ;4방향 저주 
    CustomSleep(20)
    StopLoopCheck()
    SpreadCurseAndChum(8) ; 저주첨 ; 4방향 저주 이후 애매한 몇놈들 저주걸기위함
    CustomSleep(20)
    StopLoopCheck()
    SelfHealAndChum(6) ;셀프힐&첨 3틱
    CustomSleep(30)

    StopLoopCheck() 
    SafeRestoreMana() ; 안전공증

    Loop, 4 {       

        StopLoopCheck()            
        SpreadPoisonAndChum(8) ; 중독첨
        CustomSleep(30)
        StopLoopCheck()
        SafeRestoreMana() ; 안전공증
        
        
        StopLoopCheck()
        SpreadCurseAndChum(8) ; 저주첨
        CustomSleep(50)
        StopLoopCheck()
        SafeRestoreMana() ; 안전공증
        
        
        StopLoopCheck()
        SelfHealAndChum(20)  ; 자힐첨
        CustomSleep(30)
        StopLoopCheck()
        SafeRestoreMana() ; 안전공증        
        StopLoopCheck()
        CustomSleep(30)

        ;CustomSleep(160)  ;루프 돌아갈 때 다시 공증이므로 후딜 160을 줘야 공증 후 떨어진 체력 인지 가능. 루프 첫 안전공증 로프 밖으로 빼서 주석처리
    }
    
    SendInput, {Esc}
    CustomSleep(30)
    isHuntingOn := false

    ManaRefresh := 0
    FourWayMabi := 0
    return
}


;중독쩔
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
    return
}


;자동 헬파 사냥 간략하게 정리하자면
;HellFireForAuto() 를 입력대기 헬파이어 시전(한 번 시전)을 그대로 가져와서 말타기 등 살짝만 지웠고(자동에 사냥하기 위한 헬파이어)
;HellFireHunt() 루프 안에 방향키 + 저주 + HellFireForAuto() 반복으로 자동 헬파를 계속 쏜다.
;우측 End키에 반복헬파가 아닌 헬파 한 방만 쏘기를 만들고 싶어서 만들었고.이는  OneShotHellFire() 이다.
;HellFireForAuto()에서 마무리에 마비돌리는 걸 넣어줬는데 잘못된 대상이거나 죽었을 때는 마비 돌리기를 안 쓰게 처리해줬고
;한 방 헬파 쓸 때도 마비 돌리기를 안 쓰게 해주기 위해 HellFireForAuto() 마무리에 관련 변수 isOneShotHellFireOn가 true이고
;HellFireForAutoCount > 0  일 때  HellFireForAuto()에서 마무리에 마비돌리기를 하지 않는다.

;isOneShotHellFireOn는 OneShotHellFire() 에서 true로 초기화 해주고 HellFireForAutoCount는 HellFireForAuto()에서
;실제로 헬파를 쏘고 공증을 거친 뒤 원래라면 자힐을 해주는 위치에서 HellFireForAutoCount++를 해줬다.
;즉 헬 한 방만 쓰기 위해 변수를 2개 만들었다. HellFireForAutoCount와 isOneShotHellFireOn 이렇게.

;간략 요약하자면 헬파 한 방 쏘는 걸 입력대기 헬파이어에서 가져와서 HellFireForAuto() 를 만들었고
;이걸 루프에 넣어서 헬파 반복 시전하는 HellFireHunt()를 만들었고 헬파를 한 번만 시전하기 위해 OneShotHellFire()를 만들었다.
;물론 OneShotHellFire()에도 루프를 넣었다. 대상이 아군이면 다시 타겟 변경시키기 위해.
;HellFireForAuto() 마지막에 마무리 할 때 마비 돌리는 걸 넣어줬는데 조건에 따라 마비 안 돌리게 처리(잘못된 대상, 본인 사망, 한 방 헬파시)


;자동헬파 보완 아이디어 -> 한 방 아닌 녀석은 어그로 튀어서 죽어버린다. 몹을 잡으면 타겟이 나한테 오는데
;이때 시전하면 걸리지 않습니다 라고 isWrongTarget으로 판별 가능하기 때문에
;변수 하나 만들어서 처음부터 Left 하지 말고 isWrongTarget조건문 안에 Left 넣어줘도 괜찮겠다.

; -> 마비 돌리면 말짱 도루묵이다. 대상 고정시키려면 마비 돌리기를 빼자.

;자동 헬파이어 사냥
HellFireHunt() {
    isHellFireHuntOn := true
    StopLoop := false

    if(isAtMoosa) {
        loopCount := 300
    } else {
        loopCount := 50
    }

    loop, %loopCount% {
        if(StopLoop) {
            break
        }
       
        SendInput, {ESC}
        CustomSleep(20)
        SendInput, {4}
        CustomSleep(30)

        ; 원래 조건 없이 Left였다. 두 방컷인 놈 떄리고 다른 놈 떄리면 어그로 풀리고 맞기 때문에 대상유지하기 위함
        ; 무사방에서는 도사가 몸빵을 버틸 수가 없어서 주술로 힐 받으면서 몹 몰면서 삼매각 만든다.
        ; 이때 걸리지 않습니다를 이미지서칭해서 다음 타겟으로 이동했는데 힐을 계속 받아서 인식이 힘들다.
        ; 그래서 무사방이나 힐을 계속 받는 곳에서는 헬파오토 사냥시 left 해주자
        ; 여기서 하나 더 고려해야될 것은 HellFireForAuto()에서 헬파를 쏘거나 잘못된 대상이어야 break로 헬파이어 루프에서 벗어나는데
        ; 무사방일 경우 힐을 받아서 유저가 대상일 경우 걸리지 않습니다 라는 시스템 메시지 이미지 서칭이 힘들어서
        ; 헬파 시전이 반복된다.(잘못된 대상이 아니라면 쿨타임 중이라고 인식하도록 설계)
        ; 풀마나에 입력대기 헬파이어(변수) 카운트가 1 올라간다면
        ; 걸리지 않습니다. 이미지 서칭 말고도 isAtMoosa를 조건문으로 해서 break를 해주도록 하자.
        ; 유저인지 몹인지 인식이 힘드므로 시전될때까지 반복이 아니라 한 번 시도해보고 풀마나인데 공증을 안 거치고 왔으면
        ; 그냥 다음으로 타겟을 넘기는 것이다.
        ; 
        if(isWrongTarget || isAtMoosa) { 
            SendInput, {Left}           
            CustomSleep(30)  
        }
        SendInput, {Enter}
        CustomSleep(30)
        StopLoopCheck()  ; HellFireForAuto() 가면 StopLoop가 true여도 false로 초기화 하기 때문
        HellFireForAuto()
        CustomSleep(50)  
        ;isDead 조건이 아래에 있는 것은 isDead의 true false를 결정하는 DeathCheck()가 HellFireForAuto() 내부에 있기 때문이다.
        ;isDead 조건이 HellFireForAuto()보다 위에 있다면 한 번 isDead가 true가 되면 부활을 해도 isDead가 true 상태라서 먹통됨
        if(isDead) {
            break
        }      
    }
    isHellFireHuntOn := false
    return
}

;헬파 한 방 날리기
OneShotHellFire() {
    StopLoop := false
    isOneShotHellFireOn := true
    HellFireForAutoCount := 0
    loop, 5 { ;몇번 반복 후 한 번이라도 헬파 쏘면(HellFireForAuto에서 헬파 시전시 HellFireForAutoCount 증가) 카운팅 조건으로 바로 정지. 
        if(StopLoop) {
            break
        }      
        SendInput, {ESC}
        CustomSleep(20)
        SendInput, {4}
        CustomSleep(30)
        ;원샷헬파도 타겟 유지하려면 isWrongTarget 조건 걸어서 타겟변경 해주면 된다.
        ;우선 아직 적용 안 한 이유는 그러면 항상 몹 잡고 다음 시전할 때 나를 타겟으로 잡고 isWrongTarget 인식 후 타겟변경하기 때문
        ;if(isWrongTarget) {
        SendInput, {Left}   
        CustomSleep(30)  
        ;}
        SendInput, {Enter}
        CustomSleep(60)
        StopLoopCheck()  ; HellFireForAuto() 가면 StopLoop가 true여도 false로 초기화 하기 때문
        HellFireForAuto()
        CustomSleep(50) 

        ;isDead 조건이 아래에 있는 것은 isDead의 true false를 결정하는 DeathCheck()가 HellFireForAuto() 내부에 있기 때문이다.
        ;isDead 조건이 HellFireForAuto()보다 위에 있다면 한 번 isDead가 true가 되면 부활을 해도 isDead가 true 상태라서 먹통됨
        if(isDead) { ;죽으면 당연히 멈춤. 잘못된 대상 이런 건 hellFireForAuto() 에서 판별
            break
        }
        if(HellFireForAutoCount > 0) {
            break
        }       
    }
    isOneShotHellFireOn := false
    HellFireForAutoCount := 0
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

;입력대기시 타이머 추가해서 입력대기함수 아래에 만들어 둔 CheckCancelInput:  을 통해
;CancelInput 변수를 확인해서 true면 Esc 입력해서 취소하게 해준다. -> Esc 누르니까 다른 핫키 누를 때 끼어들어서 꼬이는 경우 생김
; 그래서 c나 o키 등 상관없는 키를 눌러서 조건문에 ErrorLevel이 Escape 조건이 아니라 마지막에 else 조건에 가서 취소되도록 한다.
;이 장치가 없을 경우 입력대기 상태에서 급하게 4방위 마비를 쓰면 여전히 입력대기 중이기 때문에 따로 c나 esc를 눌러서 취소해야된다.
;그렇기 때문에 입력대기시 급하게 쓸만한 4방위 마비 핫키에 CancelInput을 true로 만들어 주는 구문을 넣어줬다.

;우선 4방위 마비 돌리기인 f:: 에만 넣어줬는데 이는 입력대기중 키 연계시 f키는 포기한 것. 그럴만한 것이 4방위 마비라서 급할 때 유용

;s : 입력대기 // c, esc: 취소 // d, 좌클릭 : 저주 헬파 공증 자힐
InputWaiting() {    
    IsWaiting := true    ;대기 상태 true

    CancelInput := false ; 취소 플래그. 유저 입력대기중 특정 시간마다 이 변수를 확인해서 true시 입력대기 취소하게 만듦

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

    if(isHuntingOn) { ;첨첨사냥 혹은 중독사냥 중이면 탭탭이 열려 있는지 확인 해두기 + 첨첨 사용 -> 헬파 쏘고 나서 첨첨해제
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

    ; 100ms마다 CancelInput 플래그를 확인하는 타이머 설정
    SetTimer, CheckCancelInput, 100

    ; Enter와 d 키 입력 대기 (10초 타임아웃)
    Input, UserInput, V L1 T10, {d}{a}{ESC}
    CustomSleep(20)


     ; Input 종료 후 타이머 끄기
     SetTimer, CheckCancelInput, Off


    ;---------------------입력대기중 헬파이어------------------------------------------------------

    if (ErrorLevel = "EndKey:d") { ; 입력대기중 d키 눌렀을 때 헬파이어 -> 입력대기중에는 isWaiting 변수를 활용하여 d키 입력시 o가 입력되게 해서 연동. 마우스클릭도 o가 입력되게.
        ;MsgBox, Enter was pressed!
        ; Enter를 눌렀을 때 실행할 로직 추가


        if(isHuntingOn) { ;첨첨 사냥중에는 단순 저주 + 헬파이어 시전만(탭탭창 열려 있는 상태면 탭탭창 복구) + 첨첨까지
            SendInput, {Esc}
            CustomSleep(30)    
            SendInput, {4} ;저주
            CustomSleep(30)
            SendInput, {Enter} 
            CustomSleep(30) ; 100 -> 30
            SendInput, {Blind}2 ; 헬파 
            CustomSleep(30)
            SendInput, {Enter}
            CustomSleep(30)  ; 90 - >30
            if(isTabTabOn) { ; 탭탭 상태였다면 탭탭으로 원상복구
                SendInput, {Esc}
                CustomSleep(30)
                SendInput, {Tab}
                CustomSleep(50)
                SendInput, {Tab}
                CustomSleep(50)
                IsWaiting := false
            }   
            Exit

        }



        ;저주 -> 헬파 -> 공증(마나 감지될 때까지 계속 시도) -> 자힐 3틱
        ;헬파쓰고 페이백 받으면 마나 오링(바닥)상태를 기존 마나량 이미지로 서치해서는 판별할 수가 없다.
        ;페이백으로 마나가 남았는지 공증 성공했는지 판별 불가.
        ;그래서 페이백 못 받았을 경우와 페이백 받았을 경우 모두를 고려해야 한다.

        ;공증 성공여부는 풀마나가 되므로 풀마나 이미지로 공증성공 확인.
        ;만약 페이백을 못 받았을 경우 동동주 먹고 공력증강 시전
        SendInput, {Esc}
        CustomSleep(20) ;후딜 50에서 20으로 낮춤. 문제 있을 경우 30->50으로 수정해본다.

        if(isRidingHunt) { ;승마사냥 토글 on/off에 따라 말타기 + 후딜 150   사용 on/off. 처음에 내릴 때만 후딜 많이 필요하므로 여기만 조건부.
            SendInput, {Blind}r ;말에서 타고 있으면 말에서 내리기. 내리고 나서 말에 마비거는 건 어떨까 싶음(방향 확인 로직 필요)
            CustomSleep(150) ; 이 딜레이를 짧게하면 말을 타고 있다고 하므로 이 문구 뜨면 늘리자. 귀찮으면 말타기를 입력대기쪽 저주 앞으로 이동
        }

        SendInput, {4} ;저주
        CustomSleep(30) ; 후딜 50에서 30으로 바꿔줌.
        SendInput, {Enter} ; 
        CustomSleep(30) ;원래 100에서 60으로 줄임  -> 다시 30으로 줄임

        ;헬파가 씹히는 경우가 생겨서 후딜을 늘리고 후딜 늘리는 걸로는 고장나는 경우가 생겨서 반복 재시전을 만들었다.
        
        ; -> 헬파가 씹히던 이유는 바람을 오래켜놔서 쿨타임 애드온 타이머가 고장나서 그랬던 거였고 반복 재시전을 만들었으나
        ; 재부팅 하니까 고쳐졌다. 하지만 덕분에 반복 재시전을 만들어서 괜찮다고 생각한다.  

        Loop ,20 { ;루프 횟수없으면 만약 말에서 내린 상태에서 s->d를 해버릴 때 말에 타버리면 말탄 상태에서 무한 공증시도를 하게 된다.
                   ; -> 말타고 시전하면 멈추는 로직 만들엇음.

            ;헬파 시전 이후 공증 후 빠른 힐을 위해 각종 함수 사이에 후딜을 빼봤다. 오작동하면 다시 후딜 넣을 것
            StopLoopCheck()
            ;CustomSleep(20)
            DeathCheck() ; 본인 사망 확인
            ;CustomSleep(20)
            CheckFullMana() ; 풀마나 확인             
            ;CustomSleep(20)
            CheckWrongTarget() ; 걸리지 않는 잘못된 대상이면 중단
            ;CustomSleep(20) 
            CheckCastOnHorse() ; 말에 탄 상태에서 시전하면 중단
            ;CustomSleep(20)
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
            } else if(isDead) { ; 사망했으면 탈출
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
                    if(inputWaitingSelfHeal) {  ; 입력대기 셀프힐 옵션에 따라 셀프힐.
                        SelfTapTapHeal(3)
                    }
                    CustomSleep(20)
                    ;이때 말 타고 있었으면 말에 다시 타게 r키 탑승
                    SendInput, {Blind}r
                    Break
                } else { ;풀마나인데 공증 거친 것이 아니면 헬파 시전 안 된 것이므로 다시 루프 반복되면서 자힐로 안 가고 헬파로 다시 온다.            

                    if(waitingHellFireCount >0) { ;첫 헬파쐈는데 공증 없이 다시 풀마나로 왔다는 것은 쿨타임이라는 것이다. 쿨일시 마비(혹은 절망) 쏘고 헬파
                        ;어차피 마비나 절망 돌려놓고 할 가능성이 높은데 일단 써보고 별로면 이 if문은 빼자.
                        loop, 1 { ;마비 100퍼 같아서 2에서 1로 변경
                            if(isAtForest) {
                                SendInput, {7} ;숲지대일시 절망
                                CustomSleep(30)
                                SendInput, {Enter} 
                                CustomSleep(30)
                            } else if(isAtMoosa) {
                                ;아무것도 안 씀
                            } else {
                                SendInput, {6} ;마비
                                CustomSleep(30)
                                SendInput, {Enter} 
                                CustomSleep(30)
                            }
                            CustomSleep(30) 
                        }
                    }
                    ;헬파를 말에다가 쏠 경우 급하게 중단 눌렀을 때 헬파 직전에 멈추기 위함
                    if(StopLoop) {
                        break
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
                    loop, 1{ ;마비 100퍼 같아서 2에서 1로 변경
                        if(isAtForest) {
                            SendInput, {7} ;숲지대일시 절망
                            CustomSleep(30)
                            SendInput, {Enter} 
                            CustomSleep(30)
                        } else if(isAtMoosa) {
                            ;아무것도 안 씀
                        }
                        else {
                            SendInput, {6} ;마비
                            CustomSleep(30)
                            SendInput, {Enter} 
                            CustomSleep(30)
                        }
                        CustomSleep(30) ;
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
                   CustomSleep(150) ; 공증 이후 루프 반복될 때 풀마나인지 확인하는 함수가 있는데 공증 성공시 회복된 마나 인지할 정도의 후딜을 줬다. 기존 50 -> 100에서 다시 150으로
               }           
                ;공증 성공인지 실패인지는 모르지만 어쨌든 공력증강 사용                
                isRefreshed := true
                
            }
            
            
        }

    ;---------------------입력대기중 삼매진화------------------------------------------------------
    } else if (ErrorLevel = "EndKey:a") { ;삼매진화
        SendInput, {Esc}
        CustomSleep(20)         

        if(isRidingHunt) { ;승마사냥 토글 on/off에 따라 말타기 + 후딜 150   사용 on/off. 처음에 내릴 때만 후딜 많이 필요하므로 여기만 조건부.
            SendInput, {Blind}r ;말에서 타고 있으면 말에서 내리기. 내리고 나서 말에 마비거는 건 어떨까 싶음(방향 확인 로직 필요)
            CustomSleep(150) ; 이 딜레이를 짧게하면 말을 타고 있다고 하므로 이 문구 뜨면 늘리자. 귀찮으면 말타기를 입력대기쪽 저주 앞으로 이동
        }
        CheckFullMana() ;풀마나 확인        
        if(!isFullMana) {
            RestoreMana()
        } 
        SamMaeJinWha() ;원래 삼매진화 함수가 시전까지만이고 대상 확정은 엔터 눌러 줘야 한다. 여기서는 대상 선택했으니 확정을 위해 엔터
        CustomSleep(60) 
        StopLoopCheck() ;혹시 모를 급히 취소에 대비해 f3 눌렀을 경우 enter 직전 취소
        SendInput, {Enter} ;대상 확정하며 시전
        CustomSleep(100) ; 후딜 70이었는데 가끔 삼매하고 무반응이길래 후딜 100으로 늘려봤다.

        ;걸리지 않거나 말에 탄 상태에서 시전했으면 뒤에 공증 할 필요가 없다.
        CheckWrongTarget() ; 걸리지 않는 잘못된 대상인지 확인
        CustomSleep(20) 
        CheckCastOnHorse() ; 말에 탄 상태에서 시전했는지 확인
        CustomSleep(20)

        ;말에 탄 상태면 그냥 끝. 잘못된 대상이면 다시 말에 탐 -> 둘 다 공증 안 함
        if(isRiding) {
            ;말에 탄 상태면 그냥 아무것도 안 하고 끝.
        }   
        if(isWrongTarget) {
            ;잘못된 대상이면 승마사냥이었을 경우 다시 말에 타게 하려고 r 넣음.
            SendInput, {Blind}r ; 승마사냥 중이면 다시 말에 타기 위함
        }

        ;말에 탄 상태도 아니고 잘못된 대상도 아니면 시전했으므로 마나 0이다. -> 공증
        ;일단 이렇게 써보고 시전 안 됐을 때 공증되는 경우가 생기면 마나체크 후 0이나 low면(사용 직후 마나젠 됐다면) 공증
        RestoreMana()
        CustomSleep(30)
        if(inputWaitingSelfHeal) {
            SelfTapTapHeal(3)
        }
        CustomSleep(50)
        SendInput, {Blind}r ; 승마사냥 중이면 다시 말에 타기 위함

    } else if (ErrorLevel = "EndKey:ESCAPE") { ; 취소
        ;MsgBox, esc was pressed!
        ;Esc를 눌렀을 때 실행할 로직 추가 (대기상태에서 c키 눌러도 esc임)

        ;취소하면 말에 다시 탑승
        CustomSleep(30)
        SendInput, {Blind}r

    } else if (ErrorLevel = "Timeout") {
        ;MsgBox, Time out! No key was pressed.
        ; 타임아웃 시 실행할 로직 추가
    } else { ;a, d,esc 등 정해진 키 이외의 다른 키를 입력했을 때
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









;근처 적에게 헬파 한 방 바로 날리거나 오토 헬파 날리기 위해 입력대기 헬파이어에서 가져 와서 수정함.
;말에서 내리는 액션은 다 뻇다.(자힐은 입력대기 헬파처럼 옵션 넣어줌)  저주걸고 헬파 쏘고 공증 후 종료되는 것
;코드 설명 주석은 입력대기 헬파이어꺼 코드 그대로 복사해서 몇 개만 상황에 맞게 바꾼 것이므로 긴 설명은 지웠음.
;필요하면 입력대기 헬파 참고

;OneShotHellfire() 이라는 단일 헬파쏘기와  HellFireHunt() 라는 헬파 자동사냥 (헬파 쏘는 거 루프)에서
;헬파이어 시전을 HellFireForAuto()를 사용해서 시전한다.
;저주 걸고 HellFireForAuto()를 호출해서 와서 걸리지 않습니다 이미지 서칭 후 확인되면 isWrongTarget이 true가 되고 이게 true면
;OneShotHellFire()나 HellFireHunt() 에서 isWrongTarget에 따라 저주 누르고 엔터 전에 Left로 타겟 전환 시키는 조건문이 루프 내부에 있다.

;이때 HellFireForAuto()에는 입력대기 헬파에서 가지고 온 것이므로 자체적으로 저주 걸어보고 타겟 확인하는 것이 있다.
;그런데 OneshotHellfire() 와 HellFireHunt() 에서 저주를 걸고 hellFireForAuto()를 호출하기 때문에 저주 거는 것이 중복이다.

;그래서 HellFireForAuto()에서 저주 거는 것을 뺴줄까 하다가 또 다른 곳에서 호출이 필요할 때가 있을지도 몰라서
;OneShotHellfire()와 HellFireHunt()에서 함수 시작 변수를 만들어서(isOneShotHellFireOn, isHellFireHuntOn) 이들 둘 다 false일 때만 사용
;즉, 원샷헬파, 헬파헌트 사용시 호출했다면 HellFireForAuto()에서 중복되는 저주 거는 것은 스킵하는 것으로 해주기로 했다. 

HellFireForAuto() {

    StopLoop := false ;초기화
    isRefreshed := false
    waitingHellFireCount := 0
    isWrongTarget := false
    notEnoughMana := False

    SendInput, {Esc}
    CustomSleep(20) 

    ;원샷헬파나 헬파이어헌트(헬파자동사냥)에서 저주 시전하고 호출하므로 둘 다 아닐 때 저주 시전
    if(!isOneShotHellFireOn && !isHellFireHuntON) {        
        SendInput, {4} ;저주
        CustomSleep(30) 
        SendInput, {Enter} ; 
        CustomSleep(30) ;원래 100에서 60으로 줄임  -> 30으로 줄여봄

    }

    Loop ,20 { ;적당한 반복수

        StopLoopCheck()
        DeathCheck() ; 본인 사망 확인
        CheckFullMana() ; 풀마나 확인             
        CheckWrongTarget() ; 걸리지 않는 잘못된 대상이면 중단

        
        ;잘못된 대상이거나 사망했을 때 break로 Loop 탈출하면 종료 전에 마비 돌리는 걸 넣어뒀는데
        ;잘못된 대상이거나 사망시에도 마비를 돌리기 때문에 잘못된 대상일 경우 꼬일 수 있다.
        ;그렇다고 Exit를 넣으면 안 되는 이유는 아예 실행중인 함수가 모두 종료된다. 자동헬파를 포함한 루프가 도는 함수도 종료된다.
        ;break를 해주되 함수 종료 전 마비 돌리는 것을 isWrongTarget 혹은 isDead일 경우 마비 안 돌리는 걸로
        if(isWrongTarget) {
            break
        } 
        if(isDead) { ; 사망했으면 탈출
            break
        }

        ; 여기서 하나 더 고려해야될 것은 HellFireForAuto()에서 헬파를 쏘거나 잘못된 대상이어야 break로 헬파이어 루프에서 벗어나는데
        ; 무사방일 경우 힐을 받아서 유저가 대상일 경우 걸리지 않습니다 라는 시스템 메시지 이미지 서칭이 힘들어서
        ; 헬파 시전이 반복된다.(잘못된 대상이 아니라면 쿨타임 중이라고 인식하도록 설계)
        ; 풀마나에 입력대기 헬파이어(변수) 카운트가 1 올라간다면
        ; 걸리지 않습니다. 이미지 서칭 말고도 isAtMoosa를 조건문으로 해서 break를 해주도록 하자.
        ; 유저인지 몹인지 인식이 힘드므로 시전될때까지 반복이 아니라 한 번 시도해보고 풀마나인데 공증을 안 거치고 왔으면
        ; 그냥 다음으로 타겟을 넘기는 것이다.



        if(isFullMana) { ; 풀마나 상태일 때 (공력증강 or 헬파 씹힘)
            if(isRefreshed && waitingHellFireCount > 0) { 
                if(inputWaitingSelfHeal && !isHellFireHuntOn) {
                    ;입력대기 헬파시 자힐 사용 토글에 따라 원샷헬파도 자힐유무 결정. 원래는 사용 안 했는데 솔플할 때 필요할 것 같아서 넣음
                    ;일단 헬파이어헌트시에는 동작 안 하게 했는데 도사 없이 솔플할 때 마비돌릴 때 중간에 마비 풀린 녀석한테 한 방 버티려면 필요할 것 같다
                    ;일단은 분리해놨고 필요시 분리 롤백해서 헬파이어헌트시에도 자힐 하도록 하자
                    SelfTapTapHeal(3) 
                }
                ;SelfTapTapHeal(3)   ;오토용이라 자힐 뺌. 필요하면 이것도 셀프힐 토글에 넣자
                HellFireForAutoCount++   ;실제로 헬파 쏘고 공증까지 거쳐온 것이므로 헬파 한 방 쐈다고 볼 수 있다.
                CustomSleep(20)
                Break
            } else { ;풀마나인데 공증 거친 것이 아니면 헬파 시전 안 된 것이므로 다시 루프 반복되면서 자힐로 안 가고 헬파로 다시 온다.            
                if(waitingHellFireCount >0) { ; 헬파를 사용했지만 공증 없이 풀마나 상태에서 다시 온 것은 시전이 안 된 것.
                    ;무사의 방일 경우 힐을 받으므로 걸리지 않는 타겟(유저)인지 몹인데 쿨탐이라서 시전이 안 된 것인지 판별이 힘들다.
                    ;그래서 무사의 방일 경우 공증 안 거치고 풀마나로 왔을 경우 2번 헬파일 경우 경우 break로 빠져나가서 다음 타겟으로.
                    if(isAtMoosa) {
                        break
                    }
   
                }


                ;헬파를 말에다가 쏠 경우 급하게 중단 눌렀을 때 헬파 직전에 멈추기 위함
                if(StopLoop) {
                    break
                }


                ; 오토 헬파시에는 한 방컷 아닌 녀석들을 대비해서 두 번째부터가 아니라 첫 번째 헬파부터 조건에 때라 마비 or 절망( 무사는 x)
                if(isAtForest) {
                    SendInput, {7} ;숲지대일시 절망
                    CustomSleep(30)
                    SendInput, {Enter} 
                    CustomSleep(30)
                } else if(isAtMoosa) {
                    ;아무것도 안 씀
                } else {
                    SendInput, {6} ;마비
                    CustomSleep(30)
                    SendInput, {Enter} 
                    CustomSleep(30)
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
            ;풀마나 아니라서 공증하고 헬파 날릴 때 공증 하기 전 마비혹은절망 걸고 공증 시도
            if(waitingHellFireCount==0) {
                loop, 1{ ;마비 100퍼 같아서 2에서 1로 변경
                    if(isAtForest) {
                        SendInput, {7} ;숲지대일시 절망
                        CustomSleep(30)
                        SendInput, {Enter} 
                        CustomSleep(30)
                    } else if(isAtMoosa) {
                        ;아무것도 안 씀
                    } else {
                        SendInput, {6} ;마비
                        CustomSleep(30)
                        SendInput, {Enter} 
                        CustomSleep(30)
                    }
                    CustomSleep(30)                    
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
                CustomSleep(150) ; 공증 이후 루프 반복될 때 풀마나인지 확인하는 함수가 있는데 공증 성공시 회복된 마나 인지할 정도의 후딜을 줬다. 기존 50 -> 100에서 다시 150으로
            }           
            ;공증 성공인지 실패인지는 모르지만 어쨌든 공력증강 사용                
            isRefreshed := true
            
        }        
        
    }

SendInput, {Esc}
CustomSleep(20)

;잘못된 대상. 즉 유저를 대상으로 했을 시 또는 본인사망일 경우 마비 안 돌리고 종료
if(isWrongTarget || isDead ) {
    return
}

;헬파원샷으로 한 방만 날리는 거 사용할 때 한 방 날렸으면 마비 안 돌리고 종료(이 변수는 헬파원샷 함수에서 초기화)
;원래 조건은 if(isOneShotHellFireOn && HellFireForAutoCount > 0) 이거였다.
;무사의 방에서 원샷헬파 처음 몹한테 시전됐을 때는 여기서 걸리는데 이미지 서칭이 힘들어서 공증없이 풀마나일 경우
;그냥 break 해줬는데 HellFireForAutoCount가 풀마나에 공증 거치고 waitingHellFireCount >0 일 때 ++을 시켜주는 상태다.
;waitingHellFireCount는 단순 헬파 시도 횟수기 때문에 0보다 큰 것은 몹이든 유저든 한 번 거쳤다는 것이다.
;이후 시전이 안 되면 같은 타겟으로 반복하는데 무사방 모드에서는 유저일 경우 걸리지 않습니다 이미지 서칭이 힘들어서
;계속 유저한테 시도를 하기 때문에 무사방에서는 1회 시도 했으면 풀마나에 공증을 안 거쳤을 시 쿨타임인지 유저타겟인지
;왜 시전이 안됐는지 모르므로 일단 isAtMoosa 조건break로  빠져나오기 때문에 HellFireForAutoCount가 안 올라간 상태인 0인 상태로
;여기까지 내려왔기 때문에 HellFireForAutoCount > 0 조건을 만족하지 못해서 원샷헬파를 사용했음에도 불구하고 필터링 조건을 통과해버렸다.
;HellFireForAutoCount 변수가 OneShotHellFire()  HellFireHunt() 이걸 사용했을 때 헬파가 시전됐는지 실제 카운팅이므로
;어차피 위에 루프를 통과해서 나올 때 0이면 사용 안 된 것이므로 굳이 다음으로 넘어가서 마비나 절망을 돌릴 필요는 없다. >=0 으로 조건 변경
if(isOneShotHellFireOn && HellFireForAutoCount >= 0) {
    return
}



;산적 막굴같은 경우 한 방컷 아닌 애들이 있다. 이런애들은 마비 안 돌리고 타겟 유지하려면 마비를 뺴야한다.
;기본 true로 하고 토글로 막굴에서는 false 로 만들어서 마비 안 돌리게 하자
;마비 돌리는 로직에는 당연하게도 숲지대(마비 안 걸리는 곳 통칭) On이면 마비대신 절망 돌림
if(ParalysisAfterAutoHellFire) {

    ;마비 넣으면 몸빵한테 삼매각이 안 만들어 지려나? 일단 추후 기본 off로 하든지 한다.    
    ;SelfTapTapHeal(3)  ;어차피 어그로 한 마리라도 살아 있으면 사망 위험 있겠지만 마비 활력으로 돌리면 뒷방만 아니면 마비 유지로 생존율 높아짐
    ;SpreadVitalityAndParalysis(12) ; 활력 후 마비로 언제 마비 풀릴지 모르는 것에 대비. 앞에 자힐도 살짝 넣어주고 앞,옆방은 한 방 버틸만함
    
    ;활력은 너무 매크로 같긴 하다. 어쨌든 일단 마비 돌리는 걸로 사용
    if(isAtForest) { ; 숲지대 모드on이면 마비대신 절망
        SpreadDespair(20) 
    } else if(isAtMoosa && isRefreshed) { ;무사방 모드on이면 마비 안 통하므로 숲지대처럼 절망.
        ;무사의 헬파를 쏘고 왔는지 무사방에서 주술이 힐 받는 도중에는 걸리지 않습니다(유저 타겟) 이미지 서칭이 힘들어서 break로 왔는지
        ;알 수 없기 때문에 공력증강을 거치고 왔는지도 추가로 확인 해준다. (공증 거치고 왔다 = 헬파 사용하고 마나 감지로 공증 사용했다는 것)
        SpreadDespair(20) 
    } else if(isAtMoosa && !isRefreshed) {
        ;무사의 방인데 공증을 거치지 않고 왔다 -> 헬파 시전을 안하고 패스했다.  이때는 아무것도 시전하지 않는다.        
    } else { ; 숲지대도 무사도 아니면 마비 돌림
        SpreadParalysis(20) 
    }

}
isRefreshed := false
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
    return
}



;SafeRestoreManaAtLow() 만든 이후에 CheckHalfHealth()를 만든 것이다. SafeRestoreManaAtLow()는 이미지 서칭2개 예제로 그냥 남겨둠

SafeRestoreManaAtLow() { ; 체력 절반쯤 이상(안전한 공력증강) + 마나가 거의 바닥이면 공력증강
    StopLoop := false ;초기화. 루프 넣고 루프탈출 넣었으니 초기화 해줘야한다.
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
    StopLoop := false ;초기화. 루프 넣고 루프탈출 넣었으니 초기화 해줘야한다.
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
    StopLoop := false ;초기화. 루프 넣고 루프탈출 넣었으니 초기화 해줘야한다.
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


;AutoHotkey 1.0에는 현재 창의 너비와 높이를 나타내는 내장 변수(예: A_WindowWidth, A_WindowHeight)가 없다
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
    
    ImageSearch, FoundX1, FoundY1, winStartX, winStartY, winEndX, winEndY,*30 %tabtab% ;탭탭라인 검색
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
        MouseMove, FoundX1+ 30, FoundY1 + 40, 1  ;x값은 +30해두면 위아래는 우클이동시 중간에 잘 붙음 y값이 +50이었는데 랜덤값줘서 우클이동시 뒤아래로 움직이게(다시 + 40으로)
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




DeathCheck() { ;본인 사망 확인
    isDead := false
    CalPos() ;현재 활성창 우측하단 좌표 계산

    ;SendInput, {Blind}0 ; 주술이라서 격수 부활 뺌 (도사는 본인 부활은 본인 사망 확인 후 사용이지만 격수는 그냥 일단 쓰고 봄)
    death := imgFolder . "healthzero.png"

    ImageSearch, FoundX1, FoundY1, startStatusBarX, startStatusBarY, winEndX, winEndY, %death% ;유령상태
    ImgResult1 := ErrorLevel ; 
    if(ImgResult1 = 0) {        
        isDead := true
        ;rev() 도사는 rev() 만든 거 써준다. 주술은 없음
    } 
    return
}





#If  ;IfWinActive 조건부 종료


    

