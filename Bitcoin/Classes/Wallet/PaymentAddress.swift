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
import Foundation

public enum PaymentAddressNetwork {
    case mainnet
    case testnet
}

public enum PaymentAddressType {
    case p2pkh
    case p2sh
}

public struct PaymentAddressVersion {
    let network: PaymentAddressNetwork
    let type: PaymentAddressType

    public var prefix: UInt8 {
        switch network {
        case .mainnet:
            switch type {
            case .p2pkh:
                return 0
            case .p2sh:
                return 5
            }
        case .testnet:
            switch type {
            case .p2pkh:
                return 111
            case .p2sh:
                return 196
            }
        }
    }

    public init(network: PaymentAddressNetwork, type: PaymentAddressType) {
        self.network = network
        self.type = type
    }

    public init?(prefix: UInt8) {
        switch prefix {
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
public func addressEncode(network: PaymentAddressNetwork = .mainnet, type: PaymentAddressType = .p2pkh) -> (_ ripemd160: Data) -> String {
    let version = PaymentAddressVersion(network: network, type: type)
    return { ripemd160 in
        ripemd160.withUnsafeBytes { (ripemd160Bytes: UnsafePointer<UInt8>) in
            var paymentAddress: UnsafeMutablePointer<Int8>!
            var paymentAddressLength = 0
            _addressEncode(ripemd160Bytes, version.prefix, &paymentAddress, &paymentAddressLength)
            return receiveString(bytes: paymentAddress, count: paymentAddressLength)
        }
    }
}

/// Convert a RIPEMD160 value to a payment address.
public func addressEncode(_ ripemd160: Data) -> String {
    return ripemd160 |> addressEncode()
}

public struct PaymentAddressComponents: Encodable {
    public let prefix: UInt8
    public let payload: Data
    public let checksum: UInt32

    public enum CodingKeys: String, CodingKey {
        case prefix
        case payload
        case checksum
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(prefix, forKey: .prefix)
        try container.encode(payload |> base16Encode, forKey: .payload)
        try container.encode(checksum, forKey: .checksum)
    }
}

public func toJSON(_ components: PaymentAddressComponents) throws -> Data {
    let encoder = JSONEncoder()
    encoder.outputFormatting = [.sortedKeys]
    return try encoder.encode(components)
}

/// Convert a payment address to its component parts.
public func addressDecode(_ address: String) throws -> PaymentAddressComponents {
    return try address.withCString { (addressString: UnsafePointer<Int8>) in
        var payloadBytes: UnsafeMutablePointer<UInt8>!
        var payloadLength = 0
        var checksum: UInt32 = 0
        var prefix: UInt8 = 0
        if let error = BitcoinError(rawValue: _addressDecode(addressString, &payloadBytes, &payloadLength, &checksum, &prefix)) {
            throw error
        }
        let payload = receiveData(bytes: payloadBytes, count: payloadLength)
        return PaymentAddressComponents(prefix: prefix, payload: payload, checksum: checksum)
    }
}
