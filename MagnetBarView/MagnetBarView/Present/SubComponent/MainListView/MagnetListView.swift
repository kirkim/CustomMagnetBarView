//
//  MagnetListView.swift
//  MagnetBarView
//
//  Created by 김기림 on 2022/04/15.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources
import Reusable

class MagnetListView: UITableView {
    private let bannerHeight = MagnetBarView.headerViewHeight - 70
    private let disposeBag = DisposeBag()
    
    init() {
        super.init(frame: CGRect.zero, style: .grouped)
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: MagnetListViewModel) {
        let dataSource = viewModel.dataSource()

        Observable.just(viewModel.data)
            .bind(to: self.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        self.rx.didScroll
            .map { _ -> CGFloat in
                let originY = self.contentOffset.y
                let value = originY <= MagnetBarView.headerMovingDistance ? -originY : -MagnetBarView.headerMovingDistance
                return value
            }
            .distinctUntilChanged()
            .share()
            .bind(to: viewModel.scrollEvent)
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        self.contentInsetAdjustmentBehavior = .never
        self.delegate = self
        self.backgroundColor = .gray
        self.register(cellType: TestCell.self)
        self.register(cellType: MagnetBannerCell.self)
    }
    
    private func layout() {
    }
}

extension MagnetListView: UITableViewDelegate {
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
            return bannerHeight
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
