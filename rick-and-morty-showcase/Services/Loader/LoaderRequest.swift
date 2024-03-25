//
//  LoaderRequest.swift
//  rick-and-morty-showcase
//
//  Created by Igor Tomilin on 22.03.24.
//

import Foundation

protocol LoaderRequest {
    associatedtype SuccessfullResponse: LoaderResponse
    associatedtype FailedResponse
    func makeURLRequest(withBaseURL url: URL) throws -> URLRequest
}

protocol LoaderResponse {
    init(data: Data, response: URLResponse) throws
}
struct EmptyResponse { }

extension EmptyResponse: LoaderResponse {
    init(data: Data, response: URLResponse) throws {}
}

extension LoaderResponse where Self: Decodable {
    init(data: Data, response: URLResponse) throws {
        self = try RMLoader.decoder.decode(Self.self, from: data)
    }
}

extension LoaderRequest {
    func makeURLRequest(
        withBaseURL baseURL: URL,
        path: String,
        method: URLRequest.Method,
        queryItems: [URLQueryItem]? = nil,
        body: Data? = nil
    ) throws -> URLRequest {
        guard var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false) else {
            throw DevError("Couldn't create components for baseURL \(baseURL.absoluteString).")
        }
        queryItems.map {
            components.queryItems = (components.queryItems ?? []) + $0
        }
        components.path += path
        guard let finalURL = components.url else {
            throw DevError("Couldn't create URL from components for baseURL \(baseURL.absoluteString).")
        }
        var request = URLRequest(url: finalURL)
        request.httpBody = body
        request.setMethod(method)
        return request
    }
}
