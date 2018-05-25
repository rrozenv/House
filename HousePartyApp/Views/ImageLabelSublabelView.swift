//
//  ImageLabelSublabelView.swift
//  HousePartyApp
//
//  Created by Robert Rozenvasser on 5/24/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import Foundation
import UIKit

final class ImageLabelSublabelView: UIView {
    
    var userImageView: UIImageView!
    var nameLabel: UILabel!
    var nameSubLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(frame: .zero)
        setupUserImageView()
        setupNameLabelsStackView()
    }
    
    func populateInfoWith(name: String, subLabel: String) {
        nameLabel.text = name
        nameSubLabel.text = subLabel
    }
    
    private func setupUserImageView() {
        userImageView = UIImageView()
        userImageView.layer.cornerRadius = 36/2
        userImageView.layer.masksToBounds = true
        userImageView.backgroundColor = Palette.faintGrey.color
        
        self.addSubview(userImageView)
        userImageView.snp.makeConstraints { (make) in
            make.left.centerY.equalTo(self)
            make.height.width.equalTo(36)
        }
    }
    
    private func setupNameLabelsStackView() {
        nameLabel = UILabel()
        nameLabel.textColor = UIColor.black
        nameLabel.numberOfLines = 1
        nameLabel.font = FontBook.AvenirHeavy.of(size: 13)
        
        nameSubLabel = UILabel()
        nameSubLabel.textColor = UIColor.gray
        nameSubLabel.numberOfLines = 1
        nameSubLabel.font = FontBook.AvenirMedium.of(size: 12)
        
        let views: [UILabel] = [nameLabel, nameSubLabel]
        let labelsStackView = UIStackView(arrangedSubviews: views)
        labelsStackView.spacing = 2.0
        labelsStackView.axis = .vertical
        
        self.addSubview(labelsStackView)
        labelsStackView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(self)
            make.left.equalTo(userImageView.snp.right).offset(10)
            make.right.equalTo(self)
        }
    }
    
}
