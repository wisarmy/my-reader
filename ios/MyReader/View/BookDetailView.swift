//
//  BookDetailView.swift
//  MyReader
//
//  Created by 高明军 on 2023/5/5.
//

import SwiftUI

struct BookDetailView: View {
    var book: Book
    var body: some View {
        VStack {
            Text(book.title).foregroundColor(.red)
            Image(book.coverPath ?? "")
                .resizable()
        }
    }
}

struct BookDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BookDetailView(book: Book.sampleData[0])
    }
}
