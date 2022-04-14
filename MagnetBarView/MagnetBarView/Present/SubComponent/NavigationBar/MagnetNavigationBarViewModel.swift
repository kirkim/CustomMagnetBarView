//
//  MagnetNavigationBarViewModel.swift
//  MagnetBarView
//
//  Created by 김기림 on 2022/04/14.
//

import UIKit
import RxCocoa

struct MagnetNavigationBarViewModel {
    // ParentView -> ViewModel
    let scrolled = PublishRelay<CGFloat>()
    
    // ViewModel -> View
    let transItem: Signal<CGFloat>
    
    init() {
        transItem = scrolled.asSignal()
        
    }
}
