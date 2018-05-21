//
//  TitleHeaderView.swift
//  HousePartyApp
//
//  Created by Robert Rozenvasser on 5/21/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import Foundation
import UIKit

final class TitleHeaderView: UIView {
    
    // MARK: - Properties
    private var containerView: UIView!
    var mainLabel: UILabel!
    
    // MARK: - Initialization
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(frame: .zero)
        self.backgroundColor = UIColor.clear
        setupContainerView()
        setupMainLabel()
    }
    
    // MARK: - Configuration
    func configureWith(value: String) {
        mainLabel.text = value
    }
    
}

extension TitleHeaderView {
    
    //MARK: View Setup
    private func setupContainerView() {
        containerView = UIView()
        containerView.backgroundColor = UIColor.white
        
        self.addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupMainLabel() {
        mainLabel = UILabel()
        
        containerView.addSubview(mainLabel)
        mainLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(containerView)
            make.left.equalTo(containerView).offset(20)
        }
    }
    
}
