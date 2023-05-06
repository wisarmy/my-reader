//
//  Book.swift
//  MyReader
//
//  Created by 高明军 on 2023/5/5.
//

import Combine
import Foundation
import GRDB
import R2Shared

struct Book: Codable, Identifiable {
    struct Id: EntityId { let rawValue: Int64 }
    
    let id: Id?
    /// Canonical identifier for the publication, extracted from its metadata.
    var identifier: String?
    /// Title of the publication, extracted from its metadata.
    var title: String
    /// Authors of the publication, separated by commas.
    var authors: String?
    /// Media type associated to the publication.
    var type: String
    /// Location of the packaged publication or a manifest.
    var path: String
    /// Location of the cover.
    var coverPath: String?
    /// Last read location in the publication.
    var locator: Locator? {
        didSet { progression = locator?.locations.totalProgression ?? 0 }
    }
    /// Current progression in the publication, extracted from the locator.
    var progression: Double
    /// Date of creation.
    var created: Date
    
    var mediaType: MediaType { MediaType.of(mediaType: type) ?? .binary }
    
    init(id: Id? = nil, identifier: String? = nil, title: String, authors: String? = nil, type: String, path: String, coverPath: String? = nil, locator: Locator? = nil, created: Date = Date()) {
        self.id = id
        self.identifier = identifier
        self.title = title
        self.authors = authors
        self.type = type
        self.path = path
        self.coverPath = coverPath
        self.locator = locator
        self.progression = locator?.locations.totalProgression ?? 0
        self.created = created
    }
    
    var cover: URL? {
        coverPath.map { Paths.covers.appendingPathComponent($0) }
    }
}

extension Book: TableRecord, FetchableRecord, PersistableRecord {
    enum Columns: String, ColumnExpression {
        case id, identifier, title, type, path, coverPath, locator, progression, created
    }
}

final class BookRepository {
    private let db: Database
    
    init(db: Database) {
        self.db = db
    }
    
    func all() -> AnyPublisher<[Book], Error> {
        db.observe { db in
            try Book.order(Book.Columns.created).fetchAll(db)
        }
    }
    
    func add(_ book: Book) -> AnyPublisher<Book.Id, Error> {
        return db.write { db in
            try book.insert(db)
            return Book.Id(rawValue: db.lastInsertedRowID)
        }.eraseToAnyPublisher()
    }
    
    func remove(_ id: Book.Id) -> AnyPublisher<Void, Error> {
        db.write { db in try Book.deleteOne(db, key: id) }
    }
    
    func saveProgress(for id: Book.Id, locator: Locator) -> AnyPublisher<Void, Error> {
        guard let json = locator.jsonString else {
            return .just(())
        }
        
        return db.write { db in
            try db.execute(literal: """
                UPDATE book
                   SET locator = \(json), progression = \(locator.locations.totalProgression ?? 0)
                 WHERE id = \(id)
            """)
        }
    }
}

extension Book {
    static let sampleData: [Book] = [
        Book(id: 1, title: "朝花夕拾", type: "epub", path: "/books/zhaohuaxishi", coverPath: "zhaohuaxishi"),
        Book(id: 2, title: "鲁滨逊漂流记", type: "epub", path: "/books/lubinxunpiaoliuji", coverPath: "lubinxunpiaoliuji"),
        Book(id: 3, title: "飘", type: "epub", path: "/books/piao", coverPath: "piao"),
        Book(id: 4, title: "谁爱这不息的变幻", type: "epub", path: "/books/shuiaizhebuxidebianhuan", coverPath: "shuiaizhebuxidebianhuan"),
        Book(id: 5, title: "朝花夕拾", type: "epub", path: "/books/zhaohuaxishi", coverPath: "zhaohuaxishi"),
        Book(id: 6, title: "鲁滨逊漂流记", type: "epub", path: "/books/lubinxunpiaoliuji", coverPath: "lubinxunpiaoliuji"),
        Book(id: 7, title: "飘", type: "epub", path: "/books/piao", coverPath: "piao"),
        Book(id: 8, title: "谁爱这不息的变幻", type: "epub", path: "/books/shuiaizhebuxidebianhuan", coverPath: "shuiaizhebuxidebianhuan"),
        
    ]
}
