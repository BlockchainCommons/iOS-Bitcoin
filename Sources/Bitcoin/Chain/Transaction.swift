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
import WolfCore

public struct Transaction: InstanceContainer, Encodable {
    var wrapped: WrappedInstance

    init(instance: OpaquePointer) {
        wrapped = WrappedInstance(instance)
    }

    public init() {
        self.init(instance: _transactionNew())
    }

    public static func deserialize(_ data: Data) throws -> Transaction {
        let instance = try data.withUnsafeBytes { dataBytes -> OpaquePointer in
            var instance: OpaquePointer!
            if let error = BitcoinError(rawValue: _transactionDeserialize(dataBytes®, data.count, &instance)) {
                throw error
            }
            return instance
        }
        return Transaction(instance: instance)
    }

    public var serialized: Data {
        var dataBytes: UnsafeMutablePointer<UInt8>!
        var dataLength = 0
        _transactionSerialize(wrapped.instance, &dataBytes, &dataLength)
        return receiveData(bytes: dataBytes, count: dataLength)
    }

    public init(version: UInt32 = 0, lockTime: UInt32 = 0, inputs: [Input] = [], outputs: [Output] = []) {
        self.init()
        self.version = version
        self.lockTime = lockTime
        self.inputs = inputs
        self.outputs = outputs
    }

    public var isValid: Bool {
        return _transactionIsValid(wrapped.instance)
    }

    public var isCoinbase: Bool {
        return _transactionIsCoinbase(wrapped.instance)
    }

    public var isOversizedCoinbase: Bool {
        return _transactionIsOversizedCoinbase(wrapped.instance)
    }

    public var isNullNonCoinbase: Bool {
        return _transactionIsNullNonCoinbase(wrapped.instance)
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
                _transactionSetInputs(wrapped.instance, instancesBuffer.baseAddress!, instances.count)
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
                _transactionSetOutputs(wrapped.instance, instancesBuffer.baseAddress!, instances.count)
            }
        }
    }

    public func isFinal(blockHeight: Int, blockTime: UInt32) -> Bool {
        return _transactionIsFinal(wrapped.instance, blockHeight, blockTime)
    }

    public func isLocked(blockHeight: Int, medianTimePast: UInt32) -> Bool {
        return _transactionIsLocked(wrapped.instance, blockHeight, medianTimePast)
    }

    public var isLockTimeConflict: Bool {
        return _transactionIsLockTimeConflict(wrapped.instance)
    }

    public var serializedSize: Int {
        return _transactionSerializedSize(wrapped.instance)
    }

    public var hash: HashDigest {
        var hash: UnsafeMutablePointer<UInt8>!
        var hashLength = 0
        _transactionHash(wrapped.instance, &hash, &hashLength)
        return try! receiveData(bytes: hash, count: hashLength) |> tagHashDigest
    }

    public var totalInputValue: UInt64 {
        return _transactionTotalInputValue(wrapped.instance)
    }

    public var totalOutputValue: UInt64 {
        return _transactionTotalOutputValue(wrapped.instance)
    }

    public var isOverspent: Bool {
        return _transactionIsOverspent(wrapped.instance)
    }

    public func signatureOperationsCount(bip16: Bool, bip141: Bool) -> Int {
        return _transactionSignatureOperationsCount(wrapped.instance, bip16, bip141)
    }

    public var signatureOperationsCount: Int {
        return signatureOperationsCount(bip16: false, bip141: false)
    }

    public var isMissingPreviousOutputs: Bool {
        return _transactionIsMissingPreviousOutputs(wrapped.instance)
    }

    public var isConfirmedDoubleSpend: Bool {
        return _transactionIsConfirmedDoubleSpend(wrapped.instance)
    }

    public func isDusty(minimumOutputValue: UInt64) -> Bool {
        return _transactionIsDusty(wrapped.instance, minimumOutputValue)
    }

    public func isMature(height: Int) -> Bool {
        return _transactionIsMature(wrapped.instance, height)
    }

    public var isInternalDoubleSpend: Bool {
        return _transactionIsInternalDoubleSpend(wrapped.instance)
    }

    public enum CodingKeys: String, CodingKey {
        case version
        case lockTime
        case inputs
        case outputs
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(version, forKey: .version)
        try container.encode(lockTime, forKey: .lockTime)
        try container.encode(inputs, forKey: .inputs)
        try container.encode(outputs, forKey: .outputs)
    }
}

extension Transaction: CustomStringConvertible {
    public var description: String {
        return try! self |> toJSONString(outputFormatting: .sortedKeys)
    }
}

// MARK: - Free functions

public func serialize(_ transaction: Transaction) -> Data {
    return transaction.serialized
}

public func deserializeTransaction(_ data: Data) throws -> Transaction {
    return try Transaction.deserialize(data)
}

/// Decode a binary transaction to JSON format.
public func transactionDecode(isPretty: Bool) -> (_ data: Data) throws -> String {
    return { data in
        return try data.withUnsafeBytes { dataBytes in
            var decoded: UnsafeMutablePointer<Int8>!
            var decodedLength = 0
            if let error = BitcoinError(rawValue: _transactionDecode(dataBytes®, data.count, isPretty, &decoded, &decodedLength)) {
                throw error
            }
            return receiveString(bytes: decoded, count: decodedLength) |> trim
        }
    }
}

/// Decode a binary transaction to JSON format.
public func transactionDecode(_ data: Data) throws -> String {
    return try data |> transactionDecode(isPretty: false)
}
