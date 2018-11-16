//
//  ScriptPattern.swift
//  Bitcoin
//
//  Created by Wolf McNally on 11/15/18.
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

/// Script patterms.
///
/// Comments from: bitcoin.org/en/developer-guide#signature-hash-types
public enum ScriptPattern: Int32
{
    /// Null Data
    ///
    /// Pubkey Script: OP_RETURN <0 to 80 bytes of data> (formerly 40 bytes)
    /// Null data scripts cannot be spent, so there's no signature script.
    case payNullData

    /// Pay to Multisig [BIP11]
    ///
    /// Pubkey script: <m> <A pubkey>[B pubkey][C pubkey...] <n> OP_CHECKMULTISIG
    /// Signature script: OP_0 <A sig>[B sig][C sig...]
    case payMultisig

    /// Pay to Public Key (obsolete)
    case payPublicKey

    /// Pay to Public Key Hash [P2PKH]
    ///
    /// Pubkey script: OP_DUP OP_HASH160 <PubKeyHash> OP_EQUALVERIFY OP_CHECKSIG
    /// Signature script: <sig> <pubkey>
    case payKeyHash

    /// Pay to Script Hash [P2SH/BIP16]
    ///
    /// The redeem script may be any pay type, but only multisig makes sense.
    /// Pubkey script: OP_HASH160 <Hash160(redeemScript)> OP_EQUAL
    /// Signature script: <sig>[sig][sig...] <redeemScript>
    case payscriptHash

    /// Sign Multisig script [BIP11]
    case signMultisig

    /// Sign Public Key (obsolete)
    case signPublicKey

    /// Sign Public Key Hash [P2PKH]
    case signKeyHash

    /// Sign Script Hash [P2SH/BIP16]
    case signScriptHash

    /// Witness coinbase reserved value [BIP141].
    case witnessReservation

    /// The script may be valid but does not conform to the common templates.
    /// Such scripts are always accepted if they are mined into blocks, but
    /// transactions with uncommon scripts may not be forwarded by peers.
    case nonStandard
}
