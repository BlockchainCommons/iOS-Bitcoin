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

public struct Input {
    var wrapped: WrappedInstance

    init(instance: OpaquePointer) {
        wrapped = WrappedInstance(instance)
    }

    public init() {
        self.init(instance: _inputNew())
    }

    public init(previousOutput: OutputPoint, sequence: UInt32 = 0xffffffff) {
        self.init()
        self.previousOutput = previousOutput
        self.sequence = sequence
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
}

extension Input: CustomStringConvertible {
    public var description: String {
        return "Input(previousOutput: \(previousOutput), sequence: 0x\(String(sequence, radix: 16)))"
    }
}
