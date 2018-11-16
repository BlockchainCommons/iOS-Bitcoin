//
//  Operation.swift
//  Bitcoin
//
//  Created by Wolf McNally on 11/14/18.
//
//  Copyright © 2018 Blockchain Commons.
//
//  Licensed under the Apache License Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing software
//  distributed under the License is distributed on an "AS IS" BASIS
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

import CBitcoin
import WolfPipe

public struct Operation: InstanceContainer {
    var wrapped: WrappedInstance

    init(instance: OpaquePointer) {
        wrapped = WrappedInstance(instance)
    }

    public init() {
        self.init(instance: _operationNew())
    }

    public init(opcode: Opcode) {
        self.init(instance: _operationFromOpcode(opcode.rawValue))
    }

    public init(data: Data, isMinimal: Bool = true) throws {
        let instance = try data.withUnsafeBytes { (dataBytes: UnsafePointer<UInt8>) -> OpaquePointer in
            var instance: OpaquePointer!
            if let error = BitcoinError(rawValue: _operationFromData(dataBytes, data.count, isMinimal, &instance)) {
                throw error
            }
            return instance
        }
        self.init(instance: instance)
    }

    public init(string: String) throws {
        let instance = try string.withCString { (stringBytes: UnsafePointer<Int8>) -> OpaquePointer in
            var instance: OpaquePointer!
            if let error = BitcoinError(rawValue: _operationFromString(stringBytes, &instance)) {
                throw error
            }
            return instance
        }
        self.init(instance: instance)
    }

    public static func deserialize(data: Data) throws -> Operation {
        let instance = try data.withUnsafeBytes { (dataBytes: UnsafePointer<UInt8>) -> OpaquePointer in
            var instance: OpaquePointer!
            if let error = BitcoinError(rawValue: _operationDeserialize(dataBytes, data.count, &instance)) {
                throw error
            }
            return instance
        }
        return Operation(instance: instance)
    }

    public var serialized: Data {
        var data: UnsafeMutablePointer<UInt8>!
        var dataLength = 0
        _operationSerialize(wrapped.instance, &data, &dataLength)
        return receiveData(bytes: data, count: dataLength)
    }

    public var isValid: Bool {
        return _operationIsValid(wrapped.instance)
    }

    public func string(with rules: RuleFork) -> String {
        var string: UnsafeMutablePointer<Int8>!
        var stringLength = 0
        _operationToString(wrapped.instance, rules.rawValue, &string, &stringLength)
        return receiveString(bytes: string, count: stringLength)
    }

    public var opcode: Opcode {
        return Opcode(rawValue: _operationGetOpcode(wrapped.instance))!
    }

    public var data: Data {
        var data: UnsafeMutablePointer<UInt8>!
        var dataLength = 0
        _operationGetData(wrapped.instance, &data, &dataLength)
        return receiveData(bytes: data, count: dataLength)
    }
}

extension Operation: Equatable {
    public static func == (lhs: Operation, rhs: Operation) -> Bool {
        return _operationEqual(lhs.wrapped.instance, rhs.wrapped.instance)
    }
}

extension Operation: CustomStringConvertible {
    public var description: String {
        return self |> toString
    }
}

// MARK: - Free Functions

public func toOperation(_ opcode: Opcode) -> Operation {
    return Operation(opcode: opcode)
}

public func toOperation(isMinimal: Bool) -> (_ data: Data) throws -> Operation {
    return { data in
        return try Operation(data: data, isMinimal: isMinimal)
    }
}

public func toOperation(_ data: Data) throws -> Operation {
    return try data |> toOperation(isMinimal: true)
}

public func toOperation(_ string: String) throws -> Operation {
    return try Operation(string: string)
}

public func serialize(_ operation: Operation) -> Data {
    return operation.serialized
}

public func deserializeOperation(_ data: Data) throws -> Operation {
    return try Operation.deserialize(data: data)
}

public func toString(rules: RuleFork) -> (_ operation: Operation) -> String {
    return { operation in
        return operation.string(with: rules)
    }
}

public func toString(_ operation: Operation) -> String {
    return operation |> toString(rules: .allRules)
}
