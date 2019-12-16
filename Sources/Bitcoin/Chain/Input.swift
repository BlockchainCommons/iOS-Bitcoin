//
//  Input.swift
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

public struct Input: InstanceContainer, Encodable {
    var wrapped: WrappedInstance

    init(instance: OpaquePointer) {
        wrapped = WrappedInstance(instance)
    }

    public init() {
        self.init(instance: _inputNew())
    }

    public static func deserialize(_ data: Data) throws -> Input {
        let instance = try data.withUnsafeBytes { dataBytes -> OpaquePointer in
            var instance: OpaquePointer!
            if let error = BitcoinError(rawValue: _inputDeserialize(dataBytes®, data.count, &instance)) {
                throw error
            }
            return instance
        }
        return Input(instance: instance)
    }

    public var serialized: Data {
        var dataBytes: UnsafeMutablePointer<UInt8>!
        var dataLength = 0
        _inputSerialize(wrapped.instance, &dataBytes, &dataLength)
        return receiveData(bytes: dataBytes, count: dataLength)
    }

    public init(previousOutput: OutputPoint? = nil, script: Script? = nil, sequence: UInt32? = nil) {
        self.init()
        if let previousOutput = previousOutput {
            self.previousOutput = previousOutput
        }
        if let script = script {
            self.script = script
        }
        self.sequence = sequence ?? 0xffffffff
    }

    public var previousOutput: OutputPoint {
        get {
            return OutputPoint(instance: _inputGetPreviousOutput(wrapped.instance))
        }

        set {
            if !isKnownUniquelyReferenced(&wrapped) {
                wrapped = WrappedInstance(_inputCopy(wrapped.instance))
            }
            _inputSetPreviousOutput(wrapped.instance, newValue.wrapped.instance)
        }
    }

    public var sequence: UInt32 {
        get {
            return _inputGetSequence(wrapped.instance)
        }

        set {
            if !isKnownUniquelyReferenced(&wrapped) {
                wrapped = WrappedInstance(_inputCopy(wrapped.instance))
            }
            _inputSetSequence(wrapped.instance, newValue)
        }
    }

    public var script: Script {
        get {
            return Script(instance: _inputGetScript(wrapped.instance))
        }

        set {
            if !isKnownUniquelyReferenced(&wrapped) {
                wrapped = WrappedInstance(_inputCopy(wrapped.instance))
            }
            _inputSetScript(wrapped.instance, newValue.wrapped.instance)
        }
    }

    public var scriptString: String {
        var decoded: UnsafeMutablePointer<Int8>!
        var decodedLength = 0
        _inputGetScriptString(wrapped.instance, RuleFork.allRules®, &decoded, &decodedLength)
        return receiveString(bytes: decoded, count: decodedLength)
    }

    public var isValid: Bool {
        return _inputIsValid(wrapped.instance)
    }

    public enum CodingKeys: String, CodingKey {
        case previousOutput
        case sequence
        case script
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(previousOutput, forKey: .previousOutput)
        try container.encode(sequence, forKey: .sequence)
        try container.encode(scriptString, forKey: .script)
    }
}

extension Input: CustomStringConvertible {
    public var description: String {
        return try! self |> toJSONString(outputFormatting: .sortedKeys)
    }
}

extension Input: Equatable {
    public static func == (lhs: Input, rhs: Input) -> Bool {
        return _inputEqual(lhs.wrapped.instance, rhs.wrapped.instance)
    }
}

// MARK: - Free functions

public func serialize(_ input: Input) -> Data {
    return input.serialized
}

public func deserializeInput(_ data: Data) throws -> Input {
    return try Input.deserialize(data)
}
