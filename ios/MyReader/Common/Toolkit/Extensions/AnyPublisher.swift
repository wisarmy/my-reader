//
//  AnyPublisher.swift
//  MyReader
//
//  Created by 高明军 on 2023/5/5.
//

import Combine

extension AnyPublisher {
    
    public static func just(_ value: Output) -> Self {
        Just(value)
            .setFailureType(to: Failure.self)
            .eraseToAnyPublisher()
    }
    
    public static func fail(_ error: Failure) -> Self {
        Fail(error: error).eraseToAnyPublisher()
    }

    enum AsyncPublisherError: Error {
        case completedBeforeOutput
    }

    func async() async throws -> Output {
        try await withCheckedThrowingContinuation { continuation in
            var cancellable: AnyCancellable?
            var completedBeforeOutput = true
            cancellable = first()
                .sink { result in
                    switch result {
                    case .finished:
                        if completedBeforeOutput {
                            continuation.resume(throwing: AsyncPublisherError.completedBeforeOutput)
                        }
                    case let .failure(error):
                        continuation.resume(throwing: error)
                    }
                    cancellable?.cancel()
                } receiveValue: { value in
                    completedBeforeOutput = false
                    continuation.resume(with: .success(value))
                }
        }
    }
}
