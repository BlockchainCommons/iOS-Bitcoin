//
//  ECPublicKey.swift
//  Bitcoin
//
//  Created by Wolf McNally on 11/1/18.
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
import WolfPipe

public let ecCompressedPublicKeySize: Int = { return _ecCompressedPublicKeySize() }()
public let ecUncompressedPublicKeySize: Int = { return _ecUncompressedPublicKeySize() }()

public class ECPublicKey: ECKey {
    public let data: Data

    init(data: Data) {
        self.data = data
    }
}

public class ECCompressedPublicKey: ECPublicKey {
    public init(_ data: Data) throws {
        guard data.count == ecCompressedPublicKeySize else {
            throw BitcoinError.invalidDataSize
        }
        super.init(data: data)
    }
}

public class ECUncompressedPublicKey: ECPublicKey {
    public init(_ data: Data) throws {
        guard data.count == ecUncompressedPublicKeySize else {
            throw BitcoinError.invalidDataSize
        }
        super.init(data: data)
    }
}

public func toECPublicKey(_ data: Data) throws -> ECPublicKey {
    switch data.count {
    case ecCompressedPublicKeySize:
        return try ECCompressedPublicKey(data)
    case ecUncompressedPublicKeySize:
        return try ECUncompressedPublicKey(data)
    default:
        throw BitcoinError.invalidFormat
    }
}

/// Derive the EC public key of an EC private key.
///
/// This is a curried function suitable for use with the pipe operator.
public func toECPublicKey(isCompressed: Bool) -> (_ privateKey: ECPrivateKey) throws -> ECPublicKey {
    return { privateKey in
        return try privateKey.data.withUnsafeBytes { (privateKeyBytes: UnsafePointer<UInt8>) in
            var publicKeyBytes: UnsafeMutablePointer<UInt8>!
            var publicKeyLength: Int = 0
            if let error = BitcoinError(rawValue: _toECPublicKey(privateKeyBytes, privateKey.data.count, isCompressed, &publicKeyBytes, &publicKeyLength)) {
                throw error
            }
            let data = receiveData(bytes: publicKeyBytes, count: publicKeyLength)
            if isCompressed {
                return try ECCompressedPublicKey(data)
            } else {
                return try ECUncompressedPublicKey(data)
            }
        }
    }
}

/// Derive the compressed EC public key of an EC private key.
///
/// This is a single-argument function suitable for use with the pipe operator.
public func toECPublicKey(_ privateKey: ECPrivateKey) throws -> ECPublicKey {
    return try privateKey |> toECPublicKey(isCompressed: true)
}

public enum ECPaymentAddressVersion: UInt8 {
    case mainnetP2KH = 0x00
    case mainnetP2SH = 0x05
    case testnetP2KH = 0x6f
    case testnetP2SH = 0xc4
}

/// Convert an EC public key to a payment address.
public func toECPaymentAddress(version: ECPaymentAddressVersion) -> (_ publicKey: ECPublicKey) throws -> String {
    return { publicKey in
        return try publicKey.data.withUnsafeBytes { (publicKeyBytes: UnsafePointer<UInt8>) in
            var addressBytes: UnsafeMutablePointer<Int8>!
            var addressLength: Int = 0
            if let error = BitcoinError(rawValue: _toECPaymentAddress(publicKeyBytes, publicKey.data.count, version.rawValue, &addressBytes, &addressLength)) {
                throw error
            }
            return receiveString(bytes: addressBytes, count: addressLength)
        }
    }
}
