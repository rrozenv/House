//
//  PhoneEntryViewController.swift
//  HousePartyApp
//
//  Created by Robert Rozenvasser on 5/11/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import SnapKit

class PhoneEntryViewController: UIViewController, BindableType, CustomNavBarViewable, KeyboardAvoidable {
    
    private var titleHeaderView: TitleHeaderView!
    private var textField: StyledTextField!
    private var nextButton: ShadowButton!
    private var containerStackView: UIStackView!
    var navView: BackButtonNavView = BackButtonNavView.blackArrow
    var navBackgroundView: UIView = UIView()
    var adjustableConstraint: Constraint!
    var latestKeyboardHeight: CGFloat = 0
    
    let disposeBag = DisposeBag()
    var viewModel: PhoneEntryViewModel!
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = .white
        setupNavBar()
        navView.containerView.backgroundColor = Palette.lightGrey.color
        navBackgroundView.backgroundColor = Palette.lightGrey.color
        setupTitleHeaderView()
        setupTextField()
        setupNextButton()
        setupContainerStackView()
        bindKeyboardNotifications(bottomOffset: 100)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.textField.becomeFirstResponder()
    }
    
    deinit { print("PhoneEntryViewController deinit") }
    
    func bindViewModel() {
        let backTapped$ = navView.backButton.rx.tap.asObservable()
        viewModel.bindBackButton(backTapped$)
        
        let nameText$ = textField.textField.rx.text.orEmpty.asObservable()
        viewModel.bindTextEntry(nameText$)
        
        let nextTapped$ = nextButton.rx.tap.asObservable()
        viewModel.bindContinueButton(nextTapped$)
        
        let clearTapped$ = textField.clearButton.rx.tap.asObservable()
            .do(onNext: { [unowned self] in self.textField.textField.text = nil })
        viewModel.bindClearButton(clearTapped$)
        
        viewModel.formattedPhoneNumber
            .drive(textField.textField.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.isPhoneNumberValid
            .drive(onNext: { [unowned self] in
                self.textField.clearButton.isHidden = $0 ? false : true
                self.nextButton.isEnabled = $0
                self.nextButton.backgroundColor = $0 ? .yellow : .gray
            })
            .disposed(by: disposeBag)
        
        viewModel.titleHeaderText
            .drive(onNext: { [unowned self] in
                self.titleHeaderView.configureWith(value: $0.originalText)
                self.titleHeaderView.mainLabel.varyingFonts(info: $0)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupTitleHeaderView() {
        titleHeaderView = TitleHeaderView()
        titleHeaderView.snp.makeConstraints { $0.height.equalTo(60) }
    }
    
    private func setupTextField() {
        textField = StyledTextField(style: .underline,
                                    inputType: .phoneNumber,
                                    alignment: .left,
                                    padding: 40)
       textField.countryCodeButton?.label.style(font: FontBook.AvenirHeavy.of(size: 18), color: .black, alignment: .center)
        textField.countryCodeButton?.label.text = "+1"
        textField.textField.style(placeHolder: "Enter Phone Number", font: FontBook.AvenirMedium.of(size: 14), backColor: .white, titleColor: .black)
    }
    
    private func setupNextButton() {
        nextButton = ShadowButton()
        nextButton.style(title: "Next")
        nextButton.snp.makeConstraints { $0.height.equalTo(ViewConst.rectButtonHeight) }
    }
    
    private func setupContainerStackView() {
        containerStackView = UIStackView(arrangedSubviews: [titleHeaderView, textField, nextButton])
        containerStackView.axis = .vertical
        containerStackView.distribution = .equalSpacing
        containerStackView.spacing = 30.0
        
        self.view.addSubview(containerStackView)
        containerStackView.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(ViewConst.inset)
            make.right.equalTo(view).offset(-ViewConst.inset)
            self.adjustableConstraint = make.bottom.equalTo(view).offset(-100).constraint
        }
    }
    
}


