//
//  BannerCell.swift
//  MagnetBarView
//
//  Created by 김기림 on 2022/04/14.
//

import SnapKit
import UIKit
import Reusable

class BannerCell: UITableViewCell, Reusable {
    private let banner = BeminBannerView(
        data: BannerSources(
            bannerType: .basic,
            sources: [
                BannerSource(bannerCellImageName: "space_bread1.jpeg", presentVC: UIViewController()),
                BannerSource(bannerCellImageName: "space_bread2.jpeg", presentVC: UIViewController()),
                BannerSource(bannerCellImageName: "space_bread3.jpeg", presentVC: UIViewController())
            ]
        )
    )
    
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
    
    func setData(data: Sample) {

    }
    
    private func layout() {
        [banner].forEach {
            self.addSubview($0)
        }
        
        banner.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        banner.moveButtonLayout(bottom: 60, trailing: 30)
    }
}
