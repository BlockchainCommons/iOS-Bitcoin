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
import WolfPipe

public struct Script: InstanceContainer {
    var wrapped: WrappedInstance

    init(instance: OpaquePointer) {
        wrapped = WrappedInstance(instance)
    }

    public init() {
        self.init(instance: _scriptNew())
    }

    public init(string: String) throws {
        let instance = try string.withCString { (stringBytes: UnsafePointer<Int8>) -> OpaquePointer in
            var instance: OpaquePointer!
            if let error = BitcoinError(rawValue: _scriptFromString(stringBytes, &instance)) {
                throw error
            }
            return instance
        }
        self.init(instance: instance)
    }

    public static func deserialize(data: Data, prefix: Bool = false) throws -> Script {
        let instance = try data.withUnsafeBytes { (dataBytes: UnsafePointer<UInt8>) -> OpaquePointer in
            var instance: OpaquePointer!
            if let error = BitcoinError(rawValue: _scriptDeserialize(dataBytes, data.count, prefix, &instance)) {
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

    public init(operations: [Operation]) {
        let operationInstances = operations.map { $0.wrapped.instance }
        let newInstance = operationInstances.withUnsafeBufferPointer { instancesBuffer in
            _scriptFromOperations(instancesBuffer.baseAddress, operationInstances.count)
        }
        self.init(instance: newInstance)
    }

    public var isValid: Bool {
        return _scriptIsValid(wrapped.instance)
    }

    public var operations: [Operation] {
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

    public static func makePayNullDataPattern(data: Data) -> [Operation] {
        return data.withUnsafeBytes { (dataBytes: UnsafePointer<UInt8>) -> [Operation] in
            var operations: UnsafeMutablePointer<OpaquePointer>!
            var operationsCount = 0
            _scriptMakePayNullDataPattern(dataBytes, data.count, &operations, &operationsCount)
            return receiveInstances(instances: operations, count: operationsCount)
        }
    }

//    public static func makePayKeyHashPattern(hash: ShortHash) -> [Operation] {
//    }
//
//    public static func makePayScriptHashPattern(hash: ShortHash) -> [Operation] {
//    }

//    static operation::list to_pay_public_key_pattern(data_slice point);
//    static operation::list to_pay_key_hash_pattern(const short_hash& hash);
//    static operation::list to_pay_script_hash_pattern(const short_hash& hash);
//    static operation::list to_pay_multisig_pattern(uint8_t signatures, const point_list& points);
//    static operation::list to_pay_multisig_pattern(uint8_t signatures, const data_stack& points);

    public static func verify(transaction: Transaction, inputIndex: UInt32, rules: RuleFork, prevoutScript: Script, value: UInt64) -> LibBitcoinResult {
        let result = _scriptVerify(transaction.wrapped.instance, inputIndex, rules.rawValue, prevoutScript.wrapped.instance, value)
        return LibBitcoinResult(code: result)
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

public func generateSignatureHash(transaction: Transaction, inputIndex: UInt32, script: Script, sigHashType: SigHashAlgorithm, scriptVersion: ScriptVersion = .unversioned, value: UInt64 = UInt64.max) -> HashDigest {
    var hash: UnsafeMutablePointer<UInt8>!
    var hashLength = 0
    _generateSignatureHash(transaction.wrapped.instance, inputIndex, script.wrapped.instance, sigHashType.rawValue, scriptVersion.rawValue, value, &hash, &hashLength)
    return try! receiveData(bytes: hash, count: hashLength) |> toHashDigest
}

public func checkSignature(_ signature: ECSignature, sigHashType: SigHashAlgorithm, publicKey: ECPublicKey, script: Script, transaction: Transaction, inputIndex: UInt32, scriptVersion: ScriptVersion = .unversioned, value: UInt64 = UInt64.max) -> Bool {
    return signature.data.withUnsafeBytes { (signatureBytes: UnsafePointer<UInt8>) in
        publicKey.data.withUnsafeBytes { (publicKeyBytes: UnsafePointer<UInt8>) in
        _checkSignature(signatureBytes, sigHashType.rawValue, publicKeyBytes, publicKey.data.count, script.wrapped.instance, transaction.wrapped.instance, inputIndex, scriptVersion.rawValue, value)
        }
    }
}

public func createEndorsement(privateKey: ECPrivateKey, script: Script, transaction: Transaction, inputIndex: UInt32, sigHashType: SigHashAlgorithm, scriptVersion: ScriptVersion = .unversioned, value: UInt64 = UInt64.max) throws -> Endorsement {
    return try privateKey.data.withUnsafeBytes { (privateKeyBytes: UnsafePointer<UInt8>) in
        var endorsement: UnsafeMutablePointer<UInt8>!
        var endorsementLength = 0
        if let error = BitcoinError(rawValue: _createEndorsement(privateKeyBytes, script.wrapped.instance, transaction.wrapped.instance, inputIndex, sigHashType.rawValue, scriptVersion.rawValue, value, &endorsement, &endorsementLength)) {
            throw error
        }
        return try receiveData(bytes: endorsement, count: endorsementLength) |> toEndorsement
    }
}


// MARK: - Free functions


/// Decode a script to plain text tokens.
public func scriptDecode(_ data: Data) -> String {
    return data.withUnsafeBytes { (dataBytes: UnsafePointer<UInt8>) in
        var decoded: UnsafeMutablePointer<Int8>!
        var decodedLength = 0
        _scriptDecode(dataBytes, data.count, &decoded, &decodedLength)
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
public func scriptToAddress(network: PaymentAddressNetwork) -> (_ script: String) throws -> String {
    return scriptToAddress(version: PaymentAddressVersion(network: network, type: .p2sh).version)
}

/// Create a BIP16 pay-to-script-hash address from a script.
public func scriptToAddress(_ script: String) throws -> String {
    return try script |> scriptToAddress(network: .mainnet)
}

public func serialize(_ script: Script) -> Data {
    return script.serialized
}

public func deserializeScript(_ data: Data) throws -> Script {
    return try Script.deserialize(data: data)
}

public func toScript(_ script: String) throws -> Script {
    return try Script(string: script)
}
