//
//  ReaderFormatModule.swift
//  MyReader
//
//  Created by 高明军 on 2023/5/9.
//

import Foundation
import UIKit
import R2Shared
import Combine

/// A ReaderFormatModule is a sub-module of ReaderModule that handles publication of a given format (eg. EPUB, CBZ).
protocol ReaderFormatModule {
    
    var delegate: ReaderFormatModuleDelegate? { get }
    
    /// Returns whether the given publication is supported by this module.
    func supports(_ publication: Publication) -> Bool
    
    /// Creates the view controller to present the publication.
    func makeReaderViewController(for publication: Publication, locator: Locator?, bookId: Book.Id, books: BookRepository, bookmarks: BookmarkRepository, highlights: HighlightRepository) async throws -> UIViewController
}

protocol ReaderFormatModuleDelegate: AnyObject {
    
    /// Shows the reader's outline from the given links.
    func presentOutline(of publication: Publication, bookId: Book.Id, from viewController: UIViewController) -> AnyPublisher<Locator, Never>
    
    /// Shows the DRM management screen for the given DRM.
    func presentDRM(for publication: Publication, from viewController: UIViewController)
    
    func presentAlert(_ title: String, message: String, from viewController: UIViewController)
    func presentError(_ error: Error?, from viewController: UIViewController)
    
}
