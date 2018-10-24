//
//  ASCII.swift
//  Bitcoin
//
//  Created by Wolf McNally on 10/23/18.
//

extension StringProtocol {
    var ascii: [Int8] {
        return unicodeScalars.compactMap { $0.isASCII ? Int8($0.value) : nil }
    }
}

extension Character {
    var ascii: Int8? {
        let a = self.unicodeScalars.first!
        return a.isASCII ? Int8(a.value) : nil
    }
}
