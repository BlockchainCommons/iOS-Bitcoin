//
//  Hash.swift
//  Bitcoin
//
//  Created by Wolf McNally on 10/24/18.
//
//  Copyright © 2018 Blockchain Commons.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

import CBitcoin
import WolfFoundation
import WolfPipe

public enum RIPEMD160Tag { }
public typealias RIPEMD160 = Tagged<RIPEMD160Tag, Data>

public func ripemd160(_ data: Data) throws -> RIPEMD160 {
    guard data.count == 20 else {
        throw BitcoinError.invalidDataSize
    }
    return RIPEMD160(rawValue: data)
}

public func toRIPEMD160(_ data: Data) -> RIPEMD160 {
    return data.withUnsafeBytes { (dataBytes: UnsafePointer<UInt8>) in
        var bytes: UnsafeMutablePointer<UInt8>!
        var count: Int = 0
        _ripemd160(dataBytes, data.count, &bytes, &count)
        return try! receiveData(bytes: bytes, count: count) |> ripemd160
    }
}


public enum SHA160Tag { }
public typealias SHA160 = Tagged<SHA160Tag, Data>

public func sha160(_ data: Data) throws -> SHA160 {
    guard data.count == 20 else {
        throw BitcoinError.invalidDataSize
    }
    return SHA160(rawValue: data)
}

public func toSHA160(_ data: Data) -> SHA160 {
    return data.withUnsafeBytes { (dataBytes: UnsafePointer<UInt8>) in
        var bytes: UnsafeMutablePointer<UInt8>!
        var count: Int = 0
        _sha160(dataBytes, data.count, &bytes, &count)
        return try! receiveData(bytes: bytes, count: count) |> sha160
    }
}


public enum SHA256Tag { }
public typealias SHA256 = Tagged<SHA256Tag, Data>

public func sha256(_ data: Data) throws -> SHA256 {
    guard data.count == 32 else {
        throw BitcoinError.invalidDataSize
    }
    return SHA256(rawValue: data)
}

public func toSHA256(_ data: Data) -> SHA256 {
    return data.withUnsafeBytes { (dataBytes: UnsafePointer<UInt8>) in
        var bytes: UnsafeMutablePointer<UInt8>!
        var count: Int = 0
        _sha256(dataBytes, data.count, &bytes, &count)
        return try! receiveData(bytes: bytes, count: count) |> sha256
    }
}


public enum SHA512Tag { }
public typealias SHA512 = Tagged<SHA512Tag, Data>

public func sha512(_ data: Data) throws -> SHA512 {
    guard data.count == 64 else {
        throw BitcoinError.invalidDataSize
    }
    return SHA512(rawValue: data)
}

public func toSHA512(_ data: Data) -> SHA512 {
    return data.withUnsafeBytes { (dataBytes: UnsafePointer<UInt8>) in
        var bytes: UnsafeMutablePointer<UInt8>!
        var count: Int = 0
        _sha512(dataBytes, data.count, &bytes, &count)
        return try! receiveData(bytes: bytes, count: count) |> sha512
    }
}


public enum Bitcoin256Tag { }
public typealias Bitcoin256 = Tagged<Bitcoin256Tag, Data>

public func bitcoin256(_ data: Data) throws -> Bitcoin256 {
    guard data.count == 32 else {
        throw BitcoinError.invalidDataSize
    }
    return Bitcoin256(rawValue: data)
}

public func toBitcoin256(_ data: Data) -> Bitcoin256 {
    return data.withUnsafeBytes { (dataBytes: UnsafePointer<UInt8>) in
        var bytes: UnsafeMutablePointer<UInt8>!
        var count: Int = 0
        _bitcoin256(dataBytes, data.count, &bytes, &count)
        return try! receiveData(bytes: bytes, count: count) |> bitcoin256
    }
}


public enum Bitcoin160Tag { }
public typealias Bitcoin160 = Tagged<Bitcoin160Tag, Data>

public func bitcoin160(_ data: Data) throws -> Bitcoin160 {
    guard data.count == 20 else {
        throw BitcoinError.invalidDataSize
    }
    return Bitcoin160(rawValue: data)
}

public func toBitcoin160(_ data: Data) -> Bitcoin160 {
    return data.withUnsafeBytes { (dataBytes: UnsafePointer<UInt8>) in
        var bytes: UnsafeMutablePointer<UInt8>!
        var count: Int = 0
        _bitcoin160(dataBytes, data.count, &bytes, &count)
        return try! receiveData(bytes: bytes, count: count) |> bitcoin160
    }
}


public enum SHA256HMACTag { }
public typealias SHA256HMAC = Tagged<SHA256HMACTag, Data>

public func sha256HMAC(_ data: Data) throws -> SHA256HMAC {
    guard data.count == 32 else {
        throw BitcoinError.invalidDataSize
    }
    return SHA256HMAC(rawValue: data)
}

public func toSHA256HMAC(key: Data) -> (_ data: Data) -> SHA256HMAC {
    return { data in
        data.withUnsafeBytes { (dataBytes: UnsafePointer<UInt8>) in
            key.withUnsafeBytes { (keyBytes: UnsafePointer<UInt8>) in
                var bytes: UnsafeMutablePointer<UInt8>!
                var count: Int = 0
                _sha256HMAC(dataBytes, data.count, keyBytes, key.count, &bytes, &count)
                return try! receiveData(bytes: bytes, count: count) |> sha256HMAC
            }
        }
    }
}


public enum SHA512HMACTag { }
public typealias SHA512HMAC = Tagged<SHA512HMACTag, Data>

public func sha512HMAC(_ data: Data) throws -> SHA512HMAC {
    guard data.count == 64 else {
        throw BitcoinError.invalidDataSize
    }
    return SHA512HMAC(rawValue: data)
}

public func toSHA512HMAC(key: Data) -> (_ data: Data) -> SHA512HMAC {
    return { data in
        data.withUnsafeBytes { (dataBytes: UnsafePointer<UInt8>) in
            key.withUnsafeBytes { (keyBytes: UnsafePointer<UInt8>) in
                var bytes: UnsafeMutablePointer<UInt8>!
                var count: Int = 0
                _sha512HMAC(dataBytes, data.count, keyBytes, key.count, &bytes, &count)
                return try! receiveData(bytes: bytes, count: count) |> sha512HMAC
            }
        }
    }
}


public enum PKCS5PBKDF2HMACSHA512Tag { }
public typealias PKCS5PBKDF2HMACSHA512 = Tagged<PKCS5PBKDF2HMACSHA512Tag, Data>

public func pkcs5PBKDF2HMACSHA512(_ data: Data) throws -> PKCS5PBKDF2HMACSHA512 {
    guard data.count == 64 else {
        throw BitcoinError.invalidDataSize
    }
    return PKCS5PBKDF2HMACSHA512(rawValue: data)
}

public func toPKCS5PBKDF2HMACSHA512(salt: Data, iterations: Int) -> (_ passphrase: Data) -> PKCS5PBKDF2HMACSHA512 {
    return { passphrase in
        passphrase.withUnsafeBytes { (passphraseBytes: UnsafePointer<UInt8>) in
            salt.withUnsafeBytes { (saltBytes: UnsafePointer<UInt8>) in
                var bytes: UnsafeMutablePointer<UInt8>!
                var count: Int = 0
                _pkcs5PBKDF2HMACSHA512(passphraseBytes, passphrase.count, saltBytes, salt.count, iterations, &bytes, &count)
                return try! receiveData(bytes: bytes, count: count) |> pkcs5PBKDF2HMACSHA512
            }
        }
    }
}
