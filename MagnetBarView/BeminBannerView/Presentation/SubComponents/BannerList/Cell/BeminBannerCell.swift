//
//  BannerCell.swift
//  Bemin_0307
//
//  Created by 김기림 on 2022/03/08.
//

import UIKit
import SnapKit

class BeminBannerCell: UICollectionViewCell {
    private var imageView = UIImageView()
    private var storage: [UIImage?] = [nil, nil, nil, nil, nil]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        self.addSubview(self.imageView)
        self.imageView.contentMode = .scaleToFill
        self.imageView.snp.makeConstraints {
            $0.top.trailing.bottom.leading.equalToSuperview()
        }
    }
    
    func setData(imageName: String) {
        let image = UIImage(named: imageName)
        self.imageView.image = image
    }
    
    func setData(row: Int, imageUrl: String) {
        if (storage[row] != nil) {
            self.imageView.image = storage[row]
        } else {
            DispatchQueue.global().async {
                let url = URL(string: imageUrl)
                let data = try? Data(contentsOf: url!)
                DispatchQueue.main.async {
                    let image = UIImage(data: data!)
                    if let image = image { self.storage[row] = image }
                    self.imageView.image = image
                }
            }
        }
    }
    
    deinit {
        print("deinit!")
    }
}
