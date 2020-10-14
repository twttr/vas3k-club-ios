//
//  Extensions.swift
//  vas3k-club-ios
//
//  Created by Romanishkin, Pavel on 14.10.20.
//  Copyright © 2020 Romanishkin, Pavel. All rights reserved.
//

import Foundation

extension String {
    func substring(from: Int, to: Int) -> String {
        let start = index(startIndex, offsetBy: from)
        let end = index(start, offsetBy: to - from)
        return String(self[start ..< end])
    }

    func substring(range: NSRange) -> String {
        return substring(from: range.lowerBound, to: range.upperBound)
    }
}
