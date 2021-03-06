//
//  TxRef.swift
//  Bitcoin
//
//  Created by Wolf McNally on 11/8/19.
//  Copyright © 2019 Blockchain Commons. All rights reserved.
//

import Foundation
import WolfPipe
import WolfFoundation
import WolfStrings

///
/// Implemented from: *Bech32 Encoded Tx Position References*
/// https://github.com/bitcoin/bips/blob/master/bip-0136.mediawiki
///

public enum EncodedTxRefTag { }
public typealias EncodedTxRef = Tagged<EncodedTxRefTag, String>
public func tagEncodedTxRef(_ string: String) -> EncodedTxRef { return EncodedTxRef(rawValue: string) }

public struct TxRef: Equatable {
    public let network: Network
    public let blockHeight: Int
    public let txIndex: Int
    public let outIndex: Int

    public init(network: Network, blockHeight: Int, txIndex: Int, outIndex: Int = 0) {
        self.network = network
        self.blockHeight = blockHeight
        self.txIndex = txIndex
        self.outIndex = outIndex
    }
}

public func toEncoded(version: Bech32Version) -> (_ txRef: TxRef) -> EncodedTxRef {
    { txRef in
        toEncoded(txRef, version: version)
    }
}

public func toEncoded(_ txRef: TxRef) -> EncodedTxRef {
    toEncoded(txRef, version: .bech32)
}

public func toEncoded(_ txRef: TxRef, version: Bech32Version) -> EncodedTxRef {
    struct BitAggregator {
        private(set) var data: Data
        private var bitMask: UInt8

        init() {
            data = Data(count: 0)
            bitMask = 0
        }

        mutating func append(_ bit: Bool) {
            if bitMask == 0 {
                bitMask = 0x01
                data.append(0)
            }
            if bit {
                data[data.count - 1] = data[data.count - 1] | bitMask
            }
            bitMask <<= 1
            if bitMask == 0x20 {
                bitMask = 0
            }
        }

        mutating func append(bits: Int, of value: Int) {
            var v = value
            for _ in 0 ..< bits {
                let bit = (v & 1) == 1 ? true : false
                append(bit)
                v >>= 1
            }
        }
    }

    func aggregate(_ txRef: TxRef) -> (data: Data, hrp: String) {
        var aggregator = BitAggregator()

        let magicCode: Int
        let hrp: String
        switch txRef.network {
        case .mainnet:
            hrp = "tx"
            if txRef.outIndex == 0 {
                magicCode = 3
            } else {
                magicCode = 4
            }
        case .testnet:
            hrp = "txtest"
            if txRef.outIndex == 0 {
                magicCode = 6
            } else {
                magicCode = 7
            }
        }

        aggregator.append(bits: 5, of: magicCode)

        let version = 0
        aggregator.append(bits: 1, of: version)

        aggregator.append(bits: 24, of: txRef.blockHeight)
        aggregator.append(bits: 15, of: txRef.txIndex)

        if txRef.outIndex != 0 {
            aggregator.append(bits: 15, of: txRef.outIndex)
        }

        return (aggregator.data, hrp)
    }

    func insertSeparators(_ inputString: String) -> EncodedTxRef {
        let rawInputString: String
        let prefix: String
        if let txInputString = inputString.removingPrefix("tx1") {
            prefix = "tx1"
            rawInputString = txInputString
        } else if let txTestInputString = inputString.removingPrefix("txtest1") {
            prefix = "txtest1"
            rawInputString = txTestInputString
        } else {
            fatalError()
        }

        let parts = rawInputString.split(by: 4)
        let s = prefix + ":" + parts.joined(separator: "-")
        return s |> tagEncodedTxRef
    }

    let (data, hrp) = txRef |> aggregate
    switch version {
    case .bech32:
        let bech32 = data |> toBech32(hrp)
        return bech32® |> insertSeparators
    case .bech32bis:
        let bech32bis = data |> toBech32Bis(hrp)
        return bech32bis® |> insertSeparators
    }
}

public func toDecoded(version: Bech32Version) -> (_ encodedTxRef: EncodedTxRef) throws -> TxRef {
    { encodedTxRef in
        try toDecoded(encodedTxRef, version: version)
    }
}

public func toDecoded(_ encodedTxRef: EncodedTxRef) throws -> TxRef {
    try toDecoded(encodedTxRef, version: .bech32)
}

