//
//  InitialViewController.swift
//  HousePartyApp
//
//  Created by Robert Rozenvasser on 5/21/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

final class InitialViewController: UIViewController, BindableType {
    
    let disposeBag = DisposeBag()
    var viewModel: InitialViewModel!
    private var headerLabel: UILabel!
    private var bodyLabel: UILabel!
    private let widthMultiplier = 0.74
    
    static func configuredWith(info: OnboardingInfo) -> InitialViewController {
        var vc = InitialViewController()
        let viewModel = InitialViewModel(info: info)
        vc.setViewModelBinding(model: viewModel)
        return vc
    }
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = UIColor.white
        setupLabels()
    }
    
    deinit { print("Onboaridng deinit") }
    
    func bindViewModel() {
        viewModel.pageInfo
            .drive(onNext: { [weak self] in
                self?.headerLabel.text = $0.header
                self?.bodyLabel.text = $0.body
            })
            .disposed(by: disposeBag)
    }
    
    private func setupLabels() {
        headerLabel = UILabel().rxStyle(font: FontBook.AvenirHeavy.of(size: 14), color: .black, alignment: .left)
        bodyLabel = UILabel().rxStyle(font: FontBook.AvenirHeavy.of(size: 14), color: .black, alignment: .left)
        let stackView = UIStackView(arrangedSubviews: [headerLabel, bodyLabel])
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 10.0
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.center.equalTo(view)
        }
    }
    
}
