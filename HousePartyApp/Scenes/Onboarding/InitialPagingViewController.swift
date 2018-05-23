//
//  InitialPagingViewController.swift
//  HousePartyApp
//
//  Created by Robert Rozenvasser on 5/21/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class InitialPagingViewController: CustomPageViewController {
    
    private let disposeBag = DisposeBag()
    private var pageIndicatorView: PageIndicatorView!
    private var continueButton: UIButton!
    private var coordinator: SignUpFlowCoordinator!
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = UIColor.white
        setupContinueButton()
        setupPageIndicator(total: OnboardingInfo.initalOnboardingInfo.count)
    }
    
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder)! }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    init(viewControllers: [UIViewController], coordinator: SignUpFlowCoordinator) {
        super.init(nibName: nil, bundle: nil)
        self.coordinator = coordinator
        self.dataSource = CustomPageControllerDataSource(viewControllers: viewControllers)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        configurePagerDataSource()
        continueButton.rx.tap.asObservable()
            .subscribe(onNext: { [unowned self] in
                self.coordinator.toNextScreen()
            })
            .disposed(by: disposeBag)
    }
    
    override func transitionTo(viewController: UIViewController) {
        let currentPageIndex = dataSource.indexFor(controller: viewController) ?? 0
        self.currentPageIndex = currentPageIndex
        self.pageViewController.setViewControllers(
            [viewController],
            direction: .forward,
            animated: true,
            completion: nil
        )
        pageIndicatorView.currentPage = currentPageIndex
    }
    
}

extension InitialPagingViewController {
    
    private func setupContinueButton() {
        continueButton = UIButton()
        continueButton.style(title: "Create Account", font: FontBook.AvenirHeavy.of(size: 14), backColor: Palette.aqua.color, titleColor: .white)
        
        view.addSubview(continueButton)
        continueButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(view).offset(-100)
            make.width.equalTo(view).multipliedBy(0.8)
            make.centerX.equalTo(view)
            make.height.height.equalTo(56)
        }
    }
    
    private func setupPageIndicator(total: Int) {
        let widthHeight: CGFloat = 6.0
        pageIndicatorView = PageIndicatorView(numberOfItems: total, widthHeight: 6.0)
        pageIndicatorView.currentPage = 0

        view.addSubview(pageIndicatorView)
        pageIndicatorView.snp.makeConstraints { (make) in
            make.centerX.equalTo(view.snp.centerX)
            make.height.equalTo(widthHeight)
            make.width.equalTo(UIStackView.dynamicWidth(itemCount: total, itemWidth: widthHeight, spacing: 10.0))
            make.bottom.equalTo(continueButton.snp.top).offset(-10)
        }
    }
    
}

