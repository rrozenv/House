//
//  KeyboardAvoidable.swift
//  HousePartyApp
//
//  Created by Robert Rozenvasser on 5/12/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import RxSwift

protocol KeyboardAvoidable: class {
    var disposeBag: DisposeBag { get }
    var latestKeyboardHeight: CGFloat { get set }
    var bottomConstraint: Constraint! { get set }
    func bindKeyboardNotifications(bottomOffset: CGFloat)
}

extension KeyboardAvoidable where Self: UIViewController {
    func bindKeyboardNotifications(bottomOffset: CGFloat) {
        UIDevice.keyboardHeightWillChange
            .subscribe(onNext: { height in
                if self.latestKeyboardHeight > 0 && height != 0 { return }
                self.bottomConstraint.update(offset: -height - bottomOffset)
                UIView.animate(withDuration: 0.5) { self.view.layoutIfNeeded() }
                self.latestKeyboardHeight = height
            })
            .disposed(by: disposeBag)
    }
}
