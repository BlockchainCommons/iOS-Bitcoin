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

/// An OutputPoint is a component of a transaction input, and specifies
/// the output of the previous transaction that is being spent.
public final class OutputPoint {
    let instance: OpaquePointer
    private let isOwned: Bool

    public init() {
        instance = _outputPointNew()
        isOwned = true
    }

    init(instance: OpaquePointer) {
        self.instance = instance
        isOwned = false
    }

    deinit {
        guard isOwned else { return }
        _outputPointDelete(instance)
    }

    public convenience init(hash: HashDigest, index: UInt32) {
        self.init()
        self.hash = hash
        self.index = index
    }

    public var index: UInt32 {
        get { return _outputPointGetIndex(instance) }
        set { _outputPointSetIndex(instance, newValue) }
    }

    public var hash: HashDigest {
        get {
            var hashBytes: UnsafeMutablePointer<UInt8>!
            var hashLength = 0
            _outputPointGetHash(instance, &hashBytes, &hashLength)
            return try! receiveData(bytes: hashBytes, count: hashLength) |> toHashDigest
        }

        set {
            newValue.data.withUnsafeBytes { hashBytes in
                _outputPointSetHash(instance, hashBytes)
            }
        }
    }
}

extension OutputPoint: CustomStringConvertible {
    public var description: String {
        return "OutputPoint(hash: \(hash), index: \(index))"
    }
}
