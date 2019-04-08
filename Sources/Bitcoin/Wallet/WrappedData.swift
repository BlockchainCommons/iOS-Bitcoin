//
//  WrappedData.swift
//  Bitcoin
//
//  Created by Wolf McNally on 11/6/18.
//

import CBitcoin
import WolfCore

public struct WrappedData: Encodable {
    public let prefix: UInt8
    public let payload: Data
    public let checksum: UInt32

    public enum CodingKeys: String, CodingKey {
        case prefix
        case payload
        case checksum
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(prefix, forKey: .prefix)
        try container.encode(payload |> toBase16, forKey: .payload)
        try container.encode(checksum, forKey: .checksum)
    }
}

/// Add a version byte and checksum to the data.
public func wrapEncode(version: UInt8) -> (_ data: Data) -> Data {
    return { data in
        data.withUnsafeBytes { dataBytes in
            var wrappedDataBytes: UnsafeMutablePointer<UInt8>!
            var wrappedDataLength = 0
            _wrapEncode(dataBytes®, data.count, version, &wrappedDataBytes, &wrappedDataLength)
            return receiveData(bytes: wrappedDataBytes, count: wrappedDataLength)
        }
    }
}

/// Add a version byte (0) and checksum to the data.
public func wrapEncode(_ data: Data) -> Data {
    return data |> wrapEncode(version: 0)
}

/// Validate the checksum of checked data and recover its version and payload.
public func wrapDecode(_ wrappedData: Data) throws -> WrappedData {
    return try wrappedData.withUnsafeBytes { wrappedDataBytes in
        var prefix: UInt8 = 0
        var payloadBytes: UnsafeMutablePointer<UInt8>!
        var payloadLength = 0
        var checksum: UInt32 = 0
        if let error = BitcoinError(rawValue: _wrapDecode(wrappedDataBytes®, wrappedData.count, &prefix, &payloadBytes, &payloadLength, &checksum)) {
            throw error
        }
        let payload = receiveData(bytes: payloadBytes, count: payloadLength)
        return WrappedData(prefix: prefix, payload: payload, checksum: checksum)
    }
}
