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
    private let titleView = UIView()
    private let titleLabel = UILabel()
    var titleLabelX: CGFloat = 0
    var titleLabelY: CGFloat = 0
    var titleLabelXValue: CGFloat = 0
    let titleLabelBottom: CGFloat = 45
    let titleLabelLeading: CGFloat = 50
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: MagnetHeaderViewModel) {
        titleLabelX = titleLabel.frame.origin.x
        titleLabelY = titleLabel.frame.origin.y
        titleLabelXValue = titleLabelX - titleLabelLeading

        viewModel.movingItem
            .emit { offset in
                let headerDistance = MagnetBarView.headerMovingDistance
                
                self.titleLabel.frame.origin.x = offset <= 0 ? self.titleLabelX + offset * self.titleLabelXValue/headerDistance : self.titleLabelX
                self.titleLabel.frame.origin.y = offset <= 0 ? self.titleLabelY - offset * self.titleLabelBottom/headerDistance : self.titleLabelY
                self.titleView.backgroundColor = .white.withAlphaComponent(offset / headerDistance + 1)
                self.titleLabel.textColor = .black.withAlphaComponent(offset / headerDistance + 1)
            }
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        titleLabel.text = "hello"
        titleLabel.font = .systemFont(ofSize: 35)
        titleLabel.textColor = .black
        
        self.backgroundColor = .clear
        titleView.backgroundColor = .white
    }
    
    private func layout() {
        [titleView, titleLabel].forEach {
            self.addSubview($0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(titleLabelBottom)
        }
        
        titleView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().inset(30)
            $0.bottom.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.top).inset(-20)
        }
    }
}
