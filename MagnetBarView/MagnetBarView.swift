//
//  MagnetBarView.swift
//  MagnetBarView
//
//  Created by 김기림 on 2022/04/12.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources

struct Sample {
    var title: String?
    var description: String?
}

// RxDataSources용 타입
struct RxStaticSectionData {
    var headers: String
    var items: [Item]
}

extension RxStaticSectionData: SectionModelType {
    typealias Item = Sample
    
    init(original: RxStaticSectionData, items: [Item]) {
        self = original
        self.items = items
    }
}

class MagnetBarView: UIViewController {
    private let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let disposeBag = DisposeBag()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        attribute()
        layout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func bind() {
        let data = [
            RxStaticSectionData(headers: "hello", items: [
                Sample(title: "hi1", description: "des1"),
                Sample(title: "hi2", description: "des2"),
                Sample(title: "hi3", description: "des3")
            ]),
            RxStaticSectionData(headers: "dsfdsfsfs", items: [
                Sample(title: "hi1", description: "des1"),
                Sample(title: "hi2", description: "des2"),
                Sample(title: "hi3", description: "des3")
            ])
        ]
        
        
        Observable.just(data)
            .bind(to: collectionView.rx.items(dataSource: dataSource()))
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        self.collectionView.backgroundColor = .gray
        self.collectionView.register(TestCell.self, forCellWithReuseIdentifier: "TestCell")
    }
    
    private func layout() {
        [collectionView].forEach {
            self.view.addSubview($0)
        }
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func dataSource() -> RxCollectionViewSectionedReloadDataSource<RxStaticSectionData> {
        return RxCollectionViewSectionedReloadDataSource<RxStaticSectionData>(
            configureCell: { dataSource, collectionView, indexPath, item in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TestCell", for: indexPath) as! TestCell
                cell.setData(data: item)
                return cell
            })
    }
}

class TestCell: UICollectionViewCell {
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func attribute() {
    }
    
    func setData(data: Sample) {
        self.titleLabel.text = data.title
        self.descriptionLabel.text = data.description
    }
    
    private func layout() {
        [titleLabel, descriptionLabel].forEach {
            self.addSubview($0)
        }
        titleLabel.snp.makeConstraints {
            $0.leading.top.equalToSuperview().offset(10)
        }
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(10)
        }
    }
}
