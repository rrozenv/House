//
//  SubmissionDetailViewController.swift
//  HousePartyApp
//
//  Created by Robert Rozenvasser on 5/29/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SnapKit

class SubmissionDetailViewController: UIViewController, BindableType, CustomNavBarViewable {
    
    private var addToEventButton: UIButton!
    private var tableView: UITableView!
    let disposeBag = DisposeBag()
    var viewModel: SubmissionDetailViewModel!
    var navView: BackButtonNavView = BackButtonNavView.blackArrow
    var navBackgroundView: UIView = UIView()
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = .white
        setupNavBar()
        setupTableView()
        setupAddToEventButton()
    }
    
    deinit { print("SubmissionDetailViewController deinit") }
    
    func bindViewModel() {
        //MARK: - Inputs
        let backTapped$ = navView.backButton.rx.tap.asObservable()
        viewModel.bindBackButton(backTapped$)
        
        addToEventButton.rx.tap.asObservable()
            .subscribe(onNext: { [unowned self] in self.displaySelectEventVC() })
            .disposed(by: disposeBag)
        
        //MARK: - Outputs
        viewModel.shouldHideAddToEventButton
            .bind(to: addToEventButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.displayedUsers
            .observeOn(MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: UserContactTableCell.defaultReusableId, cellType: UserContactTableCell.self)) { row, element, cell in
                cell.configureWith(value: element)
            }
            .disposed(by: disposeBag)
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.register(UserContactTableCell.self, forCellReuseIdentifier: UserContactTableCell.defaultReusableId)
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .singleLine
        tableView.keyboardDismissMode = .onDrag
        tableView.contentInset = UIEdgeInsetsMake(80, 0, 0, 0)
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(view)
            make.top.equalTo(navView.snp.bottom)
        }
    }
    
    private func setupAddToEventButton() {
        addToEventButton = UIButton()
        addToEventButton.style(title: "Create", font: FontBook.AvenirMedium.of(size: 15), backColor: .blue, titleColor: .white)
        
        view.addSubview(addToEventButton)
        addToEventButton.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(view)
            make.height.equalTo(50)
        }
    }
    
    private func displaySelectEventVC() {
        var vc = EventListViewController()
        let vm = EventListViewModel(user: AppController.shared.currentUser!)
        vc.setViewModelBinding(model: vm)
        vm.selectedEvent.asObservable().filterNil()
            .do(onNext: { [weak vc] _ in vc?.dismiss(animated: true, completion: nil) })
            .bind(to: viewModel.bindSelectedEvent)
        self.present(vc, animated: true, completion: nil)
    }
    
}
