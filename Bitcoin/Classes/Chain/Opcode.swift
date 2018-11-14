//
//  Opcode.swift
//  Pods
//
//  Created by Wolf McNally on 11/12/18.
//
//  Copyright © 2018 Blockchain Commons.
//
//  Licensed under the Apache License Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing software
//  distributed under the License is distributed on an "AS IS" BASIS
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

import CBitcoin
import WolfPipe

public enum Opcode: UInt8 {
    case pushSize0 = 0        // is_version (pushes [] to the stack not 0)
    case pushSize1 = 1
    case pushSize2 = 2
    case pushSize3 = 3
    case pushSize4 = 4
    case pushSize5 = 5
    case pushSize6 = 6
    case pushSize7 = 7
    case pushSize8 = 8
    case pushSize9 = 9
    case pushSize10 = 10
    case pushSize11 = 11
    case pushSize12 = 12
    case pushSize13 = 13
    case pushSize14 = 14
    case pushSize15 = 15
    case pushSize16 = 16
    case pushSize17 = 17
    case pushSize18 = 18
    case pushSize19 = 19
    case pushSize20 = 20
    case pushSize21 = 21
    case pushSize22 = 22
    case pushSize23 = 23
    case pushSize24 = 24
    case pushSize25 = 25
    case pushSize26 = 26
    case pushSize27 = 27
    case pushSize28 = 28
    case pushSize29 = 29
    case pushSize30 = 30
    case pushSize31 = 31
    case pushSize32 = 32
    case pushSize33 = 33
    case pushSize34 = 34
    case pushSize35 = 35
    case pushSize36 = 36
    case pushSize37 = 37
    case pushSize38 = 38
    case pushSize39 = 39
    case pushSize40 = 40
    case pushSize41 = 41
    case pushSize42 = 42
    case pushSize43 = 43
    case pushSize44 = 44
    case pushSize45 = 45
    case pushSize46 = 46
    case pushSize47 = 47
    case pushSize48 = 48
    case pushSize49 = 49
    case pushSize50 = 50
    case pushSize51 = 51
    case pushSize52 = 52
    case pushSize53 = 53
    case pushSize54 = 54
    case pushSize55 = 55
    case pushSize56 = 56
    case pushSize57 = 57
    case pushSize58 = 58
    case pushSize59 = 59
    case pushSize60 = 60
    case pushSize61 = 61
    case pushSize62 = 62
    case pushSize63 = 63
    case pushSize64 = 64
    case pushSize65 = 65
    case pushSize66 = 66
    case pushSize67 = 67
    case pushSize68 = 68
    case pushSize69 = 69
    case pushSize70 = 70
    case pushSize71 = 71
    case pushSize72 = 72
    case pushSize73 = 73
    case pushSize74 = 74
    case pushSize75 = 75
    case pushOneSize = 76
    case pushTwoSize = 77
    case pushFourSize = 78
    case pushNegative1 = 79   // is_numeric
    case reserved80 = 80       // [reserved]
    case pushPositive1 = 81   // is_numeric is_positive is_version
    case pushPositive2 = 82   // is_numeric is_positive is_version
    case pushPositive3 = 83   // is_numeric is_positive is_version
    case pushPositive4 = 84   // is_numeric is_positive is_version
    case pushPositive5 = 85   // is_numeric is_positive is_version
    case pushPositive6 = 86   // is_numeric is_positive is_version
    case pushPositive7 = 87   // is_numeric is_positive is_version
    case pushPositive8 = 88   // is_numeric is_positive is_version
    case pushPositive9 = 89   // is_numeric is_positive is_version
    case pushPositive10 = 90  // is_numeric is_positive is_version
    case pushPositive11 = 91  // is_numeric is_positive is_version
    case pushPositive12 = 92  // is_numeric is_positive is_version
    case pushPositive13 = 93  // is_numeric is_positive is_version
    case pushPositive14 = 94  // is_numeric is_positive is_version
    case pushPositive15 = 95  // is_numeric is_positive is_version
    case pushPositive16 = 96  // is_numeric is_positive is_version

    //-------------------------------------------------------------------------
    // is_counted

