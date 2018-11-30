//
//  WIF.swift
//  Bitcoin
//
//  Created by Wolf McNally on 11/29/18.
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

public enum WIFTag { }
public typealias WIF = Tagged<WIFTag, String>

public func wif(_ string: String) -> WIF { return WIF(rawValue: string) }

public enum WIFVersion: UInt8 {
    case mainnet = 0x80
    case testnet = 0xef
}

/// Convert an EC private key to a WIF private key.
public func toWIF(version: WIFVersion, isCompressed: Bool = true) -> (_ privateKey: ECPrivateKey) throws -> WIF {
    return { privateKey in
        var wifBytes: UnsafeMutablePointer<Int8>!
        var wifLength: Int = 0
        try privateKey.rawValue.withUnsafeBytes { (privateKeyBytes: UnsafePointer<UInt8>) in
            if let error = BitcoinError(rawValue: _ecPrivateKeyToWIF(privateKeyBytes, privateKey.rawValue.count, version.rawValue, isCompressed, &wifBytes, &wifLength)) {
                throw error
            }
        }
        return receiveString(bytes: wifBytes, count: wifLength) |> wif
    }
}

/// Convert an EC private key to a WIF private key.
public func toWIF(_ privateKey: ECPrivateKey) throws -> WIF {
    return try privateKey |> toWIF(version: .mainnet)
}

/// Convert a WIF private key to an EC private key.
public func toECPrivateKey(_ wif: WIF) throws -> ECPrivateKey {
    var privateKeyBytes: UnsafeMutablePointer<UInt8>!
    var privateKeyLength: Int = 0
    try wif.rawValue.withCString { wifString in
        if let error = BitcoinError(rawValue: _wifToECPrivateKey(wifString, &privateKeyBytes, &privateKeyLength)) {
            throw error
        }
    }
    return try ECPrivateKey(receiveData(bytes: privateKeyBytes, count: privateKeyLength))
}
