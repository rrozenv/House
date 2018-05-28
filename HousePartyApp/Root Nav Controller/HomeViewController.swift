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

final class HomeViewController: UIViewController, CustomNavBarViewable {
    
    private var coordinator: HomeCoordinator!
    let disposeBag = DisposeBag()
    var navView: HomeNavView = HomeNavView(leftIcon: #imageLiteral(resourceName: "IC_UserOptions"), leftMargin: 20.0)
    var navBackgroundView: UIView = UIView()
    private var createSubmissionButton: UIButton!
    
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
        setupTabPageController()
        setupSubmissionButton()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //bindViewModel()
        //setupUsersVc()
        createSubmissionButton.rx.tap.asObservable()
            .subscribe(onNext: { [unowned self] in self.coordinator.navigateTo(screen: .createSubmission) })
            .disposed(by: disposeBag)
    }
    
    deinit { print("HomeViewController deinit") }
    
    private func setupTabPageController() {
        var submissionVc = SubmissionListViewController()
        let submissionVm = SubmissionListViewModel(user: AppController.shared.currentUser!)
        submissionVc.setViewModelBinding(model: submissionVm)
        
        let apperence = TabAppearence(type: .underline,
                                      itemTitles: ["Submissions", "Events"],
                                      height: 50.0,
                                      selectedBkgColor: .white,
                                      selectedTitleColor: .black,
                                      notSelectedBkgColor: .white,
                                      notSelectedTitleColor: .black)
        let vc = TabPageViewController(viewControllers: [submissionVc, UIViewController()], tabAppearence: apperence)
        self.addChild(vc, frame: nil, animated: false)
        
        vc.view.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(view)
            make.top.equalTo(navView.snp.bottom)
        }
    }
    
    private func setupSubmissionButton() {
        createSubmissionButton = UIButton()
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
