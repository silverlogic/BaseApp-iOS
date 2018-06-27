//
//  Promise+Extension.swift
//  BaseAppV2
//
//  Created by Manuel García-Estañ on 11/3/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation
import PromiseKit

extension Promise {

    /// The provided closure executes when this promise rejects. It automatically casts the error object to
    /// type `APIError`. If the type is different then an error object of type `Error` will be used instead.
    ///
    /// - Parameters:
    ///   - queue: The queue to which the provided closure dispatches.
    ///   - policy: The default policy does not execute your handler for cancellation errors.
    ///   - body: The handler to execute if this promise is rejected.
    func catchAPIError(queue: DispatchQueue = .default,
                       policy: CatchPolicy = .allErrorsExceptCancellation,
                       execute body: @escaping (BaseError) -> Void) {
        self.catch(on: DispatchQueue.main, policy: .allErrors) { (error) in
            guard let error = error as? BaseError else {
                body(BaseError.generic)
                return
            }
            body(error)
        }
    }
}
