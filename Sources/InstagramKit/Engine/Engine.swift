//
//  File.swift
//  
//
//  Created by Alexey Donov on 13.03.2020.
//

import Foundation
import CoreLocation

public extension Instagram {

    class Engine {

        public static let shared = Engine()

        public private(set) var appClientID: String?
        public private(set) var appClientSecret: String?

        public private(set) var appRedirectURL: URL?

        public var accessToken: String?

        init() {
            let info = Bundle.main.infoDictionary

            appClientID = info?[Constant.Configuration.appClientId] as? String
            appClientSecret = info?[Constant.Configuration.appClientSecret] as? String
            appRedirectURL = (info?[Constant.Configuration.appRedirectURL] as? String).flatMap { URL(string: $0) }

            if appClientID?.isEmpty ?? true {
                NSLog("[InstagramKit] ERROR : Invalid Client ID. Please set a valid value for the key \"%@\" in the application Info.plist file", Constant.Configuration.appClientId);
            }

            if appClientSecret?.isEmpty ?? true {
                NSLog("[InstagramKit] ERROR : Invalid Client Secret. Please set a valid value for the key \"%@\" in the application Info.plist file", Constant.Configuration.appClientSecret);
            }

            if appRedirectURL == nil {
                NSLog("[InstagramKit] ERROR : Invalid Redirect URL. Please set a valid value for the key \"%@\" in the application Info.plist file", Constant.Configuration.appRedirectURL);
            }
        }

    }

}
