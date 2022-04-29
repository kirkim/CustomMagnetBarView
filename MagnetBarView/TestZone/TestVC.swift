//
//  TestVC.swift
//  MagnetBarView
//
//  Created by 김기림 on 2022/04/15.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

class TestVC: UIViewController {
    let testView = UIButton()
    let disposeBag = DisposeBag()
    let model = MagnetBarHttpModel.shared
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        self.view.backgroundColor = .white
        self.testView.backgroundColor = .yellow
        self.testView.setTitle("open", for: .normal)
        self.testView.setTitleColor(.black, for: .normal)
        
        self.testView.rx.tap
            .bind {
                self.model.loadData(code: "1") {
                    DispatchQueue.main.async {
                        let vc = MagnetBarView()
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
            .disposed(by: disposeBag)
        
        
        [testView].forEach {
            self.view.addSubview($0)
        }
        
        testView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(20)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
    }
}
