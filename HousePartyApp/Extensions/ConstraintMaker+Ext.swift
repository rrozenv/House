//
//  ConstraintMaker + Ext.swift
//  DesignatedHitter
//
//  Created by Robert Rozenvasser on 4/20/18.
//  Copyright © 2018 Blueprint. All rights reserved.
//

import Foundation
import SnapKit

extension ConstraintMaker {
    func topEqualTo(_ view: UIView) {
        if #available(iOS 11.0, *) {
            self.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        } else {
            self.top.equalTo(view.snp.top).offset(Constants.STATUS_BAR_HEIGHT)
        }
    }
}
