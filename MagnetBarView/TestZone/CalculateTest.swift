//
//  CalculateTest.swift
//  MagnetBarView
//
//  Created by 김기림 on 2022/04/26.
//

import UIKit

class CalculateTest: UIViewController {
    
    let titleLabel = UILabel()
    let titleLabel2 = UILabel(frame: CGRect(x: 0, y: 0, width: MagnetBarViewMath.windowWidth-100, height: 0))
    
    init() {
        super.init(nibName: nil, bundle: nil)
        layout()
        test()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func test() {
        titleLabel.text = "jsdlkfdjslkfjslkfjdlsjlksjdfljsdlkfdjslkfjslkfjdlsjlksjdfljsdlkfdjslkfjslkfjdlsjlksjdfl"
        titleLabel2.font = .systemFont(ofSize: 50)
        titleLabel2.text = "q"
        [titleLabel2, titleLabel].forEach {
            $0.numberOfLines = 0
        }
        print(titleLabel2.intrinsicContentSize.height)
        let cal = calculateTextHeight(text: titleLabel2.text!, labelHeight: titleLabel2.intrinsicContentSize.height, containaerWidth: MagnetBarViewMath.windowWidth - 30)
        print(cal)
        //        print("-------Before------")
        //        print("title1: ", titleLabel.frame)
        //        print("title1_text: ", titleLabel.text!.size(withAttributes: nil))
        //        print("title2: ", titleLabel2.frame)
        //        print("title2_text: ", titleLabel2.text!.size(withAttributes: nil))
        //        titleLabel.frame.size = titleLabel.intrinsicContentSize
        //        titleLabel2.frame.size = titleLabel2.intrinsicContentSize
        //        print("-------After------")
        //        print("title1: ", titleLabel.frame)
        //        print("title1_text: ", titleLabel.text!.size(withAttributes: nil))
        //        print("title2: ", titleLabel2.frame)
        //        print("title2_text: ", titleLabel2.text!.size(withAttributes: nil))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(self.titleLabel2.intrinsicContentSize)
    }
    
    private func calculateTextHeight(text: String, labelHeight: CGFloat, containaerWidth: CGFloat) -> CGFloat {
        let textArray = text.split(separator: "\n").map { str in
            return String(str)
        }
        let heightValue = textArray.reduce(0, { partialResult, str in
            return partialResult + str.size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 50)]).width / containaerWidth + 1
        })
        let height = heightValue * labelHeight
        print(height)
        return height
    }
    
    private func layout() {
        self.view.backgroundColor = .white
        self.view.addSubview(titleLabel)
        self.view.addSubview(titleLabel2)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(50)
            $0.leading.equalToSuperview()
        }
        
        titleLabel2.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.trailing .equalToSuperview()
        }
    }
}

