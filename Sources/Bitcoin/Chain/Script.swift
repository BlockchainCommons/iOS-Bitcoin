//
//  Script.swift
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

public struct Script: InstanceContainer {
    var wrapped: WrappedInstance

    init(instance: OpaquePointer) {
        wrapped = WrappedInstance(instance)
    }

    public init() {
        self.init(instance: _scriptNew())
    }

    public init(_ string: String) throws {
        let instance = try string.withCString { (stringBytes: UnsafePointer<Int8>) -> OpaquePointer in
            var instance: OpaquePointer!
            if let error = BitcoinError(rawValue: _scriptFromString(stringBytes, &instance)) {
                throw error
            }
            return instance
        }
        self.init(instance: instance)
    }

    public static func deserialize(_ data: Data, prefix: Bool = false) throws -> Script {
        let instance = try data.withUnsafeBytes { dataBytes -> OpaquePointer in
            var instance: OpaquePointer!
            if let error = BitcoinError(rawValue: _scriptDeserialize(dataBytes®, data.count, prefix, &instance)) {
                throw error
            }
            return instance
        }
        return Script(instance: instance)
    }

    public func serialized(prefix: Bool) -> Data {
        var dataBytes: UnsafeMutablePointer<UInt8>!
        var dataLength = 0
        _scriptSerialize(wrapped.instance, prefix, &dataBytes, &dataLength)
        return receiveData(bytes: dataBytes, count: dataLength)
    }

    public var serialized: Data {
        return serialized(prefix: false)
    }

    public init(_ operations: [ScriptOperation]) {
        let operationInstances = operations.map { $0.wrapped.instance }
        let newInstance = operationInstances.withUnsafeBufferPointer { instancesBuffer in
            _scriptFromOperations(instancesBuffer.baseAddress!, operationInstances.count)
        }
        self.init(instance: newInstance)
    }

    public var isValid: Bool {
        return _scriptIsValid(wrapped.instance)
    }

    public var operations: [ScriptOperation] {
        var operations: UnsafeMutablePointer<OpaquePointer>!
        var operationsCount = 0
        _scriptGetOperations(wrapped.instance, &operations, &operationsCount)
        return receiveInstances(instances: operations, count: operationsCount)
    }

    public var isEmpty: Bool {
        return _scriptIsEmpty(wrapped.instance)
    }

    public mutating func clear() {
        if !isKnownUniquelyReferenced(&wrapped) {
            wrapped = WrappedInstance(_scriptCopy(wrapped.instance))
        }
        _scriptClear(wrapped.instance)
    }

    public var witnessProgram: Data {
        var program: UnsafeMutablePointer<UInt8>!
        var programLength = 0
        _scriptGetWitnessProgram(wrapped.instance, &program, &programLength);
        return receiveData(bytes: program, count: programLength)
    }

    public var version: ScriptVersion {
        return ScriptVersion(rawValue: _scriptGetVersion(wrapped.instance))!
    }

    public var pattern: ScriptPattern {
        return ScriptPattern(rawValue: _scriptGetPattern(wrapped.instance))!
    }

    public var inputPattern: ScriptPattern {
        return ScriptPattern(rawValue: _scriptGetInputPattern(wrapped.instance))!
    }

    public var outputPattern: ScriptPattern {
        return ScriptPattern(rawValue: _scriptGetOutputPattern(wrapped.instance))!
    }

    public static func makePayNullDataPattern(data: Data) -> [ScriptOperation] {
        return data.withUnsafeBytes { dataBytes -> [ScriptOperation] in
            var operations: UnsafeMutablePointer<OpaquePointer>!
            var operationsCount = 0
            _scriptMakePayNullDataPattern(dataBytes®, data.count, &operations, &operationsCount)
            return receiveInstances(instances: operations, count: operationsCount)
        }
    }

    public static func makePayKeyHashPattern(hash: ShortHash) -> [ScriptOperation] {
        return hash®.withUnsafeBytes { hashBytes -> [ScriptOperation] in
            var operations: UnsafeMutablePointer<OpaquePointer>!
            var operationsCount = 0
            _scriptMakePayKeyHashPattern(hashBytes®, &operations, &operationsCount)
            return receiveInstances(instances: operations, count: operationsCount)
        }
    }

    public static func makePayScriptHashPattern(hash: ShortHash) -> [ScriptOperation] {
        return hash®.withUnsafeBytes { hashBytes -> [ScriptOperation] in
            var operations: UnsafeMutablePointer<OpaquePointer>!
            var operationsCount = 0
            _scriptMakePayScriptHashPattern(hashBytes®, &operations, &operationsCount)
            return receiveInstances(instances: operations, count: operationsCount)
        }
    }

    public static func makePayMultisigPattern(requiredSignatureCount: Int, publicKeys: [ECCompressedPublicKey]) -> [ScriptOperation] {
        let m = requiredSignatureCount
        let n = publicKeys.count

        guard (1 ... 16).contains(n), (1 ... n).contains(m) else { return [] }

        var ops = [ScriptOperation]()
        ops.append(ScriptOperation(.makePushPositive(m)))
        publicKeys.forEach { key in
            try! ops.append(ScriptOperation(key®))
        }
        ops.append(ScriptOperation(.makePushPositive(n)))
        ops.append(ScriptOperation(.checkmultisig))
        return ops
    }

//    static operation::list to_pay_public_key_pattern(data_slice point);
//    static operation::list to_pay_key_hash_pattern(const short_hash& hash);
//    static operation::list to_pay_script_hash_pattern(const short_hash& hash);

