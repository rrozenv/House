//
//  EnterNameViewController.swift
//  HousePartyApp
//
//  Created by Robert Rozenvasser on 5/23/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SnapKit

class EnterNameViewController<ViewModel: TextEntryable>: UIViewController, BindableType, CustomNavBarViewable, KeyboardAvoidable {
    
    private var titleHeaderView: TitleHeaderView!
    private var textField: StyledTextField!
    private var nextButton: ShadowButton!
    private var containerStackView: UIStackView!
    var navView: BackButtonNavView = BackButtonNavView.blackArrow
    var navBackgroundView: UIView = UIView()
    var adjustableConstraint: Constraint!
    var latestKeyboardHeight: CGFloat = 0
    
    let disposeBag = DisposeBag()
    var viewModel: ViewModel!
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = .white
        //resignKeyboardOnViewTouch()
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
    
    deinit { print("EnterNameViewController deinit") }
    
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
        
        viewModel.isNextButtonEnabled
            .drive(onNext: { [unowned self] in
                self.textField.clearButton.isHidden = $0 ? false : true
                self.nextButton.isEnabled = $0
                self.nextButton.backgroundColor = $0 ? Palette.aqua.color : Palette.faintGrey.color
            })
            .disposed(by: disposeBag)
        
        viewModel.titleHeaderText
            .drive(onNext: { [unowned self] in
                self.titleHeaderView.configureWith(value: $0.originalText)
                self.titleHeaderView.mainLabel.varyingFonts(info: $0)
            })
            .disposed(by: disposeBag)
    }
    
//    func bindKeyboardNotifications(bottomOffset: CGFloat) {
//        UIDevice.keyboardHeightWillChange
//            .subscribe(onNext: { [weak self] height in
//                guard let sSelf = self else { return }
//                if sSelf.latestKeyboardHeight > CGFloat(0.0) && height != CGFloat(0.0) { return }
//                if height == 0.0 { sSelf.adjustableConstraint.update(offset: 0) ; return }
//                print("container height: \(sSelf.containerStackView.frame.size.height)")
//                let bottomY = sSelf.containerStackView.frame.origin.y + sSelf.containerStackView.frame.size.height
//                print("bottom Y: \(bottomY)")
//                print("height: \(height)")
//                if bottomY < height {
//                    let centerYOffset = (height - (sSelf.navView.frame.origin.y +
//                        sSelf.navView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height))/2
//                    sSelf.adjustableConstraint.update(offset: -centerYOffset)
//                }
//                UIView.animate(withDuration: 0.5) { sSelf.view.layoutIfNeeded() }
//                sSelf.latestKeyboardHeight = height
//            })
//            .disposed(by: disposeBag)
//    }
    
    private func setupTitleHeaderView() {
        titleHeaderView = TitleHeaderView()
        
        self.view.addSubview(titleHeaderView)
        titleHeaderView.snp.makeConstraints { (make) in
            make.height.equalTo(TitleHeaderView.height)
            make.left.right.equalTo(view)
            make.top.equalTo(navView.snp.bottom)
        }
    }
    
    private func setupTextField() {
        textField = StyledTextField(style: .underline, inputType: .regularText, alignment: .left, padding: ViewConst.regularTFPadding)
        textField.textField.style(placeHolder: "Enter Name", font: FontBook.AvenirMedium.of(size: 14), backColor: .white, titleColor: .black)
    }
    
    private func setupNextButton() {
        nextButton = ShadowButton()
        nextButton.style(title: "Next")
        nextButton.snp.makeConstraints { $0.height.equalTo(ViewConst.rectButtonHeight) }
    }
    
    private func setupContainerStackView() {
        containerStackView = UIStackView(arrangedSubviews: [textField, nextButton])
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
