//
//  MagnetReviewHeaderCell.swift
//  MagnetBarView
//
//  Created by 김기림 on 2022/04/25.
//

import SnapKit
import UIKit
import Reusable

class MagnetReviewHeaderCell: UITableViewHeaderFooterView, Reusable {
    private let checkPhotoLabel = UILabel()
    private let sortLabel = UILabel()
    
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        layout()
        attribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func attribute() {
        self.contentView.backgroundColor = .white
        self.sortLabel.font = .systemFont(ofSize: 20, weight: .medium)
        self.sortLabel.text = "최신순  "
        self.checkPhotoLabel.font = .systemFont(ofSize: 20, weight: .medium)
        self.checkPhotoLabel.textColor = .systemBlue
        self.checkPhotoLabel.text = "☑ 포토리뷰"
    }
    
    private func layout() {
        [checkPhotoLabel, sortLabel].forEach {
            self.contentView.addSubview($0)
        }
        
        checkPhotoLabel.snp.makeConstraints {
            $0.top.equalTo(self.contentView).offset(10)
            $0.leading.equalTo(self.contentView).offset(20)
        }
        
        sortLabel.snp.makeConstraints {
            $0.top.equalTo(checkPhotoLabel)
            $0.trailing.equalTo(self.contentView).inset(20)
        }
    }
}
