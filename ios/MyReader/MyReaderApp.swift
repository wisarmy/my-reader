//
//  MyReaderApp.swift
//  MyReader
//
//  Created by 高明军 on 2023/5/4.
//

import SwiftUI
import UIKit
import R2Shared

var db: Database!
var bookRepository: BookRepository!
var bookmarkRepository: BookmarkRepository!
var highlightRepository: HighlightRepository!
var readerDelegate: ObservableReaderModule!

var httpClient: HTTPClient!

@main
struct MyReaderApp: App {
    @StateObject var library = LibraryService(books: bookRepository, httpClient: httpClient)
    @StateObject var reader: ReaderModule = ReaderModule(delegate: readerDelegate, books: bookRepository, bookmarks: bookmarkRepository, highlights: highlightRepository)

    var body: some Scene {
        WindowGroup {
            TabPageView()
                .environmentObject(library)
//                .environmentObject(reader)
        }

    }
    init() {
        httpClient = DefaultHTTPClient()
        do {
            db = try Database(file: Paths.library.appendingPathComponent("database.db"))
        } catch {
            // 处理异常
            fatalError("无法创建数据库：\(error)")
        }
        bookRepository = BookRepository(db: db)
        bookmarkRepository = BookmarkRepository(db: db)
        highlightRepository = HighlightRepository(db: db)
        readerDelegate = ObservableReaderModule()
    }
}
protocol ModuleDelegate: AnyObject {
    func presentAlert(_ title: String, message: String, from viewController: UIViewController)
    func presentError(_ error: Error?, from viewController: UIViewController)
}

class ObservableReaderModule: ObservableObject, ReaderModuleDelegate {
    init() {}
    func presentAlert(_ title: String, message: String, from viewController: UIViewController) {
        readerDelegate?.presentAlert(title, message: message, from: viewController)
    }
    
    func presentError(_ error: Error?, from viewController: UIViewController) {
        readerDelegate?.presentError(error, from: viewController)
    }
}
