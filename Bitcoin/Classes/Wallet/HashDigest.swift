//
//  HashDigest.swift
//  Bitcoin
//
//  Created by Wolf McNally on 11/8/18.
//

import Foundation
import WolfPipe

public struct HashDigest {
    public let data: Data

    public init(_ data: Data) throws {
        guard data.count == 32 else {
            throw BitcoinError.invalidDataSize
        }
        self.data = data
    }
}

extension HashDigest: CustomStringConvertible {
    public var description: String {
        return data |> base16Encode
    }
}

extension HashDigest: Equatable {
    public static func == (lhs: HashDigest, rhs: HashDigest) -> Bool {
        return lhs.data == rhs.data
    }
}

// MARK: - Free functions

public func toHashDigest(_ data: Data) throws -> HashDigest {
    return try HashDigest(data)
}

public func base16Encode(_ hash: HashDigest) -> String {
    return hash.data.reversed() |> Data.init(_:) |> base16Encode
}
