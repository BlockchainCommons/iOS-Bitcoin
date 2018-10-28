//
//  Base58.swift
//  Bitcoin
//
//  Created by Wolf McNally on 10/23/18.
//

import CBitcoin

extension Character {
    /// Returns true if the character is a valid base58 character, false otherwise.
    public var isBase58: Bool {
        guard let a = self.ascii else { return false }
        return _isBase58Char(a)
    }
}

extension String {
    /// Returns true if the string is a valid base58 character, false otherwise.
    public var isBase58: Bool {
        return self.withCString {
            _isBase58String($0)
        }
    }
}

/// Encodes the data as a base58 string.
public func base58Encode(_ data: Data) -> String {
    return data.withUnsafeBytes { (dataBytes: UnsafePointer<UInt8>) -> String in
        var bytes: UnsafeMutablePointer<Int8>!
        var count: Int = 0
        _base58Encode(dataBytes, data.count, &bytes, &count)
        return receiveString(bytes: bytes, count: count)
    }
}

/// Decodes the base58 format string.
///
/// Throws if the string is not valid base58.
public func base58Decode(_ string: String) throws -> Data {
    return try string.withCString { (stringBytes) in
        var bytes: UnsafeMutablePointer<UInt8>?
        var count: Int = 0
        _base58Decode(stringBytes, &bytes, &count)
        guard let dataBytes = bytes else {
            throw BitcoinError("Invalid Base58 format")
        }
        return receiveData(bytes: dataBytes, count: count)
    }
}

/// Encodes the data as a base58check string.
public func base58CheckEncode(version: UInt8) -> (_ data: Data) -> String {
    return { data in
        return data.withUnsafeBytes { (dataBytes: UnsafePointer<UInt8>) -> String in
            var bytes: UnsafeMutablePointer<Int8>!
            var count: Int = 0
            _base58CheckEncode(dataBytes, data.count, version, &bytes, &count)
            return receiveString(bytes: bytes, count: count)
        }
    }
}

public func base58CheckEncode(_ data: Data) -> String {
    return base58CheckEncode(version: 0)(data)
}

public func base58CheckDecode(_ string: String) throws -> (version: UInt8, payload: Data) {
    return try string.withCString { (stringBytes) in
        var bytes: UnsafeMutablePointer<UInt8>?
        var count: Int = 0
        var version: UInt8 = 0
        _base58CheckDecode(stringBytes, &bytes, &count, &version)
        guard let dataBytes = bytes else {
            throw BitcoinError("Invalid Base58Check format")
        }
        let data = receiveData(bytes: dataBytes, count: count)
        return (version, data)
    }
}
