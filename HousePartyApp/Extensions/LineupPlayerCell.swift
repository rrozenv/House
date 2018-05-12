//
//  LineupPlayerCell.swift
//  DesignatedHitter
//
//  Created by Robert Rozenvasser on 4/22/18.
//  Copyright © 2018 Blueprint. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

final class UserCell: UITableViewCell {
    
    static var defaultReusableId: String = "UserCell"
    
    // MARK: - Properties
    private var containerView: UIView!
    private var nameLabel: UILabel!
    private var positionLabel: UILabel!
    
    // MARK: - Initialization
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func commonInit() {
        self.contentView.backgroundColor = UIColor.white
        self.separatorInset = .zero
        self.preservesSuperviewLayoutMargins = false
        self.layoutMargins = .zero
        self.selectionStyle = .none
        setupContainerView()
        setupLabels()
    }
    
    func configureWith(value: User) {
        nameLabel.text = value.fullName
        positionLabel.text = value.phonenumber
    }
    
    override func prepareForReuse() { }
    
}

//MARK: Constraints Setup

extension UserCell {
    
    private func setupContainerView() {
        containerView = UIView()
        containerView.layer.cornerRadius = 10.0
        containerView.layer.masksToBounds = true
        
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView).inset(UIEdgeInsetsMake(10, 20, 10, 20))
        }
    }
    
    private func setupLabels() {
        nameLabel = UILabel()
        positionLabel = UILabel()
        
        let stackView = UIStackView(arrangedSubviews: [nameLabel, positionLabel])
        stackView.spacing = 10.0
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        
        containerView.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.edges.equalTo(containerView)
        }
    }
    
}
