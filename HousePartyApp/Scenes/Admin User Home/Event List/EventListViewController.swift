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
    
    enum Style {
        case fullScreen
        case modal
    }
    
    private var style: Style = .fullScreen
    private var tableView: UITableView!
    let disposeBag = DisposeBag()
    var viewModel: EventListViewModel!
    
//    override func loadView() {
//        super.loadView()
//        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
//        setupTableView()
//    }
    
    required init(coder aDecoder: NSCoder) { super.init(coder: aDecoder)! }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    init(style: Style) {
        super.init(nibName: nil, bundle: nil)
        self.style = style
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
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
        tableView.backgroundColor = .white
        tableView.register(EventTableCell.self, forCellReuseIdentifier: EventTableCell.defaultReusableId)
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .singleLine
        tableView.keyboardDismissMode = .onDrag
        tableView.contentInset = UIEdgeInsetsMake(80, 0, 0, 0)
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            switch self.style {
            case .fullScreen: make.edges.equalTo(view)
            case .modal: make.edges.equalTo(view).inset(40)
            }
        }
    }
    
}
