//
//  Hash.swift
//  Bitcoin
//
//  Created by Wolf McNally on 10/24/18.
//

import CBitcoin

public func RIPEMD160Hash(_ data: Data) -> Data {
    return data.withUnsafeBytes { (dataBytes: UnsafePointer<UInt8>) -> Data in
        var bytes: UnsafeMutablePointer<UInt8>!
        var count: Int = 0
        _RIPEMD160Hash(dataBytes, data.count, &bytes, &count)
        return receiveData(bytes: bytes, count: count)
    }
}

public func SHA1Hash(_ data: Data) -> Data {
    return data.withUnsafeBytes { (dataBytes: UnsafePointer<UInt8>) -> Data in
        var bytes: UnsafeMutablePointer<UInt8>!
        var count: Int = 0
        _SHA1Hash(dataBytes, data.count, &bytes, &count)
        return receiveData(bytes: bytes, count: count)
    }
}

public func SHA256Hash(_ data: Data) -> Data {
    return data.withUnsafeBytes { (dataBytes: UnsafePointer<UInt8>) -> Data in
        var bytes: UnsafeMutablePointer<UInt8>!
        var count: Int = 0
        _SHA256Hash(dataBytes, data.count, &bytes, &count)
        return receiveData(bytes: bytes, count: count)
    }
}

public func SHA256HMAC(key: Data) -> (_ data: Data) -> Data {
    return { data in
        data.withUnsafeBytes { (dataBytes: UnsafePointer<UInt8>) -> Data in
            key.withUnsafeBytes { (keyBytes: UnsafePointer<UInt8>) -> Data in
                var bytes: UnsafeMutablePointer<UInt8>!
                var count: Int = 0
                _SHA256HMAC(dataBytes, data.count, keyBytes, key.count, &bytes, &count)
                return receiveData(bytes: bytes, count: count)
            }
        }
    }
}

public func SHA512Hash(_ data: Data) -> Data {
    return data.withUnsafeBytes { (dataBytes: UnsafePointer<UInt8>) -> Data in
        var bytes: UnsafeMutablePointer<UInt8>!
        var count: Int = 0
        _SHA512Hash(dataBytes, data.count, &bytes, &count)
        return receiveData(bytes: bytes, count: count)
    }
}

public func SHA512HMAC(key: Data) -> (_ data: Data) -> Data {
    return { data in
        data.withUnsafeBytes { (dataBytes: UnsafePointer<UInt8>) -> Data in
            key.withUnsafeBytes { (keyBytes: UnsafePointer<UInt8>) -> Data in
                var bytes: UnsafeMutablePointer<UInt8>!
                var count: Int = 0
                _SHA512HMAC(dataBytes, data.count, keyBytes, key.count, &bytes, &count)
                return receiveData(bytes: bytes, count: count)
            }
        }
    }
}

public func PKCS5PBKDf2HMACSHA512(salt: Data, iterations: Int) -> (_ passphrase: Data) -> Data {
    return { passphrase in
        passphrase.withUnsafeBytes { (passphraseBytes: UnsafePointer<UInt8>) -> Data in
            salt.withUnsafeBytes { (saltBytes: UnsafePointer<UInt8>) -> Data in
                var bytes: UnsafeMutablePointer<UInt8>!
                var count: Int = 0
                _PKCS5PBKDf2HMACSHA512(passphraseBytes, passphrase.count, saltBytes, salt.count, iterations, &bytes, &count)
                return receiveData(bytes: bytes, count: count)
            }
        }
    }
}

public func bitcoinHash(_ data: Data) -> Data {
    return data.withUnsafeBytes { (dataBytes: UnsafePointer<UInt8>) -> Data in
        var bytes: UnsafeMutablePointer<UInt8>!
        var count: Int = 0
        _bitcoinHash(dataBytes, data.count, &bytes, &count)
        return receiveData(bytes: bytes, count: count)
    }
}

public func bitcoinShortHash(_ data: Data) -> Data {
    return data.withUnsafeBytes { (dataBytes: UnsafePointer<UInt8>) -> Data in
        var bytes: UnsafeMutablePointer<UInt8>!
        var count: Int = 0
        _bitcoinShortHash(dataBytes, data.count, &bytes, &count)
        return receiveData(bytes: bytes, count: count)
    }
}
