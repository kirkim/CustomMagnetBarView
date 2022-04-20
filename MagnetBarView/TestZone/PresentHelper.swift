//
//  PresentHelper.swift
//  MagnetBarView
//
//  Created by 김기림 on 2022/04/14.
//

import UIKit

class PresentHelper: UIViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let vc = MagnetBarView()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
    }
}
