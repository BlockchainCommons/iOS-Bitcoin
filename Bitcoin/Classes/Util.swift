//
//  Util.swift
//  Bitcoin
//
//  Created by Wolf McNally on 10/24/18.
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

final class WrappedInstance {
    let instance: OpaquePointer

    init(_ instance: OpaquePointer) {
        self.instance = instance
    }

    deinit {
        _deleteInstance(instance)
    }
}

func receiveString(bytes: UnsafeMutablePointer<Int8>, count: Int) -> String {
    defer { _freeData(bytes) }
    let stringData = Data(bytes: bytes, count: count)
    return String(data: stringData, encoding: .utf8)!
}

func receiveData(bytes: UnsafeMutablePointer<UInt8>, count: Int) -> Data {
    defer { _freeData(bytes) }
    return Data(bytes: bytes, count: count)
}

//func receiveInstances<T: WrappedInstance>(instances: UnsafeMutablePointer<OpaquePointer>, count: Int) -> [T] {
//    defer { _freeData(instances) }
//    let buffer = UnsafeBufferPointer<OpaquePointer>(start: instances, count: count)
//    return buffer.map { T(instance: $0) }
//}
