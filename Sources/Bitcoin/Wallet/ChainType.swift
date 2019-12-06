//
//  ChainType.swift
//  Bitcoin
//
//  Created by Wolf McNally on 12/28/18.
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

/// The value of the "change" or "chain type" field referred to in:
/// https://github.com/bitcoin/bips/blob/master/bip-0044.mediawiki
///
/// The value of `identity` has been suggested by Christopher Allen as a place to sequester value in use by BTCR DID documents.
/// https://w3c-ccg.github.io/didm-btcr/

import Foundation

public enum ChainType: Int, Codable {
    case external = 0
    case change = 1
    case identity = 7
}
