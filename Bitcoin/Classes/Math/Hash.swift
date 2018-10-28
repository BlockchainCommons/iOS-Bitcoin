//
//  Hash.swift
//  Bitcoin
//
//  Created by Wolf McNally on 10/24/18.
//

import CBitcoin

public func ripemd160(_ data: Data) -> Data {
    return data.withUnsafeBytes { (dataBytes: UnsafePointer<UInt8>) -> Data in
        var bytes: UnsafeMutablePointer<UInt8>!
        var count: Int = 0
        _ripemd160(dataBytes, data.count, &bytes, &count)
        return receiveData(bytes: bytes, count: count)
    }
}

public func sha160(_ data: Data) -> Data {
    return data.withUnsafeBytes { (dataBytes: UnsafePointer<UInt8>) -> Data in
        var bytes: UnsafeMutablePointer<UInt8>!
        var count: Int = 0
        _sha160(dataBytes, data.count, &bytes, &count)
        return receiveData(bytes: bytes, count: count)
    }
}

public func sha256(_ data: Data) -> Data {
    return data.withUnsafeBytes { (dataBytes: UnsafePointer<UInt8>) -> Data in
        var bytes: UnsafeMutablePointer<UInt8>!
        var count: Int = 0
        _sha256(dataBytes, data.count, &bytes, &count)
        return receiveData(bytes: bytes, count: count)
    }
}

public func sha256HMAC(key: Data) -> (_ data: Data) -> Data {
    return { data in
        data.withUnsafeBytes { (dataBytes: UnsafePointer<UInt8>) -> Data in
            key.withUnsafeBytes { (keyBytes: UnsafePointer<UInt8>) -> Data in
                var bytes: UnsafeMutablePointer<UInt8>!
                var count: Int = 0
                _sha256HMAC(dataBytes, data.count, keyBytes, key.count, &bytes, &count)
                return receiveData(bytes: bytes, count: count)
            }
        }
    }
}

public func sha512(_ data: Data) -> Data {
    return data.withUnsafeBytes { (dataBytes: UnsafePointer<UInt8>) -> Data in
        var bytes: UnsafeMutablePointer<UInt8>!
        var count: Int = 0
        _sha512(dataBytes, data.count, &bytes, &count)
        return receiveData(bytes: bytes, count: count)
    }
}

public func sha512HMAC(key: Data) -> (_ data: Data) -> Data {
    return { data in
        data.withUnsafeBytes { (dataBytes: UnsafePointer<UInt8>) -> Data in
            key.withUnsafeBytes { (keyBytes: UnsafePointer<UInt8>) -> Data in
                var bytes: UnsafeMutablePointer<UInt8>!
                var count: Int = 0
                _sha512HMAC(dataBytes, data.count, keyBytes, key.count, &bytes, &count)
                return receiveData(bytes: bytes, count: count)
            }
        }
    }
}

public func pkcs5PBKDF2HMACSHA512(salt: Data, iterations: Int) -> (_ passphrase: Data) -> Data {
    return { passphrase in
        passphrase.withUnsafeBytes { (passphraseBytes: UnsafePointer<UInt8>) -> Data in
            salt.withUnsafeBytes { (saltBytes: UnsafePointer<UInt8>) -> Data in
                var bytes: UnsafeMutablePointer<UInt8>!
                var count: Int = 0
                _pkcs5PBKDF2HMACSHA512(passphraseBytes, passphrase.count, saltBytes, salt.count, iterations, &bytes, &count)
                return receiveData(bytes: bytes, count: count)
            }
        }
    }
}

public func bitcoin256(_ data: Data) -> Data {
    return data.withUnsafeBytes { (dataBytes: UnsafePointer<UInt8>) -> Data in
        var bytes: UnsafeMutablePointer<UInt8>!
        var count: Int = 0
        _bitcoin256(dataBytes, data.count, &bytes, &count)
        return receiveData(bytes: bytes, count: count)
    }
}

public func bitcoin160(_ data: Data) -> Data {
    return data.withUnsafeBytes { (dataBytes: UnsafePointer<UInt8>) -> Data in
        var bytes: UnsafeMutablePointer<UInt8>!
        var count: Int = 0
        _bitcoin160(dataBytes, data.count, &bytes, &count)
        return receiveData(bytes: bytes, count: count)
    }
}
