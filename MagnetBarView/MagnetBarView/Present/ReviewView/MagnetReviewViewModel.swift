//
//  MagnetReviewViewModel.swift
//  MagnetBarView
//
//  Created by 김기림 on 2022/04/25.
//

import UIKit
import RxDataSources

struct MagnetReviewViewModel {
    let data = [
        MagnetReviewSectionModel.totalRatingSection(items: [ TotalRatingItem(totalCount: 10, averageRating: 4)]),
        MagnetReviewSectionModel.reviewSection(items: [
            ReviewItem(userName: "제니", rating: 5, data: Date.now, description: "sdfds", imageUrl: "space_bread1.jpeg"),
            ReviewItem(userName: "제니", rating: 5, data: Date.now, description: "sdfds", imageUrl: "space_bread2.jpeg"),
            ReviewItem(userName: "제니", rating: 5, data: Date.now, description: "sdfdssdfdssdfdssdfdssdfdssdfdssdfdssdfdssdfdssdfdssdfdssdfdssdfdssd\nfdssdfdssdfdssdfdssdfdssdfdssdfdssdfdssdfdssdfdssdfdssdfdssdfdssdfdssdfdssdfdssdfdssdfdssdfdssdfdssdfdssdfdssdfdssdfdssdfdssdfdssdfdssdfdssdfds", imageUrl: "space_bread3.jpeg")
        ])
    ]
    
    
    func dataSource() -> RxTableViewSectionedReloadDataSource<MagnetReviewSectionModel> {
        let dataSource = RxTableViewSectionedReloadDataSource<MagnetReviewSectionModel>(
            configureCell: { dataSource, tableView, indexPath, item in
                switch dataSource[indexPath.section] {
                case .totalRatingSection(items: let items):
                    let cell = tableView.dequeueReusableCell(for: indexPath, cellType: MagnetReviewTotalRatingCell.self)
                    return cell
                case .reviewSection(items: let items):
                    let cell = tableView.dequeueReusableCell(withIdentifier: "MagnetReviewCell", for: indexPath) as! MagnetReviewCell
                    cell.setData(data: items[indexPath.row])
                    return cell
                }
                
            })
            
    
        return dataSource
    }
}
