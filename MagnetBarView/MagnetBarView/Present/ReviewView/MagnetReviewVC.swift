//
//  MagnetReviewView.swift
//  MagnetBarView
//
//  Created by 김기림 on 2022/04/18.
//

import UIKit
import SnapKit

class MagnetReviewVC: UIViewController {
    private let tempTitleLabel = UILabel()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func attribute() {
        self.view.backgroundColor = .white
        self.tempTitleLabel.text = "sample ReviewPage"
        self.tempTitleLabel.font = .systemFont(ofSize: 40, weight: .bold)
        self.tempTitleLabel.textColor = .green
        self.tempTitleLabel.textAlignment = .center
    }
    
    private func layout() {
        [tempTitleLabel].forEach {
            self.view.addSubview($0)
        }
        
        tempTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(50)
            $0.leading.trailing.equalToSuperview()
        }
    }
}
