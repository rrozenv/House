//
//  EventTableCell.swift
//  HousePartyApp
//
//  Created by Robert Rozenvasser on 5/28/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

final class EventTableCell: UITableViewCell {
    
    // MARK: - Properties
    static let defaultReusableId: String = "EventTableCell"
    private var disposeBag = DisposeBag()
    private var containerView: UIView!
    private var mainLabel: UILabel!
    private var dateLabel: UILabel!
    private var countLabel: UILabel!
    
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
        setupNameLabelsStackView()
    }
    
    // MARK: - Configuration
    func configureWith(value: Event) {
        mainLabel.text = value.venueName
        dateLabel.text = value.date.description
        countLabel.text = "Added: \(value.submissions.count) submissions"
    }
    
}

extension EventTableCell {
    
    //MARK: View Setup
    private func setupContainerView() {
        containerView = UIView()
        containerView.backgroundColor = UIColor.green
        
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
    }
    
    private func setupNameLabelsStackView() {
        mainLabel = UILabel().rxStyle(font: FontBook.AvenirHeavy.of(size: 15), color: .black, alignment: .left)
        mainLabel.numberOfLines = 0
        
        dateLabel = UILabel().rxStyle(font: FontBook.AvenirMedium.of(size: 13), color: .black, alignment: .left)
        dateLabel.numberOfLines = 0
        
        countLabel = UILabel().rxStyle(font: FontBook.AvenirMedium.of(size: 13), color: .black, alignment: .left)
        countLabel.numberOfLines = 0


        let views: [UILabel] = [mainLabel, dateLabel, countLabel]
        let labelsStackView = UIStackView(arrangedSubviews: views)
        labelsStackView.spacing = 2.0
        labelsStackView.axis = .vertical
        
        containerView.addSubview(labelsStackView)
        labelsStackView.snp.makeConstraints { (make) in
            make.edges.equalTo(containerView)
        }
    }
    
}
