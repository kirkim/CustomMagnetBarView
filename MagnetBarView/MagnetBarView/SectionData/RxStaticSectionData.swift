//
//  RxStaticSectionData.swift
//  MagnetBarView
//
//  Created by 김기림 on 2022/04/13.
//

import RxDataSources

struct Sample {
    var title: String?
    var description1: String?
    var description2: String?
    var price: Int?
    var thumbnail: String?
}

// RxDataSources용 타입
struct RxStaticSectionData {
    var header: String
    var items: [Item]
}

extension RxStaticSectionData: SectionModelType {
    typealias Item = Sample
    
    init(original: RxStaticSectionData, items: [Item]) {
        self = original
        self.items = items
    }
}
