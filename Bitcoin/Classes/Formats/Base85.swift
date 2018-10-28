//
//  Base85.swift
//  Bitcoin
//
//  Created by Wolf McNally on 10/25/18.
//

import CBitcoin

/// Encodes the data as a base85 string.
public func base85Encode(_ data: Data) -> String {
    return data.withUnsafeBytes { (dataBytes: UnsafePointer<UInt8>) -> String in
        var bytes: UnsafeMutablePointer<Int8>!
        var count: Int = 0
        _base85Encode(dataBytes, data.count, &bytes, &count)
        return receiveString(bytes: bytes, count: count)
    }
}

/// Decodes the base85 format string.
///
/// Throws if the string is not valid base85.
public func base85Decode(_ string: String) throws -> Data {
    return try string.withCString { (stringBytes) in
        var bytes: UnsafeMutablePointer<UInt8>?
        var count: Int = 0
        _base85Decode(stringBytes, &bytes, &count)
        guard let dataBytes = bytes else {
            throw BitcoinError("Invalid Base58 format.")
        }
        return receiveData(bytes: dataBytes, count: count)
    }
}
