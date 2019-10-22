//
//  AppDelegate.swift
//  Bitcoin
//
//  Created by Wolf McNally on 09/15/2018.
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

import UIKit
import Bitcoin
import WolfCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        testBitcoin()
        return true
    }

    private func testBitcoin() {
        // Should print "true" twice.
        print("Nakomoto" |> toUTF8 |> signMessage(with: "KwE19y2Ud8EUEBjeUG4Uc4qWUJUUoZJxHR3xUfTpCSsJEDv2o8fu" |> tagWIF) == "HxQp3cXgOIhBEGXks27sfeSQHVgNUeYgl5i5wG/dOUYaSIRnnzXR6NcyH+AfNAHtkWcyOD9rX4pojqmuQyH79K4=")
        print("Nakomoto" |> toUTF8 |> validateMessage(paymentAddress: "1PeChFbhxDD9NLbU21DfD55aQBC4ZTR3tE", signature: "HxQp3cXgOIhBEGXks27sfeSQHVgNUeYgl5i5wG/dOUYaSIRnnzXR6NcyH+AfNAHtkWcyOD9rX4pojqmuQyH79K4="))
    }
}
