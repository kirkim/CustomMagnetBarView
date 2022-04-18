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
    private let mainNavigationBar = MagnetNavigationBar()
    let viewModel = MagnetBarViewModel()
    
    private let navigationHeight:CGFloat = 80
    private let windowWidth = (UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate).windowWidth!
    
    private var bannerViewHeight: CGFloat = 0
    private var offsetStandard:CGFloat = 0
    
    init() {
        super.init(nibName: nil, bundle: nil)
        attribute()
        setNumber()
        layout()
        bind()
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
        
    }
    
    private func setNumber() {
        bannerViewHeight = self.windowWidth * 10/13
        offsetStandard = bannerViewHeight - navigationHeight
    }
    
    private func bind() {
        mainNavigationBar.bind(viewModel.mainNavigationBarViewModel)
        mainListView.bind(viewModel.mainListViewModel, maxValue: self.offsetStandard)
    }
    
    
    private func attribute() {

    }
    
    private func layout() {
        [mainListView, mainNavigationBar].forEach {
            self.view.addSubview($0)
        }
        
        mainListView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        mainNavigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(self.navigationHeight)
        }
    }
}
