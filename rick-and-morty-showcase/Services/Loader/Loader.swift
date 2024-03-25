//
//  Loader.swift
//  rick-and-morty-showcase
//
//  Created by Igor Tomilin on 22.03.24.
//

import Foundation

protocol Loader {
    func execute<
        Request: LoaderRequest,
        SuccessfullResponse,
        FailedResponse
    >(_ request: Request) async throws -> LoaderDataResult<SuccessfullResponse, FailedResponse> where SuccessfullResponse == Request.SuccessfullResponse, FailedResponse == Request.FailedResponse
}

final class LoaderDataResult<SuccessfullResponse: LoaderResponse, FailedResponse: LoaderResponse> {
    let data: Data
    let response: URLResponse
    var httpResponse: HTTPURLResponse? { response as? HTTPURLResponse }
    init(data: Data, response: URLResponse) {
        self.data = data
        self.response = response
    }
    func checkStatus() throws -> Self {
        guard let status = httpResponse?.statusCode else {
            throw DevError("Undefined response \(type(of: response)).")
        }
        if (200..<300).contains(status) {
            return self
        } else {
           throw DevError("Status is not successfull. (\(status))")
        }
    }
    func getSuccessfullResponse() throws -> SuccessfullResponse {
        try SuccessfullResponse(data: data, response: response)
    }
    func getFailedResponse() throws -> FailedResponse {
        try FailedResponse(data: data, response: response)
    }
}
