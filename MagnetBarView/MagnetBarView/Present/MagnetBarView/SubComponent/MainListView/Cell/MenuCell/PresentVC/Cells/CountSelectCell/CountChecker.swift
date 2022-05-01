//
//  CountChecker.swift
//  MagnetBarView
//
//  Created by 김기림 on 2022/05/01.
//

import UIKit

class CountCheckerView: UIView {
    private let minusButton = UIButton()
    private let plusButton = UIButton()
    private let countLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func attribute() {
        self.minusButton.setImage(UIImage(systemName: "minus"), for: .normal)
        self.minusButton.tintColor = .black
        self.plusButton.setImage(UIImage(systemName: "plus"), for: .normal)
        self.plusButton.tintColor = .black
        self.countLabel.text = "1개"
        self.countLabel.textAlignment = .center
        
    }
    
    private func layout() {
        [minusButton, countLabel, plusButton].forEach {
            self.addSubview($0)
        }
        
        minusButton.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.3)
        }
        
        countLabel.snp.makeConstraints {
            $0.leading.equalTo(minusButton.snp.trailing)
            $0.top.bottom.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.4)
        }
        
        plusButton.snp.makeConstraints {
            $0.top.trailing.bottom.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.3)
        }
    }
}
