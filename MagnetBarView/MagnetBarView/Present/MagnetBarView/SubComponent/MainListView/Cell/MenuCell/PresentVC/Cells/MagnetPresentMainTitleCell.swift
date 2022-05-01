//
//  MagnetPresentMainTitleCell.swift
//  MagnetBarView
//
//  Created by 김기림 on 2022/05/01.
//

import UIKit
import SnapKit
import Reusable

class MagnetPresentMainTitleCell: UICollectionViewCell, Reusable {
    private let mainPhotoView = UIImageView()
    private let headerLabelShadow = UIView()
    private let headerLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func attribute() {
        //Temp
        mainPhotoView.backgroundColor = .blue
        headerLabelShadow.backgroundColor = .clear
        headerLabel.backgroundColor = .red
        mainPhotoView.image = UIImage(named: "review1")
        
        headerLabel.text = "hello"
        headerLabel.textAlignment = .center
        headerLabel.font = .systemFont(ofSize: 30, weight: .medium)
        headerLabel.layer.cornerRadius = 10
        headerLabel.layer.masksToBounds = true
        
        headerLabelShadow.layer.shadowColor = UIColor.black.cgColor // 색깔
        headerLabelShadow.layer.masksToBounds = false  // 내부에 속한 요소들이 UIView 밖을 벗어날 때, 잘라낼 것인지. 그림자는 밖에 그려지는 것이므로 false 로 설정
        headerLabelShadow.layer.shadowOffset = CGSize(width: 2, height: 4) // 위치조정
        headerLabelShadow.layer.shadowRadius = 2 // 반경
        headerLabelShadow.layer.shadowOpacity = 0.5 // alpha값
    }
    
    private func layout() {
        [mainPhotoView, headerLabelShadow].forEach {
            self.addSubview($0)
        }
        
        let windowWidth = MagnetBarViewMath.windowWidth
        
        mainPhotoView.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview()
            $0.height.equalTo(windowWidth)
        }
        
        let headerViewHeight = 60
        
        headerLabelShadow.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(windowWidth*0.9)
            $0.height.equalTo(headerViewHeight)
            $0.bottom.equalTo(mainPhotoView).offset(headerViewHeight/2)
        }
        
        headerLabelShadow.addSubview(headerLabel)
        headerLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
