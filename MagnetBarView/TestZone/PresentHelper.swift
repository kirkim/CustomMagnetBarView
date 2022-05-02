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
//        let vc = MagnetReviewVC(indexPath: nil)
        let vc = MagnetPresentMenuVC()
        self.navigationController?.pushViewController(vc, animated: true)
        self.navigationItem.backButtonTitle = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
    }
}
