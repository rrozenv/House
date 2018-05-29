//
//  UsersViewController.swift
//  HousePartyApp
//
//  Created by Robert Rozenvasser on 5/6/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxOptional
import Moya

class UsersViewController: UIViewController, BindableType {
    
    let disposeBag = DisposeBag()
    var viewModel: UsersViewModel!
    private var tableView: UITableView!
    //let provider = MoyaProvider<API>()
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = UIColor.red
        setupTableView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
         print("width of iPhone X: \(UIScreen.main.bounds.width)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    deinit { print("GameSettingsViewController deinit") }
    
    func bindViewModel() {
        //MARK: - Input
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
//        tableView.rx.itemSelected.asObservable()
//            .map { GameOption.Sort.list[$0.row] }
//            .bind(to: viewModel.selectedOptionInput)
//            .disposed(by: disposeBag)

        //MARK: - Output
        viewModel.users
            .observeOn(MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: UserCell.defaultReusableId, cellType: UserCell.self)) { row, element, cell in
                cell.configureWith(value: element)
            }
            .disposed(by: disposeBag)
        
        viewModel.errorTracker
            .drive(onNext: { (error) in
                print("ERRROR")
                print(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
}

extension UsersViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
}

extension UsersViewController {
    
    private func setupTableView() {
        tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.register(UserCell.self, forCellReuseIdentifier: UserCell.defaultReusableId)
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = UIColor.white
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
    
}
