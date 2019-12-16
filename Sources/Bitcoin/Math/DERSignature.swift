//
//  DERSignature.swift
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
import WolfFoundation
import WolfPipe

public enum DERSignatureTag { }
/// A DER-encoded signature
public typealias DERSignature = Tagged<DERSignatureTag, Data>

public func tagDERSignature(_ data: Data) throws -> DERSignature {
    guard (64 ... 72).contains(data.count) else {
        throw BitcoinError.invalidDataSize
    }
    return DERSignature(rawValue: data)
}

public func toDERSignature(_ ecSignature: ECSignature) throws -> DERSignature {
    return try ecSignature®.withUnsafeBytes { (ecSignatureBytes: UnsafeRawBufferPointer) in
        var derSignatureBytes: UnsafeMutablePointer<UInt8>!
        var derSignatureLength = 0
        if let error = BitcoinError(rawValue: _encodeSignature(ecSignatureBytes®, &derSignatureBytes, &derSignatureLength)) {
            throw error
        }
        return try receiveData(bytes: derSignatureBytes, count: derSignatureLength) |> tagDERSignature
    }
}
