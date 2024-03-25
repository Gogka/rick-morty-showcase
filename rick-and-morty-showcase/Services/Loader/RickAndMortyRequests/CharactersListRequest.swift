//
//  CharactersListRequest.swift
//  rick-and-morty-showcase
//
//  Created by Igor Tomilin on 22.03.24.
//

import Foundation

struct CharactersListRequest: LoaderRequest {
    let page: Int
    
    func makeURLRequest(withBaseURL url: URL) throws -> URLRequest {
        try makeURLRequest(
            withBaseURL: url,
            path: "/character",
            method: .get,
            queryItems: [
                .init(name: "page", value: "\(page)")
            ]
        )
    }
}

extension CharactersListRequest {
    typealias FailedResponse = EmptyResponse
    struct SuccessfullResponse: Decodable, LoaderResponse {
        struct Info: Decodable {
            let pages: Int
        }
        struct Character: Decodable, LoaderResponse {
            let id: Int
            let name: String
            let type: String
            let image: URL
        }
        let info: Info
        let results: [Character]
    }
}
