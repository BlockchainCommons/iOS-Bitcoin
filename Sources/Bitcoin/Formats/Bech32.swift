//
//  Bech32.swift
//  Bitcoin
//
//  Created by Wolf McNally on 11/7/19.
//  Copyright © 2019 Blockchain Commons. All rights reserved.
//

//  Based on:
//  https://github.com/0xDEADP00L/Bech32/blob/master/Sources/Bech32.swift

//  Base32 address format for native v0-16 witness outputs implementation
//  https://github.com/bitcoin/bips/blob/master/bip-0173.mediawiki
//  Inspired by Pieter Wuille C++ implementation

import Foundation
import WolfFoundation
import WolfPipe

public enum Bech32Version {
    case bech32
    case bech32bis

    // bech32bis
    // See: https://gist.github.com/sipa/a9845b37c1b298a7301c33a04090b2eb
    var m: UInt32 {
        switch self {
        case .bech32:
            return 1
        case .bech32bis:
            return 0x3FFFFFFF
        }
    }
}

public enum Bech32Tag { }
public typealias Bech32 = Tagged<Bech32Tag, String>
public func tagBech32(_ string: String) -> Bech32 { return Bech32(rawValue: string) }

public func toBech32(_ hrp: String) -> (_ data: Data) -> Bech32 {
    return { data in
        Bech32Impl.encode(hrp, values: data, version: .bech32) |> tagBech32
    }
}

public func toData(_ bech32: Bech32) throws -> (hrp: String, data: Data) {
    let (hrp, data) = try Bech32Impl.decode(bech32®, version: .bech32)
    return (hrp, data)
}

public enum Bech32BisTag { }
public typealias Bech32Bis = Tagged<Bech32BisTag, String>
public func tagBech32Bis(_ string: String) -> Bech32Bis { return Bech32Bis(rawValue: string) }

public func toBech32Bis(_ hrp: String) -> (_ data: Data) -> Bech32Bis {
    return { data in
        Bech32Impl.encode(hrp, values: data, version: .bech32bis) |> tagBech32Bis
    }
}

public func toData(_ bech32Bis: Bech32Bis) throws -> (hrp: String, data: Data) {
    let (hrp, data) = try Bech32Impl.decode(bech32Bis®, version: .bech32bis)
    return (hrp, data)
}

extension Character {
    /// Returns true if the character is a valid Bech32 character, false otherwise.
    public var isBech32: Bool {
        return Bech32Impl._isBech32(String(self).asciiByte)
    }
}

