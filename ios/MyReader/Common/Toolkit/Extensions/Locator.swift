//
//  Locator.swift
//  MyReader
//
//  Created by 高明军 on 2023/5/5.
//

import Foundation
import R2Shared

extension Locator: Codable {
    public init(from decoder: Decoder) throws {
        let json = try decoder.singleValueContainer().decode(String.self)
        try self.init(jsonString: json)!
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(jsonString)
    }
}
