//
//  AddBookWithLinkView.swift
//  MyReader
//
//  Created by 高明军 on 2023/5/6.
//

import SwiftUI


struct AddBookWithLinkView: View {
    @State var newBookLink = ""
    var onAdd: (_ link: String) -> Void

    var body: some View {
        VStack {
            TextField("图书链接", text: $newBookLink)
                .padding()
            HStack {
                Button("取消") {
                    print("cancel")
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.2))
                Button("保存") {
                    onAdd(newBookLink)
                    newBookLink = ""
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                
            }
            .padding()
        }
    }
}

struct AddBookWithLinkView_Previews: PreviewProvider {
    static var previews: some View {
        @State var isShow = true
        AddBookWithLinkView(){link in }
    }
}
