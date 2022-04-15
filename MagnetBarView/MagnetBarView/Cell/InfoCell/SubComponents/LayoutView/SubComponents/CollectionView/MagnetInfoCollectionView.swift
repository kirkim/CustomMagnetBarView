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
    let viewModel = MagnetInfoCollectionViewModel()
    
    init() {
        super.init(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        attribute()
        layout()
        bind(viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: MagnetInfoCollectionViewModel) {
        Driver.just([
            InfoCollectionCellData(thumbnail: "review1.jpeg", review: "친구 추천으로 주문했는데, 진짜 홀딱 반했어요!!친구 추천으로 주문했는데, 진짜 홀딱 반했어요!!", rating: 5),
            InfoCollectionCellData(thumbnail: "review1.jpeg", review: "친구 추천으로 주문했는데, 진짜 홀딱 반했어요!!", rating: 5),
            InfoCollectionCellData(thumbnail: "review1.jpeg", review: "친구 추천으로 주문했는데, 진짜 홀딱 반했어요!!", rating: 5),
            InfoCollectionCellData(thumbnail: "", review: "", rating: 0)
        ])
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
