//
//  File.swift
//  
//
//  Created by Alexey Donov on 13.03.2020.
//

import Foundation

protocol Model: Identifiable, Decodable {
    var id: String { get }
}
