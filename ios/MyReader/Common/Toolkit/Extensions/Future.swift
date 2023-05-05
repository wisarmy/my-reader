//
//  Future.swift
//  MyReader
//
//  Created by 高明军 on 2023/5/5.
//

import Combine
import Foundation

extension Future {
    /// Creates a `Future` which runs asynchronously on the given `queue`.
    public convenience init(on queue: DispatchQueue, _ attemptToFulfill: @escaping (@escaping Future<Output, Failure>.Promise) -> Void) {
        self.init { promise in
            queue.async {
                attemptToFulfill(promise)
            }
        }
    }
}

