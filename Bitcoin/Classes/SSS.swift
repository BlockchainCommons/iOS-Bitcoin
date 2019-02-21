//
//  SSS.swift
//  Bitcoin
//
//  Created by Wolf McNally on 2/20/19.
//

import CBitcoin

public func randomBytes(count: Int) -> Data {
    var data = Data(count: count)
    let result = data.withUnsafeMutableBytes {
        _randombytes($0, count)
    }
    return data
}
