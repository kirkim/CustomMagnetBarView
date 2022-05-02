//
//  MagnetPresentMenuVC.swift
//  MagnetBarView
//
//  Created by 김기림 on 2022/05/01.
//

import UIKit
import RxSwift
import RxCocoa

class MagnetPresentMenuVC: UIViewController {
    private let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let submitView = MagnetSubmitTapView()
    
    private let sectionManager = MagnetPresentMenuSectionManager()
    private let disposeBag = DisposeBag()
    private let viewModel =  MagnetPresentMenuViewModel()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        attribute()
        layout()
        bind(viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func bind(_ viewModel: MagnetPresentMenuViewModel = MagnetPresentMenuViewModel()) {
        self.collectionView.collectionViewLayout = viewModel.createLayout()
        self.submitView.bind(viewModel.submitTapViewModel)
        let dataSource = viewModel.dataSource()
        Observable.just(viewModel.data)
            .bind(to: self.collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        let scrollEvent = self.collectionView.rx.didScroll
            .map { _ -> CGFloat in
                return self.collectionView.contentOffset.y
            }
            .share()
        
        scrollEvent.bind { offsetY in
            if (offsetY >= MagnetBarViewMath.windowWidth - 200) {
                let alphaValue = MagnetBarViewMath.windowWidth - 200
                self.navigationController?.navigationBar.isHidden = false
                self.navigationController?.navigationBar.alpha = (offsetY - alphaValue)/100
            } else {
                self.navigationController?.navigationBar.isHidden = true
            }
        }
        .disposed(by: disposeBag)
        
        self.collectionView.rx.itemSelected
            .map({ indexPath -> (IndexPath, UICollectionView) in
                return (indexPath, self.collectionView)
            })
            .bind(to: viewModel.itemSelect)
            .disposed(by: disposeBag)
    }
    
    private func attribute() {


        self.title = "[가성비갑]모듬초밥10p"
        self.collectionView.backgroundColor = .systemGray4
        self.collectionView.contentInsetAdjustmentBehavior = .never
        self.collectionView.register(cellType: MagnetPresentMainTitleCell.self)
        self.collectionView.register(cellType: MagnetPresentMenuCell.self)
        self.collectionView.register(cellType: MagnetPresentCountSelectCell.self)
        self.collectionView.register(supplementaryViewType: MagnetPresentMenuHeaderView.self, ofKind: UICollectionView.elementKindSectionHeader)
    }
    
    private func layout() {
        [collectionView, submitView].forEach {
            self.view.addSubview($0)
        }
        
        submitView.snp.makeConstraints {
            $0.leading.bottom.trailing.equalToSuperview()
            $0.height.equalTo(150)
        }
        
        collectionView.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview()
            $0.bottom.equalTo(submitView.snp.top)
        }
        
    }
}
