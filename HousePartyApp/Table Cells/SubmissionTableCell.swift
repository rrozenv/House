//
//  SubmissionTableCell.swift
//  HousePartyApp
//
//  Created by Robert Rozenvasser on 5/28/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

final class SubmissionTableCell: UITableViewCell {
    
    // MARK: - Properties
    static let defaultReusableId: String = "SubmissionTableCell"
    private var disposeBag = DisposeBag()
    private var containerView: UIView!
    private var mainLabel: UILabel!
    private var collectionView: UICollectionView!
    private var collectionViewGridLayout: ContactsCollViewGridLayout!
    
    // MARK: - Initialization
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        self.contentView.backgroundColor = UIColor.white
        self.separatorInset = .zero
        self.preservesSuperviewLayoutMargins = false
        self.layoutMargins = .zero
        self.selectionStyle = .none
        setupContainerView()
        setupCollectionView()
        setupMainLabel()
    }
    
    // MARK: - Configuration
    func configureWith(value: Submission) {
        mainLabel.text = value.createdAt.description
        Observable.of(value.allNumbers)
            .observeOn(MainScheduler.instance)
            .bind(to: collectionView.rx.items(cellIdentifier: ContactCollCell.defaultReusableId, cellType: ContactCollCell.self)) { row, element, cell in
                cell.configureWithNumber(value: element)
            }
            .disposed(by: disposeBag)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
}

extension SubmissionTableCell {
    
    //MARK: View Setup
    private func setupContainerView() {
        collectionViewGridLayout = ContactsCollViewGridLayout()
        containerView = UIView()
        containerView.backgroundColor = UIColor.green
        
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
    }
    
    private func setupMainLabel() {
        mainLabel = UILabel().rxStyle(font: FontBook.AvenirMedium.of(size: 20), color: .black, alignment: .left)
        
        containerView.addSubview(mainLabel)
        mainLabel.snp.makeConstraints { (make) in
            make.top.equalTo(containerView)
            make.left.equalTo(containerView).offset(20)
            make.bottom.equalTo(collectionView.snp.top)
        }
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: collectionViewGridLayout)
        collectionView.backgroundColor = UIColor.orange
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.allowsMultipleSelection = false
        collectionView.register(ContactCollCell.self, forCellWithReuseIdentifier: ContactCollCell.defaultReusableId)
        
        containerView.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(containerView)
            make.height.equalTo(collectionViewGridLayout.itemSize.height + 1.0)
        }
    }
    
}
