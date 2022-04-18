//
//  MagnetBarViewModel.swift
//  MagnetBarView
//
//  Created by 김기림 on 2022/04/14.
//

import UIKit
import RxCocoa
import RxSwift

struct MagnetBarViewModel {
    private let disposeBag = DisposeBag()
//    let mainHeaderViewModel = MagnetHeaderViewModel()
    let mainNavigationBarViewModel: MagnetNavigationBarViewModel
    let mainListViewModel: MagnetListViewModel
    
    // viewModel -> View
    let presentVC = PublishRelay<UIViewController>()
    
    init() {
        self.mainNavigationBarViewModel = MagnetNavigationBarViewModel(mainTitle: "aaaaa")
        self.mainListViewModel = MagnetListViewModel(mainTitle: "aaaaa")
        
        mainListViewModel.scrollEvent
            .bind(to: mainListViewModel.bannerCellViewModel.scrolled)
            .disposed(by: disposeBag)
        
        mainListViewModel.scrollEvent
            .bind(to: mainNavigationBarViewModel.scrolled)
            .disposed(by: disposeBag)
        
        mainListViewModel.presentVC
            .emit(to: presentVC)
            .disposed(by: disposeBag)
    }
    
}
