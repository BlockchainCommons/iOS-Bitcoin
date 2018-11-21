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
import WolfPipe

/// A DER-encoded signature
public struct DERSignature {
    public let data: Data

    public init(_ data: Data) throws {
        guard data.count <= 72 else {
            throw BitcoinError.invalidDataSize
        }
        self.data = data
    }
}

// MARK: - Free functions

public func toDERSignature(_ data: Data) throws -> DERSignature {
    return try DERSignature(data)
}

public func derEncode(_ ecSignature: ECSignature) throws -> DERSignature {
    return try ecSignature.data.withUnsafeBytes { (ecSignatureBytes: UnsafePointer<UInt8>) in
        var derSignatureBytes: UnsafeMutablePointer<UInt8>!
        var derSignatureLength = 0
        if let error = BitcoinError(rawValue: _encodeSignature(ecSignatureBytes, &derSignatureBytes, &derSignatureLength)) {
            throw error
        }
        return try DERSignature(receiveData(bytes: derSignatureBytes, count: derSignatureLength))
    }
}

public func derDecode(isStrict: Bool) -> (_ derSignature: DERSignature) throws -> ECSignature {
    return { derSignature in
        try derSignature.data.withUnsafeBytes { (derSignatureBytes: UnsafePointer<UInt8>) in
            var ecSignatureBytes: UnsafeMutablePointer<UInt8>!
            var ecSignatureLength = 0
            if let error = BitcoinError(rawValue: _parseSignature(derSignatureBytes, derSignature.data.count, isStrict, &ecSignatureBytes, &ecSignatureLength)) {
                throw error
            }
            return try ECSignature(receiveData(bytes: ecSignatureBytes, count: ecSignatureLength))
        }
    }
}

public func derDecode(_ derSignature: DERSignature) throws -> ECSignature {
    return try derSignature |> derDecode(isStrict: true)
}
