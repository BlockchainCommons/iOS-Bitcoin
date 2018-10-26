//
//  Base16.swift
//  Bitcoin
//
//  Created by Wolf McNally on 10/24/18.
//

import CBitcoin

/// Encodes the data as a base16 (hex) string.
public func toBase16(_ data: Data) -> String {
    return data.withUnsafeBytes { (dataBytes: UnsafePointer<UInt8>) -> String in
        var bytes: UnsafeMutablePointer<Int8>!
        var count: Int = 0
        _encodeBase16(dataBytes, data.count, &bytes, &count)
        return receiveString(bytes: bytes, count: count)
    }
}

/// Decodes the base16 (hex) format string.
///
/// Throws if the string is not valid base16.
public func base16ToData(_ string: String) throws -> Data {
    return try string.withCString { (stringBytes) in
        var bytes: UnsafeMutablePointer<UInt8>?
        var count: Int = 0
        _decodeBase16(stringBytes, &bytes, &count)
        guard let dataBytes = bytes else {
            throw BitcoinError("Invalid Base16 format.")
        }
        return receiveData(bytes: dataBytes, count: count)
    }
}

/// Encodes the bitcoin hash as a string.
///
/// The bitcoin hash format is like base16, but with the bytes reversed.
/// Throws if the input data is not exactly 32 bytes long.
public func toHash(_ data: Data) throws -> String {
    guard data.count == 32 else {
        throw BitcoinError("Invalid bitcoin hash.")
    }
    return data.withUnsafeBytes { (dataBytes: UnsafePointer<UInt8>) -> String in
        var bytes: UnsafeMutablePointer<Int8>!
        var count: Int = 0
        _encodeHash(dataBytes, &bytes, &count)
        return receiveString(bytes: bytes, count: count)
    }
}

/// Decodes the base16 (hex) format string.
///
/// The bitcoin hash format is like base16, but with the bytes reversed.
/// Throws if the string is not valid base16.
public func hashToData(_ string: String) throws -> Data {
    return try string.withCString { (stringBytes) in
        var bytes: UnsafeMutablePointer<UInt8>?
        var count: Int = 0
        _decodeHash(stringBytes, &bytes, &count)
        guard let dataBytes = bytes else {
            throw BitcoinError("Invalid bitcoin hash format.")
        }
        return receiveData(bytes: dataBytes, count: count)
    }
}
