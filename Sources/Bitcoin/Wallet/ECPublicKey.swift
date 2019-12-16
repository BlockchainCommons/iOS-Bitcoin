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
import WolfFoundation

public let ecCompressedPublicKeySize: Int = { return _ecCompressedPublicKeySize() }()
public let ecUncompressedPublicKeySize: Int = { return _ecUncompressedPublicKeySize() }()

public class ECPublicKey: ECKey {
    public func decompress() throws -> ECPublicKey {
        return self
    }

    public func compress() throws -> ECPublicKey {
        return self
    }
}

public final class ECCompressedPublicKey: ECPublicKey {
    public init(_ rawValue: Data) throws {
        guard rawValue.count == ecCompressedPublicKeySize else {
            throw BitcoinError.invalidDataSize
        }
        super.init(rawValue: rawValue)
    }

    required init(rawValue: Data) {
        super.init(rawValue: rawValue)
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    public override func decompress() throws -> ECPublicKey {
        return try! rawValue.withUnsafeBytes { compressedBytes in
            var uncompressed: UnsafeMutablePointer<UInt8>!
            var uncompressedLength = 0
            if let error = BitcoinError(rawValue: _decompress(compressedBytes®, &uncompressed, &uncompressedLength)) {
                throw error
            }
            return try ECUncompressedPublicKey(receiveData(bytes: uncompressed, count: uncompressedLength))
        }
    }
}

public final class ECUncompressedPublicKey: ECPublicKey {
    public init(_ rawValue: Data) throws {
        guard rawValue.count == ecUncompressedPublicKeySize else {
            throw BitcoinError.invalidDataSize
        }
        super.init(rawValue: rawValue)
    }

    required init(rawValue: Data) {
        super.init(rawValue: rawValue)
    }

    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
    }

    public override func compress() throws -> ECPublicKey {
        return try! rawValue.withUnsafeBytes { uncompressedBytes in
            var compressed: UnsafeMutablePointer<UInt8>!
            var compressedLength = 0
            if let error = BitcoinError(rawValue: _compress(uncompressedBytes®, &compressed, &compressedLength)) {
                throw error
            }
            return try ECCompressedPublicKey(receiveData(bytes: compressed, count: compressedLength))
        }
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
        return try privateKey®.withUnsafeBytes { privateKeyBytes in
            var publicKeyBytes: UnsafeMutablePointer<UInt8>!
            var publicKeyLength: Int = 0
            if let error = BitcoinError(rawValue: _toECPublicKey(privateKeyBytes®, privateKey®.count, isCompressed, &publicKeyBytes, &publicKeyLength)) {
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

public func toECPublicKey(_ hdKey: HDKey) throws -> ECPublicKey {
    return try hdKey |> toECPrivateKey |> toECPublicKey
}

public enum ECPaymentAddressType {
    case p2kh
    case p2sh

    public func version(for network: Network) -> UInt8 {
        switch self {
        case .p2kh:
            return network.paymentAddressP2KHVersion
        case .p2sh:
            return network.paymentAddressP2SHVersion
        }
    }
}

extension Network {
    public var paymentAddressP2KHVersion: UInt8 {
        switch self {
        case .mainnet:
            return 0x00
        case .testnet:
            return 0x6f
        }
    }

    public var paymentAddressP2SHVersion: UInt8 {
        switch self {
        case .mainnet:
            return 0x05
        case .testnet:
            return 0xc4
        }
    }
}

/// Convert an EC public key to a payment address.
public func toECPaymentAddress(network: Network, type: ECPaymentAddressType) -> (_ publicKey: ECPublicKey) throws -> PaymentAddress {
    return { publicKey in
        return try publicKey®.withUnsafeBytes { publicKeyBytes in
            var addressBytes: UnsafeMutablePointer<Int8>!
            var addressLength: Int = 0
            if let error = BitcoinError(rawValue: _toECPaymentAddress(publicKeyBytes®, publicKey®.count, type.version(for: network), &addressBytes, &addressLength)) {
                throw error
            }
            return receiveString(bytes: addressBytes, count: addressLength) |> tagPaymentAddress
        }
    }
}

public func decompress(_ key: ECPublicKey) throws -> ECPublicKey {
    return try key.decompress()
}

public func compress(_ key: ECPublicKey) throws -> ECPublicKey {
    return try key.compress()
}
