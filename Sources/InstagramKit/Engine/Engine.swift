//
//  File.swift
//  
//
//  Created by Alexey Donov on 13.03.2020.
//

import Foundation
import CoreLocation

extension Instagram {

    public class Engine {

        public static let shared = Engine()

        public private(set) var appClientID: String?

        public private(set) var appRedirectURL: URL?

        public var accessToken: String?

        init() {
            let info = Bundle.main.infoDictionary

            appClientID = info?[Constant.Configuration.appClientId] as? String
            appRedirectURL = (info?[Constant.Configuration.appRedirectURL] as? String).flatMap { URL(string: $0) }

            if appClientID?.isEmpty ?? true {
                NSLog("[InstagramKit] ERROR : Invalid Client ID. Please set a valid value for the key \"%@\" in the App's Info.plist file", Constant.Configuration.appClientId);
            }

            if appRedirectURL == nil {
                NSLog("[InstagramKit] ERROR : Invalid Redirect URL. Please set a valid value for the key \"%@\" in the App's Info.plist file", Constant.Configuration.appRedirectURL);
            }
        }

    }

}
