//
//  MagnetBannerCellViewModel.swift
//  MagnetBarView
//
//  Created by 김기림 on 2022/04/18.
//

import UIKit
import RxCocoa
import RxSwift

struct MagnetBannerCellViewModel {
    let mainHeaderViewModel = MagnetHeaderViewModel()
    let bannerViewModel: BeminBannerViewModel
    private let disposeBag = DisposeBag()
    
    // ParentView -> ViewModel
    let scrolled = PublishRelay<(CGFloat, CGFloat)>()
    
    // ParentViewModel -> ViewModel
    let title = PublishRelay<String>()
    
    init(imageName: [String]) {
        var imageBundle: [BannerSource] = []
        imageName.forEach { image in
            imageBundle.append(BannerSource(bannerCellImageName: image, presentVC: UIViewController()))
        }
        bannerViewModel = BeminBannerViewModel(data: BannerSources(bannerType: .basic, sources: imageBundle))
        scrolled
            .bind(to: mainHeaderViewModel.scrolled)
            .disposed(by: disposeBag)
        title
            .bind(to: mainHeaderViewModel.title)
            .disposed(by: disposeBag)
        
    }
}
