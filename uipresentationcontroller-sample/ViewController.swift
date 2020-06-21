//
//  ViewController.swift
//  uipresentationcontroller-sample
//
//  Created by Shinya Kumagai on 2020/06/21.
//  Copyright © 2020 Shinya Kumagai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction private func onShowDialogButtonTouch(_ sender: Any) {
        let vc = storyboard!.instantiateViewController(identifier: "AlertDialog")
        present(vc, animated: true)
    }
}

