//
//  ECPublicKey.swift
//  Bitcoin
//
//  Created by Wolf McNally on 11/1/18.
//

import CBitcoin
import WolfPipe

public let ecCompressedPublicKeySize: Int = { return _ecCompressedPublicKeySize() }()
public let ecUncompressedPublicKeySize: Int = { return _ecUncompressedPublicKeySize() }()

public class ECPublicKey {
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

public func base16Encode(_ publicKey: ECPublicKey) -> String {
    return publicKey.data |> base16Encode
}

/// Derive the EC public key of an EC private key.
///
/// This is a curried function suitable for use with the pipe operator.
public func toECPublicKey(isCompressed: Bool) -> (_ privateKey: ECPrivateKey) throws -> ECPublicKey {
    return { privateKey in
        return try privateKey.data.withUnsafeBytes { (privateKeyBytes: UnsafePointer<UInt8>) in
            var publicKeyBytes: UnsafeMutablePointer<UInt8>!
            var publicKeyLength: Int = 0
            guard _toECPublicKey(privateKeyBytes, privateKey.data.count, isCompressed, &publicKeyBytes, &publicKeyLength) else {
                throw BitcoinError.invalidFormat
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
            guard _toECPaymentAddress(publicKeyBytes, publicKey.data.count, version.rawValue, &addressBytes, &addressLength) else {
                throw BitcoinError.invalidFormat
            }
            return receiveString(bytes: addressBytes, count: addressLength)
        }
    }
}
