//
//  ECSignature.swift
//  Bitcoin
//
//  Created by Wolf McNally on 11/19/18.
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
import WolfCore

public enum ECSignatureTag { }
/// Parsed ECDSA signature
public typealias ECSignature = Tagged<ECSignatureTag, Data>

public func tagECSignature(_ data: Data) throws -> ECSignature {
    guard data.count == 64 else {
        throw BitcoinError.invalidDataSize
    }
    return ECSignature(rawValue: data)
}

public func toECSignature(isStrict: Bool) -> (_ derSignature: DERSignature) throws -> ECSignature {
    return { derSignature in
        try derSignature®.withUnsafeBytes { (derSignatureBytes: UnsafeRawBufferPointer) in
            var ecSignatureBytes: UnsafeMutablePointer<UInt8>!
            var ecSignatureLength = 0
            if let error = BitcoinError(rawValue: _parseSignature(derSignatureBytes®, derSignature®.count, isStrict, &ecSignatureBytes, &ecSignatureLength)) {
                throw error
            }
            return try receiveData(bytes: ecSignatureBytes, count: ecSignatureLength) |> tagECSignature
        }
    }
}

public func toECSignature(_ derSignature: DERSignature) throws -> ECSignature {
    return try derSignature |> toECSignature(isStrict: true)
}
