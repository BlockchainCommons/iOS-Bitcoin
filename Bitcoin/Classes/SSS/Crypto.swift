//
//  Crypto.swift
//  Bitcoin
//
//  Created by Wolf McNally on 10/24/18.
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

public struct Crypto {
    public static var keyLength: Int { return _crypto_stream_keybytes() }
    public static var nonceLength: Int { return _crypto_stream_noncebytes() }

    public struct Ciphertext: Codable {
        public let message: Data
        public let nonce: Data

        public init(message: Data, nonce: Data) {
            self.message = message
            self.nonce = nonce
        }
    }

    public static func encrypt(plaintext: Data, key: Data) throws -> Ciphertext {
        guard key.count == keyLength else { throw BitcoinError.invalidDataSize }
        let messageLength = plaintext.count
        var output = Data(count: messageLength)
        let nonce = seed(count: nonceLength)
        let result = output.withUnsafeMutableBytes { outputBytes in
            plaintext.withUnsafeBytes { inputBytes in
                nonce.withUnsafeBytes { nonceBytes in
                    key.withUnsafeBytes { keyBytes in
                        _crypto_stream_xor(outputBytes, inputBytes, messageLength, nonceBytes, keyBytes)
                    }
                }
            }
        }
        guard result == 0 else { throw BitcoinError.invalidData }
        return Ciphertext(message: output, nonce: nonce)
    }

    public static func decrypt(ciphertext: Ciphertext, key: Data) throws -> Data {
        guard key.count == keyLength else { throw BitcoinError.invalidDataSize }
        guard ciphertext.nonce.count == nonceLength else { throw BitcoinError.invalidDataSize }
        let messageLength = ciphertext.message.count
        var output = Data(count: messageLength)
        let result = output.withUnsafeMutableBytes { outputBytes in
            ciphertext.message.withUnsafeBytes { inputBytes in
                ciphertext.nonce.withUnsafeBytes { nonceBytes in
                    key.withUnsafeBytes { keyBytes in
                        _crypto_stream_xor(outputBytes, inputBytes, messageLength, nonceBytes, keyBytes)
                    }
                }
            }
        }
        guard result == 0 else { throw BitcoinError.invalidData }
        return output
    }

    public static func generateKey() -> Data {
        return seed(count: keyLength)
    }
}
