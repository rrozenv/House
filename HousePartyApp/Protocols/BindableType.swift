//
//  BindableType.swift
//  DesignatedHitter
//
//  Created by Robert Rozenvasser on 4/19/18.
//  Copyright © 2018 Blueprint. All rights reserved.
//

import Foundation
import UIKit

protocol BindableType {
    associatedtype ViewModelType
    var viewModel: ViewModelType! { get set }
    func bindViewModel()
}

extension BindableType where Self: UIViewController {
    mutating func setViewModelBinding(model: Self.ViewModelType) {
        viewModel = model
        loadViewIfNeeded()
        bindViewModel()
    }
}
