//
//  EPUBModule.swift
//  MyReader
//
//  Created by 高明军 on 2023/5/9.
//

import Foundation
import UIKit
import R2Shared
import R2Navigator


final class EPUBModule: ReaderFormatModule {
    
    weak var delegate: ReaderFormatModuleDelegate?
    
    init(delegate: ReaderFormatModuleDelegate?) {
        self.delegate = delegate
    }

    func supports(_ publication: Publication) -> Bool {
        return publication.conforms(to: .epub)
            || publication.readingOrder.allAreHTML
    }
    
    @MainActor
    func makeReaderViewController(for publication: Publication, locator: Locator?, bookId: Book.Id, books: BookRepository, bookmarks: BookmarkRepository, highlights: HighlightRepository) async throws -> UIViewController {
        guard publication.metadata.identifier != nil else {
            throw ReaderError.epubNotValid
        }
        
        let preferencesStore = makePreferencesStore(books: books)
        let epubViewController = try EPUBViewController(
            publication: publication,
            locator: locator,
            bookId: bookId,
            books: books,
            bookmarks: bookmarks,
            highlights: highlights,
            initialPreferences: try await preferencesStore.preferences(for: bookId),
            preferencesStore: preferencesStore
        )
        epubViewController.moduleDelegate = delegate
        return epubViewController
    }
    
    func makePreferencesStore(books: BookRepository) -> AnyUserPreferencesStore<EPUBPreferences> {
        CompositeUserPreferencesStore(
            publicationStore: DatabaseUserPreferencesStore(books: books),
            sharedStore: UserDefaultsUserPreferencesStore(),
            publicationFilter: { $0.filterPublicationPreferences() },
            sharedFilter: { $0.filterSharedPreferences() }
        ).eraseToAnyPreferencesStore()
    }
}
