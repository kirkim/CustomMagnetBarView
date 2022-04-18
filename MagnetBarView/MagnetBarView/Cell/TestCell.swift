//
//  TestCell.swift
//  MagnetBarView
//
//  Created by 김기림 on 2022/04/13.
//

import SnapKit
import UIKit
import Reusable

class TestCell: UICollectionViewCell, Reusable {
    private let titleLabel = UILabel()
    private let descriptionLabel1 = UILabel()
    private let descriptionLabel2 = UILabel()
    private let priceLabel = UILabel()
    private let thumbnailView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func attribute() {
        self.titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        
        [descriptionLabel1, descriptionLabel2].forEach {
            $0.numberOfLines = 1
            $0.lineBreakMode = .byTruncatingTail
            $0.font = .systemFont(ofSize: 13, weight: .light)
            $0.textColor = .systemGray
        }
        self.backgroundColor = .white
    }
    
    func setData(data: Sample) {
        self.titleLabel.text = data.title
        self.descriptionLabel1.text = data.description1
        self.descriptionLabel2.text = data.description2
        self.priceLabel.text = data.price?.parsingToKoreanPrice()
        let image = UIImage(named: data.thumbnail ?? "review1.jpeg")
        self.thumbnailView.image = image
    }
    
    private func layout() {
        [titleLabel, descriptionLabel1, descriptionLabel2, priceLabel, thumbnailView].forEach {
            self.addSubview($0)
        }
        let topMargin:CGFloat = 15
        let leftMargin:CGFloat = 20
        
        thumbnailView.snp.makeConstraints {
            $0.top.equalTo(self.contentView).offset(topMargin)
            $0.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(self.contentView).inset(topMargin)
            $0.width.equalTo(self.contentView.frame.height - topMargin*2)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.contentView).offset(topMargin)
            $0.leading.equalTo(self.contentView).offset(leftMargin)
            $0.trailing.equalTo(thumbnailView.snp.leading)
        }
        
        priceLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.equalTo(self.contentView).offset(leftMargin)
            $0.trailing.equalTo(thumbnailView.snp.leading)
        }
        
        descriptionLabel1.snp.makeConstraints {
            $0.top.equalTo(priceLabel.snp.bottom).offset(10)
            $0.leading.equalTo(self.contentView).offset(leftMargin)
            $0.trailing.equalTo(thumbnailView.snp.leading)
        }
        
        descriptionLabel2.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel1.snp.bottom).offset(2)
            $0.leading.equalTo(self.contentView).offset(leftMargin)
            $0.trailing.equalTo(thumbnailView.snp.leading)
        }
    }
}
