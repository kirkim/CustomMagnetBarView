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
import Reusable

class MagnetBarView: UIViewController {
    private let disposeBag = DisposeBag()
    private let mainListView = MagnetListView()
    private let mainHeaderView = MagnetHeaderView()
    private let mainNavigationBar = MagnetNavigationBar()
    let viewModel = MagnetBarViewModel()
    
    static let navigationHeight:CGFloat = 80
    static let headerViewHeight:CGFloat = (UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate).windowWidth! * 8/13 + MagnetBarView.navigationHeight
    static let headerMovingDistance:CGFloat = MagnetBarView.headerViewHeight - 100
    
    init() {
        super.init(nibName: nil, bundle: nil)
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        bind()
    }
    
    private func bind() {
        mainHeaderView.bind(viewModel.mainHeaderViewModel)
        mainNavigationBar.bind(viewModel.mainNavigationBarViewModel)
        mainListView.bind(viewModel.mainListViewModel)
        
        viewModel.scrolled
            .emit { offset in
                self.mainHeaderView.frame.origin.y = offset
            }
            .disposed(by: disposeBag)
    }
    
    private func attribute() {

    }
    
    private func layout() {
        [mainListView, mainHeaderView, mainNavigationBar].forEach {
            self.view.addSubview($0)
        }
        
        mainHeaderView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(MagnetBarView.headerViewHeight)
        }
        
        mainListView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        mainNavigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(MagnetBarView.navigationHeight)
        }
    }
}
