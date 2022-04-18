//
//  MagnetInfoCollectionViewModel.swift
//  MagnetBarView
//
//  Created by 김기림 on 2022/04/15.
//

import UIKit
import RxCocoa
import RxSwift

enum MagnetInfoCellType {
    case review(indexPath: IndexPath)
    case popReviewVC
}

struct MagnetInfoCollectionViewModel {
    // View -> ViewModel
    let cellClicked = PublishRelay<IndexPath>()
    
    // ViewMoel -> ParentViewModel
    let popVC: Signal<MagnetInfoCellType>
    
    init() {
        popVC = cellClicked
            .map({ indexPath -> MagnetInfoCellType in
                if (indexPath.row == 3) {
                    return MagnetInfoCellType.popReviewVC
                } else {
                    return MagnetInfoCellType.review(indexPath: indexPath)
                }
            })
            .asSignal(onErrorJustReturn: .popReviewVC)
    }
}


