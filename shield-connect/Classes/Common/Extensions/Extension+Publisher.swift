//
//  Extension+Publisher.swift
//  dating-app
//
//  Created by Александр on 10.04.2025.
//

import Foundation
import Combine

extension Publisher {
    func asyncValue() async throws -> Output {
        try await withCheckedThrowingContinuation { continuation in
            var cancellable: AnyCancellable?

            cancellable = self
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    case .finished:
                        break
                    }
                    _ = cancellable
                }, receiveValue: { value in
                    continuation.resume(returning: value)
                    _ = cancellable
                })
        }
    }
}
