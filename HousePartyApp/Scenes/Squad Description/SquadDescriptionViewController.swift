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
    private var nextButton: UIButton!
    var navView: BackButtonNavView = BackButtonNavView.blackArrow
    var navBackgroundView: UIView = UIView()
    
    let disposeBag = DisposeBag()
    var viewModel: SelectSquadViewModel!
    private let dataSource = MultipleSelectionFilterDataSource<ContactViewModel, UserContactTableCell>(isSingleSelection: false)
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = .white
        setupNavBar()
        navView.containerView.backgroundColor = Palette.lightGrey.color
        navBackgroundView.backgroundColor = Palette.lightGrey.color
        setupCollectionView()
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
            .map { [unowned self] in self.dataSource.getAllSelectedItems() }
        viewModel.bindNextButton(nextTapped$)
        
       
        
        //MARK: - Outputs
        
    }
    
    private func setupCollectionView() {
        collectionViewGridLayout = ContactsCollViewGridLayout()
        collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: collectionViewGridLayout)
        collectionView.backgroundColor = UIColor.orange
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.allowsMultipleSelection = false
//        collectionView.register(CalendarDayCell.self, forCellWithReuseIdentifier: CalendarDayCell.reuseIdentifier)
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.left.equalTo(navView.backButton.snp.right).offset(20)
            make.right.equalTo(navView)
            make.centerY.equalTo(navView)
            make.height.equalTo(collectionViewGridLayout.itemSize.height)
        }
    }
}
