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

final class HomeViewController: UIViewController, CustomNavBarViewable {
    
    let disposeBag = DisposeBag()
    var navView: HomeNavView = HomeNavView(leftIcon: #imageLiteral(resourceName: "IC_UserOptions"), leftMargin: 20.0)
    var navBackgroundView: UIView = UIView()
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = UIColor.white
        setupNavBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //bindViewModel()
        setupUsersVc()
    }
    
    deinit { print("HomeViewController deinit") }
    
//    func bindViewModel() {
//        navView.leftButton.rx.tap.asObservable()
//            .subscribe(onNext: { [unowned self] in
//                self.userProfileDisplayed = !self.userProfileDisplayed
//            })
//            .disposed(by: disposeBag)
//    }
    
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
