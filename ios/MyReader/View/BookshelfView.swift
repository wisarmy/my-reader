//
//  BookshelfView.swift
//  MyReader
//
//  Created by 高明军 on 2023/5/5.
//

import SwiftUI

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
                AddBookWithLinkView() { link in
                    print(link)
                }
                
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
