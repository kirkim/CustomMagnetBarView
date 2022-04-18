//
//  MagnetListView.swift
//  MagnetBarView
//
//  Created by 김기림 on 2022/04/15.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources
import Reusable

class MagnetListView: UICollectionView {
    private let disposeBag = DisposeBag()
    
    init() {
        super.init(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: MagnetListViewModel, maxValue: CGFloat) {
        let dataSource = viewModel.dataSource()

        Observable.just(viewModel.data)
            .bind(to: self.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        self.rx.didScroll
            .map { _ -> (CGFloat, CGFloat) in
                let originY = self.contentOffset.y
                let value = originY <= maxValue ? -originY : -maxValue
                return (value, maxValue)
            }
            .share()
            .bind(to: viewModel.scrollEvent)
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        self.contentInsetAdjustmentBehavior = .never
        self.backgroundColor = .systemGray5
        self.register(cellType: MagnetMenuCell.self)
        self.register(cellType: MagnetInfoCell.self)
        self.register(cellType: MagnetBannerCell.self)
        self.register(supplementaryViewType: MagnetMenuHeaderCell.self, ofKind: UICollectionView.elementKindSectionHeader)
    }
    
    private func layout() {
        self.collectionViewLayout = createLayout()
    }
        
    func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
            switch sectionNumber {
            case 0:
                return self.bannerSection()
            case 1:
                return self.infoSecion()
            default:
                return self.menuSection()
            }
        }
    }
    
    private func bannerSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(10/13)), subitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    private func infoSecion() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(8/13)), subitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        return section
    }

    private func menuSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.3)), subitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 15, trailing: 0)
        // header
        let globalHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(80))
        let globalHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: globalHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        globalHeader.pinToVisibleBounds = true
        section.boundarySupplementaryItems = [globalHeader]
        return section
    }

}

struct Constants {
    struct HeaderKind {
        static let space = "SpaceCollectionReusableView"
        static let globalSegmentedControl = "segmentedControlHeader"
    }
}
