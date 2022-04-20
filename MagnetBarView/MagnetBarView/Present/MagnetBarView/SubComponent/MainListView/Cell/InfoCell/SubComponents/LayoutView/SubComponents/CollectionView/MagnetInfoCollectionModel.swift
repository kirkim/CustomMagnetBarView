//
//  MagnetInfoCollectionModel.swift
//  MagnetBarView
//
//  Created by 김기림 on 2022/04/18.
//

import Foundation

struct MagnetInfoCollectionModel {
    let data = [
        InfoCollectionCellData(thumbnail: "review1.jpeg", review: "친구 추천으로 주문했는데, 진짜 홀딱 반했어요!!친구 추천으로 주문했는데, 진짜 홀딱 반했어요!!", rating: 5),
        InfoCollectionCellData(thumbnail: "review1.jpeg", review: "친구 추천으로 주문했는데, 진짜 홀딱 반했어요!!", rating: 5),
        InfoCollectionCellData(thumbnail: "review1.jpeg", review: "친구 추천으로 주문했는데, 진짜 홀딱 반했어요!!", rating: 5),
        InfoCollectionCellData(thumbnail: "", review: "", rating: 0)
    ]
    
    init() {
        
    }
}
