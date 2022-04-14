//
//  TestCell.swift
//  MagnetBarView
//
//  Created by 김기림 on 2022/04/13.
//

import SnapKit
import UIKit
import Reusable

class TestCell: UITableViewCell, Reusable {
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func attribute() {
        self.titleLabel.backgroundColor = .blue
        self.descriptionLabel.backgroundColor = .red
    }
    
    func setData(data: Sample) {
        self.titleLabel.text = data.title
        self.descriptionLabel.text = data.description
    }
    
    private func layout() {
        [titleLabel, descriptionLabel].forEach {
            self.addSubview($0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.top.equalTo(contentView)
            $0.height.equalTo(50)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(10)
            $0.height.equalTo(50)
        }
    }
}
