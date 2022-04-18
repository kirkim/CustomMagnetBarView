//
//  TopNavigationBar.swift
//  MagnetBarView
//
//  Created by 김기림 on 2022/04/14.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class MagnetNavigationBar: UIView {
    static let titleFontSize:CGFloat = 30
    private let disposeBag = DisposeBag()
    let backButton = UIButton()
    let titleLabel = UILabel()
    let shareButton = UIButton()
    let likeButton = UIButton()
    
    init() {
        super.init(frame: CGRect.zero)
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: MagnetNavigationBarViewModel) {
        viewModel.transItem
            .emit { value, maxValue in
                let alpha = -value / maxValue
                self.backButton.tintColor = UIColor(white: 1 - alpha, alpha: 1)
                self.shareButton.tintColor = UIColor(white: 1 - alpha, alpha: 1)
                self.likeButton.tintColor = UIColor(red: 1 + alpha, green: 1 - alpha, blue: 1 - alpha, alpha: 1)
                if (-value >= maxValue-10) {
                    self.titleLabel.textColor = .black
                    self.backgroundColor = .white
                } else {
                    self.titleLabel.textColor = .black.withAlphaComponent(0)
                    self.backgroundColor = UIColor(white: 1, alpha: 0)
                }
                
            }
            .disposed(by: disposeBag)
        self.titleLabel.text = viewModel.mainTitle
    }
    
    private func attribute() {
        backButton.setImage(UIImage(systemName: "arrow.backward"), for: .normal)
        backButton.tintColor = .white
        
        shareButton.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        shareButton.tintColor = .white
        
        likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        likeButton.tintColor = .white
        
        titleLabel.textColor = .white.withAlphaComponent(0)
        titleLabel.font = .systemFont(ofSize: MagnetNavigationBar.titleFontSize)
    }
    
    private func layout() {
        [backButton, titleLabel, shareButton, likeButton].forEach {
            self.addSubview($0)
        }
        
        backButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(10)
            $0.leading.equalToSuperview().offset(20)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(50)
            $0.bottom.equalToSuperview()
        }
        
        likeButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(10)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        shareButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(10)
            $0.trailing.equalTo(likeButton.snp.leading).inset(-20)
        }
    }
}
