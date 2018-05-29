//
//  EventListViewController.swift
//  HousePartyApp
//
//  Created by Robert Rozenvasser on 5/28/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SnapKit

class EventListViewController: UIViewController, BindableType {
    
    private var tableView: UITableView!
    let disposeBag = DisposeBag()
    var viewModel: EventListViewModel!
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = .white
        setupTableView()
    }

    deinit { print("EventListViewController deinit") }
    
    func bindViewModel() {
        //MARK: - Inputs
        let eventTapped$ = tableView.rx.modelSelected(Event.self).asObservable()
        viewModel.bindDidSelectEvent(eventTapped$)
        
        //MARK: - Outputs
        viewModel.displayedEvents
            .observeOn(MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: EventTableCell.defaultReusableId, cellType: EventTableCell.self)) { row, element, cell in
                cell.configureWith(value: element)
            }
            .disposed(by: disposeBag)
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.register(EventTableCell.self, forCellReuseIdentifier: EventTableCell.defaultReusableId)
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