public func toDecoded(_ encodedTxRef: EncodedTxRef, version: Bech32Version) throws -> TxRef {
    final class BitEnumerator {
        private let data: Data
        private var byteIndex: Int
        private var bitMask: UInt8

        init(data: Data) {
            self.data = data
            byteIndex = 0
            bitMask = 0x01
        }

        private func next() -> Bool? {
            guard byteIndex < data.count else { return nil }
            let result = (data[byteIndex] & bitMask) != 0
            bitMask <<= 1
            if bitMask == 0x20 {
                bitMask = 0x01
                byteIndex += 1
            }
            return result
        }

        func next(bits: Int) -> Int? {
            var value = 0
            var bitMask = 1
            for _ in 0 ..< bits {
                guard let b = next() else { return nil }
                if b {
                    value |= bitMask
                }
                bitMask <<= 1
            }
            return value
        }
    }

    func stripSeparators(_ encodedTxRef: EncodedTxRef) throws -> String {
        let inputString = encodedTxRef®.lowercased()
        let rawInputString: String
        let prefix: String
        if let txInputString = inputString.removingPrefix("tx1") {
            prefix = "tx1"
            rawInputString = txInputString
        } else if let txTestInputString = inputString.removingPrefix("txtest1") {
            prefix = "txtest1"
            rawInputString = txTestInputString
        } else {
            throw TxRefError.unknownHumanReadablePart
        }

        let filteredString = rawInputString.filter { $0.isBech32 }
        return prefix + filteredString
    }

    let strippedString = try encodedTxRef |> stripSeparators
    let hrp: String
    let bech32Data: Data
    switch version {
    case .bech32:
        (hrp, bech32Data) = try strippedString |> tagBech32 |> toData
    case .bech32bis:
        (hrp, bech32Data) = try strippedString |> tagBech32Bis |> toData
    }

    let enumerator = BitEnumerator(data: bech32Data)

    guard let magicCode = enumerator.next(bits: 5) else {
        throw TxRefError.noMagicCode
    }

    let isTest: Bool
    switch magicCode {
    case 3, 4:
        isTest = false
    case 6, 7:
        isTest = true
    default:
        throw TxRefError.unknownMagicCode(magicCode)
    }

    let hasTestPrefix = hrp == "txtest"

    let hasOutpoint = (magicCode == 4 || magicCode == 7)

    if hasOutpoint {
        guard bech32Data.count == 12 else {
            throw TxRefError.invalidLength
        }
    } else {
        guard bech32Data.count == 9 else {
            throw TxRefError.invalidLength
        }
    }

    guard isTest == hasTestPrefix else {
        throw TxRefError.chainMismatch
    }

    guard let version = enumerator.next(bits: 1) else {
        throw TxRefError.noVersion
    }
    guard version == 0 else {
        throw TxRefError.unknownVersion(version)
    }
    guard let blockheight = enumerator.next(bits: 24) else {
        throw TxRefError.noBlockHeight
    }
    guard let txIndex = enumerator.next(bits: 15) else {
        throw TxRefError.noTxIndex
    }

    let outIndex: Int
    switch magicCode {
    case 4, 7: // has outpoint
        guard let i = enumerator.next(bits: 15) else {
            throw TxRefError.noOutIndex
        }
        guard i > 0 else {
            throw TxRefError.zeroOutIndex
        }
        outIndex = i
    default:
        outIndex = 0
    }

    let network: Network = isTest ? .testnet : .mainnet

    return TxRef(network: network, blockHeight: blockheight, txIndex: txIndex, outIndex: outIndex)
}

public enum TxRefError: LocalizedError {
    case noMagicCode
    case unknownMagicCode(Int)
    case noVersion
    case unknownVersion(Int)
    case noBlockHeight
    case noTxIndex
    case noOutIndex
    case unknownHumanReadablePart
    case chainMismatch
    case invalidLength
    case zeroOutIndex

    public var errorDescription: String? {
        switch self {
        case .noMagicCode:
            return "No magic code."
        case .unknownMagicCode(let code):
            return "Unknown magic code: \(code)."
        case .noVersion:
            return "No version."
        case .unknownVersion(let version):
            return "Unknown version: \(version)."
        case .noBlockHeight:
            return "No block height."
        case .noTxIndex:
            return "No Tx Index."
        case .noOutIndex:
            return "No output index."
        case .unknownHumanReadablePart:
            return "Unknown human readable part."
        case .chainMismatch:
            return "Human readable part does not match chain."
        case .invalidLength:
            return "String was invalid length."
        case .zeroOutIndex:
            return "Output index encoded as zero not allowed."
        }
    }
}
