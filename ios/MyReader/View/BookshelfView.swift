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


struct BookshelfView: View {
    var books: [Book]
    @State var showingAddBookActionSheet = false
    @State var showingNewBookModal = false
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 20) {
                    ForEach(books, id: \.id) { book in
                        NavigationLink(destination: BookDetailView(book:book)){
                            VStack {
                                Text(book.title)
                                    .foregroundColor(.black)
                                Image(book.coverPath ?? "")
                                    .resizable()
                                    .frame(maxWidth: 100, maxHeight: 150)
                            }
                        }
                        
                    }
                }
                
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
                    let httpClient = DefaultHTTPClient()
                    var db: Database
                    do {
                        db = try Database(file: Paths.library.appendingPathComponent("database.db"))
                    } catch {
                        // 处理异常
                        fatalError("无法创建数据库：\(error)")
                    }
                    print(Paths.library.absoluteString)
                    
                    let books = BookRepository(db: db)
                    
                    let library = LibraryService(books: books, httpClient: httpClient)
                    let url = URL(string: link)!
                    print("url: ",url)
                    Task {
                        do {
                            try await library.importPublication(from: url, sender: hostAddBookWithLinkView)
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
        BookshelfView(books: Book.sampleData)
    }
}
