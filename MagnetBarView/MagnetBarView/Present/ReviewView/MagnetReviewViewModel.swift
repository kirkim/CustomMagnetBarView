//
//  MagnetReviewViewModel.swift
//  MagnetBarView
//
//  Created by 김기림 on 2022/04/25.
//

import UIKit
import RxDataSources
import RxCocoa

struct MagnetReviewViewModel {
    let model = MagnetReviewModel()
    let data: Driver<[MagnetReviewSectionModel]>
    
    init() {
        data = model.data.asDriver(onErrorJustReturn: [])
    }
    
    func dataSource() -> RxTableViewSectionedReloadDataSource<MagnetReviewSectionModel> {
        let dataSource = RxTableViewSectionedReloadDataSource<MagnetReviewSectionModel>(
            configureCell: { dataSource, tableView, indexPath, item in
                switch dataSource[indexPath.section] {
                case .totalRatingSection(items: let items):
                    let cell = tableView.dequeueReusableCell(for: indexPath, cellType: MagnetReviewTotalRatingCell.self)
                    return cell
                case .reviewSection(items: let items):
                    let cell = tableView.dequeueReusableCell(withIdentifier: "MagnetReviewCell", for: indexPath) as! MagnetReviewCell
                    cell.setData(data: items[indexPath.row], image: self.model.makeReviewImage(index: indexPath.row, url: items[indexPath.row].photoUrl!))
                    return cell
                }
                
            })
            
    
        return dataSource
    }
}
