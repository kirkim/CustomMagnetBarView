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
    private let titleLabel = UILabel()
    private let windowWidth = (UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate).windowWidth!
    let titleScaleRatio: CGFloat = 0.7
    var titleLabelX: CGFloat = 0
    var titleLabelY: CGFloat = 0
    let titleLabelBottom: CGFloat = 45
    let titleLabelLeading: CGFloat = 55 // MagnetNavigationBar의 타이틀 라벨의 leading값보다 약간 여유 있게 둔다 (5 정도)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: MagnetHeaderViewModel) {
        let offsetOriginY = self.calculateTitleSize(title: "s", fontSize: MagnetNavigationBar.titleFontSize/titleScaleRatio).height - self.calculateTitleSize(title: "s", fontSize: MagnetNavigationBar.titleFontSize).height + self.titleLabelBottom
        let titleLabelXValue = titleLabelX - titleLabelLeading

        viewModel.movingItem
            .emit { offset, maxOffset in
                let offsetRatio = offset / maxOffset
                self.titleLabel.frame.origin.x = offset <= 0 ? self.titleLabelX + offsetRatio * titleLabelXValue : self.titleLabelX
                self.titleLabel.frame.origin.y = offset <= 0 ? self.titleLabelY - offsetRatio * offsetOriginY : self.titleLabelY
                let titleScale = min(max(1.0 + offsetRatio, self.titleScaleRatio), 1.0)
                let headerScale = max(min(1.0 - offsetRatio*0.2, 1.2), 1.0)
                self.transform = CGAffineTransform(scaleX: headerScale, y: 1)
                self.titleLabel.transform = CGAffineTransform(scaleX: titleScale*(1/headerScale), y: titleScale) // 보정값
            }
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        titleLabel.font = .systemFont(ofSize: MagnetNavigationBar.titleFontSize/titleScaleRatio)
        titleLabel.textColor = .black
        
        self.backgroundColor = .white
    }
    
    func setTitle(title: String) {
        titleLabel.text = title
    }
    
    func layout() {
        [titleLabel].forEach {
            self.addSubview($0)
        }

        let titleSize = calculateTitleSize(title: self.titleLabel.text!, fontSize: MagnetNavigationBar.titleFontSize/titleScaleRatio)
        titleLabelX = (self.windowWidth - titleSize.width)/2 - 20
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
