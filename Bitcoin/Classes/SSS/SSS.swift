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
import WolfPipe

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

    static let maxMessageSize = 4096
    static let shareMetadataSize = 49

    public static func createShares(from message: Data, shareCount: Int, quorum: Int) throws -> [SSSKeyShare] {
        let messageSize = message.count
        guard messageSize <= maxMessageSize else {
            throw BitcoinError.invalidDataSize
        }
        let shareLength = messageSize + shareMetadataSize
        let outBufferLen = shareLength * shareCount
        var outData = Data(count: outBufferLen)
        return try outData.withUnsafeMutableBytes { (outBytes: UnsafeMutablePointer<UInt8>) -> [SSSKeyShare] in
            return try message.withUnsafeBytes { (inBytes: UnsafePointer<UInt8>) -> [SSSKeyShare] in
                let result = _sss_create_shares_varlen(outBytes, inBytes, messageSize, UInt8(shareCount), UInt8(quorum))
                guard result == 0 else {
                    throw BitcoinError.invalidDataSize
                }

                var shares = [SSSKeyShare]()
                let p = UnsafeRawPointer(outBytes)
                let id = seed(count: 16)
                for i in 0 ..< shareCount {
                    let message = Data(bytes: p + i * shareLength, count: shareLength)
                    shares.append(SSSKeyShare(message: message, id: id))
                }
                return shares
            }
        }
    }

    public static func combineShares(_ shares: [SSSKeyShare]) throws -> Data? {
        guard !shares.isEmpty else { return nil }

        let shareSize = shares.first!.message.count
        guard (shareMetadataSize...(maxMessageSize + shareMetadataSize)).contains(shareSize) else {
            throw BitcoinError.invalidDataSize
        }
        var sharesData = Data()
        for share in shares {
            let shareData = share.message
            guard shareData.count == shareSize else {
                throw BitcoinError.invalidDataSize
            }
            sharesData += shareData
        }
        let messageSize = shareSize - 49
        var message = Data(count: messageSize)
        let result: Int32 = message.withUnsafeMutableBytes { (messageBytes: UnsafeMutablePointer<UInt8>) -> Int32 in
            sharesData.withUnsafeBytes { (sharesBytes: UnsafePointer<UInt8>) -> Int32 in
                _sss_combine_shares_varlen(messageBytes, sharesBytes, shareSize, UInt8(shares.count))
            }
        }
        guard result == 0 else {
            return nil
        }
        return message
    }
}
