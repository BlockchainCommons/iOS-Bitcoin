//
//  ScriptVersion.swift
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

/// Script versions (bip141).
public enum ScriptVersion: Int32
{
    /// Defined by bip141.
    case zero

    /// All reserved script versions (1..16).
    case reserved

    /// All unversioned scripts.
    case unversioned
};
