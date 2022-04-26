//
//  MagnetReviewTotalRatingCell.swift
//  MagnetBarView
//
//  Created by 김기림 on 2022/04/26.
//

import UIKit
import SnapKit
import Reusable

class MagnetReviewTotalRatingCell: UITableViewCell, Reusable {
    private let totalRatingLabel = UILabel()
    private let starLabel = UILabel()
    private let countDescription = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
        attribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func attribute() {
        self.selectionStyle = .none
        self.totalRatingLabel.font = .systemFont(ofSize: 60, weight: .bold)
        self.totalRatingLabel.text = "5.0"
        self.starLabel.text = "★★★★★"
        self.starLabel.font = .systemFont(ofSize: 25, weight: .bold)
        self.starLabel.textColor = .systemYellow
        self.countDescription.text = "리뷰 290개"
    }
    
    private func layout() {
        [totalRatingLabel, starLabel, countDescription].forEach {
            self.addSubview($0)
        }
        
        totalRatingLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(20)
        }
        
        starLabel.snp.makeConstraints {
            $0.top.equalTo(totalRatingLabel)
            $0.leading.equalTo(totalRatingLabel.snp.trailing).offset(30)
        }
        
        countDescription.snp.makeConstraints {
            $0.top.equalTo(starLabel.snp.bottom).offset(5)
            $0.leading.equalTo(starLabel)
        }
    }
}
