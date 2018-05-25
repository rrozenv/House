//
//  SquadDescriptionViewController.swift
//  HousePartyApp
//
//  Created by Robert Rozenvasser on 5/25/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SnapKit

class SquadDescriptionViewController: UIViewController, BindableType, CustomNavBarViewable, KeyboardAvoidable {
    
    var latestKeyboardHeight: CGFloat = 0
    var adjustableConstraint: Constraint!
    private var collectionView: UICollectionView!
    private var collectionViewGridLayout: ContactsCollViewGridLayout!
    private var bodyTextView: UITextView!
    private var bodyPlaceholderLabel: UILabel!
    private var nextButton: UIButton!
    
    var navView: BackButtonNavView = BackButtonNavView.blackArrow
    var navBackgroundView: UIView = UIView()
    
    let disposeBag = DisposeBag()
    var viewModel: SquadDescriptionViewModel!
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = .white
        setupNavBar()
        navView.containerView.backgroundColor = Palette.lightGrey.color
        navBackgroundView.backgroundColor = Palette.lightGrey.color
        setupCollectionView()
        setupBodyTextView()
        setupNextButton()
        bindKeyboardNotifications(bottomOffset: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    deinit { print("SelectSquadViewController deinit") }
    
    func bindViewModel() {
        
//        collectionView.rx.setDelegate(self)
//            .disposed(by: disposeBag)
        
        //MARK: - Inputs
        let backTapped$ = navView.backButton.rx.tap.asObservable()
        viewModel.bindBackButton(backTapped$)
        
        let nextTapped$ = nextButton.rx.tap
            .asObservable()
            .map { [unowned self] in self.bodyTextView.text }.filterNil()
        viewModel.bindNextButton(nextTapped$)
        
        bodyTextView.rx.text.orEmpty
            .do(onNext: { [unowned self] in self.bodyPlaceholderLabel.isHidden = $0 == "" ? false : true })
            .do(onNext: { [unowned self] in self.nextButton.isHidden = ($0.count > 5) ? false : true })
            .subscribe()
            .disposed(by: disposeBag)
        
        //MARK: - Outputs
        viewModel.selectedContacts
            .observeOn(MainScheduler.instance)
            .bind(to: collectionView.rx.items(cellIdentifier: ContactCollCell.defaultReusableId, cellType: ContactCollCell.self)) { row, element, cell in
                cell.configureWith(value: element)
            }
            .disposed(by: disposeBag)
    }
    
    private func setupCollectionView() {
        collectionViewGridLayout = ContactsCollViewGridLayout()
        collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: collectionViewGridLayout)
        collectionView.backgroundColor = UIColor.orange
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.allowsMultipleSelection = false
        collectionView.register(ContactCollCell.self, forCellWithReuseIdentifier: ContactCollCell.defaultReusableId)
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.left.equalTo(navView.backButton.snp.right).offset(15)
            make.right.equalTo(navView)
            make.centerY.equalTo(navView)
            make.height.equalTo(collectionViewGridLayout.itemSize.height)
        }
    }
    
    private func setupBodyTextView() {
        bodyTextView = UITextView()
        bodyTextView.font = FontBook.AvenirHeavy.of(size: 14)
        bodyTextView.isEditable = true
        bodyTextView.isScrollEnabled = false
        
        bodyPlaceholderLabel = UILabel().rxStyle(font: FontBook.AvenirMedium.of(size: 14), color: Palette.lightGrey.color, alignment: .left)
        
        bodyTextView.addSubview(bodyPlaceholderLabel)
        bodyPlaceholderLabel.snp.makeConstraints { (make) in
            make.left.top.equalTo(bodyTextView).offset(7)
        }
        
        view.addSubview(bodyTextView)
        bodyTextView.snp.makeConstraints { (make) in
            make.left.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-20)
            make.top.equalTo(navView.snp.bottom).offset(10)
        }
    }
    
    
    private func setupNextButton() {
        nextButton = ShadowButton()
        nextButton.style(title: "Next")
        
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints {
            $0.height.equalTo(ViewConst.rectButtonHeight)
            $0.left.equalTo(ViewConst.inset)
            $0.right.equalTo(-ViewConst.inset)
            self.adjustableConstraint = $0.bottom.equalTo(view).offset(-ViewConst.inset).constraint
        }
    }
}
