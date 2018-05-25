//
//  ContactCollCell.swift
//  HousePartyApp
//
//  Created by Robert Rozenvasser on 5/25/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import Foundation
import UIKit

final class ContactCollCell: UICollectionViewCell {
    
    // MARK: - Properties
    static var defaultReusableId: String = "ContactCollCell"
    static let width: CGFloat = 46.0
    private var avatarImageView: UIImageView!
    private var mainLabel: UILabel!

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImageView()
        setupLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        self.contentView.backgroundColor = UIColor.white
        
    }
    
    // MARK: - Configuration
    func configureWith(value: Contact) {
        mainLabel.text = value.fullName
    }
    
}

extension ContactCollCell {
    
    //MARK: View Setup
    private func setupImageView() {
        avatarImageView = UIImageView()
        avatarImageView.image = #imageLiteral(resourceName: "IC_CheckMark")
        avatarImageView.layer.cornerRadius = ContactCollCell.width/2
        
        contentView.addSubview(avatarImageView)
        avatarImageView.snp.makeConstraints { make in
            make.top.left.right.equalTo(contentView)
            make.height.equalTo(ContactCollCell.width)
            make.width.equalTo(ContactCollCell.width)
        }
    }
    
    private func setupLabel() {
        mainLabel = UILabel().rxStyle(font: FontBook.AvenirMedium.of(size: 10), color: .black, alignment: .center)
        mainLabel.lineBreakMode = .byTruncatingTail
        
        contentView.addSubview(mainLabel)
        mainLabel.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(contentView)
            //make.top.equalTo(avatarImageView.snp.bottom).offset(-3)
        }
    }

    
}
