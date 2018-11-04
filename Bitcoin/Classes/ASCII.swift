//
//  ASCII.swift
//  Bitcoin
//
//  Created by Wolf McNally on 10/23/18.
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

extension StringProtocol {
    var ascii: [Int8] {
        return unicodeScalars.compactMap { $0.isASCII ? Int8($0.value) : nil }
    }
}

extension Character {
    var ascii: Int8? {
        let a = self.unicodeScalars.first!
        return a.isASCII ? Int8(a.value) : nil
    }
}