    case nop = 97
    case reserved98 = 98       // [ver]
    case `if` = 99               // is_conditional
    case notif = 100            // is_conditional
    case disabledVerif = 101   // is_disabled
    case disabledVernotif = 102// is_disabled
    case `else` = 103            // is_conditional
    case endif = 104            // is_conditional
    case verify = 105
    case `return` = 106
    case toaltstack = 107
    case fromaltstack = 108
    case drop2 = 109
    case dup2 = 110
    case dup3 = 111
    case over2 = 112
    case rot2 = 113
    case swap2 = 114
    case ifdup = 115
    case depth = 116
    case drop = 117
    case dup = 118
    case nip = 119
    case over = 120
    case pick = 121
    case roll = 122
    case rot = 123
    case swap = 124
    case tuck = 125
    case disabledCat = 126     // is_disabled
    case disabledSubstr = 127  // is_disabled
    case disabledLeft = 128    // is_disabled
    case disabledRight = 129   // is_disabled
    case size = 130
    case disabledInvert = 131  // is_disabled
    case disabledAnd = 132     // is_disabled
    case disabledOr = 133      // is_disabled
    case disabledXor = 134     // is_disabled
    case equal = 135
    case equalverify = 136
    case reserved137 = 137     // [reserved1]
    case reserved138 = 138     // [reserved2]
    case add1 = 139
    case sub1 = 140
    case disabledMul2 = 141    // is_disabled
    case disabledDiv2 = 142    // is_disabled
    case negate = 143
    case abs = 144
    case not = 145
    case nonzero = 146
    case add = 147
    case sub = 148
    case disabledMul = 149     // is_disabled
    case disabledDiv = 150     // is_disabled
    case disabledMod = 151     // is_disabled
    case disabledLshift = 152  // is_disabled
    case disabledRshift = 153  // is_disabled
    case booland = 154
    case boolor = 155
    case numequal = 156
    case numequalverify = 157
    case numnotequal = 158
    case lessthan = 159
    case greaterthan = 160
    case lessthanorequal = 161
    case greaterthanorequal = 162
    case min = 163
    case max = 164
    case within = 165
    case ripemd160 = 166
    case sha1 = 167
    case sha256 = 168
    case hash160 = 169
    case hash256 = 170
    case codeseparator = 171
    case checksig = 172
    case checksigverify = 173
    case checkmultisig = 174
    case checkmultisigverify = 175
    case nop1 = 176
    //case nop2 = 177
    case checklocktimeverify = 177 //nop2
    //case nop3 = 178
    case checksequenceverify = 178 //nop3
    case nop4 = 179
    case nop5 = 180
    case nop6 = 181
    case nop7 = 182
    case nop8 = 183
    case nop9 = 184
    case nop10 = 185
    case reserved186 = 186
    case reserved187 = 187
    case reserved188 = 188
    case reserved189 = 189
    case reserved190 = 190
    case reserved191 = 191
    case reserved192 = 192
    case reserved193 = 193
    case reserved194 = 194
    case reserved195 = 195
    case reserved196 = 196
    case reserved197 = 197
    case reserved198 = 198
    case reserved199 = 199
    case reserved200 = 200
    case reserved201 = 201
    case reserved202 = 202
    case reserved203 = 203
    case reserved204 = 204
    case reserved205 = 205
    case reserved206 = 206
    case reserved207 = 207
    case reserved208 = 208
    case reserved209 = 209
    case reserved210 = 210
    case reserved211 = 211
    case reserved212 = 212
    case reserved213 = 213
    case reserved214 = 214
    case reserved215 = 215
    case reserved216 = 216
    case reserved217 = 217
    case reserved218 = 218
    case reserved219 = 219
    case reserved220 = 220
    case reserved221 = 221
    case reserved222 = 222
    case reserved223 = 223
    case reserved224 = 224
    case reserved225 = 225
    case reserved226 = 226
    case reserved227 = 227
    case reserved228 = 228
    case reserved229 = 229
    case reserved230 = 230
    case reserved231 = 231
    case reserved232 = 232
    case reserved233 = 233
    case reserved234 = 234
    case reserved235 = 235
    case reserved236 = 236
    case reserved237 = 237
    case reserved238 = 238
    case reserved239 = 239
    case reserved240 = 240
    case reserved241 = 241
    case reserved242 = 242
    case reserved243 = 243
    case reserved244 = 244
    case reserved245 = 245
    case reserved246 = 246
    case reserved247 = 247
    case reserved248 = 248
    case reserved249 = 249
    case reserved250 = 250
    case reserved251 = 251
    case reserved252 = 252
    case reserved253 = 253
    case reserved254 = 254
    case reserved255 = 255

    public static func makeFrom(mnemonic: String) throws -> Opcode {
        let opcode = try mnemonic.withCString { (mnemonicBytes: UnsafePointer<Int8>) -> UInt8 in
            var opcode: UInt8 = 0
            if let error = BitcoinError(rawValue: _opcodeFromString(mnemonicBytes, &opcode)) {
                throw error
            }
            return opcode
        }
        return Opcode(rawValue: opcode)!
    }

    public static func makeFrom(hexadecimal: String) throws -> Opcode {
        let opcode = try hexadecimal.withCString { (hexBytes: UnsafePointer<Int8>) -> UInt8 in
            var opcode: UInt8 = 0
            if let error = BitcoinError(rawValue: _opcodeFromHexadecimal(hexBytes, &opcode)) {
                throw error
            }
            return opcode
        }
        return Opcode(rawValue: opcode)!
    }

    public init?(mnemonic: String, rules: RuleFork = .allRules) {
        do {
            let opcode = try Opcode.makeFrom(mnemonic: mnemonic)
            self.init(rawValue: opcode.rawValue)
        } catch {
            return nil
        }
    }

    public init?(hexadecimal: String) {
        do {
            let opcode = try Opcode.makeFrom(hexadecimal: hexadecimal)
            self.init(rawValue: opcode.rawValue)
        } catch {
            return nil
        }
    }

    public var hexadecimal: String {
        var string: UnsafeMutablePointer<Int8>!
        var count = 0
        _opcodeToHexadecimal(rawValue, &string, &count)
        return receiveString(bytes: string, count: count)
    }

    public func toString(with rules: RuleFork = .allRules) -> String {
        var string: UnsafeMutablePointer<Int8>!
        var count = 0
        _opcodeToString(rawValue, rules.rawValue, &string, &count)
        return receiveString(bytes: string, count: count)
    }
}

extension Opcode: CustomStringConvertible {
    public var description: String {
        return toString()
    }
}

// MARK: - Free functions

public func toOpcode(_ string: String) throws -> Opcode {
    return try Opcode.makeFrom(mnemonic: string)
}

public func hexadecimalToOpcode(_ string: String) throws -> Opcode {
    return try Opcode.makeFrom(hexadecimal: string)
}

public func toString(_ opcode: Opcode, rules: RuleFork) -> String {
    return opcode.toString(with: rules)
}

public func toString(rules: RuleFork) -> (_ opcode: Opcode) -> String {
    return { opcode in
        opcode.toString(with: rules)
    }
}

public func toHexadecimal(_ opcode: Opcode) -> String {
    return opcode.hexadecimal
}
