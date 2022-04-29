//
//  MagnetReviewViewModel.swift
//  MagnetBarView
//
//  Created by 김기림 on 2022/04/25.
//

import UIKit
import RxDataSources
import RxCocoa
import RxSwift

class MagnetReviewViewModel {
    let model = MagnetReviewModel()
    let headerViewModel = MagnetReviewHeaderCellViewModel()
//    let data = PublishRelay<[MagnetReviewSectionModel]>()
    let data: Driver<[MagnetReviewSectionModel]>
    
    let disposeBag = DisposeBag()
    
    init() {
        data = Observable.combineLatest(model.reviewData, model.totalRatingData, headerViewModel.hasPhoto.share()) { review, totalRating, hasPhoto in
            print("hello")
            guard hasPhoto == false else { return [totalRating, review] }
            let items = (review.items as! [ReviewItem]).filter { item in
                return item.photoUrl != nil
            }
            return [totalRating, MagnetReviewSectionModel.reviewSection(items: items)]
        }.asDriver(onErrorJustReturn: [])
        
//        headerViewModel.hasPhoto.map({ [weak self] isSelected -> [MagnetReviewSectionModel] in
//            guard let totalRatingData = self?.model.totalRatingData,
//                  let reviewData = self?.model.reviewData else { return [] }
//            guard isSelected == false else { return [totalRatingData, reviewData] }
//            let items = (reviewData.items as! [ReviewItem]).filter { item in
//                return item.photoUrl != nil
//            }
//            return [totalRatingData, MagnetReviewSectionModel.reviewSection(items: items)]
//        })
//        .bind(to: data)
//        .disposed(by: disposeBag)
    }
    
    func dataSource() -> RxTableViewSectionedReloadDataSource<MagnetReviewSectionModel> {
        let dataSource = RxTableViewSectionedReloadDataSource<MagnetReviewSectionModel>(
            configureCell: { dataSource, tableView, indexPath, item in
                switch dataSource[indexPath.section] {
                case .totalRatingSection(items: let items):
                    let cell = tableView.dequeueReusableCell(for: indexPath, cellType: MagnetReviewTotalRatingCell.self)
                    cell.setData(data: items[indexPath.row])
                    return cell
                case .reviewSection(items: let items):
                    let cell = tableView.dequeueReusableCell(withIdentifier: "MagnetReviewCell", for: indexPath) as! MagnetReviewCell
                    cell.setData(data: items[indexPath.row], image: self.model.makeReviewImage(index: indexPath.row, url: items[indexPath.row].photoUrl))
                    return cell
                }
            })
        return dataSource
    }
}
