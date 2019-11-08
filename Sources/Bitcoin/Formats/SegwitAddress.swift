//
//  SegwitAddress.swift
//  Bitcoin
//
//  Created by Wolf McNally on 11/7/19.
//  Copyright © 2019 Blockchain Commons. All rights reserved.
//

//  Based on:
//  https://github.com/0xDEADP00L/Bech32/blob/master/Sources/SegwitAddrCoder.swift

//  Base32 address format for native v0-16 witness outputs implementation
//  https://github.com/bitcoin/bips/blob/master/bip-0173.mediawiki
//  Inspired by Pieter Wuille C++ implementation

import Foundation
import WolfCore

public struct SegwitAddress {
    public let version: Int
    public let program: Data

    public init(version: Int, program: Data) {
        self.version = version
        self.program = program
    }
}

public func toBech32(_ hrp: String) -> (_ address: SegwitAddress) throws -> Bech32 {
    return { address in
        try SegwitAddrCoder.encode(hrp: hrp, segwitAddress: address)
    }
}

public func toSegwitAddress(_ hrp: String) -> (_ bech32: Bech32) throws -> SegwitAddress {
    return { bech32 in
        try SegwitAddrCoder.decode(hrp: hrp, bech32: bech32)
    }
}

/// Segregated Witness Address encoder/decoder
fileprivate class SegwitAddrCoder {
    /// Convert from one power-of-2 number base to another
    private static func convertBits(from: Int, to: Int, pad: Bool, idata: Data) throws -> Data {
        var acc: Int = 0
        var bits: Int = 0
        let maxv: Int = (1 << to) - 1
        let maxAcc: Int = (1 << (from + to - 1)) - 1
        var odata = Data()
        for ibyte in idata {
            acc = ((acc << from) | Int(ibyte)) & maxAcc
            bits += from
            while bits >= to {
                bits -= to
                odata.append(UInt8((acc >> bits) & maxv))
            }
        }
        if pad {
            if bits != 0 {
                odata.append(UInt8((acc << (to - bits)) & maxv))
            }
        } else if (bits >= from || ((acc << (to - bits)) & maxv) != 0) {
            throw SegwitAddressError.bitsConversionFailed
        }
        return odata
    }

    /// Decode segwit address
    fileprivate static func decode(hrp: String, bech32: Bech32) throws -> SegwitAddress {
        let dec = try bech32 |> toData
        guard dec.hrp == hrp else {
            throw SegwitAddressError.hrpMismatch(dec.hrp, hrp)
        }
        guard dec.data.count >= 1 else {
            throw SegwitAddressError.checksumSizeTooLow
        }
        let conv = try convertBits(from: 5, to: 8, pad: false, idata: dec.data.advanced(by: 1))
        guard conv.count >= 2 && conv.count <= 40 else {
            throw SegwitAddressError.dataSizeMismatch(conv.count)
        }
        guard dec.data[0] <= 16 else {
            throw SegwitAddressError.segwitVersionNotSupported(dec.data[0])
        }
        if dec.data[0] == 0 && conv.count != 20 && conv.count != 32 {
            throw SegwitAddressError.segwitV0ProgramSizeMismatch(conv.count)
        }
        return SegwitAddress(version: Int(dec.data[0]), program: conv)
    }

    /// Encode segwit address
    fileprivate static func encode(hrp: String, segwitAddress: SegwitAddress) throws -> Bech32 {
        var enc = Data([UInt8(segwitAddress.version)])
        enc.append(try convertBits(from: 8, to: 5, pad: true, idata: segwitAddress.program))
        let result = enc |> toBech32(hrp)
        guard let _ = try? decode(hrp: hrp, bech32: result) else {
            throw SegwitAddressError.encodingCheckFailed
        }
        return result
    }
}

public enum SegwitAddressError: LocalizedError {
    case bitsConversionFailed
    case hrpMismatch(String, String)
    case checksumSizeTooLow

    case dataSizeMismatch(Int)
    case segwitVersionNotSupported(UInt8)
    case segwitV0ProgramSizeMismatch(Int)

    case encodingCheckFailed

    public var errorDescription: String? {
        switch self {
        case .bitsConversionFailed:
            return "Failed to perform bits conversion"
        case .checksumSizeTooLow:
            return "Checksum size is too low"
        case .dataSizeMismatch(let size):
            return "Program size \(size) does not meet required range 2...40"
        case .encodingCheckFailed:
            return "Failed to check result after encoding"
        case .hrpMismatch(let got, let expected):
            return "Human-readable-part \"\(got)\" does not match requested \"\(expected)\""
        case .segwitV0ProgramSizeMismatch(let size):
            return "Segwit program size \(size) does not meet version 0 requirments"
        case .segwitVersionNotSupported(let version):
            return "Segwit version \(version) is not supported by this decoder"
        }
    }
}
