//
//  PaymentAddress.swift
//  Bitcoin
//
//  Created by Wolf McNally on 11/5/18.
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

public enum PaymentAddressTag { }
public typealias PaymentAddress = Tagged<PaymentAddressTag, String>
public func tagPaymentAddress(_ string: String) -> PaymentAddress { return PaymentAddress(rawValue: string) }

public enum PaymentAddressEncoding {
    case p2pkh
    case p2sh
    case p2wpkh
    case p2wsh
    case p2wpkhInP2sh
    case p2wshInP2sh
}

public struct PaymentAddressVersion {
    public let network: Network
    public let type: PaymentAddressEncoding

    public var version: UInt8 {
        switch network {
        case .mainnet:
            switch type {
            case .p2pkh:
                return 0
            case .p2sh:
                return 5
            default:
                fatalError("Unsupported")
            }
        case .testnet:
            switch type {
            case .p2pkh:
                return 111
            case .p2sh:
                return 196
            default:
                fatalError("Unsupported")
            }
        }
    }

    public init(network: Network, type: PaymentAddressEncoding) {
        self.network = network
        self.type = type
    }

    public init?(version: UInt8) {
        switch version {
        case 0:
            network = .mainnet
            type = .p2sh
        case 5:
            network = .mainnet
            type = .p2pkh
        case 111:
            network = .testnet
            type = .p2sh
        case 196:
            network = .testnet
            type = .p2pkh
        default:
            return nil
        }
    }
}

/// Convert a RIPEMD160 value to a payment address.
public func addressEncode(version: UInt8) -> (_ ripemd160: ShortHash) -> PaymentAddress {
    return { ripemd160 in
        ripemd160®.withUnsafeBytes { ripemd160Bytes in
            var address: UnsafeMutablePointer<Int8>!
            var addressLength = 0
            _addressEncode(ripemd160Bytes®, version, &address, &addressLength)
            return receiveString(bytes: address, count: addressLength) |> tagPaymentAddress
        }
    }
}

/// Convert a RIPEMD160 value to a payment address.
public func addressEncode(network: Network = .mainnet, type: PaymentAddressEncoding = .p2pkh) -> (_ ripemd160: ShortHash) -> PaymentAddress {
    return addressEncode(version: PaymentAddressVersion(network: network, type: type).version)
}

/// Convert a RIPEMD160 value to a payment address.
public func addressEncode(_ ripemd160: ShortHash) -> PaymentAddress {
    return ripemd160 |> addressEncode()
}

/// Convert a payment address to its component parts.
public func addressDecode(_ address: PaymentAddress) throws -> WrappedData {
    return try address®.withCString { (addressString: UnsafePointer<Int8>) in
        var prefix: UInt8 = 0
        var payloadBytes: UnsafeMutablePointer<UInt8>!
        var payloadLength = 0
        var checksum: UInt32 = 0
        if let error = BitcoinError(rawValue: _addressDecode(addressString, &prefix, &payloadBytes, &payloadLength, &checksum)) {
            throw error
        }
        let payload = receiveData(bytes: payloadBytes, count: payloadLength)
        return WrappedData(prefix: prefix, payload: payload, checksum: checksum)
    }
}

public func getHash(_ paymentAddress: PaymentAddress) throws -> ShortHash {
    return try paymentAddress®.withCString { addressBytes in
        var hashBytes: UnsafeMutablePointer<UInt8>!
        var hashLength = 0
        if let result = BitcoinError(rawValue: _addressHash(addressBytes, &hashBytes, &hashLength)) {
            throw result
        }
        return try receiveData(bytes: hashBytes, count: hashLength) |> tagShortHash
    }
}

public func network(_ address: PaymentAddress) throws -> Network {
    let wrappedData = try address |> addressDecode
    guard let version = PaymentAddressVersion(version: wrappedData.prefix) else {
        throw BitcoinError.invalidAddress
    }
    return version.network
}

/// Create a payment address with an embedded record of binary data.
///
/// The data is hashed as RIPEMD160 and then embedded in a script of the form:
///
///     dup hash160 [RIPEMD160] equalverify checksig
///
/// The script is then serialized, hashed as RIPEMD160, and used with the specified version to create a Bitcoin payment address.
public func addressEmbed(version: UInt8) -> (_ data: Data) -> PaymentAddress {
    return { data in
        data.withUnsafeBytes { dataBytes in
            var address: UnsafeMutablePointer<Int8>!
            var addressLength = 0
            _addressEmbed(dataBytes®, data.count, version, &address, &addressLength)
            return receiveString(bytes: address, count: addressLength) |> tagPaymentAddress
        }
    }
}

/// Create a payment address with an embedded record of binary data.
///
/// The data is hashed as RIPEMD160 and then embedded in a script of the form:
///
///     dup hash160 [RIPEMD160] equalverify checksig
///
/// The script is then serialized, hashed as RIPEMD160, and used with the specified version to create a Bitcoin payment address.
public func addressEmbed(network: Network, type: PaymentAddressEncoding) -> (_ data: Data) -> PaymentAddress {
    return addressEmbed(version: PaymentAddressVersion(network: network, type: type).version)
}
