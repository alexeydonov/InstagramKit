//
//  File.swift
//  
//
//  Created by Alexey Donov on 15.03.2020.
//

import Foundation

extension Instagram {

    public enum Scope: String, Hashable {
        case basic = "basic"
        case comments = "comments"
        case relationships = "relationships"
        case likes = "likes"
        case publicContent = "public_content"
        case followerList = "follower_list"
    }

}
