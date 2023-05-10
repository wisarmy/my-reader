//
//  PDFModule.swift
//  MyReader
//
//  Created by 高明军 on 2023/5/9.
//

import Foundation
import UIKit
import R2Navigator
import R2Shared


/// The PDF module is only available on iOS 11 and more, since it relies on PDFKit.
@available(iOS 11.0, *)
final class PDFModule: ReaderFormatModule {

    weak var delegate: ReaderFormatModuleDelegate?
    
    init(delegate: ReaderFormatModuleDelegate?) {
        self.delegate = delegate
    }
    
    func supports(_ publication: Publication) -> Bool {
        return publication.conforms(to: .pdf)
    }
    
    @MainActor
    func makeReaderViewController(for publication: Publication, locator: Locator?, bookId: Book.Id, books: BookRepository, bookmarks: BookmarkRepository, highlights: HighlightRepository) async throws -> UIViewController {
        let preferencesStore = makePreferencesStore(books: books)
        let viewController = try PDFViewController(
            publication: publication,
            locator: locator,
            bookId: bookId,
            books: books,
            bookmarks: bookmarks,
            highlights: highlights,
            initialPreferences: try await preferencesStore.preferences(for: bookId),
            preferencesStore: preferencesStore
        )
        viewController.moduleDelegate = delegate
        return viewController
    }
    
    func makePreferencesStore(books: BookRepository) -> AnyUserPreferencesStore<PDFPreferences> {
        CompositeUserPreferencesStore(
            publicationStore: DatabaseUserPreferencesStore(books: books),
            sharedStore: UserDefaultsUserPreferencesStore(),
            publicationFilter: { $0.filterPublicationPreferences() },
            sharedFilter: { $0.filterSharedPreferences() }
        ).eraseToAnyPreferencesStore()
    }
}
