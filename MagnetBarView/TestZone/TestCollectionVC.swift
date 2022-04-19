//
//  TestCollectionView.swift
//  MagnetBarView
//
//  Created by 김기림 on 2022/04/19.
//

import UIKit
import Reusable

class TestCollectionVC: UIViewController {
    let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    var headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44)) {
        didSet {
            let element = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            // this activates the "sticky" behavior
            element.pinToVisibleBounds = true
            self.headerElement = element
        }
    }
    var headerElement: NSCollectionLayoutBoundarySupplementaryItem?

    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        attribute()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func attribute() {
        self.collectionView.collectionViewLayout = createLayout()
        self.collectionView.register(supplementaryViewType: MagnetMenuHeaderCell.self, ofKind: UICollectionView.elementKindSectionHeader)

    }
    
    private func layout() {
        
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionNumber, env) -> NSCollectionLayoutSection? in
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.3)), subitem: item, count: 1)
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 15, trailing: 0)
            
            section.boundarySupplementaryItems = [self.headerElement!]

//            // header
//            let globalHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(80))
//            let globalHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: globalHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
//            globalHeader.pinToVisibleBounds = true
//            section.boundarySupplementaryItems = [globalHeader]
            return section
        }
    }
    
    func supplementary(collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? {

        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, for: indexPath, viewType: MagnetMenuHeaderCell.self)
            
        header.setData(title: "Sticky header \(indexPath.section + 1)")
//            header.configure(with: "Sticky header \(indexPath.section + 1)")

            return header
    }
}
