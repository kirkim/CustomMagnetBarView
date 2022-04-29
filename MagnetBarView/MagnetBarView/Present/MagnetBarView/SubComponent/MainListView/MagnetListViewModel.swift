//
//  MagnetListViewModel.swift
//  MagnetBarView
//
//  Created by 김기림 on 2022/04/15.
//

import UIKit
import RxCocoa
import RxDataSources

class MagnetListViewModel {
    let bannerCellViewModel = MagnetBannerCellViewModel()
    let infoCellViewModel = MagnetInfoViewModel()
    let stickyViewModel: RemoteMainListBarViewModel
    
    // View -> ViewModel
    let scrollEvent = PublishRelay<(CGFloat, CGFloat)>()
    let stickyHeaderOn = PublishRelay<Bool>()
    let changeSection = PublishRelay<Int>()
    
    // ViewModel -> ParentViewModel
    let presentReviewVC: Signal<MagnetReviewVC>
    
    let data: [MagnetSectionModel]
    
    private let httpModel = HttpModel.shared
    private let mainTitle: String
    //////////
    // View -> ViewModel
//    let pageChanging = PublishRelay<Int>()
    
    // ViewModel -> View
    //    let scrolledPage: Signal<IndexPath>
    
    // TabBarView -> ViewModel -> View
    let slotChanged = PublishRelay<IndexPath>()
    ////////
    
    private var MenuImageStorage: [IndexPath : UIImage] = [:]
    
    init() {
        self.data = httpModel.getTotalData()
        self.mainTitle = httpModel.getStoreName()
        stickyViewModel = RemoteMainListBarViewModel(itemTitles: httpModel.getSectionTitles())
        
        presentReviewVC = infoCellViewModel.popVC
            .map { type -> MagnetReviewVC in
                switch type {
                case .popReviewVC:
                    return MagnetReviewVC(row: nil)
                case .review(let row):
                    return MagnetReviewVC(row: row)
                }
            }
            .asSignal()
    }

    func dataSource() -> RxCollectionViewSectionedReloadDataSource<MagnetSectionModel> {
        let dataSource = RxCollectionViewSectionedReloadDataSource<MagnetSectionModel>(
            configureCell: { [weak self] dataSource, collectionView, indexPath, item in
                guard let self = self else { fatalError() }
                switch dataSource[indexPath.section] {
                case .SectionBanner(items: let items):
                    let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: MagnetBannerCell.self)
                    cell.setData(title: items[indexPath.row].mainTitle)
                    cell.layout()
                    cell.bind(self.bannerCellViewModel)
                    return cell
                case .SectionInfo(items: let items):
                    let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: MagnetInfoCell.self)
                    cell.bind(self.infoCellViewModel)
                    cell.setData(data: items[indexPath.row])
                    return cell
                case .SectionSticky(items: _):
                    let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: MagnetStickyCell.self)
                    cell.bind(self.stickyViewModel)
                    return cell
                case .SectionMenu(header: _, items: let items):
                    let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: MagnetMenuCell.self)
                    
                    let image = self.makeMenuImage(indexPath: indexPath, url: items[indexPath.row].thumbnail ?? "")
                    
                    cell.setData(indexPath: indexPath, data: items[indexPath.row], image: image)
                    return cell
                }
            })
        
        dataSource.configureSupplementaryView = {(dataSource, collectionView, kind, indexPath) -> UICollectionReusableView in
            switch dataSource[indexPath.section] {
            case .SectionMenu(header: let headerValue, items: _):
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, for: indexPath, viewType: MagnetMenuHeaderCell.self)
                    header.setData(title: headerValue)
                    return header
            default:
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, for: indexPath, viewType: MagnetMenuHeaderCell.self)
                    return header
            }
        }
        return dataSource
    }
    
    private func makeMenuImage(indexPath: IndexPath, url: String) -> UIImage {
        if (MenuImageStorage[indexPath] != nil) {
            return MenuImageStorage[indexPath]!
        } else {
            let url = URL(string: url)
            let data = try? Data(contentsOf: url!)
            let image = UIImage(data: data!)
            if let image = image { self.MenuImageStorage.updateValue(image, forKey: indexPath) }
            return image ?? UIImage()
        }
    }
}
