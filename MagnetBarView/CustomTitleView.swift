//
//  MagnetBarView.swift
//  MagnetBarView
//
//  Created by 김기림 on 2022/04/12.
//

import UIKit

class CustomTitleView: UIViewController {
     
    
    init() {
        super.init(nibName: nil, bundle: nil)
        attribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func attribute() {
        self.view.backgroundColor = .gray
        setTitleView()
    }
    
    private func layout() {
        
    }
    
    func setTitleView() {
        let titleName = UILabel()
        titleName.text = "Click"
        titleName.font = UIFont(name: "Chalkduster", size: 30)
        titleName.textColor = .magenta
        titleName.sizeToFit()
        
        let titleButton = UIButton()
        titleButton.setTitle(" Here", for: .normal)
        titleButton.titleLabel?.font = UIFont(name: "Menlo", size: 30)
        titleButton.setTitleColor(UIColor.cyan, for: .normal)
        titleButton.addTarget(self, action: #selector(buttonTaped(sender:)), for: .touchUpInside)
        
        let stackView = UIStackView(arrangedSubviews: [titleName, titleButton])
        stackView.axis = .horizontal
        stackView.frame.size.width = titleName.frame.width + titleButton.frame.width
        stackView.frame.size.height = max(titleName.frame.height, titleButton.frame.height)
        
        navigationItem.titleView = stackView
    }
    
    @objc func buttonTaped(sender: UIButton) {
        let alert = UIAlertController(title: "안녕하세요!", message: "후르륵짭짭 입니다.", preferredStyle: .alert)
        let Okey = UIAlertAction(title: "반가워요!", style: .destructive, handler: nil)
        alert.addAction(Okey)
        present(alert, animated: true)
    }
}
