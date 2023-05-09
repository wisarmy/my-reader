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
var httpClient: HTTPClient!


@main
struct MyReaderApp: App {
    @StateObject var library = LibraryService(books: bookRepository, httpClient: httpClient)
    var body: some Scene {
        WindowGroup {
            TabPageView()
                .environmentObject(library)
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
    }
}
protocol ModuleDelegate: AnyObject {
    func presentAlert(_ title: String, message: String, from viewController: UIViewController)
    func presentError(_ error: Error?, from viewController: UIViewController)
}
