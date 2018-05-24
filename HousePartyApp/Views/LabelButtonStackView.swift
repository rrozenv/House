//
//  LabelButtonStackView.swift
//  HousePartyApp
//
//  Created by Robert Rozenvasser on 5/24/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import Foundation
import UIKit

final class LabelButtonStackView: UIView {

    var containerView: UIView!
    var titleLabel: UILabel!
    var button: ShadowButton!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(frame: .zero)
        setupContainerView()
        setupStackView()
    }
    
    func populateInfoWith(titleText: String, buttonText: String) {
        titleLabel.text = titleText
        button.setTitle(buttonText, for: .normal)
    }
    
    private func setupContainerView() {
        containerView = UIView()
        containerView.backgroundColor = .white
        
        self.addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    
    private func setupStackView() {
        titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        button = ShadowButton()
        button.style(title: "")
        button.snp.makeConstraints { (make) in
            make.height.equalTo(ViewConst.rectButtonHeight)
        }
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, button])
        stackView.spacing = 10.0
        stackView.axis = .vertical
        
        containerView.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.center.equalTo(containerView)
            make.left.equalTo(containerView).offset(ViewConst.inset)
            make.right.equalTo(containerView).offset(-ViewConst.inset)
        }
    }
    
}
