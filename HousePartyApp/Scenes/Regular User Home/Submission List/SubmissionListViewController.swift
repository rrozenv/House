//
//  SubmissionListViewController.swift
//  HousePartyApp
//
//  Created by Robert Rozenvasser on 5/26/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SnapKit

class SubmissionListViewController<ViewModel: SubmissionListInputsOutputs>: UIViewController, BindableType {
    
    private var tableView: UITableView!
    
    let disposeBag = DisposeBag()
    var viewModel: ViewModel!
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = .white
        setupTableView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    deinit { print("SubmissionListViewController deinit") }
    
    func bindViewModel() {
//        tableView.rx.setDelegate(self)
//            .disposed(by: disposeBag)
        
        //MARK: - Inputs
        let submissionTapped$ = tableView.rx.itemSelected.asObservable().map { $0.row }
        viewModel.bindSelectedSubmissionIndex(submissionTapped$)
        
        //MARK: - Outputs
        viewModel.displayedSubmissions
            .observeOn(MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: SubmissionTableCell.defaultReusableId, cellType: SubmissionTableCell.self)) { row, element, cell in
                cell.configureWith(value: element)
            }
            .disposed(by: disposeBag)
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.register(SubmissionTableCell.self, forCellReuseIdentifier: SubmissionTableCell.defaultReusableId)
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .singleLine
        tableView.keyboardDismissMode = .onDrag
        tableView.contentInset = UIEdgeInsetsMake(80, 0, 0, 0)
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
    
}

//extension SubmissionListViewController: UITableViewDelegate {
//
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return CGFloat.leastNonzeroMagnitude
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return CGFloat.leastNonzeroMagnitude
//    }
//
//}

