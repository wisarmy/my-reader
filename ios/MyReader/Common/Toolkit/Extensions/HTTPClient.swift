//
//  HTTPClient.swift
//  MyReader
//
//  Created by 高明军 on 2023/5/8.
//

import Combine
import Foundation
import R2Shared

struct HTTPDownload {
    let file: URL
    let response: HTTPResponse
}

extension HTTPClient {
    
    func fetch(_ request: HTTPRequestConvertible) -> AnyPublisher<HTTPResponse, HTTPError> {
        var cancellable: R2Shared.Cancellable? = nil
        return Future { promise in
            cancellable = self.fetch(request, completion: promise)
        }
        .handleEvents(receiveCancel: { cancellable?.cancel() })
        .eraseToAnyPublisher()
    }
    
    func download(_ request: HTTPRequestConvertible, progress: @escaping (Double) -> Void) async throws -> HTTPDownload {
        try await withCheckedThrowingContinuation { cont in
            do {
                let (destination, handle) = try openTemporaryFileForWriting()
                var cancellable: R2Shared.Cancellable? = nil
                
                cancellable = stream(request,
                    consume: { data, progression in
                        if Task.isCancelled {
                            cancellable?.cancel()
                            try? handle.close()
                            try? FileManager.default.removeItem(at: destination)
                            return
                        }
                        if let progression = progression {
                            progress(progression)
                        }
                        handle.write(data)
                    },
                    completion: { result in
                        do {
                            try handle.close()
                            cont.resume(returning: HTTPDownload(file: destination, response: try result.get()))
                        } catch {
                            try? FileManager.default.removeItem(at: destination)
                            cont.resume(throwing: HTTPError(error: error))
                        }
                    }
                )
            } catch {
                cont.resume(throwing: HTTPError(error: error))
            }
        }
    }
    
    private func openTemporaryFileForWriting() throws -> (URL, FileHandle) {
        let destination = Paths.makeTemporaryURL()
        // Makes sure the file exists.
        try "".write(to: destination, atomically: true, encoding: .utf8)
        do {
            let handle = try FileHandle(forWritingTo: destination)
            return (destination, handle)
        } catch {
            throw HTTPError(kind: .other, cause: error)
        }
    }
}
