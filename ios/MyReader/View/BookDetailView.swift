//
//  BookDetailView.swift
//  MyReader
//
//  Created by 高明军 on 2023/5/5.
//

import SwiftUI
import UIKit

struct BookDetailView: View {
    var book: Book
    var reader: ReaderModuleAPI!
    @EnvironmentObject var library: LibraryService
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            Text(book.title).foregroundColor(.red)
            Image(book.coverPath ?? "")
                .resizable()
        }.onAppear {
            _ = UIHostingController(rootView: self)

            Task {
//                let pub = try await library.openBook(book, sender: bookDetailView)
//                reader.presentPublication(publication: pub, book: book, in: presentationMode.wrappedValue)
            }
        }
    }

}

//struct BookDetailView: UIViewControllerRepresentable {
//    var book: Book
//
//    typealias UIViewControllerType = UINavigationController
//
//    func makeUIViewController(context: Context) -> UINavigationController {
//        let viewController = UIViewController()
//        viewController.view.backgroundColor = .red
//        let navigationController = UINavigationController(rootViewController: viewController)
//        return navigationController
//    }
//
//    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
//        // Do nothing
//    }
//}

//struct BookDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        BookDetailView(book: Book.sampleData[0])
//    }
//}
