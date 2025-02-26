# UIKit Custom Popup

UIKit을 활용한 커스텀 팝업을 제공합니다. <br>
다양한 팝업 타입과 동작을 지정하여 원하는 형태로 자유롭게 커스텀이 가능합니다.

> 원하는 타입을 추가하여 자유롭게 커스텀이 가능합니다.  
> `contentText`의 길이에 따라 팝업의 높이는 동적으로 변경됩니다. 

## PopupUIType
- **A** : 버튼 1개인 팝업
- **B** : 버튼 2개인 팝업

## PopupActionType
- **dismiss** : 팝업 종료 동작 수행
- **move** : 다른 ViewController로 이동하는 동작 수행

---

## 사용법

```swift
PopupManager.shared.presentPopup(
    uiType: .A,
    actionType: .dismiss,
    titleText: "Notice",
    contentText: "Would you like to complete it?",
    animated: true
)
```

```swift
PopupManager.shared.presentPopup(
    uiType: .B,
    actionType: .move,
    titleText: "Notice",
    contentText: "Would you like to move?",
    destinationStoryboard: "Main",
    destinationVCIdentifier: "SecondViewController",
    animated: true
)
```

---

## 결과

<p align="center">
    <img src="https://github.com/user-attachments/assets/a084178c-9c68-46e9-a75d-625589225dde" width="30%">
    <img src="https://github.com/user-attachments/assets/a8f54fc8-d770-4be5-a4b1-9c8e4934282f" width="30%">
    <img src="https://github.com/user-attachments/assets/861290e5-b8e5-4803-94a4-660d730c8048" width="30%">
</p>

