//
//  Output.swift
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

public struct Output: InstanceContainer {
    var wrapped: WrappedInstance

    init(instance: OpaquePointer) {
        wrapped = WrappedInstance(instance)
    }

    public init() {
        self.init(instance: _outputNew())
    }

    public static func deserialize(data: Data) throws -> Output {
        let instance = try data.withUnsafeBytes { (dataBytes: UnsafePointer<UInt8>) -> OpaquePointer in
            var instance: OpaquePointer!
            if let error = BitcoinError(rawValue: _outputDeserialize(dataBytes, data.count, &instance)) {
                throw error
            }
            return instance
        }
        return Output(instance: instance)
    }

    public var serialized: Data {
        var dataBytes: UnsafeMutablePointer<UInt8>!
        var dataLength = 0
        _outputSerialize(wrapped.instance, &dataBytes, &dataLength)
        return receiveData(bytes: dataBytes, count: dataLength)
    }

    public init(value: UInt64, paymentAddress: String) throws {
        self.init()
        self.value = value
        try setPaymentAddress(paymentAddress)
    }

    public init(value: UInt64) {
        self.init()
        self.value = value
    }

    public mutating func setPaymentAddress(_ paymentAddress: String) throws {
        if !isKnownUniquelyReferenced(&wrapped) {
            wrapped = WrappedInstance(_outputCopy(wrapped.instance))
        }
        try paymentAddress.withCString { paymentAddressBytes in
            if let error = BitcoinError(rawValue: _outputSetPaymentAddress(wrapped.instance, paymentAddressBytes)) {
                throw error;
            }
        }
    }

    public var value: UInt64 {
        get {
            return _outputGetValue(wrapped.instance)
        }

        set {
            if !isKnownUniquelyReferenced(&wrapped) {
                wrapped = WrappedInstance(_outputCopy(wrapped.instance))
            }
            _outputSetValue(wrapped.instance, newValue)
        }
    }

    public var script: String {
        var decoded: UnsafeMutablePointer<Int8>!
        var decodedLength = 0
        _outputGetScript(wrapped.instance, RuleFork.allRules.rawValue, &decoded, &decodedLength)
        return receiveString(bytes: decoded, count: decodedLength)
    }
}

extension Output: CustomStringConvertible {
    public var description: String {
        return "Output(value: \(value), script: '\(script)')"
    }
}

extension Output: Equatable {
    public static func == (lhs: Output, rhs: Output) -> Bool {
        return _outputEqual(lhs.wrapped.instance, rhs.wrapped.instance)
    }
}

// MARK: - Free functions

public func serialize(_ output: Output) -> Data {
    return output.serialized
}

public func deserializeOutput(_ data: Data) throws -> Output {
    return try Output.deserialize(data: data)
}
