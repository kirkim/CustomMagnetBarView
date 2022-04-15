//
//  MagnetListViewModel.swift
//  MagnetBarView
//
//  Created by 김기림 on 2022/04/15.
//

import UIKit
import RxCocoa
import RxDataSources

struct MagnetListViewModel {
    
    // View -> ViewModel
    let scrollEvent = PublishRelay<CGFloat>()
    
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
    
    func dataSource() -> RxTableViewSectionedReloadDataSource<RxStaticSectionData> {
        return RxTableViewSectionedReloadDataSource<RxStaticSectionData>(
            configureCell: { dataSource, tableView, indexPath, item in
                if indexPath.section == 0 {
                    let cell = tableView.dequeueReusableCell(for: indexPath, cellType: MagnetBannerCell.self)
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(for: indexPath, cellType: TestCell.self)
                    cell.setData(data: item)
                    return cell
                }
            })
    }

}
