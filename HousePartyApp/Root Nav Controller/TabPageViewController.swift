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
    
    private enum Sort: Int, CustomStringConvertible {
        case submissions
        case events
        
        var description: String {
            switch self {
            case .submissions: return "Submissions"
            case .events: return "Events"
            }
        }
    }

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
    
    init(viewControllers: [UIViewController]) {
        super.init(nibName: nil, bundle: nil)
        self.dataSource = CustomPageControllerDataSource(viewControllers: viewControllers)
    }
    
    deinit { print("VerifyLineupPageViewController deinit") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePagerDataSource()
        setupTabButtonBindings()
    }
    
    func setupTabButtonBindings() {
        tabOptionsView.buttons.forEach { button in
            button.rx.tap.asObservable()
                .map { Sort(rawValue: button.tag) }.filterNil()
                .subscribe(onNext: { [unowned self] in
                    self.tabOptionsView.adjustButtonStyle(selected: $0.rawValue)
                    guard let vc = self.dataSource.controllerFor(index: $0.rawValue) else { fatalError() }
                    self.transitionTo(viewController: vc)
                })
                .disposed(by: disposeBag)
        }
    }
    
}

extension TabPageViewController {
    
    override func pageViewController(_ pageViewController: UIPageViewController,
                                     didFinishAnimating finished: Bool,
                                     previousViewControllers: [UIViewController],
                                     transitionCompleted completed: Bool) {
        guard let vc = dataSource.controllerFor(index: willTransitionToIndex) else { return }
        self.transitionTo(viewController: vc)
        self.tabOptionsView.adjustButtonStyle(selected: willTransitionToIndex)
    }
    
    override func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        guard let idx = pendingViewControllers.first.flatMap(self.dataSource.indexFor(controller:))
            else { return }
        self.willTransitionToIndex = idx
    }
    
}

extension TabPageViewController {
    
    private func setupTabOptionsView() {
        let apperence = TabAppearence(type: .underline,
                                      itemTitles: [Sort.submissions.description, Sort.events.description],
                                      height: 50.0,
                                      selectedBkgColor: .blue,
                                      selectedTitleColor: .white,
                                      notSelectedBkgColor: .gray,
                                      notSelectedTitleColor: .black)
        tabOptionsView = TabOptionsView(appearence: apperence)
        tabOptionsView.adjustButtonStyle(selected: Sort.submissions.rawValue)
        
        view.addSubview(tabOptionsView)
        tabOptionsView.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.topEqualTo(view)
        }
    }
    
}

