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

public final class Output {
    let instance: OpaquePointer
    private let isOwned: Bool

    public init() {
        instance = _outputNew()
        isOwned = true
    }

    init(instance: OpaquePointer) {
        self.instance = instance
        isOwned = false
    }

    deinit {
        guard isOwned else { return }
        _outputDelete(instance)
    }

    public convenience init(value: UInt64, paymentAddress: String) throws {
        self.init()
        _outputSetValue(instance, value)
        try paymentAddress.withCString { paymentAddressBytes in
            if let error = BitcoinError(rawValue: _outputSetPaymentAddress(instance, paymentAddressBytes)) {
                throw error;
            }
        }
    }

    public var value: UInt64 {
        get { return _outputGetValue(instance) }
        set { _outputSetValue(instance, newValue) }
    }

    public var script: String {
        var decoded: UnsafeMutablePointer<Int8>!
        var decodedLength = 0
        _outputGetScript(instance, &decoded, &decodedLength)
        return receiveString(bytes: decoded, count: decodedLength)
    }
}

extension Output: CustomStringConvertible {
    public var description: String {
        return "Output(value: \(value), script: \(script))"
    }
}
