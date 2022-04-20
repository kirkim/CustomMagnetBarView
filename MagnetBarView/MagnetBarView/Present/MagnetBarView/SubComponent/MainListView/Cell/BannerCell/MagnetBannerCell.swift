//
//  BannerCell.swift
//  MagnetBarView
//
//  Created by 김기림 on 2022/04/14.
//

import SnapKit
import UIKit
import Reusable

class MagnetBannerCell: UICollectionViewCell, Reusable {
    static let headerViewHeight:CGFloat = 150
    private let windowWidth = (UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate).windowWidth!
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
    private let headerView = MagnetHeaderView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func attribute() {
        self.backgroundColor = .white
    }
    
    func setData(title: String) {
        self.headerView.setTitle(title: title)
    }
    
    func bind(_ viewModel: MagnetBannerCellViewModel) {
        self.headerView.bind(viewModel.mainHeaderViewModel)
    }
    
    func layout() {
        [banner, headerView].forEach {
            self.addSubview($0)
        }
        
        banner.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview()
            $0.height.equalTo(windowWidth*8/13)
        }
        
        headerView.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-4)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(MagnetBannerCell.headerViewHeight)
        }
        
        headerView.layout()
    }
}
