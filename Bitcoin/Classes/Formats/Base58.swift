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
public func toBase58(_ data: Data) -> String {
    return data.withUnsafeBytes { (dataBytes: UnsafePointer<UInt8>) -> String in
        var bytes: UnsafeMutablePointer<Int8>!
        var count: Int = 0
        _encodeBase58(dataBytes, data.count, &bytes, &count)
        return receiveString(bytes: bytes, count: count)
    }
}

/// Decodes the base58 format string.
///
/// Throws if the string is not valid base58.
public func base58ToData(_ string: String) throws -> Data {
    return try string.withCString { (stringBytes) in
        var bytes: UnsafeMutablePointer<UInt8>?
        var count: Int = 0
        _decodeBase58(stringBytes, &bytes, &count)
        guard let dataBytes = bytes else {
            throw BitcoinError("Invalid Base58 format")
        }
        return receiveData(bytes: dataBytes, count: count)
    }
}

/// Encodes the data as a base58check string.
public func toBase58CheckWithVersion(_ version: UInt8) -> (_ data: Data) -> String {
    return { data in
        return data.withUnsafeBytes { (dataBytes: UnsafePointer<UInt8>) -> String in
            var bytes: UnsafeMutablePointer<Int8>!
            var count: Int = 0
            _encodeBase58Check(dataBytes, data.count, version, &bytes, &count)
            return receiveString(bytes: bytes, count: count)
        }
    }
}

public func toBase58Check(_ data: Data) -> String {
    return toBase58CheckWithVersion(0)(data)
}

public func base58CheckToDataWithVersion(_ version: UInt8) -> (_ string: String) throws -> Data {
    return { string in
        return try string.withCString { (stringBytes) in
            var bytes: UnsafeMutablePointer<UInt8>?
            var count: Int = 0
            var decodedVersion: UInt8 = 0
            _decodeBase58Check(stringBytes, &bytes, &count, &decodedVersion)
            guard let dataBytes = bytes else {
                throw BitcoinError("Invalid Base58Check format")
            }
            guard decodedVersion == version else {
                throw BitcoinError("Unexpected Base58Check version number.")
            }
            return receiveData(bytes: dataBytes, count: count)
        }
    }
}

public func base58CheckToData(_ string: String) throws -> Data {
    return try base58CheckToDataWithVersion(0)(string)
}
