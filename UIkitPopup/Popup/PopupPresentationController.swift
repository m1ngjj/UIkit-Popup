//
//  PopupPresentationController.swift
//  UikitPopup
//
//  Created by m1ngjj on 1/19/25.
//

import UIKit

class PopupPresentationController: UIPresentationController {

    var popupHeight: CGFloat = 318  // 기본값을 설정해두고, 실제 높이는 나중에 설정
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let container = containerView else {
            return super.frameOfPresentedViewInContainerView
        }
        
        let width: CGFloat = 337
        let originX = (container.bounds.width - width) / 2
        let originY = (container.bounds.height - popupHeight) / 2
        return CGRect(x: originX, y: originY, width: width, height: popupHeight)
    }
    
    // containerView의 레이아웃이 갱신될 때마다 팝업의 프레임을 다시 설정하여 중앙에 위치하도록 함
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        presentedView?.frame = frameOfPresentedViewInContainerView
    }

    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        containerView?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
    
    // 팝업의 높이를 동적으로 설정하는 메소드 추가
    func updatePopupHeight(_ height: CGFloat) {
        self.popupHeight = height
        containerView?.setNeedsLayout() // 레이아웃 갱신
    }
}

class CustomTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {
        return PopupPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
