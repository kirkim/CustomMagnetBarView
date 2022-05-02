//
//  MagnetPresentMenuViewModel.swift
//  MagnetBarView
//
//  Created by 김기림 on 2022/05/01.
//

import UIKit
import RxDataSources
import RxCocoa
import RxSwift

struct SelectChecker {
    var selectType: SelectType
    var selectCells: [Int]
    var isValid: Bool {
        switch selectType {
        case .mustOne:
            return true
        case .custom(let min, let max):
            let cellCount = selectCells.count
            if (cellCount >= min && cellCount <= max) {
                return true
            } else {
                return false
            }
        }
    }
    
    mutating func add(row: Int) {
        self.selectCells.append(row)
    }
    
    mutating func remove(row: Int) {
        if let index = selectCells.firstIndex(of: row) {
            selectCells.remove(at: index)
        }
    }
    
    func canSelectCell() -> Bool {
        switch selectType {
        case .mustOne:
            return true
        case .custom(_, let max):
            if (selectCells.count < max) {
                return true
            }
            return false
        }
    }
    
    func isSelectCell(row: Int) -> Bool {
        if (self.selectCells.contains(row)) {
            return true
        }
        return false
    }
}

class MagnetPresentMenuViewModel {
    private let disposeBag = DisposeBag()
    private let sectionManager = MagnetPresentMenuSectionManager()
    let itemSelect = PublishRelay<(IndexPath, UICollectionView)>()
    private var selectChecker:[SelectChecker] = []
    private var initMustOneCell: [Int] = []
    
    let submitTapViewModel = MagnetSubmitTapViewModel()
    let inputPrice = BehaviorRelay<Int>(value: 0)
    
    let data:[PresentMenuSectionModel] = [
        PresentMenuSectionModel.SectionMainTitle(items: [PresentMenuTitleItem(imageUrl: nil, mainTitle: "hi")]),
        PresentMenuSectionModel.SectionMenu(header: "가격", selecType: .custom(min: 0, max: 4), items: [
            PresentMenuItem(title: "", description: "", price: 3, thumbnail: ""),
            PresentMenuItem(title: "", description: "", price: 3, thumbnail: ""),
            PresentMenuItem(title: "", description: "", price: 3, thumbnail: ""),
            PresentMenuItem(title: "", description: "", price: 3, thumbnail: "")
        ]),
        PresentMenuSectionModel.SectionMenu(header: "가격", selecType: .mustOne, items: [
            PresentMenuItem(title: "", description: "", price: 3, thumbnail: ""),
            PresentMenuItem(title: "", description: "", price: 3, thumbnail: ""),
            PresentMenuItem(title: "", description: "", price: 3, thumbnail: ""),
            PresentMenuItem(title: "", description: "", price: 3, thumbnail: "")
        ]),
        PresentMenuSectionModel.SectionMenu(header: "가격", selecType: .custom(min: 2, max: 4), items: [
            PresentMenuItem(title: "", description: "", price: 3, thumbnail: ""),
            PresentMenuItem(title: "", description: "", price: 3, thumbnail: ""),
            PresentMenuItem(title: "", description: "", price: 3, thumbnail: ""),
            PresentMenuItem(title: "", description: "", price: 3, thumbnail: ""),
            PresentMenuItem(title: "", description: "", price: 3, thumbnail: ""),
            PresentMenuItem(title: "", description: "", price: 3, thumbnail: "")
        ]),

        PresentMenuSectionModel.SectionSelectCount(items: [PresentSelectCountItem(title: "s")]),
    ]
    
