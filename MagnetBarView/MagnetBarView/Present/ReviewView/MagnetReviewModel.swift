//
//  MagnetReviewModel.swift
//  MagnetBarView
//
//  Created by 김기림 on 2022/04/28.
//

import UIKit
import RxSwift
import RxCocoa



class MagnetReviewModel {
    private let disposeBag = DisposeBag()
    private let httpManager = MagnetReviewHttpManager.shared
    private var reviewImageStorage: [Int : UIImage] = [:]
    
    init() {
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
    
    func getData(hasPhoto: Bool) -> [MagnetReviewSectionModel] {
        guard let totalRatingData = self.httpManager.totalRatingData,
              let reviewData = self.httpManager.reviewData else { return [] }
        guard hasPhoto == false else { return [totalRatingData, reviewData] }
        let items = (reviewData.items as! [ReviewItem]).filter { item in
            return item.photoUrl != nil
        }
        return [totalRatingData, MagnetReviewSectionModel.reviewSection(items: items)]
    }
}
