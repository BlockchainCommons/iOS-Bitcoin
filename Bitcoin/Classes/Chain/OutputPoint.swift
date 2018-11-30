//
//  OutputPoint.swift
//  Bitcoin
//
//  Created by Wolf McNally on 11/8/18.
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
import WolfFoundation

/// An OutputPoint is a component of a transaction input, and specifies
/// the output of the previous transaction that is being spent.
public struct OutputPoint: InstanceContainer, Encodable {
    var wrapped: WrappedInstance

    init(instance: OpaquePointer) {
        wrapped = WrappedInstance(instance)
    }

    public init() {
        self.init(instance: _outputPointNew())
    }

    public static func deserialize(data: Data) throws -> OutputPoint {
        let instance = try data.withUnsafeBytes { (dataBytes: UnsafePointer<UInt8>) -> OpaquePointer in
            var instance: OpaquePointer!
            if let error = BitcoinError(rawValue: _outputPointDeserialize(dataBytes, data.count, &instance)) {
                throw error
            }
            return instance
        }
        return OutputPoint(instance: instance)
    }

//    public init(script: Script) {
//        let instance = _outputPointFromScript(script.wrapped.instance)
//        self.init(instance: instance)
//    }

    public var serialized: Data {
        var dataBytes: UnsafeMutablePointer<UInt8>!
        var dataLength = 0
        _outputPointSerialize(wrapped.instance, &dataBytes, &dataLength)
        return receiveData(bytes: dataBytes, count: dataLength)
    }

    public init(hash: HashDigest, index: UInt32) {
        self.init()
        self.hash = hash
        self.index = index
    }

    /// This is a sentinel used in `index` to indicate no output, e.g. coinbase.
    public static let nullIndex = UInt32.max

    public var index: UInt32 {
        get {
            return _outputPointGetIndex(wrapped.instance)
        }

        set {
            if !isKnownUniquelyReferenced(&wrapped) {
                wrapped = WrappedInstance(_outputPointCopy(wrapped.instance))
            }
            _outputPointSetIndex(wrapped.instance, newValue)
        }
    }

    public var hash: HashDigest {
        get {
            var hashBytes: UnsafeMutablePointer<UInt8>!
            var hashLength = 0
            _outputPointGetHash(wrapped.instance, &hashBytes, &hashLength)
            return try! receiveData(bytes: hashBytes, count: hashLength) |> hashDigest
        }

        set {
            if !isKnownUniquelyReferenced(&wrapped) {
                wrapped = WrappedInstance(_outputPointCopy(wrapped.instance))
            }
            newValue.rawValue.withUnsafeBytes { hashBytes in
                _outputPointSetHash(wrapped.instance, hashBytes)
            }
        }
    }

    public var isValid: Bool {
        return _outputPointIsValid(wrapped.instance)
    }

    public var isNull: Bool {
        return _outputPointIsNull(wrapped.instance)
    }

    public enum CodingKeys: String, CodingKey {
        case hash
        case index
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(hash.rawValue |> toBase16, forKey: .hash)
        try container.encode(index, forKey: .index)
    }
}

extension OutputPoint: CustomStringConvertible {
    public var description: String {
        return try! self |> toJSONStringWithOutputFormatting(.sortedKeys)
    }
}

extension OutputPoint: Equatable {
    public static func == (lhs: OutputPoint, rhs: OutputPoint) -> Bool {
        return _outputPointEqual(lhs.wrapped.instance, rhs.wrapped.instance);
    }
}

// MARK: - Free functions

public func serialize(_ outputPoint: OutputPoint) -> Data {
    return outputPoint.serialized
}

public func deserializeOutputPoint(_ data: Data) throws -> OutputPoint {
    return try OutputPoint.deserialize(data: data)
}
