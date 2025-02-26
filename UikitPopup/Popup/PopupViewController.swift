//
//  PopupViewController.swift
//  UikitPopup
//
//  Created by m1ngjj on 1/19/25.
//

import UIKit

class PopupViewController: UIViewController {
        
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var contentTextLabel: UILabel!
    
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    var titleText: String?
    var contentText: String?
    
    var uiType: PopupUIType = .A
    var actionType: PopupActionType = .dismiss

    // 네비게이션 시 사용할 스토리보드와 뷰컨트롤러 식별자 (옵셔널)
    var destinationStoryboard: String?
    var destinationVCIdentifier: String?
    
    init(nibName: String?) {
        super.init(nibName: nibName, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupText()
        setupActions()

        // 텍스트가 설정된 후 팝업의 높이 조정
        adjustPopupHeight()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // systemLayoutSizeFitting을 사용하여 텍스트에 맞는 높이를 계산
        let targetSize = CGSize(width: contentTextLabel.frame.width, height: CGFloat.greatestFiniteMagnitude)
        let estimatedSize = contentTextLabel.systemLayoutSizeFitting(targetSize,
                                                                     withHorizontalFittingPriority: .required,
                                                                     verticalFittingPriority: .fittingSizeLevel)
        // 레이블의 높이 업데이트
        var frame = contentTextLabel.frame
        frame.size.height = estimatedSize.height
        contentTextLabel.frame = frame

        // 레이블 크기를 고려하여 팝업 높이 조정
        adjustPopupHeight()
    }
    
    //MARK: - configureTextForPopupType
    private func setupText() {
        titleTextLabel.text = titleText ?? ""
        contentTextLabel.text = contentText ?? ""
    }
    
    //MARK: - configureUIForPopupType
    private func setupUI() {
        switch uiType {
        case .A:
            view.layer.cornerRadius = 8

            leftButton.layer.cornerRadius = 8
            leftButton.backgroundColor = UIColor.systemBlue
            leftButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            leftButton.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                leftButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                leftButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
            ])
            
            rightButton.isHidden = true

        case .B:
            view.layer.cornerRadius = 24

            leftButton.layer.cornerRadius = 16
            leftButton.backgroundColor = UIColor.systemGray
            leftButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            
            rightButton.layer.cornerRadius = 16
            rightButton.backgroundColor = UIColor.systemBlue
            rightButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            rightButton.setTitleColor(.white, for: .normal)
        }
        view.layer.masksToBounds = true
    }
    
    //MARK: - setupActions
    private func setupActions() {
        switch (uiType, actionType) {
        case (.A, .dismiss):
            leftButton.setTitle("Confirm", for: .normal)
        case (.A, .move):
            leftButton.setTitle("Confirm", for: .normal)

        case (.B, .move):
            leftButton.setTitle("Cancel", for: .normal)
            rightButton.setTitle("Confirm", for: .normal)
            
        default:
            break
        }
    }


    //MARK: - showPopup & hidePopup
    func showPopup(animated: Bool = true, completion: (() -> Void)? = nil) {
        if animated {
            view.alpha = 0
            UIView.animate(withDuration: 0.3, animations: {
                self.view.alpha = 1
            }, completion: { _ in completion?() })
        } else {
            completion?()
        }
    }
    
    func hidePopup(animated: Bool = true, completion: (() -> Void)? = nil) {
        if animated {
            UIView.animate(withDuration: 0.3, animations: {
                self.view.alpha = 0
            }, completion: { _ in completion?() })
        } else {
            completion?()
        }
    }
    
    // MARK: - 텍스트에 맞춰 팝업의 높이를 조정하는 함수
    func adjustPopupHeight() {
        // 두 레이블의 높이 중 더 큰 값을 선택하여 팝업의 높이에 반영
        let labelHeight = contentTextLabel.frame.height
        
        // topView, bottomView, maxLabelHeight의 높이를 합산하여 팝업의 높이 계산
        let totalHeight = topView.frame.height + bottomView.frame.height + labelHeight + 40 // 여백 추가
        
        // 팝업의 높이를 업데이트
        if let presentationController = self.presentationController as? PopupPresentationController {
            presentationController.updatePopupHeight(totalHeight)
        }
        
        // 팝업의 높이를 조정
        var frame = self.view.frame
        frame.size.height = totalHeight
        self.view.frame = frame
    }

    // MARK: - tapLeftButton
    @IBAction func tapLeftButton(_ sender: UIButton) {
        PopupManager.shared.dismissPopup()
    }
    
    // MARK: - tapRightButton
    @IBAction func tapRightButton(_ sender: UIButton) {
        switch actionType {
        case .move:
            // 네비게이션 액션: destinationStoryboard와 destinationVCIdentifier가 전달되었는지 확인
            if let storyboardName = destinationStoryboard,
               let vcIdentifier = destinationVCIdentifier {
                PopupManager.shared.dismissPopup(animated: true) {
                    let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
                    let destinationVC = storyboard.instantiateViewController(withIdentifier: vcIdentifier)
                    // 네비게이션 컨트롤러가 있다면 push, 아니면 present
                    if let topVC = PopupManager.shared.topViewController() {
                        if let nav = topVC.navigationController {
                            nav.pushViewController(destinationVC, animated: true)
                        } else {
                            topVC.present(destinationVC, animated: true, completion: nil)
                        }
                    } else {
                        print("네비게이션 컨트롤러를 찾을 수 없습니다.")
                    }
                }
            } else {
                print("네비게이션 컨트롤러를 찾을 수 없습니다.")
            }
        default :
            break
        }
    }
}

//MARK: Class method
extension PopupViewController {
    
    static func instance() -> PopupViewController {
        guard let vc = UIStoryboard(name: "Popup", bundle: nil).instantiateViewController(identifier: "PopupViewController") as? PopupViewController else {
            fatalError("Not found Popup in storyboard.")
        }
        return vc
    }
    
}
