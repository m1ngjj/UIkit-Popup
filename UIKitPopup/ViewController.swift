//
//  ViewController.swift
//  UikitPopup
//
//  Created by m1ngjj on 2/26/25.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func tapbutton1(_ sender: UIButton) {
        PopupManager.shared.presentPopup(
            uiType: .A,
            actionType: .dismiss,
            titleText: "Notice",
            contentText: "Would you like to complete it?",
            animated: true
        )
    }
    
    @IBAction func tapButton2(_ sender: UIButton) {
        PopupManager.shared.presentPopup(
            uiType: .B,
            actionType: .move,
            titleText: "Notice",
            contentText: "Would you like to move?",
            destinationStoryboard: "Main",
            destinationVCIdentifier: "SecondViewController",
            animated: true
        )
    }
}

