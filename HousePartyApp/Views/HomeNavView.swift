//
//  HomeNavView.swift
//  DesignatedHitter
//
//  Created by Robert Rozenvasser on 4/21/18.
//  Copyright © 2018 Blueprint. All rights reserved.
//

import Foundation
import UIKit

final class HomeNavView: UIView {
    
    var containerView: UIView!
    var leftButton: UIButton!
    var title: UILabel!
    
    //MARK: Initalizer Setup
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(leftIcon: UIImage, leftMargin: CGFloat) {
        super.init(frame: .zero)
        self.backgroundColor = .clear
        setupContainerView()
        setupLeftImageView(icon: leftIcon, leftMargin: leftMargin)
        setupTitle()
    }
    
    private func setupContainerView() {
        containerView = UIView()
        containerView.backgroundColor = UIColor.white
        
        self.addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    
    private func setupLeftImageView(icon: UIImage, leftMargin: CGFloat) {
        leftButton = UIButton()
        leftButton.setImage(icon, for: .normal)
        
        containerView.addSubview(leftButton)
        leftButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(containerView.snp.centerY)
            make.left.equalTo(containerView).offset(leftMargin)
        }
    }
    
    private func setupTitle() {
        title = UILabel()
        title.style(font: FontBook.AvenirMedium.of(size: 12), color: .black)
        
        containerView.addSubview(title)
        title.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
    
}
