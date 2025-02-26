//
//  PopupManager.swift
//  UikitPopup
//
//  Created by m1ngjj on 1/19/25.
//

import UIKit

class PopupManager {
    static let shared = PopupManager()
    private init() { }

    private var currentPopupVC: PopupViewController?
    private var customTransitioningDelegate: UIViewControllerTransitioningDelegate?

    func topViewController(base: UIViewController? = nil) -> UIViewController? {
        let baseVC: UIViewController? = {
            if #available(iOS 13.0, *) {
                return UIApplication.shared.connectedScenes
                    .compactMap { $0 as? UIWindowScene }
                    .first(where: { $0.activationState == .foregroundActive })?
                    .windows
                    .first(where: { $0.isKeyWindow })?
                    .rootViewController
            } else {
                return UIApplication.shared.keyWindow?.rootViewController
            }
        }()

        let baseController = base ?? baseVC

        if let nav = baseController as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = baseController as? UITabBarController,
           let selected = tab.selectedViewController {
            return topViewController(base: selected)
        }
        if let presented = baseController?.presentedViewController {
            return topViewController(base: presented)
        }
        return baseController
    }

    func presentPopup(uiType: PopupUIType = .A,
                      actionType: PopupActionType = .dismiss,
                      titleText: String,
                      contentText: String,
                      destinationStoryboard: String? = nil,
                      destinationVCIdentifier: String? = nil,
                      animated: Bool = true,s
                      completion: (() -> Void)? = nil) {
        guard let topVC = topViewController() else {
            print("최상위 ViewController를 찾을 수 없습니다.")
            return
        }

        // 스토리보드에서 PopupViewController 인스턴스 로드
        let storyboard = UIStoryboard(name: "Popup", bundle: nil)
        guard let popupVC = storyboard.instantiateViewController(withIdentifier: "PopupViewController") as? PopupViewController else {
            print("스토리보드에서 PopupViewController를 찾을 수 없습니다.")
            return
        }

        customTransitioningDelegate = CustomTransitioningDelegate()
        popupVC.modalPresentationStyle = .custom
        popupVC.transitioningDelegate = customTransitioningDelegate
        
        // 호출 시 전달받은 값 할당
        popupVC.uiType = uiType
        popupVC.actionType = actionType
        popupVC.titleText = titleText
        popupVC.contentText = contentText
        
        // 네비게이션 관련 파라미터 설정
        popupVC.destinationStoryboard = destinationStoryboard
        popupVC.destinationVCIdentifier = destinationVCIdentifier

        popupVC.view.alpha = 0

        // 현재 팝업으로 설정
        currentPopupVC = popupVC

        // 팝업을 모달로 표시 (애니메이션 없이 일단 표시)
        topVC.present(popupVC, animated: false) { [weak self] in
            popupVC.showPopup(animated: animated, completion: completion)
            self?.currentPopupVC = popupVC
        }
    }

    func dismissPopup(animated: Bool = true, completion: (() -> Void)? = nil) {
        guard let popupVC = currentPopupVC else {
            completion?()
            return
        }

        popupVC.hidePopup(animated: animated) { [weak self] in
            popupVC.dismiss(animated: false, completion: completion)
            self?.currentPopupVC = nil
            self?.customTransitioningDelegate = nil
        }
    }
}