/// Bech32 checksum implementation
fileprivate class Bech32Impl {
    private static let gen: [UInt32] = [0x3b6a57b2, 0x26508e6d, 0x1ea119fa, 0x3d4233dd, 0x2a1462b3]
    /// Bech32 checksum delimiter
    private static let checksumMarker: String = "1"
    /// Bech32 character set for encoding
    private static let encCharset: Data = "qpzry9x8gf2tvdw0s3jn54khce6mua7l".data(using: .utf8)!
    /// Bech32 character set for decoding
    private static let decCharset: [Int8] = [
        -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
        -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
        -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
        15, -1, 10, 17, 21, 20, 26, 30,  7,  5, -1, -1, -1, -1, -1, -1,
        -1, 29, -1, 24, 13, 25,  9,  8, 23, -1, 18, 22, 31, 27, 19, -1,
        1,  0,  3, 16, 11, 28, 12, 14,  6,  4,  2, -1, -1, -1, -1, -1,
        -1, 29, -1, 24, 13, 25,  9,  8, 23, -1, 18, 22, 31, 27, 19, -1,
        1,  0,  3, 16, 11, 28, 12, 14,  6,  4,  2, -1, -1, -1, -1, -1
    ]

    fileprivate static func _isBech32(_ c: UInt8) -> Bool {
        return encCharset.contains(c)
    }

    /// Find the polynomial with value coefficients mod the generator as 30-bit.
    private static func polymod(_ values: Data) -> UInt32 {
        var chk: UInt32 = 1
        for v in values {
            let top = (chk >> 25)
            chk = (chk & 0x1ffffff) << 5 ^ UInt32(v)
            for i: UInt8 in 0..<5 {
                chk ^= ((top >> i) & 1) == 0 ? 0 : gen[Int(i)]
            }
        }
        return chk
    }

    /// Expand a HRP for use in checksum computation.
    private static func expandHrp(_ hrp: String) -> Data {
        guard let hrpBytes = hrp.data(using: .utf8) else { return Data() }
        var result = Data(repeating: 0x00, count: hrpBytes.count*2+1)
        for (i, c) in hrpBytes.enumerated() {
            result[i] = c >> 5
            result[i + hrpBytes.count + 1] = c & 0x1f
        }
        result[hrp.count] = 0
        return result
    }

    /// Verify checksum
    private static func verifyChecksum(hrp: String, checksum: Data, version: Bech32Version) -> Bool {
        var data = expandHrp(hrp)
        data.append(checksum)
        return polymod(data) == version.m
    }

    /// Create checksum
    private static func createChecksum(hrp: String, values: Data, version: Bech32Version) -> Data {
        var enc = expandHrp(hrp)
        enc.append(values)
        enc.append(Data(repeating: 0x00, count: 6))
        let mod: UInt32 = polymod(enc) ^ version.m
        var ret: Data = Data(repeating: 0x00, count: 6)
        for i in 0..<6 {
            ret[i] = UInt8((mod >> (5 * (5 - i))) & 31)
        }
        return ret
    }

    /// Encode Bech32 string
    fileprivate static func encode(_ hrp: String, values: Data, version: Bech32Version) -> String {
        let checksum = createChecksum(hrp: hrp, values: values, version: version)
        var combined = values
        combined.append(checksum)
        guard let hrpBytes = hrp.data(using: .utf8) else { return "" }
        var ret = hrpBytes
        ret.append("1".data(using: .utf8)!)
        for i in combined {
            ret.append(encCharset[Int(i)])
        }
        return String(data: ret, encoding: .utf8) ?? ""
    }

    /// Decode Bech32 string
    fileprivate static func decode(_ str: String, version: Bech32Version) throws -> (hrp: String, checksum: Data) {
        guard let strBytes = str.data(using: .utf8) else {
            throw Bech32Error.nonUTF8String
        }
        guard strBytes.count <= 90 else {
            throw Bech32Error.stringLengthExceeded
        }
        var lower: Bool = false
        var upper: Bool = false
        for c in strBytes {
            // printable range
            if c < 33 || c > 126 {
                throw Bech32Error.nonPrintableCharacter
            }
            // 'a' to 'z'
            if c >= 97 && c <= 122 {
                lower = true
            }
            // 'A' to 'Z'
            if c >= 65 && c <= 90 {
                upper = true
            }
        }
        if lower && upper {
            throw Bech32Error.invalidCase
        }
        guard let pos = str.range(of: checksumMarker, options: .backwards)?.lowerBound else {
            throw Bech32Error.noChecksumMarker
        }
        let intPos: Int = str.distance(from: str.startIndex, to: pos)
        guard intPos >= 1 else {
            throw Bech32Error.incorrectHrpSize
        }
        guard intPos + 7 <= str.count else {
            throw Bech32Error.incorrectChecksumSize
        }
        let vSize: Int = str.count - 1 - intPos
        var values: Data = Data(repeating: 0x00, count: vSize)
        for i in 0..<vSize {
            let c = strBytes[i + intPos + 1]
            let decInt = decCharset[Int(c)]
            if decInt == -1 {
                throw Bech32Error.invalidCharacter
            }
            values[i] = UInt8(decInt)
        }
        let hrp = String(str[..<pos]).lowercased()
        guard verifyChecksum(hrp: hrp, checksum: values, version: version) else {
            throw Bech32Error.checksumMismatch
        }
        return (hrp, Data(values[..<(vSize-6)]))
    }
}

public enum Bech32Error: LocalizedError {
    case nonUTF8String
    case nonPrintableCharacter
    case invalidCase
    case noChecksumMarker
    case incorrectHrpSize
    case incorrectChecksumSize
    case stringLengthExceeded

    case invalidCharacter
    case checksumMismatch

    public var errorDescription: String? {
        switch self {
        case .checksumMismatch:
            return "Checksum doesn't match"
        case .incorrectChecksumSize:
            return "Checksum size too low"
        case .incorrectHrpSize:
            return "Human-readable-part is too small or empty"
        case .invalidCase:
            return "String contains mixed case characters"
        case .invalidCharacter:
            return "Invalid character met on decoding"
        case .noChecksumMarker:
            return "Checksum delimiter not found"
        case .nonPrintableCharacter:
            return "Non printable character in input string"
        case .nonUTF8String:
            return "String cannot be decoded by utf8 decoder"
        case .stringLengthExceeded:
            return "Input string is too long"
        }
    }
}
