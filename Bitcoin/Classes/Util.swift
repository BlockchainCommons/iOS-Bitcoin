//
//  Util.swift
//  Bitcoin
//
//  Created by Wolf McNally on 10/24/18.
//

import CBitcoin

func receiveString(bytes: UnsafeMutablePointer<Int8>, count: Int) -> String {
    defer { _freeString(bytes) }
    let stringData = Data(bytes: bytes, count: count)
    return String(data: stringData, encoding: .utf8)!
}

func receiveData(bytes: UnsafeMutablePointer<UInt8>, count: Int) -> Data {
    defer { _freeData(bytes) }
    return Data(bytes: bytes, count: count)
}
