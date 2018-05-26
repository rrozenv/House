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

class SubmissionListViewController: UIViewController, BindableType {
    
    private var tableView: UITableView!
    
    let disposeBag = DisposeBag()
    var viewModel: SubmissionListViewModel!
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = .white
        setupTableView()
    }

    deinit { print("SubmissionListViewController deinit") }
    
    func bindViewModel() {
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        //MARK: - Inputs
        let submissionTapped$ = tableView.rx.modelSelected(Submission.self).asObservable()
        viewModel.bindDidSelectSubmission(submissionTapped$)
        
        //MARK: - Outputs
        viewModel.displayedSubmissions
            .observeOn(MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: TitleSelectionCell.defaultReusableId, cellType: TitleSelectionCell.self)) { row, element, cell in
                cell.configureWith(value: element.createdAt.description)
            }
            .disposed(by: disposeBag)
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.register(TitleSelectionCell.self, forCellReuseIdentifier: TitleSelectionCell.defaultReusableId)
        tableView.separatorStyle = .singleLine
        tableView.keyboardDismissMode = .onDrag
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
    
}

extension SubmissionListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return TitleSelectionCell.height
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }

}

