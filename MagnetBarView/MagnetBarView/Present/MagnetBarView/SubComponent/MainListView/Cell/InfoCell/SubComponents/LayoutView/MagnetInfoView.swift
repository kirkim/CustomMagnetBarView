//
//  MagnetInfoView.swift
//  MagnetBarView
//
//  Created by 김기림 on 2022/04/15.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

class MagnetInfoView: UIView {
    let nav = MagnetInfoNavBar()
    
    let infoContainer = UIView()
    let deliveryInfo = DelieveryInfoView()
    let takeoutInfo = TakeoutInfoView()

    let reviewCollectionView = MagnetInfoCollectionView()
    
    private let disposeBag = DisposeBag()
    
    let windowWidth:CGFloat = (UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate).windowWidth!
    let leftMargin:CGFloat = 20
    
    init() {
        super.init(frame: CGRect.zero)
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: MagnetInfoViewModel) {
        let navViewModel = viewModel.navViewModel
        let collectionViewModel = viewModel.infoCollectionViewModel
        
        nav.bind(navViewModel)
        reviewCollectionView.bind(collectionViewModel)
        
        navViewModel.buttonChanged
            .emit { type in
                switch type {
                case .delivery:
                    self.infoContainer.frame.origin.x = self.leftMargin
                case .takeout:
                    self.infoContainer.frame.origin.x = self.leftMargin - self.frame.width
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        self.backgroundColor = .white
    }
    
    private func layout() {
        [nav, infoContainer, reviewCollectionView].forEach {
            self.addSubview($0)
        }
        
        [deliveryInfo, takeoutInfo].forEach {
            infoContainer.addSubview($0)
        }

        deliveryInfo.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
            $0.width.equalTo(self.windowWidth)
        }

        takeoutInfo.snp.makeConstraints {
            $0.trailing.top.bottom.equalToSuperview()
            $0.width.equalTo(self.windowWidth)
        }

        nav.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        
        infoContainer.snp.makeConstraints {
            $0.top.equalTo(self.nav.snp.bottom).offset(30)
            $0.leading.equalToSuperview().offset(leftMargin)
            $0.width.equalTo(self.windowWidth * 2)
        }
        
        reviewCollectionView.snp.makeConstraints {
            $0.top.equalTo(infoContainer.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(leftMargin)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(100)
        }
        
        self.snp.makeConstraints {
            $0.bottom.equalTo(reviewCollectionView)
        }
    }
}
