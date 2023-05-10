//
//  HighlightCellView.swift
//  MyReader
//
//  Created by 高明军 on 2023/5/9.
//

import Foundation
import SwiftUI

struct HighlightCellView: View {
    let highlight: Highlight
    
    var body: some View {
        HStack {
            Rectangle()
                .fill(Color(highlight.color.uiColor))
                .frame(maxWidth: 20, maxHeight: .infinity)
            
            Text(highlight.locator.text.sanitized().highlight ?? "")
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .padding()
            
            Spacer()
        }
    }
}
