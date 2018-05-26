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
    
    private var homeCoordinator: HomeCoordinator!
    let disposeBag = DisposeBag()
    var navView: HomeNavView = HomeNavView(leftIcon: #imageLiteral(resourceName: "IC_UserOptions"), leftMargin: 20.0)
    var navBackgroundView: UIView = UIView()
    
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder)! }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    init(coordinator: HomeCoordinator) {
        super.init(nibName: nil, bundle: nil)
        self.homeCoordinator = coordinator
    }
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = UIColor.white
        setupNavBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //bindViewModel()
        //setupUsersVc()
        setupTabPageController()
    }
    
    deinit { print("HomeViewController deinit") }
    
    private func setupTabPageController() {
        var submissionVc = SubmissionListViewController()
        let submissionVm = SubmissionListViewModel(user: AppController.shared.currentUser!)
        submissionVc.setViewModelBinding(model: submissionVm)
        let vc = TabPageViewController(viewControllers: [submissionVc, submissionVc])
        self.addChild(vc, frame: nil, animated: false)
        
        vc.view.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(view)
            make.top.equalTo(navView.snp.bottom)
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
