//
//  SearchBarView.swift
//  HousePartyApp
//
//  Created by Robert Rozenvasser on 5/21/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import Foundation
import UIKit

final class ShadowButton: UIButton {

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(frame: .zero)
        self.layer.cornerRadius = 5.0
        self.layer.masksToBounds = true
        self.dropShadow()
    }
    
}

final class ButtonLabel: UIButton {
    
    var label: UILabel!

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(frame: .zero)
        self.setupLabel()
    }
    
    private func setupLabel() {
        label = UILabel()
        self.addSubview(label)
        label.snp.makeConstraints { (make) in make.edges.equalTo(self) }
    }
    
}

final class StyledTextField: UIView {
    
    enum Style {
        case background
        case underline
    }
    
    enum InputType {
        case regularText
        case phoneNumber
    }
    
    var textField: PaddedTextField!
    var underlineView: UIView!
    var clearButton: UIButton!
    var countryCodeButton: ButtonLabel?
    
    //MARK: Initalizer Setup
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(style: Style, inputType: InputType, alignment: NSTextAlignment, padding: CGFloat) {
        super.init(frame: .zero)
        setupSearchTextfield(padding: padding, alignment: alignment)
        setupUnderlineView()
        setupStackView()
        setupClearButton()
        switch style {
        case .background: underlineView.isHidden = true
        default: break
        }
        switch inputType {
        case .phoneNumber: setupCountryCodeButton()
        default: break
        }
    }
    
}

extension StyledTextField {
    
    private func setupSearchTextfield(padding: CGFloat, alignment: NSTextAlignment) {
        textField = PaddedTextField(padding: padding)
        textField.textAlignment = alignment
        textField.snp.makeConstraints { $0.height.equalTo(50) }
    }
    
    private func setupUnderlineView() {
        underlineView = UIView()
        underlineView.backgroundColor = Palette.faintGrey.color
        underlineView.snp.makeConstraints { $0.height.equalTo(3) }
    }
    
    private func setupClearButton() {
        clearButton = UIButton()
        clearButton.setImage(#imageLiteral(resourceName: "IC_ClearSearch"), for: .normal)
        
        self.addSubview(clearButton)
        clearButton.snp.makeConstraints { (make) in
            make.right.equalTo(textField).offset(-10)
            make.width.height.equalTo(20)
            make.centerY.equalTo(textField)
        }
    }
    
    private func setupCountryCodeButton() {
        textField.padding.left = 30.0
        countryCodeButton = ButtonLabel()
        
        self.addSubview(countryCodeButton!)
        countryCodeButton!.snp.makeConstraints { (make) in
            make.left.equalTo(textField)
            make.centerY.equalTo(textField)
        }
    }
    
    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [textField, underlineView])
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 0
        
        self.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    
}


final class SearchBarView: UIView {
    
    var searchTextField: PaddedTextField!
    var searchIconImageView: UIImageView!
    var clearButton: UIButton!
    
    //MARK: Initalizer Setup
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(frame: .zero)
        setupSearchTextfield()
        setupSearchIcon()
        setupClearSearchButton()
    }
    
    func style(placeHolder: String, backColor: UIColor, searchIcon: UIImage, clearIcon: UIImage) {
        searchTextField.placeholder = placeHolder
        searchTextField.backgroundColor = backColor
        searchIconImageView.image = searchIcon
        clearButton.setImage(clearIcon, for: .normal)
    }
    
}

extension SearchBarView {
    
    private func setupSearchTextfield() {
        searchTextField = PaddedTextField(padding: 38)
        searchTextField.layer.cornerRadius = 2.0
        searchTextField.layer.masksToBounds = true
        searchTextField.font = FontBook.AvenirMedium.of(size: 14)
        searchTextField.textColor = UIColor.black
        
        self.addSubview(searchTextField)
        searchTextField.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    
    private func setupSearchIcon() {
        searchIconImageView = UIImageView()
        
        self.addSubview(searchIconImageView)
        searchIconImageView.snp.makeConstraints { (make) in
            make.left.equalTo(searchTextField).offset(16)
            make.width.height.equalTo(14)
            make.centerY.equalTo(searchTextField).offset(-1)
        }
    }
    
    private func setupClearSearchButton() {
        clearButton = UIButton()
        
        self.addSubview(clearButton)
        clearButton.snp.makeConstraints { (make) in
            make.right.equalTo(searchTextField).offset(-10)
            make.width.height.equalTo(20)
            make.centerY.equalTo(searchTextField)
        }
    }
    
}
