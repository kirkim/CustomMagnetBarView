//
//  MagnetReviewModel.swift
//  MagnetBarView
//
//  Created by 김기림 on 2022/04/28.
//

import UIKit
import RxSwift
import RxCocoa

struct ReviewJSONData: Codable {
    var reviews: [ReviewItem]
    var averageRating: CGFloat
}

class MagnetReviewModel {
    private let httpmanager = DeliveryHttpManager.shared
    private let storeHttpManager = MagnetBarHttpModel.shared
    private let disposeBag = DisposeBag()
    
    let data = PublishRelay<[MagnetReviewSectionModel]>()
    let reviewData = PublishRelay<MagnetReviewSectionModel>()
    let totalRatingData = PublishRelay<MagnetReviewSectionModel>()
//    var reviewData: MagnetReviewSectionModel?
//    var totalRatingData: MagnetReviewSectionModel?
//
//    let complete = PublishRelay<Bool>()
    
    private var reviewImageStorage: [Int : UIImage] = [:]
    
    init() {
        httpmanager.getFetch(type: .allReviews(storeCode: storeHttpManager.getStoreCode()))
            .subscribe(
                onSuccess: { [weak self] result in
                    switch result {
                    case .success(let data):
                        do {
                            let dataModel = try JSONDecoder().decode(ReviewJSONData.self, from: data)
//                            let data = [
//                                MagnetReviewSectionModel.totalRatingSection(items: [TotalRatingItem(totalCount: dataModel.reviews.count, averageRating: dataModel.averageRating)]),
//                                MagnetReviewSectionModel.reviewSection(items: dataModel.reviews)
//                            ]
//                            self?.data.accept(data)
                            self?.totalRatingData.accept(MagnetReviewSectionModel.totalRatingSection(items: [TotalRatingItem(totalCount: dataModel.reviews.count, averageRating: dataModel.averageRating)]))
                            self?.reviewData.accept(MagnetReviewSectionModel.reviewSection(items: dataModel.reviews))
//                            self?.totalRatingData = MagnetReviewSectionModel.totalRatingSection(items: [TotalRatingItem(totalCount: dataModel.reviews.count, averageRating: dataModel.averageRating)])
//                            self?.reviewData = MagnetReviewSectionModel.reviewSection(items: dataModel.reviews)
//                            self?.complete.accept(true)
                        } catch {
                            print("decoding error: ", error.localizedDescription)
                        }
                    case .failure(let error):
                        print("fail: ", error.localizedDescription)
                    }
                
            }, onFailure: { error in
                print("error: ", error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    func makeReviewImage(index: Int, url: String?) -> UIImage? {
        guard let url = url else {
            return nil
        }
        
        if (reviewImageStorage[index] != nil) {
            return reviewImageStorage[index]!
        } else {
            let url = URL(string: url)
            let data = try? Data(contentsOf: url!)
            let image = UIImage(data: data!)
            if let image = image { self.reviewImageStorage.updateValue(image, forKey: index) }
            return image ?? UIImage()
        }
    }

}
