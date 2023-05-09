//
//  BookshelfView.swift
//  MyReader
//
//  Created by 高明军 on 2023/5/5.
//

import SwiftUI
import Combine
import R2Streamer
import R2Shared
import UIKit
import Foundation

struct BookshelfView: View {
    @State var showingAddBookActionSheet = false
    @State var showingNewBookModal = false
    @State var books: [Book]
    @State var subscriptions = Set<AnyCancellable>()
    @EnvironmentObject var library: LibraryService

    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 20) {
                    ForEach(books, id: \.id) { book in
                        NavigationLink(destination: BookDetailView(book:book)){
                            VStack {
                                Text(book.title)
                                    .foregroundColor(.black)
                                if
                                    let coverURL = book.cover,
                                    let coverData = try? Data(contentsOf: coverURL),
                                    let cover = UIImage(data: coverData)
                                {
                                    Image(uiImage: cover)
                                        .resizable()
                                        .frame(maxWidth: 100, maxHeight: 150)
                                    
                                } else {
                                    Image(systemName: "photo")
                                        .resizable()
                                        .frame(width: 100, height: 150)
                                }
                            }
                        }
                        
                    }
                }
                
            }
            .onAppear {
                library.allBooks()
                    .receive(on: DispatchQueue.main)
                    .sink { completion in
                        if case .failure(let error) = completion {
                            fatalError("获取图书列表失败：\(error)")
                        }
                    } receiveValue: { newBooks in
                        print("newBooks: ", newBooks)
                        if !newBooks.isEmpty {
                            self.books = newBooks
                        }
                    }
                    .store(in: &subscriptions)
            }
            // ScrollView ending
            .padding()
            .navigationTitle("书架")
            .navigationBarItems(trailing: Button(action: {
                showingAddBookActionSheet = true
            }) {
                Image(systemName: "plus")
                    .foregroundColor(.blue)
            })
            .alert("添加图书", isPresented: $showingNewBookModal) {
                AddBookWithLinkView(onAdd: {link in
                    let hostAddBookWithLinkView = UIHostingController(rootView: self)
                    let url = URL(string: link)!
                    print("url: ",url)
     
                    Task {
                        do {
                            let newBook = try await library.importPublication(from: url, sender: hostAddBookWithLinkView)
                            self.books.append(newBook)
                        } catch {
                            fatalError("导入图书失败：\(error)")
                        }
                    }
                })
                
            }
            .actionSheet(isPresented: $showingAddBookActionSheet) {
                ActionSheet(title: Text("添加书籍"), message: Text("选择要添加书籍的方式"), buttons: [
                    .default(Text("您的设备")) {
                    },
                    .default(Text("网络链接")) {
                        showingNewBookModal = true
                        print("showingNewBookModal", showingNewBookModal)
                    },
                    .cancel()
                ])
            }
        }
        
    }
}

struct BookshelfView_Previews: PreviewProvider {
    static var previews: some View {
        let library = LibraryService(books: bookRepository, httpClient: httpClient)
        BookshelfView(books: Book.sampleData).environmentObject(library)
    }
}
