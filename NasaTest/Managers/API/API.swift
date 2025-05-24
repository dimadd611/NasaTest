//
//  API.swift
//  NasaTest
//
//  Created by Дмитрий Рахманюк on 24.05.2025.
//

import Foundation
import Foundation
import Alamofire

enum APIError: Error, LocalizedError {
    case networkFailure(Error)      
    case decodingFailure(Error)
    case serverError(statusCode: Int)
    case unknown

    var errorDescription: String? {
        switch self {
        case .networkFailure(_):
            return "Network error: Please check your internet connection."
        case .decodingFailure(let err):
            return "Data processing error: \(err.localizedDescription)"
        case .serverError(let code):
            return "Server error: status code \(code)"
        case .unknown:
            return "Unknown error occurred"
        }
    }
}

final class APIManager {
    static let shared = APIManager()
    private init() {}

    private let baseURL = "https://api.spacexdata.com/v4"

    func fetchLaunches() async throws -> [SpaceResponse] {
        let url = "\(baseURL)/launches"
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url)
                .validate(statusCode: 200..<300) // Валидируем только успешные коды
                .responseDecodable(of: [SpaceResponse].self, decoder: decoder) { response in
                    switch response.result {
                    case .success(let launches):
                        continuation.resume(returning: launches)
                    case .failure(let error):
                        if let responseCode = response.response?.statusCode,
                           !(200..<300).contains(responseCode) {
                            continuation.resume(throwing: APIError.serverError(statusCode: responseCode))
                        } else if let decodingError = error.asAFError?.underlyingError as? DecodingError {
                            continuation.resume(throwing: APIError.decodingFailure(decodingError))
                        } else if let afError = error.asAFError {
                            continuation.resume(throwing: APIError.networkFailure(afError))
                        } else {
                            continuation.resume(throwing: APIError.unknown)
                        }
                    }
                }
        }
    }
    
    func getRocketInfo(id: String) async throws -> RocketResponse {
        let url = "\(baseURL)/rockets/\(id)"
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url)
                .validate(statusCode: 200..<300) // Валидируем только успешные коды
                .responseDecodable(of: RocketResponse.self, decoder: decoder) { response in
                    switch response.result {
                    case .success(let launches):
                        continuation.resume(returning: launches)
                    case .failure(let error):
                        if let responseCode = response.response?.statusCode,
                           !(200..<300).contains(responseCode) {
                            continuation.resume(throwing: APIError.serverError(statusCode: responseCode))
                        } else if let decodingError = error.asAFError?.underlyingError as? DecodingError {
                            continuation.resume(throwing: APIError.decodingFailure(decodingError))
                        } else if let afError = error.asAFError {
                            continuation.resume(throwing: APIError.networkFailure(afError))
                        } else {
                            continuation.resume(throwing: APIError.unknown)
                        }
                    }
                }
        }
    }
}
