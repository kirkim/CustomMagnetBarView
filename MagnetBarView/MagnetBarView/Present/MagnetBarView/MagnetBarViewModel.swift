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
    let mainNavigationBarViewModel = MagnetNavigationBarViewModel()
    let mainListViewModel = MagnetListViewModel()
    let stickyHeaderViewModel: RemoteMainListBarViewModel
    
    // viewModel -> View
    let presentReviewVC: Signal<MagnetReviewVC>
    let stickyHeaderOn: Signal<Bool>
    
    init() {
        self.stickyHeaderViewModel = mainListViewModel.stickyViewModel
        
        mainListViewModel.scrollEvent
            .bind(to: mainListViewModel.bannerCellViewModel.movingHeaderView)
            .disposed(by: disposeBag)
        
        mainListViewModel.scrollEvent
            .bind(to: mainNavigationBarViewModel.scrolled)
            .disposed(by: disposeBag)
        
        presentReviewVC = mainListViewModel.presentReviewVC
        
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
