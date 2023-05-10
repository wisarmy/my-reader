//
//  ReaderError.swift
//  MyReader
//
//  Created by 高明军 on 2023/5/9.
//

import Foundation

enum ReaderError: LocalizedError {
    case formatNotSupported
    case epubNotValid
    
    var errorDescription: String? {
        switch self {
        case .formatNotSupported:
            return NSLocalizedString("reader_error_formatNotSupported", comment: "Error message when trying to read a publication with a unsupported format")
        case .epubNotValid:
            return NSLocalizedString("reader_error_epubNotValid", comment: "Error message when trying to read an EPUB that is invalid")
        }
    }
}
