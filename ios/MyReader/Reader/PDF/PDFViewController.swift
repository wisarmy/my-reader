//
//  PDFViewController.swift
//  MyReader
//
//  Created by 高明军 on 2023/5/9.
//

import Foundation
import UIKit
import R2Navigator
import R2Shared
import ReadiumAdapterGCDWebServer
import SwiftUI

@available(iOS 11.0, *)
final class PDFViewController: ReaderViewController<PDFNavigatorViewController> {

    private let preferencesStore: AnyUserPreferencesStore<PDFPreferences>

    init(
        publication: Publication,
        locator: Locator?,
        bookId: Book.Id,
        books: BookRepository,
        bookmarks: BookmarkRepository,
        highlights: HighlightRepository,
        initialPreferences: PDFPreferences,
        preferencesStore: AnyUserPreferencesStore<PDFPreferences>
    ) throws {
        self.preferencesStore = preferencesStore

        let navigator = try PDFNavigatorViewController(
            publication: publication,
            initialLocation: locator,
            config: PDFNavigatorViewController.Configuration(
                preferences: initialPreferences
            ),
            httpServer: GCDHTTPServer.shared
        )
        
        super.init(navigator: navigator, publication: publication, bookId: bookId, books: books, bookmarks: bookmarks, highlights: highlights)

        navigator.delegate = self
    }
    
    override var currentBookmark: Bookmark? {
        guard let locator = navigator.currentLocation else {
            return nil
        }

        return Bookmark(bookId: bookId, locator: locator)
    }

    override func presentUserPreferences() {
        Task {
            let userPrefs = UserPreferences(
                model: UserPreferencesViewModel(
                    bookId: bookId,
                    preferences: try! await preferencesStore.preferences(for: bookId),
                    configurable: navigator,
                    store: preferencesStore
                ),
                onClose: { [weak self] in
                    self?.dismiss(animated: true)
                }
            )
            let vc = UIHostingController(rootView: userPrefs)
            vc.modalPresentationStyle = .formSheet
            present(vc, animated: true)
        }
    }
}

@available(iOS 11.0, *)
extension PDFViewController: PDFNavigatorDelegate {
}
