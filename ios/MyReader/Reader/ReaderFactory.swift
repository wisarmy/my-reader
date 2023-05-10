//
//  ReaderFactory.swift
//  MyReader
//
//  Created by 高明军 on 2023/5/9.
//

import Foundation
import UIKit
import R2Shared
import SwiftUI
import Combine

final class ReaderFactory {
    
    final class Storyboards {
        let drm = UIStoryboard(name: "DRM", bundle: nil)
    }
    
    let storyboards = Storyboards()
}

extension ReaderFactory: OutlineTableViewControllerFactory {
    func make(publication: Publication, bookId: Book.Id, bookmarks: BookmarkRepository, highlights: HighlightRepository) -> OutlineTableViewAdapter {
        let view = OutlineTableView(publication: publication, bookId: bookId, bookmarkRepository: bookmarks, highlightRepository: highlights)
        let hostingVC = OutlineHostingController(rootView: view)
        hostingVC.title = publication.metadata.title
        
        return (hostingVC, view.goToLocatorPublisher)
    }
}

//extension ReaderFactory: DRMManagementTableViewControllerFactory {
//    func make(publication: Publication, delegate: ReaderModuleDelegate?) -> DRMManagementTableViewController {
//        let controller =
//            storyboards.drm.instantiateViewController(withIdentifier: "DRMManagementTableViewController") as! DRMManagementTableViewController
//        controller.moduleDelegate = delegate
//        controller.viewModel = DRMViewModel.make(publication: publication, presentingViewController: controller)
//        return controller
//    }
//}

/// This is a wrapper for the "OutlineTableView" to encapsulate the  "Cancel" button behaviour
class OutlineHostingController: UIHostingController<OutlineTableView> {
    override public init(rootView: OutlineTableView) {
        super.init(rootView: rootView)
        self.navigationItem.setLeftBarButton(UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonPressed)), animated: true)
    }
    
    @MainActor @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func cancelButtonPressed(_ sender: UIBarItem) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}
