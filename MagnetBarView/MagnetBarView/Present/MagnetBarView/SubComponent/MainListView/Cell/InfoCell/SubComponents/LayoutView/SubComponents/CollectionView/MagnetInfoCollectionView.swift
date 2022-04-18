//
//  MagnetInfoCollectionView.swift
//  MagnetBarView
//
//  Created by 김기림 on 2022/04/15.
//

import UIKit
import RxSwift
import RxCocoa
import Reusable

class MagnetInfoCollectionView: UICollectionView {
    private let disposeBag = DisposeBag()
    private let viewModel = MagnetInfoCollectionViewModel()
    private let model = MagnetInfoCollectionModel()
    
    init() {
        super.init(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        attribute()
        layout()
        setData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData() {
        Driver.just(model.data)
            .drive(self.rx.items) { collectionView, row, data in
                if (row == 3) {
                    let cell = collectionView.dequeueReusableCell(for: IndexPath(row: row, section: 0), cellType: MagnetInfoMoreButtonCell.self)
                    return cell
                } else {
                    let cell = collectionView.dequeueReusableCell(for: IndexPath(row: row, section: 0), cellType: MagnetInfoReviewCell.self)
                    cell.setData(data: data)
                    return cell
                }
            }
            .disposed(by: disposeBag)
    }
    
    func bind(_ viewModel: MagnetInfoCollectionViewModel) {
        self.rx.itemSelected
            .bind(to: viewModel.cellClicked)
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        self.delegate = self
        self.register(cellType: MagnetInfoReviewCell.self)
        self.register(cellType: MagnetInfoMoreButtonCell.self)
        self.showsHorizontalScrollIndicator = false
    }
    
    private func layout() {
        if let layout = self.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 20
            layout.sectionInset = .init(top: 0, left: 0, bottom: 0, right: 20)
        }
    }
}

extension MagnetInfoCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = indexPath.row == 3 ? self.frame.height - 20 : self.frame.width*3/4
        let height:CGFloat = self.frame.height - 20
        return CGSize(width: width, height: height)
    }
}
