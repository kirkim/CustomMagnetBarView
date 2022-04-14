//
//  MainHeaderViewModel.swift
//  MagnetBarView
//
//  Created by 김기림 on 2022/04/14.
//

import UIKit
import RxCocoa

struct MagnetHeaderViewModel {
    // ParentView -> ViewModel
    let scrolled = PublishRelay<CGFloat>()
    
    // ViewModel -> View
    let movingItem: Signal<CGFloat>
    
    init() {
        movingItem = scrolled.asSignal()
        
    }
}
