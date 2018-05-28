//
//  HomeViewController.swift
//  HousePartyApp
//
//  Created by Robert Rozenvasser on 5/6/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
import SnapKit

protocol Invitable: Codable {
    var fullName: String { get }
    var phonenumber: String { get }
}

final class HomeViewController<ViewModel: HomeViewControllable>: UIViewController, BindableType, CustomNavBarViewable {

    private var coordinator: HomeCoordinator!
    var viewModel: ViewModel!
    let disposeBag = DisposeBag()
    var navView: HomeNavView = HomeNavView(leftIcon: #imageLiteral(resourceName: "IC_UserOptions"), leftMargin: 20.0)
    var navBackgroundView: UIView = UIView()
    private var createSubmissionButton = UIButton()
    
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder)! }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    init(coordinator: HomeCoordinator) {
        super.init(nibName: nil, bundle: nil)
        self.coordinator = coordinator
    }
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = UIColor.white
        setupNavBar()
        setupSubmissionButton()
    }
    
    func bindViewModel() {
        let createTapped$ = createSubmissionButton.rx.tap.asObservable()
        viewModel.bindCreateButton(createTapped$)
        
        viewModel.tabInfo
            .drive(onNext: { [unowned self] in
                let vc = TabPageViewController(viewControllers: $0.vcs, tabAppearence: $0.appearance)
                self.addChild(vc, frame: nil, animated: false)
                vc.view.snp.makeConstraints { (make) in
                    make.left.right.equalTo(self.view)
                    make.bottom.equalTo(self.createSubmissionButton.snp.top)
                    make.top.equalTo(self.navView.snp.bottom)
                }
            })
            .disposed(by: disposeBag)
    }
    
    deinit { print("HomeViewController deinit") }
    
    private func setupSubmissionButton() {
        createSubmissionButton.style(title: "Create", font: FontBook.AvenirMedium.of(size: 15), backColor: .blue, titleColor: .white)
        
        view.addSubview(createSubmissionButton)
        createSubmissionButton.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(view)
            make.height.equalTo(50)
        }
    }
    
    private func setupUsersVc() {
        var vc = UsersViewController()
        let vm = UsersViewModel(string: "Hi")
        vc.setViewModelBinding(model: vm)
        self.addChild(vc, frame: nil, animated: false)
        
        vc.view.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(view)
            make.top.equalTo(navView.snp.bottom)
        }
    }
    
}
