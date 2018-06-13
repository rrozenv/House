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
    var _id: String { get }
    var fullName: String { get }
    var phonenumber: String { get }
}

final class HomeViewController<ViewModel: HomeViewControllable>: UIViewController, BindableType, CustomNavBarViewable {

    var viewModel: ViewModel!
    let disposeBag = DisposeBag()
    var navView: HomeNavView = HomeNavView(leftIcon: #imageLiteral(resourceName: "IC_UserOptions"), leftMargin: 20.0)
    var navBackgroundView: UIView = UIView()
    private var createSubmissionButton = UIButton()
    
    var userProfileDisplayed = false { didSet { self.toggleUserProfileVc() } }
    
    private lazy var userProfileViewController: UserProfileViewController = { [unowned self] in
        var vc = UserProfileViewController()
        let vm = UserProfileViewModel(coordinator: viewModel.coordinator)
        vc.setViewModelBinding(model: vm)
        vm.didDismiss.asObservable()
            .subscribe(onNext: { [weak self] in
                self?.userProfileDisplayed = false
            })
            .disposed(by: vm.disposeBag)
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        setupNavBar()
        setupSubmissionButton()
    }
    
    func bindViewModel() {
        let createTapped$ = createSubmissionButton.rx.tap.asObservable()
        viewModel.bindCreateButton(createTapped$)
        
        navView.leftButton.rx.tap.asObservable()
            .subscribe(onNext: { [unowned self] in self.userProfileDisplayed = !self.userProfileDisplayed })
            .disposed(by: disposeBag)
       
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
    
    private func toggleUserProfileVc() {
        if userProfileDisplayed {
            UIView.animate(withDuration: 0.3, animations: {
                self.addChild(self.userProfileViewController, frame: self.view.frame, animated: false)
            })
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.removeChild(self.userProfileViewController, completion: nil)
            })
        }
    }
    
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
