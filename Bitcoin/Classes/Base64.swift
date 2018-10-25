//
//  Base64.swift
//  Bitcoin
//
//  Created by Wolf McNally on 10/25/18.
//

import WolfPipe
import CBitcoin

/// Encodes the data as a base64 string.
public func toBase64(_ data: Data) -> String {
    return data.withUnsafeBytes { (dataBytes: UnsafePointer<UInt8>) -> String in
        var bytes: UnsafeMutablePointer<Int8>!
        var count: Int = 0
        _encodeBase64(dataBytes, data.count, &bytes, &count)
        return receiveString(bytes: bytes, count: count)
    }
}

/// Decodes the base64 format string.
///
/// Throws if the string is not valid base64.
public func base64ToData(_ string: String) throws -> Data {
    return try string.withCString { (stringBytes) in
        var bytes: UnsafeMutablePointer<UInt8>?
        var count: Int = 0
        _decodeBase64(stringBytes, &bytes, &count)
        guard let dataBytes = bytes else {
            throw BitcoinError("Invalid Base58 format.")
        }
        return receiveData(bytes: dataBytes, count: count)
    }
}
