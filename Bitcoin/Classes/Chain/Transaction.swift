//
//  Transaction.swift
//  Bitcoin
//
//  Created by Wolf McNally on 11/7/18.
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

/// Decode a binary transaction to JSON format.
public func transactionDecode(isPretty: Bool) -> (_ data: Data) throws -> String {
    return { data in
        return try data.withUnsafeBytes { (dataBytes: UnsafePointer<UInt8>) in
            var decoded: UnsafeMutablePointer<Int8>!
            var decodedLength = 0
            if let error = BitcoinError(rawValue: _transactionDecode(dataBytes, data.count, isPretty, &decoded, &decodedLength)) {
                throw error
            }
            return receiveString(bytes: decoded, count: decodedLength)
        }
    }
}

/// Decode a binary transaction to JSON format.
public func transactionDecode(_ data: Data) throws -> String {
    return try data |> transactionDecode(isPretty: false)
}

public struct Transaction: InstanceContainer {
    var wrapped: WrappedInstance

    init(instance: OpaquePointer) {
        wrapped = WrappedInstance(instance)
    }

    public init() {
        self.init(instance: _transactionNew())
    }

    public init(version: UInt32, lockTime: UInt32, inputs: [Input], outputs: [Output]) {
        self.init()
        self.version = version
        self.lockTime = lockTime
        self.inputs = inputs
        self.outputs = outputs
    }

    public var version: UInt32 {
        get {
            return _transactionGetVersion(wrapped.instance)
        }

        set {
            if !isKnownUniquelyReferenced(&wrapped) {
                wrapped = WrappedInstance(_transactionCopy(wrapped.instance))
            }
            _transactionSetVersion(wrapped.instance, newValue)
        }
    }

    public var lockTime: UInt32 {
        get {
            return _transactionGetLockTime(wrapped.instance)
        }

        set {
            if !isKnownUniquelyReferenced(&wrapped) {
                wrapped = WrappedInstance(_transactionCopy(wrapped.instance))
            }
            _transactionSetLockTime(wrapped.instance, newValue)
        }
    }

    public var inputs: [Input] {
        get {
            var inputs: UnsafeMutablePointer<OpaquePointer>!
            var inputsCount = 0
            _transactionGetInputs(wrapped.instance, &inputs, &inputsCount)
            return receiveInstances(instances: inputs, count: inputsCount)
        }

        set {
            if !isKnownUniquelyReferenced(&wrapped) {
                wrapped = WrappedInstance(_transactionCopy(wrapped.instance))
            }
            let instances = newValue.map { $0.wrapped.instance }
            instances.withUnsafeBufferPointer { instancesBuffer in
                _transactionSetInputs(wrapped.instance, instancesBuffer.baseAddress, instances.count)
            }
        }
    }

    public var outputs: [Output] {
        get {
            var outputs: UnsafeMutablePointer<OpaquePointer>!
            var outputsCount = 0
            _transactionGetOutputs(wrapped.instance, &outputs, &outputsCount)
            return receiveInstances(instances: outputs, count: outputsCount)
        }

        set {
            if !isKnownUniquelyReferenced(&wrapped) {
                wrapped = WrappedInstance(_transactionCopy(wrapped.instance))
            }
            let instances = newValue.map { $0.wrapped.instance }
            instances.withUnsafeBufferPointer { instancesBuffer in
                _transactionSetOutputs(wrapped.instance, instancesBuffer.baseAddress, instances.count)
            }
        }
    }
}

extension Transaction: CustomStringConvertible {
    public var description: String {
        return "Transaction(version: \(version), lockTime: \(lockTime), inputs: \(inputs), outputs: \(outputs))"
    }
}
