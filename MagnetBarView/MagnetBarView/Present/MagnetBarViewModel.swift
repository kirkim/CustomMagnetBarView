//
//  MagnetBarViewModel.swift
//  MagnetBarView
//
//  Created by 김기림 on 2022/04/14.
//

import Foundation
import RxCocoa

struct MagnetBarViewModel {
    let mainHeaderViewModel = MagnetHeaderViewModel()
    let mainNavigationBarViewModel = MagnetNavigationBarViewModel()
    let data = [
        RxStaticSectionData(header: "hello", items: [Sample(title: "hi1", description: "des1")]),
        RxStaticSectionData(header: "dsfdsfsfs", items: [
            Sample(title: "hi1", description: "des1"),
            Sample(title: "hi2", description: "des2"),
            Sample(title: "hi3", description: "des3")
        ]),
        RxStaticSectionData(header: "dsfdsfsfs", items: [
            Sample(title: "hi1", description: "des1"),
            Sample(title: "hi2", description: "des2"),
            Sample(title: "hi3", description: "des3")
        ]),
        RxStaticSectionData(header: "dsfdsfsfs", items: [
            Sample(title: "hi1", description: "des1"),
            Sample(title: "hi2", description: "des2"),
            Sample(title: "hi3", description: "des3")
        ]),
        RxStaticSectionData(header: "dsfdsfsfs", items: [
            Sample(title: "hi1", description: "des1"),
            Sample(title: "hi2", description: "des2"),
            Sample(title: "hi3", description: "des3")
        ])
    ]
}
