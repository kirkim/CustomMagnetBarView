//
//  SubmitTapView.swift
//  MagnetBarView
//
//  Created by 김기림 on 2022/05/01.
//

import UIKit

class MagnetSubmitTapView: UIView {
    private let minPriceLabel = UILabel()
    private let submitTapView = UIView()
    private let submitTitleLabel = UILabel()
    private let submitPriceLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func attribute() {
        self.backgroundColor = .white
        self.submitTapView.backgroundColor = .systemMint
        self.submitTapView.layer.cornerRadius = 5
        self.minPriceLabel.font = .systemFont(ofSize: 14, weight: .light)
        self.submitTitleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        self.submitPriceLabel.font = .systemFont(ofSize: 15, weight: .medium)
        self.submitTitleLabel.textColor = .white
        self.submitPriceLabel.textColor = .white
        
        //Temp
        self.minPriceLabel.text = "배달최소주문금액 23,000원"
        self.minPriceLabel.textColor = .darkGray
        self.submitTitleLabel.text = "1개 담기"
        self.submitPriceLabel.text = 25000.parsingToKoreanPrice()
    }
    
    private func layout() {
        [minPriceLabel, submitTapView].forEach {
            self.addSubview($0)
        }
        
        minPriceLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.centerX.equalToSuperview()
        }
        
        submitTapView.snp.makeConstraints {
            $0.top.equalTo(minPriceLabel.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(MagnetBarViewMath.windowWidth*0.9)
            $0.bottom.equalToSuperview().offset(-40)
        }
        
        [submitTitleLabel, submitPriceLabel].forEach {
            submitTapView.addSubview($0)
        }
        
        submitTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        submitPriceLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
        }
    }
}
