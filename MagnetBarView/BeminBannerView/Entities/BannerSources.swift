//
//  BannerSources.swift
//  BeminBanner
//
//  Created by 김기림 on 2022/04/11.
//

import UIKit

struct BannerSource {
    let bannerImageUrl: String
    var totalViewCellImageName: String?
    let presentVC: UIViewController
}

struct BannerSources {
    let bannerType: BannerButtonType
    var title: String = ""
    var subTitle: String = ""
    var totalViewCellRatio: CGFloat = 0
    let sources: [BannerSource]
}
