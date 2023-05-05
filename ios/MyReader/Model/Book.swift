//
//  Book.swift
//  MyReader
//
//  Created by 高明军 on 2023/5/5.
//

import Foundation

//struct Book: Codable {
//    struct Id: EntityId { let rawValue: Int64 }
//    
//    let id: Id?
//    /// Canonical identifier for the publication, extracted from its metadata.
//    var identifier: String?
//    /// Title of the publication, extracted from its metadata.
//    var title: String
//    /// Authors of the publication, separated by commas.
//    var authors: String?
//    /// Media type associated to the publication.
//    var type: String
//    /// Location of the packaged publication or a manifest.
//    var path: String
//    /// Location of the cover.
//    var coverPath: String?
//    /// Last read location in the publication.
//    var locator: Locator? {
//        didSet { progression = locator?.locations.totalProgression ?? 0 }
//    }
//    /// Current progression in the publication, extracted from the locator.
//    var progression: Double
//    /// Date of creation.
//    var created: Date
//    
//    var mediaType: MediaType { MediaType.of(mediaType: type) ?? .binary }
//    
//    init(id: Id? = nil, identifier: String? = nil, title: String, authors: String? = nil, type: String, path: String, coverPath: String? = nil, locator: Locator? = nil, created: Date = Date()) {
//        self.id = id
//        self.identifier = identifier
//        self.title = title
//        self.authors = authors
//        self.type = type
//        self.path = path
//        self.coverPath = coverPath
//        self.locator = locator
//        self.progression = locator?.locations.totalProgression ?? 0
//        self.created = created
//    }
//    
//    var cover: URL? {
//        coverPath.map { Paths.covers.appendingPathComponent($0) }
//    }
//}
//
///// Protocol for a database entity id.
/////
///// Using this instead of regular integers makes the code safer, because we can only give ids of the
///// right model in APIs. It also helps self-document APIs.
//protocol EntityId: Codable, Hashable, RawRepresentable, ExpressibleByIntegerLiteral, CustomStringConvertible, DatabaseValueConvertible where RawValue == Int64 {}
//
//extension EntityId {
//    
//    // MARK: - ExpressibleByIntegerLiteral
//    
//    init(integerLiteral value: Int64) {
//        self.init(rawValue: value)!
//    }
//    
//    // MARK: - Codable
//    
//    init(from decoder: Decoder) throws {
//        self.init(rawValue: try decoder.singleValueContainer().decode(Int64.self))!
//    }
//    
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.singleValueContainer()
//        try container.encode(rawValue)
//    }
//    
//    // MARK: - CustomStringConvertible
//    
//    var description: String {
//        "\(Self.self)(\(rawValue))"
//    }
//    
//    // MARK: - DatabaseValueConvertible
//    
//    var databaseValue: DatabaseValue { rawValue.databaseValue }
//    
//    static func fromDatabaseValue(_ dbValue: DatabaseValue) -> Self? {
//        Int64.fromDatabaseValue(dbValue).map(Self.init)
//    }
//}
