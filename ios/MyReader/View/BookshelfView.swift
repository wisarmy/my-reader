//
//  BookshelfView.swift
//  MyReader
//
//  Created by 高明军 on 2023/5/5.
//

import SwiftUI

struct BookshelfView: View {
    var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 15))], spacing: 20) {
                
            }
        }
    }
}

struct BookshelfView_Previews: PreviewProvider {
    static var previews: some View {
        BookshelfView()
    }
}
