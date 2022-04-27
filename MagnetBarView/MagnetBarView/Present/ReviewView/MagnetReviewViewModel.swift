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
            ReviewItem(reviewId: 1, userId: "제니", rating: 5, description: "sdfds", photoUrl: "space_bread1.jpeg", createAt: "1231"),
            ReviewItem(reviewId: 2, userId: "제니", rating: 5, description: "sdfds", photoUrl: "space_bread2.jpeg", createAt: "123"),
            ReviewItem(reviewId: 3, userId: "제니", rating: 5, description: "sdfdssdfdssdfdssdfdssdfdssdfdssdfdssdfdssdfdssdfdssdfdssdfdssdfdssd\nfdssdfdssdfdssdfdssdfdssdfdssdfdssdfdssdfdssdfdssdfdssdfdssdfdssdfdssdfdssdfdssdfdssdfdssdfdssdfdssdfdssdfdssdfdssdfdssdfdssdfdssdfdssdfdssdfds", photoUrl: "space_bread3.jpeg", createAt: "123123")
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
