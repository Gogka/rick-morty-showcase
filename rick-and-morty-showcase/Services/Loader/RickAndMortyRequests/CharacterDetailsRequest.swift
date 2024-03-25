//
//  CharacterDetailsRequest.swift
//  rick-and-morty-showcase
//
//  Created by Igor Tomilin on 24.03.24.
//

import Foundation

struct CharacterDetailsRequest: LoaderRequest {
    let characterId: Int
    
    func makeURLRequest(withBaseURL url: URL) throws -> URLRequest {
        try makeURLRequest(
            withBaseURL: url,
            path: "/character/\(characterId)",
            method: .get
        )
    }
}

extension CharacterDetailsRequest {
    typealias FailedResponse = EmptyResponse
    typealias SuccessfullResponse = CharactersListRequest.SuccessfullResponse.Character
}
