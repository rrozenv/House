//
//  UITextView+Ext.swift
//  HousePartyApp
//
//  Created by Robert Rozenvasser on 5/16/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    
    func varyingFonts(originalText: String,
                      fontDict: [String: UIFont],
                      fontColor: UIColor) {
        let style = NSMutableParagraphStyle()
        style.alignment = .left
        let attributedOriginalText = NSMutableAttributedString(string: originalText)
        
        fontDict.forEach {
            let linkRange = attributedOriginalText.mutableString.range(of: $0.key)
            attributedOriginalText.addAttribute(NSAttributedStringKey.font, value: $0.value, range: linkRange)
        }
        
        let fullRange = NSMakeRange(0, attributedOriginalText.length)
        attributedOriginalText.addAttribute(NSAttributedStringKey.paragraphStyle, value: style, range: fullRange)

        self.attributedText = attributedOriginalText
    }
    
}
