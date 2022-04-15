//
//  MagnetInfoCell.swift
//  MagnetBarView
//
//  Created by 김기림 on 2022/04/15.
//

import SnapKit
import UIKit
import Reusable

class MagnetInfoCell: UITableViewCell, Reusable {
    let infoView = MagnetInfoView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func attribute() {
        
    }
    
    private func layout() {
        self.addSubview(infoView)
        
        infoView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
