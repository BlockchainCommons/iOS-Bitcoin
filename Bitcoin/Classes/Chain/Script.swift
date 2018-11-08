//
//  Script.swift
//  Bitcoin
//
//  Created by Wolf McNally on 11/7/18.
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

/// Decode a script to plain text tokens.
public func scriptDecode(_ data: Data) -> String {
    return data.withUnsafeBytes { (dataBytes: UnsafePointer<UInt8>) in
        var decoded: UnsafeMutablePointer<Int8>!
        var decodedLength = 0
        _scriptDecode(dataBytes, data.count, &decoded, &decodedLength)
        return receiveString(bytes: decoded, count: decodedLength)
    }
}

/// Encode a plain text script.
public func scriptEncode(_ script: String) throws -> Data {
    return try script.withCString { (scriptBytes: UnsafePointer<Int8>) in
        var encoded: UnsafeMutablePointer<UInt8>!
        var encodedLength = 0
        if let error = BitcoinError(rawValue: _scriptEncode(scriptBytes, &encoded, &encodedLength)) {
            throw error
        }
        return receiveData(bytes: encoded, count: encodedLength)
    }
}

/// Create a BIP16 pay-to-script-hash address from a script.
public func scriptToAddress(version: UInt8) -> (_ script: String) throws -> String {
    return { script in
        return try script.withCString { (scriptBytes: UnsafePointer<Int8>) in
            var paymentAddress: UnsafeMutablePointer<Int8>!
            var paymentAddressLength = 0
            if let error = BitcoinError(rawValue: _scriptToAddress(scriptBytes, version, &paymentAddress, &paymentAddressLength)) {
                throw error
            }
            return receiveString(bytes: paymentAddress, count: paymentAddressLength)
        }
    }
}

/// Create a BIP16 pay-to-script-hash address from a script.
public func scriptToAddress(network: PaymentAddressNetwork) -> (_ script: String) throws -> String {
    return scriptToAddress(version: PaymentAddressVersion(network: network, type: .p2sh).version)
}

/// Create a BIP16 pay-to-script-hash address from a script.
public func scriptToAddress(_ script: String) throws -> String {
    return try script |> scriptToAddress(network: .mainnet)
}
