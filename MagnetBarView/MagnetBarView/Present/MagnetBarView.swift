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
    private let tableView = UITableView(frame: CGRect.zero, style: .grouped)
    private let disposeBag = DisposeBag()
    private let mainHeaderView = MagnetHeaderView()
    private let mainNavigationBar = MagnetNavigationBar()
    private let headerBackgroundView = UIView()
    private let headerViewHeight:CGFloat = 500
    private var headerViewValue: CGFloat = 0
    let viewModel = MagnetBarViewModel()
    
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
        headerViewValue = headerViewHeight - 100
        self.navigationController?.navigationBar.isHidden = true
//        let navigationBarAppearace = UINavigationBarAppearance()
//        navigationBarAppearace.configureWithOpaqueBackground()
//        navigationBarAppearace.backgroundColor = .clear
//        self.navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearace
//        self.navigationController?.navigationBar.standardAppearance = navigationBarAppearace
//        self.navigationController?.navigationBar.compactAppearance = navigationBarAppearace
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mainHeaderView.bind(viewModel.mainHeaderViewModel)
        mainNavigationBar.bind(viewModel.mainNavigationBarViewModel)
    }
    
    private func bind(_ viewModel: MagnetBarViewModel) {
        let dataSource = dataSource()

        Observable.just(viewModel.data)
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        let scrollEvent = self.tableView.rx.didScroll
            .map { _ -> CGFloat in
                let originY = self.tableView.contentOffset.y
                let value = originY <= self.headerViewValue ? -originY : -self.headerViewValue
                self.mainHeaderView.frame.origin.y = value
                return value
            }
            .distinctUntilChanged()
            .share()
        
        scrollEvent
            .bind(to: viewModel.mainHeaderViewModel.scrolled)
            .disposed(by: disposeBag)
        
        scrollEvent
            .bind(to: viewModel.mainNavigationBarViewModel.scrolled)
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        self.tableView.delegate = self
        self.tableView.backgroundColor = .gray
        self.tableView.register(cellType: TestCell.self)
    }
    
    private func layout() {
        [tableView, mainHeaderView, mainNavigationBar].forEach {
            self.view.addSubview($0)
        }
        
        mainHeaderView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(headerViewHeight)
        }
        
        tableView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        mainNavigationBar.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(100)
        }
    }
    
    func dataSource() -> RxTableViewSectionedReloadDataSource<RxStaticSectionData> {
        return RxTableViewSectionedReloadDataSource<RxStaticSectionData>(
            configureCell: { dataSource, tableView, indexPath, item in
                let cell = tableView.dequeueReusableCell(withIdentifier: "TestCell", for: indexPath) as! TestCell
                cell.setData(data: item)
                return cell
            })
    }
}

extension MagnetBarView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if (section != 0) {
            let header = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 100))
            header.backgroundColor = .orange
            return header
        } else {
            let header = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 500))
            header.backgroundColor = .green
            return header
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
