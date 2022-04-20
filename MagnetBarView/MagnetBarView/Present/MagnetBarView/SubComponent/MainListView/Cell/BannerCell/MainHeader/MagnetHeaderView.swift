//
//  MainHeaderView.swift
//  MagnetBarView
//
//  Created by 김기림 on 2022/04/14.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class MagnetHeaderView: UIView {
    private let disposeBag = DisposeBag()
    private let backGroundView = UIView()
    private let titleLabel = UILabel()
    private let windowWidth = (UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate).windowWidth!
    let backGroundViewSideMargin: CGFloat = 20
    let titleScaleRatio: CGFloat = 0.7
    var titleLabelX: CGFloat = 0
    var titleLabelY: CGFloat = 0
    let titleLabelBottom: CGFloat = 50
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: MagnetHeaderViewModel) {
        let afterFontHeight = self.calculateTitleSize(title: "s", fontSize: MagnetNavigationBar.titleFontSize).height
        let offsetOriginY = MagnetBannerCell.headerViewHeight - (afterFontHeight + MagnetNavigationBar.titleBottomMargin) - self.titleLabelY
        let offsetOriginX = titleLabelX - MagnetNavigationBar.titleLeftMargin
        let widthRatio = backGroundViewSideMargin*2/(self.windowWidth-backGroundViewSideMargin*2)
        
        viewModel.movingItem
            .emit { offset, maxOffset in
                let offsetRatio = offset / maxOffset
                let titleScale = min(max(1.0 + (1-self.titleScaleRatio)*offsetRatio, self.titleScaleRatio), 1.0)
                let headerScale = max(min(1.0 - offsetRatio*widthRatio, 1.0 + widthRatio), 1.0)
                
                self.titleLabel.frame.origin.x = offset < 0 ? self.titleLabelX + offsetRatio * offsetOriginX : self.titleLabelX
                self.titleLabel.frame.origin.y = offset < 0 ? self.titleLabelY-1 - offsetRatio * offsetOriginY : self.titleLabelY
                self.backGroundView.transform = CGAffineTransform(scaleX: headerScale, y: 1)
                self.titleLabel.transform = CGAffineTransform(scaleX: titleScale, y: titleScale)
            }
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        self.backgroundColor = .clear
        titleLabel.textColor = .black
        titleLabel.font = UIFont(name: "Helvetica", size: MagnetNavigationBar.titleFontSize/titleScaleRatio)
        
        self.backGroundView.backgroundColor = .white
        backGroundView.layer.shadowColor = UIColor.black.cgColor // 색깔
        backGroundView.layer.masksToBounds = false  // 내부에 속한 요소들이 UIView 밖을 벗어날 때, 잘라낼 것인지. 그림자는 밖에 그려지는 것이므로 false 로 설정
        backGroundView.layer.shadowOffset = CGSize(width: 0, height: 4) // 위치조정
        backGroundView.layer.shadowRadius = 5 // 반경
        backGroundView.layer.shadowOpacity = 0.3 // alpha값
    }
    
    func setTitle(title: String) {
        titleLabel.text = title
    }
    
    func layout() {
        [backGroundView, titleLabel].forEach {
            self.addSubview($0)
        }

        backGroundView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(backGroundViewSideMargin)
            $0.trailing.equalToSuperview().inset(backGroundViewSideMargin)
        }
        
        let titleSize = calculateTitleSize(title: self.titleLabel.text!, fontSize: MagnetNavigationBar.titleFontSize/titleScaleRatio)
        titleLabelX = (self.windowWidth - titleSize.width)/2
        titleLabelY = MagnetBannerCell.headerViewHeight - titleSize.height - titleLabelBottom
        titleLabel.frame = CGRect(x: titleLabelX, y: titleLabelY, width: titleSize.width, height: titleSize.height)
    }
    
    private func calculateTitleSize(title: String, fontSize: CGFloat) -> CGSize {
        let font = UIFont(name: "Helvetica", size: fontSize)
        let fontAttributes = [NSAttributedString.Key.font: font]
        let text = title
        let size = (text as NSString).size(withAttributes: fontAttributes as [NSAttributedString.Key : Any])
        return size
    }
}
