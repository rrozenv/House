//
//  TitleSelectionCell.swift
//  HousePartyApp
//
//  Created by Robert Rozenvasser on 5/21/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import Foundation
import UIKit

final class TitleSelectionCell: UITableViewCell {
    
    // MARK: - Properties
    static let defaultReusableId: String = "UserContactTableCell"
    static let height: CGFloat = 60.0
    private var containerView: UIView!
    private var mainLabel: UILabel!
    private var circleBorderView: UIView!

    // MARK: - Initialization
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        self.contentView.backgroundColor = UIColor.white
        self.selectionStyle = .none
        setupContainerView()
        setupMainLabel()
        setupCirleBorderView()
    }
    
    // MARK: - Configuration
    func configureWith(value: String) {
        mainLabel.text = value
    }
    
}

extension TitleSelectionCell {
    
    //MARK: View Setup
    private func setupContainerView() {
        containerView = UIView()
        containerView.backgroundColor = UIColor.white
        
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
    }
    
    private func setupMainLabel() {
        mainLabel = UILabel().rxStyle(font: FontBook.AvenirMedium.of(size: 14), color: .black, alignment: .left)
        
        containerView.addSubview(mainLabel)
        mainLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(containerView)
            make.left.equalTo(containerView).offset(20)
        }
    }
    
    private func setupCirleBorderView() {
        circleBorderView = UIView()
        circleBorderView.layer.borderWidth = 2.0
        circleBorderView.layer.borderColor = Palette.lightGrey.color.cgColor
        circleBorderView.layer.cornerRadius = 20/2
        circleBorderView.layer.masksToBounds = true
        circleBorderView.backgroundColor = UIColor.white
        
        containerView.addSubview(circleBorderView)
        circleBorderView.snp.makeConstraints { (make) in
            make.right.equalTo(containerView).offset(-26)
            make.centerY.equalTo(containerView)
            make.height.width.equalTo(20)
        }
    }
    
}
