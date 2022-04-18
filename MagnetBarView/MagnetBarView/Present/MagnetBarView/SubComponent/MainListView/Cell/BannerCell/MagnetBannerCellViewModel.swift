//
//  MagnetBannerCellViewModel.swift
//  MagnetBarView
//
//  Created by 김기림 on 2022/04/18.
//

import UIKit
import RxCocoa
import RxSwift

struct MagnetBannerCellViewModel {
    let mainHeaderViewModel = MagnetHeaderViewModel()
    private let disposeBag = DisposeBag()
    
    // ParentView -> ViewModel
    let scrolled = PublishRelay<(CGFloat, CGFloat)>()
    
    init() {
        scrolled
            .bind(to: mainHeaderViewModel.scrolled)
            .disposed(by: disposeBag)
    }
}
