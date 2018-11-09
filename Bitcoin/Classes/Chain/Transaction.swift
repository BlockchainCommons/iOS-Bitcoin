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

//public final class Input {
//    private let input: OpaquePointer
//
//    public init() {
//        input = _newTransactionInput()
//    }
//
//    deinit {
//        _deleteTransactionInput(input)
//    }
//}

//
//public func transactionEncode() {
//    var input = _transactionInput()
//    input.sequenc
//}

//public enum Target {
//    case address(String)
//    case script(String)
//}
//
//public struct Output {
//    var target: Target
//    var satoshi: UInt64
//    var seed: UInt32?
//}
//
//public struct Transaction {
//    var version: UInt32
//    var lockTime: UInt32
//    var inputs: [Input]
//    var outputs: [Output]
//}
//
//public func transactionEncode(_ transaction: Transaction) -> Data {
//    var inputStrings: [String] = []
//    for input in transaction.inputs {
//        var s: [String] = []
//        s.append(input.hash |> base16Encode)
//        s.append(String(input.index))
//        if let sequence = input.sequence {
//            s.append(String(sequence))
//        }
//        inputStrings.append(s.joined(separator: ":"))
//    }
//    let inputs = inputStrings.joined(separator: " ")
//
//    var outputStrings: [String] = []
//    for output in transaction.outputs {
//        var s: [String] = []
//        switch output.target {
//        case .address(let a):
//            s.append(a)
//        case .script(let scr):
//            s.append(scr)
//        }
//        s.append(String(output.satoshi))
//        if let seed = output.seed {
//            s.append(String(seed))
//        }
//        outputStrings.append(s.joined(separator: ":"))
//    }
//    let outputs = outputStrings.joined(separator: " ")
//}
