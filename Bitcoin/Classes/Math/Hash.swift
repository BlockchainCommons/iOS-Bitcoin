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

public func toRIPEMD160(_ data: Data) -> ShortHash {
    return data.withUnsafeBytes { dataBytes in
        var bytes: UnsafeMutablePointer<UInt8>!
        var count: Int = 0
        _ripemd160(dataBytes®, data.count, &bytes, &count)
        return try! receiveData(bytes: bytes, count: count) |> tagShortHash
    }
}

public func toSHA160(_ data: Data) -> ShortHash {
    return data.withUnsafeBytes { dataBytes in
        var bytes: UnsafeMutablePointer<UInt8>!
        var count: Int = 0
        _sha160(dataBytes®, data.count, &bytes, &count)
        return try! receiveData(bytes: bytes, count: count) |> tagShortHash
    }
}

public func toSHA256(_ data: Data) -> HashDigest {
    return data.withUnsafeBytes { dataBytes in
        var bytes: UnsafeMutablePointer<UInt8>!
        var count: Int = 0
        _sha256(dataBytes®, data.count, &bytes, &count)
        return try! receiveData(bytes: bytes, count: count) |> tagHashDigest
    }
}

public func toSHA512(_ data: Data) -> LongHash {
    return data.withUnsafeBytes { dataBytes in
        var bytes: UnsafeMutablePointer<UInt8>!
        var count: Int = 0
        _sha512(dataBytes®, data.count, &bytes, &count)
        return try! receiveData(bytes: bytes, count: count) |> tagLongHash
    }
}

public func toBitcoin256(_ data: Data) -> HashDigest {
    return data.withUnsafeBytes { dataBytes in
        var bytes: UnsafeMutablePointer<UInt8>!
        var count: Int = 0
        _bitcoin256(dataBytes®, data.count, &bytes, &count)
        return try! receiveData(bytes: bytes, count: count) |> tagHashDigest
    }
}

public func toBitcoin160(_ data: Data) -> ShortHash {
    return data.withUnsafeBytes { dataBytes in
        var bytes: UnsafeMutablePointer<UInt8>!
        var count: Int = 0
        _bitcoin160(dataBytes®, data.count, &bytes, &count)
        return try! receiveData(bytes: bytes, count: count) |> tagShortHash
    }
}

public func toSHA256HMAC(key: Data) -> (_ data: Data) -> HashDigest {
    return { data in
        data.withUnsafeBytes { dataBytes in
            key.withUnsafeBytes { keyBytes in
                var bytes: UnsafeMutablePointer<UInt8>!
                var count: Int = 0
                _sha256HMAC(dataBytes®, data.count, keyBytes®, key.count, &bytes, &count)
                return try! receiveData(bytes: bytes, count: count) |> tagHashDigest
            }
        }
    }
}

public func toSHA512HMAC(key: Data) -> (_ data: Data) -> LongHash {
    return { data in
        data.withUnsafeBytes { dataBytes in
            key.withUnsafeBytes { keyBytes in
                var bytes: UnsafeMutablePointer<UInt8>!
                var count: Int = 0
                _sha512HMAC(dataBytes®, data.count, keyBytes®, key.count, &bytes, &count)
                return try! receiveData(bytes: bytes, count: count) |> tagLongHash
            }
        }
    }
}

public func toPKCS5PBKDF2HMACSHA512(salt: Data, iterations: Int) -> (_ passphrase: Data) -> LongHash {
    return { passphrase in
        passphrase.withUnsafeBytes { passphraseBytes in
            salt.withUnsafeBytes { saltBytes in
                var bytes: UnsafeMutablePointer<UInt8>!
                var count: Int = 0
                _pkcs5PBKDF2HMACSHA512(passphraseBytes®, passphrase.count, saltBytes®, salt.count, iterations, &bytes, &count)
                return try! receiveData(bytes: bytes, count: count) |> tagLongHash
            }
        }
    }
}