    init() {
        let totalPrice = inputPrice.scan(0, accumulator: { a, b in
            return a + b
        })
        
        totalPrice
            .bind(to: submitTapViewModel.currentPrice)
            .disposed(by: disposeBag)
        
        
        self.selectChecker.append(SelectChecker(selectType: .mustOne, selectCells: [])) // 첫번째 섹션이 메인타이틀로 사용한 것에 대한 보정값
        var i = -1 // section인덱스
        self.data.forEach { dat in
            i += 1
            switch dat {
            case .SectionMenu(header: _, selecType: let selectType, items: _):
                self.selectChecker.append(SelectChecker(selectType: selectType, selectCells: []))
                if (selectType == .mustOne) {
                    self.initMustOneCell.append(i)
                }
            case .SectionMainTitle(items: _):
                return
            case .SectionSelectCount(items: _):
                return
            }
        }

        itemSelect
            .filter { indexPath, collectionView in
                let cell = collectionView.cellForItem(at: indexPath) as? MagnetPresentMenuCell
                return (cell != nil)
            }
            .bind { indexPath, collectionView in
                let cell = collectionView.cellForItem(at: indexPath) as! MagnetPresentMenuCell
                if (self.selectChecker[indexPath.section].selectType == .mustOne) {
                    self.manageOnlyOneSelectSection(collectionView: collectionView, indexPath: indexPath)
                } else if (cell.isClicked == true) {
                    self.selectChecker[indexPath.section].remove(row: indexPath.row)
                    self.inputPrice.accept(cell.clickedItem())
                } else if (self.selectChecker[indexPath.section].canSelectCell() == false) {
                    print("can't clicked!")
                } else {
                    self.selectChecker[indexPath.section].add(row: indexPath.row)
                    self.inputPrice.accept(cell.clickedItem())
                }
            }
            .disposed(by: disposeBag)
        
        itemSelect.bind { _, _ in
            var canSubmit: Bool = true
            self.selectChecker.forEach { checker in
                if (checker.isValid == false) {
                    canSubmit = false
                }
            }
            self.submitTapViewModel.canSubmit.accept(canSubmit)
        }
        .disposed(by: disposeBag)
    }
    
    func manageOnlyOneSelectSection(collectionView: UICollectionView, indexPath: IndexPath) {
        let rowCount = self.data[indexPath.section].items.count
        let selectedCell = collectionView.cellForItem(at: indexPath) as! MagnetPresentMenuCell
        guard selectedCell.isClicked == false else { return }
        for i in 0..<rowCount {
            let cell = collectionView.cellForItem(at: IndexPath(row: i, section: indexPath.section)) as! MagnetPresentMenuCell
            if (cell.isClicked == true) {
                self.inputPrice.accept(cell.clickedItem())
                self.selectChecker[indexPath.section].remove(row: i)
            }
        }
        self.inputPrice.accept(selectedCell.clickedItem())
        self.selectChecker[indexPath.section].add(row: indexPath.row)
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        return sectionManager.createLayout(sectionCount: self.data.count)
    }
    
    func dataSource() -> RxCollectionViewSectionedReloadDataSource<PresentMenuSectionModel> {
        let dataSource = RxCollectionViewSectionedReloadDataSource<PresentMenuSectionModel>(
            configureCell: { dataSource, collectionView, indexPath, item in
                switch dataSource[indexPath.section] {
                case .SectionMainTitle(items: let item):
                    let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: MagnetPresentMainTitleCell.self)
                    
                    return cell
                case .SectionMenu(header: _, selecType: _, items: _):
                    let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: MagnetPresentMenuCell.self)
                    if (self.selectChecker[indexPath.section].isSelectCell(row: indexPath.row)) {
                        cell.clickedItem()
                    } else if (indexPath.row == 0 && self.initMustOneCell.contains(indexPath.section)) {
                        if let index = self.initMustOneCell.firstIndex(of: indexPath.section) {
                            self.initMustOneCell.remove(at: index)
                        }
                        cell.clickedItem()
                    }
                    return cell
                case .SectionSelectCount(items: _):
                    let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: MagnetPresentCountSelectCell.self)
                    //   let image = self.makeMenuImage(indexPath: indexPath, url: items[indexPath.row].thumbnail ?? "")
                    
                    return cell
                }
            })
        
        dataSource.configureSupplementaryView = {(dataSource, collectionView, kind, indexPath) -> UICollectionReusableView in
//            switch dataSource[indexPath.section] {
//            default:
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, for: indexPath, viewType: MagnetPresentMenuHeaderView.self)
                    return header
            }
//        }
        return dataSource
    }
}
