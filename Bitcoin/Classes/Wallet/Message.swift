//
//  Message.swift
//  Bitcoin
//
//  Created by Wolf McNally on 11/5/18.
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

public func messageSign(wif: String) -> (_ message: Data) -> String {
    return { message in
        wif.withCString { (wifString: UnsafePointer<Int8>) in
            message.withUnsafeBytes { (messageBytes: UnsafePointer<UInt8>) in
                var signatureBytes: UnsafeMutablePointer<Int8>!
                var signatureLength = 0
                _messageSign(messageBytes, message.count, wifString, &signatureBytes, &signatureLength)
                return receiveString(bytes: signatureBytes, count: signatureLength)
            }
        }
    }
}
