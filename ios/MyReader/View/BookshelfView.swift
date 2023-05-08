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
                    ForEach(books) { book in
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
                    var subscriptions = Set<AnyCancellable>()

                    let hostAddBookWithLinkView = UIHostingController(rootView: self)
                    
                    guard let server = PublicationServer() else {
                        /// FIXME: we should recover properly if the publication server can't start, maybe this should only forbid opening a publication?
                        fatalError("Can't start publication server")
                    }
                    
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
              
                    
                    var library = LibraryService(books: books, publicationServer: server, httpClient: httpClient)
                   
                 

                       let url = URL(string: "https://s3.amazonaws.com/moby-dick/moby-dick.epub")!
                       print("url: ",url)

                       library.importPublication(from: url, sender: hostAddBookWithLinkView)
                           .receive(on: DispatchQueue.main)
                           .sink { completion in
                               if case .failure(let error) = completion {
                                   print(error.localizedDescription)
                               }
                               switch completion {
                               case .finished:
                                   print("导入完成")
                               case .failure(let error):
                                   print("导入失败: ", error.localizedDescription)
                               }
                               
                           } receiveValue: {  progress in
                               print("导入进度: ", progress)
                           }
                           .store(in: &subscriptions)
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
