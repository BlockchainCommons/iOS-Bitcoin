//
//  SSS.swift
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

public struct SSS {
    public static func randomBytes(count: Int) throws -> Data {
        var data = Data(count: count)
        let result = data.withUnsafeMutableBytes {
            _randombytes($0, count)
        }
        guard result == 0 else {
            throw BitcoinError.noRandomNumberSource
        }
        return data
    }

    public static func createShares(from message: SSSMessage, shareCount: Int, quorum: Int) -> [SSSShare] {
        let outBufferSize = SSSShare.length * shareCount + 1000
        var outBuffer = Data(count: outBufferSize)
        return outBuffer.withUnsafeMutableBytes { (outBytes: UnsafeMutablePointer<UInt8>) in
            message.data.withUnsafeBytes { (messageBytes: UnsafePointer<UInt8>) in
                _sss_create_shares(UnsafeMutableRawPointer(outBytes), messageBytes, UInt8(shareCount), UInt8(quorum))

                var shares = [SSSShare]()
                let p = UnsafeRawPointer(outBytes)
                for i in 0 ..< shareCount {
                    let data = Data(bytes: p + i * SSSShare.length, count: SSSShare.length)
                    try! shares.append(SSSShare(data: data))
                }
                return shares
            }
        }
    }

    public static func combineShares(_ shares: [SSSShare]) -> SSSMessage? {
        let inBuffer = shares.reduce(into: Data()) { (buf, share) in buf.append(share.data) }
        return inBuffer.withUnsafeBytes { (sharesBytes: UnsafePointer<UInt8>) -> SSSMessage? in
            var data = Data(count: SSSMessage.length)
            let result = data.withUnsafeMutableBytes { (messageBytes: UnsafeMutablePointer<UInt8>) in
                return _sss_combine_shares(messageBytes, UnsafeRawPointer(sharesBytes), UInt8(shares.count))
            }
            guard result == 0 else {
                return nil
            }
            return try! SSSMessage(data: data)
        }
    }

    // The message to be split is possibly longer than the SSS message length (64 bytes).
    // So, we instead symmetrically encrypt the message with a new secret key, which then becomes
    // the thing we split. We then distribute the encrypted message with each share of the split key.
    public static func createShares(from data: Data, shareCount: Int, quorum: Int) -> [SSSKeyShare] {
        let key = Crypto.generateKey()
        let ciphertext = try! Crypto.encrypt(plaintext: data, key: key)
        let paddingLength = SSSMessage.length - key.count
        assert(paddingLength >= 0)
        let keyMessage = try! SSSMessage(data: key + Data(count: paddingLength))
        let keyShares = SSS.createShares(from: keyMessage, shareCount: shareCount, quorum: quorum)
        return keyShares.map { keyShare in
            return SSSKeyShare(message: ciphertext.message, nonce: ciphertext.nonce, key: keyShare.data)
        }
    }

    public static func combineShares(_ shares: [SSSKeyShare]) throws -> Data? {
        guard !shares.isEmpty else { return nil }

        let ciphertext = Crypto.Ciphertext(message: shares.first!.message, nonce: shares.first!.nonce)

        let keyShares = try shares.map { try SSSShare(data: $0.key) }

        guard let paddedKey = SSS.combineShares(keyShares)?.data else { return nil }
        guard paddedKey.count >= Crypto.keyLength else { throw BitcoinError.invalidDataSize }
        let recoveredKey = paddedKey[0 ..< Crypto.keyLength]

        return try Crypto.decrypt(ciphertext: ciphertext, key: recoveredKey)
    }
}
