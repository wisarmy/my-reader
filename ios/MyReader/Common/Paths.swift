//
//  Paths.swift
//  MyReader
//
//  Created by 高明军 on 2023/5/5.
//

import Combine
import Foundation
import R2Shared

final class Paths {
    private init() {}
    
    static let home: URL =
        URL(fileURLWithPath: NSHomeDirectory(), isDirectory: true)
    
    static let temporary: URL =
        URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
    
    static let documents: URL =
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    static let library: URL =
        FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first!
    
    static let covers: URL = {
        let url = library.appendingPathComponent("Covers")
        try! FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
        return url
    }()
    
    static func makeDocumentURL(for source: URL? = nil, title: String?, mediaType: MediaType) -> AnyPublisher<URL, Never> {
        Future(on: .global()) { promise in
            // Is the file already in Documents/?
            if let source = source, source.standardizedFileURL.deletingLastPathComponent() == documents.standardizedFileURL {
                promise(.success(source))
            } else {
                let title = title.takeIf { !$0.isEmpty } ?? UUID().uuidString
                let ext = mediaType.fileExtension?.addingPrefix(".") ?? ""
                let filename = "\(title)\(ext)".sanitizedPathComponent
                promise(.success(documents.appendingUniquePathComponent(filename)))
            }
        }.eraseToAnyPublisher()
    }
    
    static func makeTemporaryURL() -> AnyPublisher<URL, Never> {
        Future(on: .global()) { promise in
            promise(.success(temporary.appendingUniquePathComponent()))
        }.eraseToAnyPublisher()
    }
    
    /// Returns whether the given `url` locates a file that is under the app's home directory.
    static func isAppFile(at url: URL) -> Bool {
        home.isParentOf(url)
    }
}