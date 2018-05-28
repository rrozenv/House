//
//  TabPageViewController.swift
//  HousePartyApp
//
//  Created by Robert Rozenvasser on 5/26/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class TabPageViewController: CustomPageViewController {

    private var tabApperence: TabAppearence!
    private var tabOptionsView: TabOptionsView!
    private let disposeBag = DisposeBag()
    private var willTransitionToIndex: Int = 0
    
    override func loadView() {
        super.loadView()
        self.navigationController?.navigationBar.isHidden = true
        view.backgroundColor = UIColor.white
        setupTabOptionsView()
    }
    
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder)! }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    init(viewControllers: [UIViewController], tabAppearence: TabAppearence) {
        super.init(nibName: nil, bundle: nil)
        self.tabApperence = tabAppearence
        self.dataSource = CustomPageControllerDataSource(viewControllers: viewControllers)
    }
    
    deinit { print("TabPageViewController deinit") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePagerDataSource()
        setupTabButtonBindings()
        self.didFinishTransition = { [unowned self] in
            self.tabOptionsView.adjustButtonStyle(selected: $0)
        }
    }
    
    func setupTabButtonBindings() {
        tabOptionsView.buttons.forEach { button in
            button.rx.tap.asObservable()
                .map { button.tag }
                .subscribe(onNext: { [unowned self] in
                    guard let vc = self.dataSource.controllerFor(index: $0) else { fatalError() }
                    self.transitionTo(viewController: vc)
                })
                .disposed(by: disposeBag)
        }
    }
    
}

extension TabPageViewController {
    
    private func setupTabOptionsView() {
        tabOptionsView = TabOptionsView(appearence: tabApperence)
        tabOptionsView.adjustButtonStyle(selected: 0)
        
        view.addSubview(tabOptionsView)
        tabOptionsView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.topEqualTo(view)
        }
    }
    
}

