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
import WolfCore

public func signMessage(with privateKey: ECPrivateKey) -> (_ message: Data) -> ECSignature {
    return { message in
        message |> toSHA256 |> sign(with: privateKey)
    }
}

public func verifySignature(publicKey: ECPublicKey, signature: ECSignature) -> (_ message: Data) -> Bool {
    return { message in
        message |> toSHA256 |> verifySignature(publicKey: publicKey, signature: signature)
    }
}

public func sign(with privateKey: ECPrivateKey) -> (_ hash: HashDigest) -> ECSignature {
    return { hash in
        return hash®.withUnsafeBytes { hashBytes -> ECSignature in
            privateKey®.withUnsafeBytes { privateKeyBytes -> ECSignature in
                var signature: UnsafeMutablePointer<UInt8>!
                var signatureLength = 0
                _sign(hashBytes®, privateKeyBytes®, &signature, &signatureLength)
                return try! receiveData(bytes: signature, count: signatureLength) |> tagECSignature
            }
        }
    }
}

public func verifySignature(publicKey: ECPublicKey, signature: ECSignature) -> (_ hash: HashDigest) -> Bool {
    return { hash in
        return hash®.withUnsafeBytes { hashBytes in
            publicKey®.withUnsafeBytes { publicKeyBytes in
                signature®.withUnsafeBytes { signatureBytes in
                    _verifySignature(publicKeyBytes®, publicKey®.count, hashBytes®, signatureBytes®)
                }
            }
        }
    }
}

/// Create a message signature.
public func signMessage(with wif: WIF) -> (_ message: Data) -> String {
    return { message in
        wif®.withCString { (wifString: UnsafePointer<Int8>) in
            message.withUnsafeBytes { messageBytes in
                var signatureBytes: UnsafeMutablePointer<Int8>!
                var signatureLength = 0
                _messageSign(messageBytes®, message.count, wifString, &signatureBytes, &signatureLength)
                return receiveString(bytes: signatureBytes, count: signatureLength)
            }
        }
    }
}

/// Validate a message signature.
public func validateMessage(paymentAddress: PaymentAddress, signature: String) -> (_ message: Data) -> Bool {
    return { message in
        paymentAddress®.withCString { (paymentAddressString: UnsafePointer<Int8>) in
            signature.withCString { (signatureString: UnsafePointer<Int8>) in
                message.withUnsafeBytes { messageBytes in
                    _messageValidate(paymentAddressString, signatureString, messageBytes®, message.count)
                }
            }
        }
    }
}
