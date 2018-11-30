//
//  Signing.swift
//  Bitcoin
//
//  Created by Wolf McNally on 11/28/18.
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

public func sign(hash: HashDigest, privateKey: ECPrivateKey) -> ECSignature {
    return hash.rawValue.withUnsafeBytes { (hashBytes: UnsafePointer<UInt8>) -> ECSignature in
        privateKey.rawValue.withUnsafeBytes { (privateKeyBytes: UnsafePointer<UInt8>) -> ECSignature in
            var signature: UnsafeMutablePointer<UInt8>!
            var signatureLength = 0
            _sign(hashBytes, privateKeyBytes, &signature, &signatureLength)
            return try! receiveData(bytes: signature, count: signatureLength) |> ecSignature
        }
    }
}

public func verifySignature(hash: HashDigest, publicKey: ECPublicKey, signature: ECSignature) -> Bool {
    return hash.rawValue.withUnsafeBytes { (hashBytes: UnsafePointer<UInt8>) in
        publicKey.rawValue.withUnsafeBytes { (publicKeyBytes: UnsafePointer<UInt8>) in
            signature.rawValue.withUnsafeBytes { (signatureBytes: UnsafePointer<UInt8>) in
                _verifySignature(publicKeyBytes, publicKey.rawValue.count, hashBytes, signatureBytes)
            }
        }
    }
}

/// Create a message signature.
public func messageSign(wif: WIF) -> (_ message: Data) -> String {
    return { message in
        wif.rawValue.withCString { (wifString: UnsafePointer<Int8>) in
            message.withUnsafeBytes { (messageBytes: UnsafePointer<UInt8>) in
                var signatureBytes: UnsafeMutablePointer<Int8>!
                var signatureLength = 0
                _messageSign(messageBytes, message.count, wifString, &signatureBytes, &signatureLength)
                return receiveString(bytes: signatureBytes, count: signatureLength)
            }
        }
    }
}

/// Validate a message signature.
public func messageValidate(paymentAddress: PaymentAddress, signature: String) -> (_ message: Data) -> Bool {
    return { message in
        paymentAddress.rawValue.withCString { (paymentAddressString: UnsafePointer<Int8>) in
            signature.withCString { (signatureString: UnsafePointer<Int8>) in
                message.withUnsafeBytes { (messageBytes: UnsafePointer<UInt8>) in
                    _messageValidate(paymentAddressString, signatureString, messageBytes, message.count)
                }
            }
        }
    }
}
