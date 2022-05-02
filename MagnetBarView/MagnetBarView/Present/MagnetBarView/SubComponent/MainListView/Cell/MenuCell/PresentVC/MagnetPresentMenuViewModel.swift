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
    private let countSelectViewModel = MagnetPresentCountSelectViewModel()
    let submitTapViewModel = MagnetSubmitTapViewModel()
    
    //View -> ViewModel
    let itemSelect = PublishRelay<(IndexPath, UICollectionView)>()
    
    //ViewModel -> View
    let warningAlert = PublishRelay<String>()
    let inputPrice = BehaviorRelay<Int>(value: 0)
    
    // checker Manager
    private var selectChecker:[SelectChecker] = []
    private var initMustOneCell: [Int] = []
    
    let data:[PresentMenuSectionModel] = [
        PresentMenuSectionModel.SectionMainTitle(items: [PresentMenuTitleItem(imageUrl: nil, mainTitle: "hi")]),
        PresentMenuSectionModel.SectionMenu(header: "가격", selecType: .mustOne, items: [
            PresentMenuItem(title: "소", price: 13000),
            PresentMenuItem(title: "중", price: 16000),
            PresentMenuItem(title: "대", price: 20000),
            PresentMenuItem(title: "특대", price: 30000),
        ]),
        PresentMenuSectionModel.SectionMenu(header: "사리추가", selecType: .custom(min: 0, max: 3), items: [
            PresentMenuItem(title: "라면사리", price: 1000),
            PresentMenuItem(title: "우동사리", price: 2000),
            PresentMenuItem(title: "중국당면", price: 3000),
            PresentMenuItem(title: "치즈사리", price: 2500),
            PresentMenuItem(title: "깻잎추가", price: 1500),
            PresentMenuItem(title: "돈까스토핑추가", price: 5500),
        ]),
        PresentMenuSectionModel.SectionMenu(header: "서비스", selecType: .custom(min: 1, max: 2), items: [
            PresentMenuItem(title: "콜라", price: 0),
            PresentMenuItem(title: "사이다", price: 0),
            PresentMenuItem(title: "제로콜라", price: 0),
            PresentMenuItem(title: "트레비", price: 0),
        ]),
        PresentMenuSectionModel.SectionSelectCount(items: [PresentSelectCountItem(title: "s")]),
    ]
    
    init() {
        let totalPrice = inputPrice.scan(0, accumulator: { a, b in
            return a + b
        })
        
        Observable
            .combineLatest(totalPrice, countSelectViewModel.totalCount.asObservable()) { a, b in
                return a * b
            }
            .subscribe(onNext: {value in
                self.submitTapViewModel.currentPrice.accept(value)
            })
            .disposed(by: disposeBag)
        
        self.selectChecker.append(SelectChecker(selectType: .mustOne, selectCells: [])) // 첫번째 섹션이 메인타이틀로 사용한 것에 대한 보정값
        var i = -1 // section인덱스
        self.data.forEach { dat in
            i += 1
            switch dat {
            case .SectionMenu(header: _, selecType: let selectType, items: let items):
                self.selectChecker.append(SelectChecker(selectType: selectType, selectCells: []))
                if (selectType == .mustOne) {
                    self.inputPrice.accept(items[0].price!) // 초기에 자동선택되어있는 아이템이므로 값을 추가해준다
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
                    switch self.selectChecker[indexPath.section].selectType {
                    case .custom(min: _, max: let max):
                        self.warningAlert.accept("\(max)개까지 선택 가능합니다.")
                    case .mustOne:
                        fatalError() // .mustOne 타입인데 이곳으로 오면 안됨
                    }
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
                case .SectionMenu(header: _, selecType: _, items: let items):
                    let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: MagnetPresentMenuCell.self)
                    if (self.selectChecker[indexPath.section].isSelectCell(row: indexPath.row)) {
                        cell.clickedItem()
                    } else if (indexPath.row == 0 && self.initMustOneCell.contains(indexPath.section)) {
                        if let index = self.initMustOneCell.firstIndex(of: indexPath.section) {
                            self.initMustOneCell.remove(at: index)
                        }
                        cell.clickedItem()
                    }
                    cell.setData(data: items[indexPath.row])
                    return cell
                case .SectionSelectCount(items: _):
                    let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: MagnetPresentCountSelectCell.self)
                    //   let image = self.makeMenuImage(indexPath: indexPath, url: items[indexPath.row].thumbnail ?? "")
                    cell.bind(self.countSelectViewModel)
                    return cell
                }
            })
        
        dataSource.configureSupplementaryView = {(dataSource, collectionView, kind, indexPath) -> UICollectionReusableView in
            switch dataSource[indexPath.section] {
            case .SectionMenu(header: let headerString, selecType: let type, items: let items):
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, for: indexPath, viewType: MagnetPresentMenuHeaderView.self)
                header.setData(header: headerString, type: type, itemCount: items.count)
                return header
            default:
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, for: indexPath, viewType: MagnetPresentMenuHeaderView.self)
                return header
            }
        }
        return dataSource
    }
}
