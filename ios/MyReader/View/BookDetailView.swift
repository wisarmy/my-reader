//
//  BookDetailView.swift
//  MyReader
//
//  Created by 高明军 on 2023/5/5.
//

import SwiftUI
import UIKit

struct BookDetailView: UIViewControllerRepresentable {
    var book: Book
    var library = LibraryService(books: bookRepository, httpClient: httpClient)
    var reader: ReaderModule = ReaderModule(delegate: readerDelegate, books: bookRepository, bookmarks: bookmarkRepository, highlights: highlightRepository)
    typealias UIViewControllerType = UINavigationController

    func makeUIViewController(context: Context) -> UINavigationController {
        let navigationController = UINavigationController()
        navigationController.isNavigationBarHidden = true
        Task {
            let pub = try await library.openBook(book, sender: navigationController)
            reader.presentPublication(publication: pub, book: book, in: navigationController)
            if let readerView = navigationController.viewControllers.first?.view {
                readerView.frame = navigationController.view.bounds
                readerView.layoutIfNeeded()
            }
        }
        return navigationController
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
    }
}

struct BookDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BookDetailView(book: Book.sampleData[0])
    }
}