    public static func verify(transaction: Transaction, inputIndex: Int, rules: RuleFork, prevoutScript: Script, value: UInt64) -> LibBitcoinResult {
        let result = _scriptVerify(transaction.wrapped.instance, UInt32(inputIndex), rules®, prevoutScript.wrapped.instance, value)
        return LibBitcoinResult(code: result)
    }

    public func serializedSize(prefix: Bool) -> Int {
        return _scriptSerializedSize(wrapped.instance, prefix)
    }
}

extension Script: CustomStringConvertible {
    public var description: String {
        return "Script('\(self |> serialize |> scriptDecode)')"
    }
}

extension Script: Equatable {
    public static func == (lhs: Script, rhs: Script) -> Bool {
        return _scriptEqual(lhs.wrapped.instance, rhs.wrapped.instance);
    }
}

public func generateSignatureHash(transaction: Transaction, inputIndex: Int, script: Script, sigHashType: SigHashAlgorithm, scriptVersion: ScriptVersion = .unversioned, value: UInt64 = UInt64.max) -> HashDigest {
    var hash: UnsafeMutablePointer<UInt8>!
    var hashLength = 0
    _generateSignatureHash(transaction.wrapped.instance, UInt32(inputIndex), script.wrapped.instance, sigHashType®, scriptVersion®, value, &hash, &hashLength)
    return try! receiveData(bytes: hash, count: hashLength) |> tagHashDigest
}

public func checkSignature(_ signature: ECSignature, sigHashType: SigHashAlgorithm, publicKey: ECPublicKey, script: Script, transaction: Transaction, inputIndex: Int, scriptVersion: ScriptVersion = .unversioned, value: UInt64 = UInt64.max) -> Bool {
    return signature®.withUnsafeBytes { signatureBytes in
        publicKey®.withUnsafeBytes { publicKeyBytes in
            _checkSignature(signatureBytes®, sigHashType®, publicKeyBytes®, publicKey®.count, script.wrapped.instance, transaction.wrapped.instance, UInt32(inputIndex), scriptVersion®, value)
        }
    }
}

public func createEndorsement(privateKey: ECPrivateKey, script: Script, transaction: Transaction, inputIndex: Int, sigHashType: SigHashAlgorithm, scriptVersion: ScriptVersion = .unversioned, value: UInt64 = UInt64.max) throws -> Endorsement {
    return try privateKey®.withUnsafeBytes { privateKeyBytes in
        var _endorsement: UnsafeMutablePointer<UInt8>!
        var endorsementLength = 0
        if let error = BitcoinError(rawValue: _createEndorsement(privateKeyBytes®, script.wrapped.instance, transaction.wrapped.instance, UInt32(inputIndex), sigHashType®, scriptVersion®, value, &_endorsement, &endorsementLength)) {
            throw error
        }
        return try! receiveData(bytes: _endorsement, count: endorsementLength) |> tagEndorsement
    }
}


// MARK: - Free functions


/// Decode a script to plain text tokens.
public func scriptDecode(_ data: Data) -> String {
    return data.withUnsafeBytes { dataBytes in
        var decoded: UnsafeMutablePointer<Int8>!
        var decodedLength = 0
        _scriptDecode(dataBytes®, data.count, &decoded, &decodedLength)
        return receiveString(bytes: decoded, count: decodedLength)
    }
}

/// Encode a plain text script.
public func scriptEncode(_ script: String) throws -> Data {
    return try script.withCString { (scriptBytes: UnsafePointer<Int8>) in
        var encoded: UnsafeMutablePointer<UInt8>!
        var encodedLength = 0
        if let error = BitcoinError(rawValue: _scriptEncode(scriptBytes, &encoded, &encodedLength)) {
            throw error
        }
        return receiveData(bytes: encoded, count: encodedLength)
    }
}

/// Create a BIP16 pay-to-script-hash address from a script.
public func scriptToAddress(version: UInt8) -> (_ script: String) throws -> String {
    return { script in
        return try script.withCString { (scriptBytes: UnsafePointer<Int8>) in
            var paymentAddress: UnsafeMutablePointer<Int8>!
            var paymentAddressLength = 0
            if let error = BitcoinError(rawValue: _scriptToAddress(scriptBytes, version, &paymentAddress, &paymentAddressLength)) {
                throw error
            }
            return receiveString(bytes: paymentAddress, count: paymentAddressLength)
        }
    }
}

/// Create a BIP16 pay-to-script-hash address from a script.
public func scriptToAddress(network: Network) -> (_ script: String) throws -> String {
    return scriptToAddress(version: PaymentAddressVersion(network: network, type: .p2sh).version)
}

public func serialize(_ script: Script) -> Data {
    return script.serialized
}

public func deserializeScript(_ data: Data) throws -> Script {
    return try Script.deserialize(data)
}

public func toScript(_ script: String) throws -> Script {
    return try Script(script)
}


extension Script: ExpressibleByArrayLiteral {
    public init(arrayLiteral: ScriptOperation...) {
        self.init(arrayLiteral)
    }
}
