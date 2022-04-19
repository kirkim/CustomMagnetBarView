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
    let stickyHeaderViewModel: RemoteMainListBarViewModel
    
    // viewModel -> View
    let presentVC = PublishRelay<UIViewController>()
    let stickyHeaderOn: Signal<Bool>
    
    init() {
        self.mainNavigationBarViewModel = MagnetNavigationBarViewModel(mainTitle: "aaaaa")
        self.mainListViewModel = MagnetListViewModel(mainTitle: "aaaaa")
        self.stickyHeaderViewModel = mainListViewModel.stickyViewModel
        
        mainListViewModel.scrollEvent
            .bind(to: mainListViewModel.bannerCellViewModel.scrolled)
            .disposed(by: disposeBag)
        
        mainListViewModel.scrollEvent
            .bind(to: mainNavigationBarViewModel.scrolled)
            .disposed(by: disposeBag)
        
        mainListViewModel.presentVC
            .emit(to: presentVC)
            .disposed(by: disposeBag)
        
        stickyHeaderOn = mainListViewModel.stickyHeaderOn.asSignal()
        
        stickyHeaderViewModel.slotChanged
            .bind(to: mainListViewModel.slotChanged)
            .disposed(by: disposeBag)
        
        mainListViewModel.changeSection
            .map({ sectionNumber in
                return IndexPath(row: sectionNumber - 1, section: 0)
            })
            .bind(to: stickyHeaderViewModel.slotChanging)
            .disposed(by: disposeBag)
    }
    
}
