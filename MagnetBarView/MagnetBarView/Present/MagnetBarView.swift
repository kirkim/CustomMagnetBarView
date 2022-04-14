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
    static let headerViewHeight:CGFloat = (UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate).windowWidth! * 8/13 + 70
    static let headerViewValue: CGFloat = MagnetBarView.headerViewHeight - 100
    private let tableView = UITableView(frame: CGRect.zero, style: .grouped)
    private let disposeBag = DisposeBag()
    private let mainHeaderView = MagnetHeaderView()
    private let mainNavigationBar = MagnetNavigationBar()
    private let headerBackgroundView = UIView()
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
        self.navigationController?.navigationBar.isHidden = true
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
                let value = originY <= MagnetBarView.headerViewValue ? -originY : -MagnetBarView.headerViewValue
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
        tableView.contentInsetAdjustmentBehavior = .never
        self.tableView.delegate = self
        self.tableView.backgroundColor = .gray
        self.tableView.register(cellType: TestCell.self)
        self.tableView.register(cellType: BannerCell.self)
    }
    
    private func layout() {
        [tableView, mainHeaderView, mainNavigationBar].forEach {
            self.view.addSubview($0)
        }
        
        mainHeaderView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(MagnetBarView.headerViewHeight)
        }
        
        tableView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        mainNavigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(80)
        }
    }
    
    func dataSource() -> RxTableViewSectionedReloadDataSource<RxStaticSectionData> {
        return RxTableViewSectionedReloadDataSource<RxStaticSectionData>(
            configureCell: { dataSource, tableView, indexPath, item in
                if indexPath.section == 0 {
                    let cell = tableView.dequeueReusableCell(for: indexPath, cellType: BannerCell.self)
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(for: indexPath, cellType: TestCell.self)
                    cell.setData(data: item)
                    return cell
                }
            })
    }
}

extension MagnetBarView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if (section != 0) {
            let header = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 0))
            header.backgroundColor = .orange
            return header
        } else {
            let header = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 0))
            header.backgroundColor = .green
            return nil
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return MagnetBarView.headerViewHeight - 70
        }
        return 150
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return .leastNormalMagnitude
        }
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
}

