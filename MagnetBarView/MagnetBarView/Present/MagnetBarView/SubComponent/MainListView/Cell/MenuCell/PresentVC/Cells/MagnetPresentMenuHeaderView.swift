//
//  MagnetPresentMenuHeaderView.swift
//  MagnetBarView
//
//  Created by 김기림 on 2022/05/01.
//

import UIKit
import SnapKit
import Reusable

class MagnetPresentMenuHeaderView: UICollectionReusableView, Reusable {
    private let titleLabel = UILabel()
    private let checkCountLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func attribute() {
        //Temp
        self.titleLabel.text = "가격"
        self.titleLabel.font = .systemFont(ofSize: 22, weight: .semibold)
        self.checkCountLabel.text = "2개 선택가능"
        self.checkCountLabel.font = .systemFont(ofSize: 20, weight: .medium)
    }
    
    private func layout() {
        [titleLabel, checkCountLabel].forEach {
            self.addSubview($0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        checkCountLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.trailing).offset(20)
            $0.centerY.equalToSuperview()
        }
    }
}
