//
//  ContentView.swift
//  MyReader
//
//  Created by 高明军 on 2023/5/4.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            ZStack {
                Rectangle().foregroundColor(Color(UIColor(white: 0.95, alpha: 1.0)))
                    .edgesIgnoringSafeArea(.top)
                VStack {
                    Text("书架")
                    Spacer()
                }
            }.tabItem {
                Image(systemName: "books.vertical")
                Text("书架")
            }
            ZStack {
                Rectangle().foregroundColor(Color(UIColor(white: 0.95, alpha: 1.0)))
                    .edgesIgnoringSafeArea(.top)
                VStack {
                    Text("设置")
                    Spacer()
                }
            }.tabItem {
                Image(systemName: "gear")
                Text("设置")
            }
        }
        .accentColor(.green)
        .foregroundColor(.red)
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
