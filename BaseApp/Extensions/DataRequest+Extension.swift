//
//  DataRequest+Extension.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/7/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Alamofire
import Foundation

extension DataRequest {
    
    /// Validates a response given from the server. It calculates if the response is succesful or not.
    ///
    /// - Postcondition: The type of request is returned based on the status code of the response. A status
    ///                  code between the range of two hundred to three hundred would be `success`. Otherwise,
    ///                  `failure`.
    ///
    /// - Returns: A `DataRequest` representing the type of request.
    func validateResponse() -> DataRequest {
        return validate { (_, response: HTTPURLResponse, responseData: Data?) -> Request.ValidationResult in
            let statusCode = response.statusCode
            if Array(200..<300).contains(statusCode) {
                return .success
            }
            guard let data = responseData,
                  let dictionary = try?
                    JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                  let errorDictionary = dictionary else {
                return .failure(AFError.responseValidationFailed(reason: .unacceptableStatusCode(code:
                    statusCode)))
            }
            let errorDescription = BaseError.errorDescriptionFromErrorDictionary(errorDictionary)
            let apiError = BaseError(statusCode: statusCode, errorDescription: errorDescription)
            return .failure(apiError)
        }
    }
}
