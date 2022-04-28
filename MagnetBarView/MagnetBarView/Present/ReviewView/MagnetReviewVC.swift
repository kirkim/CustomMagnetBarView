//
//  MagnetReviewView.swift
//  MagnetBarView
//
//  Created by 김기림 on 2022/04/18.
//

import UIKit
import SnapKit
import RxSwift
import RxDataSources

class MagnetReviewVC: UIViewController {
    private let tableView = UITableView(frame: CGRect.zero, style: .plain)
    private let disposeBag = DisposeBag()
    private let viewModel = MagnetReviewViewModel()
    
    init(indexPath: IndexPath?) {
        super.init(nibName: nil, bundle: nil)
        attribute()
        layout()
        bind(viewModel)
        if (indexPath != nil) {
            let row = indexPath!.row
            self.tableView.scrollToRow(at: IndexPath(row: row, section: 1), at: .top, animated: false)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: MagnetReviewViewModel) {
        let dataSource = viewModel.dataSource()
        viewModel.data
            .drive(self.tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        self.tableView.delegate = self
        
        self.view.backgroundColor = .white
        let cellNib = UINib(nibName: "MagnetReviewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "MagnetReviewCell")
        tableView.register(headerFooterViewType: MagnetReviewHeaderCell.self)
        tableView.register(cellType: MagnetReviewTotalRatingCell.self)
    }
    
    private func layout() {
        [tableView].forEach {
            self.view.addSubview($0)
        }
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension MagnetReviewVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if (section == 1) {
            let header = tableView.dequeueReusableHeaderFooterView(MagnetReviewHeaderCell.self)
            return header
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 1) {
            return 50
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section == 0) {
            return 100
        } else {
            return 500
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section == 0) {
            return 100
        } else {
            return UITableView.automaticDimension
        }
    }
}
