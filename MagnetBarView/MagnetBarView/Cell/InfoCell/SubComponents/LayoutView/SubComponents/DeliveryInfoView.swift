//
//  DeliveryInfo.swift
//  MagnetBarView
//
//  Created by 김기림 on 2022/04/15.
//

import UIKit

class DelieveryInfoView: UIView {
    let deliveryPriceLabel = UILabel()
    let minPriceLabel = UILabel()
    let section1 = UILabel()
    let section2 = UILabel()
    
    init() {
        super.init(frame: CGRect.zero)
        attribute()
        layout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //TODO: 나중에 ViewModel에서 가격정보 얻어오도록 구현
    func bind() {
        deliveryPriceLabel.text = 2000.parsingToKoreanPrice()
        minPriceLabel.text = 20000.parsingToKoreanPrice()
    }
    
    private func attribute() {
        self.section1.text = "배달비"
        self.section2.text = "최소주문"
        
        [section1, section2, deliveryPriceLabel, minPriceLabel].forEach {
            $0.font = .systemFont(ofSize: 17, weight: .light)
            $0.textColor = .black
        }
    }
    
    private func layout() {
        [section1, section2, deliveryPriceLabel, minPriceLabel].forEach {
            self.addSubview($0)
        }
        
        let sectionWidth:CGFloat = 100
        
        section1.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
            $0.width.equalTo(sectionWidth)
        }
        
        section2.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalTo(section1.snp.bottom).offset(10)
            $0.width.equalTo(sectionWidth)
        }
        
        deliveryPriceLabel.snp.makeConstraints {
            $0.leading.equalTo(section1.snp.trailing)
            $0.top.equalTo(section1)
        }
        
        minPriceLabel.snp.makeConstraints {
            $0.leading.equalTo(section2.snp.trailing)
            $0.top.equalTo(section2)
        }
        
        self.snp.makeConstraints {
            $0.bottom.equalTo(section2)
        }
    }
}
