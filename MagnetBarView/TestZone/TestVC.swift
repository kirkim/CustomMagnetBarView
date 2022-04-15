//
//  TestVC.swift
//  MagnetBarView
//
//  Created by 김기림 on 2022/04/15.
//

import UIKit
import SnapKit

class TestVC: UIViewController {
    let testView = MagnetInfoNavBar()
    let testView2 = DelieveryInfoView()
    let testView3 = TakeoutInfoView()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        self.view.backgroundColor = .white
        
        [testView, testView2, testView3].forEach {
            self.view.addSubview($0)
        }
        
        testView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(50)
            $0.leading.trailing.equalToSuperview()
        }
        
        testView2.snp.makeConstraints {
            $0.top.equalTo(self.testView.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview()
        }
        
        testView3.snp.makeConstraints {
            $0.top.equalTo(self.testView2.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview()
        }
    }
}
