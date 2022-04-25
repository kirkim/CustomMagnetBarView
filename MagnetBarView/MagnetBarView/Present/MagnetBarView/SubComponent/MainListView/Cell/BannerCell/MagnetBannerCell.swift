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
    private let banner = BeminBannerView()
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
        banner.bind(viewModel.bannerViewModel)
    }
    
    func layout() {
        [banner, headerView].forEach {
            self.addSubview($0)
        }
        
        banner.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview()
            $0.height.equalTo(MagnetBarViewMath.windowWidth*8/13)
        }
        
        headerView.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-4)
            $0.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(MagnetBarViewMath.headerViewHeight)
        }
        
        headerView.layout()
    }
}
