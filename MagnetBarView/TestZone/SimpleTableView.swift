//
//  SimpleTableView.swift
//  MagnetBarView
//
//  Created by 김기림 on 2022/04/13.
//

import UIKit
import Reusable

class SimpleTableView: UIViewController {
//    let tableView = UITableView(frame: CGRect.zero, style: .grouped)
//
//    init() {
//        super.init(nibName: nil, bundle: nil)
//        attribute()
//        layout()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    private func attribute() {
//        self.tableView.dataSource = self
//        self.tableView.register(cellType: TestCell.self)
//    }
//
//    private func layout() {
//        self.view.addSubview(tableView)
//
//        tableView.snp.makeConstraints {
//            $0.edges.equalToSuperview()
//        }
//    }
}

//extension SimpleTableView: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 6
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: TestCell.self)
//        cell.setData(data: Sample(title: "hello", description: "hello everyone!"))
//        return cell
//    }
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 3
//    }
//
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        switch section {
//        case 0:
//            return "Header"
//        case 1:
//            return "Header2"
//        case 2:
//            return "Header3"
//        default:
//            return "Header"
//        }
//    }
//}
