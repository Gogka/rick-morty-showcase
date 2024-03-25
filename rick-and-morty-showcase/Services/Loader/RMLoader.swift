//
//  RMLoader.swift
//  rick-and-morty-showcase
//
//  Created by Igor Tomilin on 22.03.24.
//

import Foundation
import os

final class RMLoader: Loader {
    static let decoder = makeObject(JSONDecoder()) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        $0.dateDecodingStrategy = .custom { decoder in
            let string = try decoder.singleValueContainer().decode(String.self)
            guard let date = formatter.date(from: string) else {
                throw DevError("Couldn't get a date from string \(string)")
            }
            return date
        }
    }
    
    private let session: URLSession
    private let baseURL: URL
    private var listeners: [RMLoaderListener]
    init(session: URLSession = .shared, listeners: [RMLoaderListener] = []) {
        self.session = session
        self.listeners = listeners
        self.baseURL = URL(string: "https://rickandmortyapi.com/api")!
    }
    
    func execute<Request, SuccessfullResponse, FailedResponse>(_ request: Request) async throws -> LoaderDataResult<SuccessfullResponse, FailedResponse> where Request : LoaderRequest, SuccessfullResponse == Request.SuccessfullResponse, FailedResponse : LoaderResponse, FailedResponse == Request.FailedResponse {
        let request = try request.makeURLRequest(withBaseURL: baseURL)
        listeners.forEach { $0.loader(self, willPerformRequest: request) }
        do {
            let (data, response) = try await session.data(for: request)
            listeners.forEach { $0.loader(self, hasExecutedDataRequest: request, data: data, response: response) }
            return LoaderDataResult(data: data, response: response)
        } catch {
            listeners.forEach { $0.loader(self, didReceiveError: error, request: request) }
            throw error
        }
    }
}

protocol RMLoaderListener {
    func loader(_ loader: RMLoader, willPerformRequest request: URLRequest)
    func loader(_ loader: RMLoader, hasExecutedDataRequest request: URLRequest, data: Data, response: URLResponse)
    func loader(_ loader: RMLoader, didReceiveError error: Error, request: URLRequest)
}

struct RMLoaderLogger: RMLoaderListener {
    let logger: Logger
    func loader(_ loader: RMLoader, willPerformRequest request: URLRequest) {
        logger.debug("[\(request.httpMethod ?? "", privacy: .public)] \(request.url?.absoluteString ?? "", privacy: .public)")
    }
    func loader(_ loader: RMLoader, hasExecutedDataRequest request: URLRequest, data: Data, response: URLResponse) {
        guard let status = (response as? HTTPURLResponse)?.statusCode,
              let dataString = String(data: data, encoding: .utf8) else { return }
        if (200..<300).contains(status) {
            logger.debug("\(status) [\(request.httpMethod ?? "", privacy: .public)] \(request.url?.absoluteString ?? "", privacy: .public)")
            logger.debug("\(dataString, privacy: .public)")
        } else {
            logger.error("\(status) [\(request.httpMethod ?? "", privacy: .public)] \(request.url?.absoluteString ?? "", privacy: .public)")
            logger.error("\(dataString, privacy: .public)")
        }
    }
    func loader(_ loader: RMLoader, didReceiveError error: Error, request: URLRequest) {
        logger.fault("[\(request.httpMethod ?? "", privacy: .public)] \(request.url?.absoluteString ?? "", privacy: .public)")
        logger.fault(error)
    }
}
