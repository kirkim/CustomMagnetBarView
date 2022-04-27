//
//  TestView.swift
//  MagnetBarView
//
//  Created by 김기림 on 2022/04/15.
//

import UIKit
import SnapKit

class TestView: UIView {
    let testView = MagnetSummaryReviewView()
    
    init() {
        super.init(frame: CGRect.zero)
        setUI()
//        testView.bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        self.backgroundColor = .white
        
        [testView].forEach {
            self.addSubview($0)
        }
        
        testView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(100)
        }
    }
}
