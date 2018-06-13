//
//  SelectCityViewController.swift
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

class SelectCityViewController: UIViewController, BindableType, CustomNavBarViewable {
    
    private var searchBarView: SearchBarView!
    private var tableView: UITableView!
    var navView: BackButtonNavView = BackButtonNavView.blackArrow
    var navBackgroundView: UIView = UIView()
    
    let disposeBag = DisposeBag()
    var viewModel: SelectCityViewModel!
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = .white
        setupNavBar()
        navView.containerView.backgroundColor = Palette.lightGrey.color
        navBackgroundView.backgroundColor = Palette.lightGrey.color
        setupSearchBarView()
        setupTableView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    deinit { print("SelectCityViewController deinit") }
    
    func bindViewModel() {
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        //MARK: - Inputs
        let cityTapped$ = tableView.rx.modelSelected(String.self).asObservable()
        viewModel.bindDidSelectCity(cityTapped$)
        
//        let backTapped$ = navView.backButton.rx.tap.asObservable()
//        viewModel.bindBackButton(backTapped$)
        
        let searchText$ = searchBarView.searchTextField.rx.text.orEmpty.asObservable()
            .filter { [unowned self] _ in self.searchBarView.searchTextField.isFirstResponder }
        viewModel.bindSearchText(searchText$)
        
        let clearSearchTapped$ = searchBarView.clearButton.rx.tap.asObservable()
            .do(onNext: { [unowned self] in self.searchBarView.searchTextField.text = nil })
        viewModel.bindClearSearch(clearSearchTapped$)
        
        //MARK: - Outputs
        viewModel.displayedCities
            .observeOn(MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: TitleSelectionCell.defaultReusableId, cellType: TitleSelectionCell.self)) { row, element, cell in
                cell.configureWith(value: element)
            }
            .disposed(by: disposeBag)
    }
    
    private func setupSearchBarView() {
        searchBarView = SearchBarView()
        searchBarView.style(placeHolder: "Search city...", backColor: Palette.lightGrey.color, searchIcon: #imageLiteral(resourceName: "IC_Search"), clearIcon: #imageLiteral(resourceName: "IC_ClearSearch"))
    
        view.addSubview(searchBarView)
        searchBarView.snp.makeConstraints { (make) in
            make.left.equalTo(navView.backButton.snp.right).offset(15)
            make.right.equalTo(view).offset(-15)
            make.centerY.equalTo(navView)
            make.height.equalTo(ViewConst.rectButtonHeight)
        }
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.register(TitleSelectionCell.self, forCellReuseIdentifier: TitleSelectionCell.defaultReusableId)
        tableView.separatorStyle = .singleLine
        tableView.keyboardDismissMode = .onDrag
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.top.equalTo(navView.snp.bottom)
        }
    }
    
}

extension SelectCityViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return TitleSelectionCell.height
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return TitleHeaderView.height
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = TitleHeaderView()
        headerView.configureWith(value: "What's your CITY?")
        let varyingFontInfo = VaryingFontInfo(originalText: "What's your CITY?", fontDict: ["CITY?": FontBook.AvenirBlack.of(size: 14), "What's your": FontBook.AvenirMedium.of(size: 13)], fontColor: .black)
        headerView.mainLabel.varyingFonts(info: varyingFontInfo)
        return headerView
    }

}

