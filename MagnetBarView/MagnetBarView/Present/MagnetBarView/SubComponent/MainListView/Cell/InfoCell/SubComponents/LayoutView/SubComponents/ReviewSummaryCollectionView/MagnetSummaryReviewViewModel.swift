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
    case review(row: Int)
    case popReviewVC
}

struct MagnetSummaryReviewViewModel {
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
                    return MagnetInfoCellType.review(row: indexPath.row)
                }
            })
            .asSignal(onErrorJustReturn: .popReviewVC)
    }
}


