//
//  CustomNavigationController.swift
//  HousePartyApp
//
//  Created by Robert Rozenvasser on 5/31/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

final class CustomNavigationController: UINavigationController, CustomNavBarViewable {
    
    private let disposeBag: DisposeBag = DisposeBag()
    var navView: BackButtonNavView = BackButtonNavView.blackArrow
    var navBackgroundView: UIView = UIView()
    var navBarIsHidden: Bool = false {
        didSet {
            navView.isHidden = navBarIsHidden
            navBackgroundView.isHidden = navBarIsHidden
        }
    }

    override func loadView() {
        super.loadView()
        navView.containerView.backgroundColor = Palette.lightGrey.color
        navBackgroundView.backgroundColor = Palette.lightGrey.color
        setupNavBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        navView.backButton.rx.tap.asObservable()
            .subscribe(onNext: { [unowned self] in self.popViewController(animated: true) })
            .disposed(by: disposeBag)
    }
    
}
