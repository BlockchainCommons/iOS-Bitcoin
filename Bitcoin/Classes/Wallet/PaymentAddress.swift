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
}

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

public func addressEncode(_ ripemd160: Data) -> String {
    return ripemd160 |> addressEncode()
}
