//
//  File.swift
//  
//
//  Created by Alexey Donov on 13.03.2020.
//

import Foundation

extension Instagram {
    
    public struct User: Model {

        public let id: String

        public var username: String

        public var fullName: String?

        public var profilePictureURL: URL?

        public var bio: String?

        public var website: URL?

        public let mediaCount: Int

        public let followsCount: Int

        public let followedByCount: Int

        fileprivate enum CodingKeys: String, CodingKey {
            case id = "id"
            case username = "username"
            case fullName = "full_name"
            case profilePictureURL = "profile_picture"
            case bio = "bio"
            case website = "website"
            case counters = "counts"
        }

        fileprivate struct Counters: Decodable {
            var media: Int
            var follows: Int
            var followed_by: Int
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            id = try container.decode(String.self, forKey: .id)
            username = try container.decode(String.self, forKey: .username)
            fullName = try container.decodeIfPresent(String.self, forKey: .fullName)
            profilePictureURL = try container.decodeIfPresent(URL.self, forKey: .profilePictureURL)
            bio = try container.decodeIfPresent(String.self, forKey: .bio)
            website = try? container.decodeIfPresent(URL.self, forKey: .website)
            let counters = try container.decode(Counters.self, forKey: .counters)
            mediaCount = counters.media
            followsCount = counters.follows
            followedByCount = counters.followed_by
        }
    }

}
