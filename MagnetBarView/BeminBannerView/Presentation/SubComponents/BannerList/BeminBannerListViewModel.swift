//
//  RxBannerCollectionViewModel.swift
//  RefactoringBannerUsingRxSwift
//
//  Created by 김기림 on 2022/03/21.
//

import UIKit
import RxSwift
import RxCocoa

struct BeminBannerListViewModel {
    let cellImageName: Driver<[String]>
    let nowPage = BehaviorSubject<Int>(value: 0)
    
    // View -> ViewModel
    let cellClicked = PublishRelay<IndexPath>()
    
    // ViewModel -> parentView
    let presentVC: Signal<IndexPath>
    
    init(bannerImageNames: [String]) {
        self.cellImageName = BehaviorSubject<[String]>(value: bannerImageNames)
        .asDriver(onErrorJustReturn: [])
        
        presentVC = cellClicked
            .asSignal(onErrorJustReturn: IndexPath(row: 0, section: 0))
    }
}
