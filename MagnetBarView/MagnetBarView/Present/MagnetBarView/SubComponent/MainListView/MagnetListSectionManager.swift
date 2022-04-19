//
//  MagnetListSectionManager.swift
//  MagnetBarView
//
//  Created by 김기림 on 2022/04/19.
//

import UIKit

enum MagnetSectionType: Int {
    case banner
    case Info
    case stickHeader
    case menu
    var section: Int {
        return self.rawValue
    }
}

struct MagnetSectionOriginY {
    
}

struct MagnetListSectionManager {
    let bannerCellHeightRatio:CGFloat = 10/13
    let InfoCellHeightRatio:CGFloat = 8/13
    let menuListCellHeightRatio:CGFloat = 0.3
    let stickyHeaderPositionY:CGFloat
    let menuListHeaderHeight:CGFloat = 80
    let sectionSpace:CGFloat = 15
    let windowWidth:CGFloat = (UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate).windowWidth!
    
    init() {
        stickyHeaderPositionY = windowWidth * (self.bannerCellHeightRatio + self.InfoCellHeightRatio) - MagnetBarView.navigationHeight
    }
    
    func calculateSectionOriginY(data: [RxStaticSectionData]) -> [CGFloat] {
        guard data.count >= 4 else { return [] }
        var sectionOriginY: [CGFloat] = []
        let validData = data[3...]
        var tempData:[CGFloat] = []
        validData.forEach { data in
            let tempHeight = menuListHeaderHeight + CGFloat(data.items.count) * windowWidth * menuListCellHeightRatio
            tempData.append(tempHeight)
        }
        sectionOriginY.append(stickyHeaderPositionY)
        
        tempData.reduce(stickyHeaderPositionY) { a, b in
            let result = a + b + sectionSpace
            sectionOriginY.append(result)
            return result
        }

        return sectionOriginY
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
            switch sectionNumber {
            case MagnetSectionType.banner.section:
                return self.bannerSection()
            case MagnetSectionType.Info.section:
                return self.infoSecion()
            case MagnetSectionType.stickHeader.section:
                return self.stickyHeaderSection()
            default:
                return self.menuSection()
            }
        }
    }
    
    private func bannerSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(bannerCellHeightRatio)), subitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    private func infoSecion() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(InfoCellHeightRatio)), subitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        return section
    }

    private func menuSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(menuListCellHeightRatio)), subitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: sectionSpace, trailing: 0)
        // header
        let globalHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(menuListHeaderHeight))
        let globalHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: globalHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        globalHeader.pinToVisibleBounds = false
        section.boundarySupplementaryItems = [globalHeader]
        return section
    }
    
    private func stickyHeaderSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1)), subitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        // header
        let globalHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(80))
        let globalHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: globalHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        globalHeader.pinToVisibleBounds = true
        section.boundarySupplementaryItems = [globalHeader]
        return section
    }
}
