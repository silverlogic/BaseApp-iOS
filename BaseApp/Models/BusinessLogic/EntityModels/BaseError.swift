//
//  APIError.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/6/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation

/// A class entity representing an error that the API would return or an internal error in the application.
final class BaseError: Error {
    
    // MARK: - Attributes
    let statusCode: Int
    let errorDescription: String
    
    
    // MARK: - Initializers
    
    /// Initializes an instance of `BaseError` with a given status code and an error description.
    ///
    /// - Parameters:
    ///   - statusCode: An `Int` representing the status code of the response. The status code would usually
    ///                 be within the four hundred to five hundred.
    ///   - errorDescription: A `String` representing the description of the error given from the API.
    init(statusCode: Int, errorDescription: String) {
        self.statusCode = statusCode
        self.errorDescription = errorDescription
    }
}


// MARK: - Public Class Methods
extension BaseError {
    
    /// Takes an error dictionary returned from the API and gets the error description.
    ///
    /// - Parameter errorDictionary: An `[String: Any]` representing the error dictionary returned from the
    ///                              API.
    /// - Returns: A `String` representing the error description. If the dictionary can't be parsed, a default
    ///            error description will be returned.
    class func errorDescriptionFromErrorDictionary(_ errorDictionary: [String: Any]) -> String {
        if let usernameErrors = errorDictionary["username"] as? [String],
           let usernameError = usernameErrors.first {
            return usernameError + " 😞"
        }
        if let userIdErrors = errorDictionary["id"] as? [String],
           let userIdError = userIdErrors.first {
            return userIdError + " 😞"
        }
        if let firstNameErrors = errorDictionary["first_name"] as? [String],
           let firstNameError = firstNameErrors.first {
            return firstNameError + " 😞"
        }
        if let lastNameErrors = errorDictionary["last_name"] as? [String],
           let lastNameError = lastNameErrors.first {
            return lastNameError + " 😞"
        }
        if let phoneErrors = errorDictionary["phone"] as? [String],
           let phoneError = phoneErrors.first {
            return phoneError + " 😞"
        }
        if let birthDateErrors = errorDictionary["birth_date"] as? [String],
           let birthDateError = birthDateErrors.first {
            return birthDateError + " 😞"
        }
        if let emailErrors = errorDictionary["email"] as? [String],
           let emailError = emailErrors.first {
            return emailError + " 😞"
        }
        if let emailError = errorDictionary["email"] as? String {
            return emailError + " 😞"
        }
        if let genderErrors = errorDictionary["gender"] as? [String],
           let genderError = genderErrors.first {
            return genderError + " 😞"
        }
        if let tokenErrors = errorDictionary["token"] as? [String],
           let tokenError = tokenErrors.first {
            return tokenError + " 😞"
        }
        if let passwordErrors = errorDictionary["password"] as? [String],
           let passwordError = passwordErrors.first {
            return passwordError + " 😞"
        }
        if let photoErrors = errorDictionary["photo"] as? [String],
           let photoError = photoErrors.first {
            return photoError + " 😞"
        }
        if let nonFieldErrors = errorDictionary["non_field_errors"] as? [String],
           let nonFieldError = nonFieldErrors.first {
            return nonFieldError + " 😞"
        }
        if let detailErrors = errorDictionary["detail"] as? [String],
           let detailError = detailErrors.first {
            return detailError + " 😞"
        }
        if let imageErrors = errorDictionary["image"] as? [String],
           let imageError = imageErrors.first {
            return imageError + " 😞"
        }
        if let providerErrors = errorDictionary["provider"] as? [String],
           let providerError = providerErrors.first {
            return providerError
        }
        return NSLocalizedString("BaseError.DefaultErrorDescription", comment: "Default Error")
    }
}


// MARK: - Internal Errors
extension BaseError {
    static var generic: BaseError {
        let description = NSLocalizedString("BaseError.DefaultErrorDescription", comment: "Default Error")
        return BaseError(statusCode: 0, errorDescription: description)
    }
    
    static var fieldsEmpty: BaseError {
        let description = NSLocalizedString("BaseError.FieldsMissing", comment: "Default Error")
        return BaseError(statusCode: 101, errorDescription: description)
    }
    
    static var passwordsDoNotMatch: BaseError {
        let description = NSLocalizedString("BaseError.PasswordsDoNotMatch", comment: "Default Error")
        return BaseError(statusCode: 102, errorDescription: description)
    }
    
    static var emailNeededForOAuth: BaseError {
        let description = NSLocalizedString("BaseError.EmailNeededForOAuth", comment: "Default Error")
        return BaseError(statusCode: 103, errorDescription: description)
    }
    
    static var emailAlreadyInUseForOAuth: BaseError {
        let description = NSLocalizedString("BaseError.EmailAlreadyInUseForOAuth", comment: "Default Error")
        return BaseError(statusCode: 104, errorDescription: description)
    }
    
    static var emailNeededForOAuthFacebook: BaseError {
        let description = NSLocalizedString("BaseError.EmailNeededForOAuth", comment: "Default Error")
        return BaseError(statusCode: 105, errorDescription: description)
    }
    
    static var emailNeededForOAuthLinkedIn: BaseError {
        let description = NSLocalizedString("BaseError.EmailNeededForOAuth", comment: "Default Error")
        return BaseError(statusCode: 106, errorDescription: description)
    }
    
    static var emailNeededForOAuthTwitter: BaseError {
        let description = NSLocalizedString("BaseError.EmailNeededForOAuth", comment: "Default Error")
        return BaseError(statusCode: 107, errorDescription: description)
    }
    
    static var endOfPagination: BaseError {
        let description = NSLocalizedString("BaseError.EndOfPagination", comment: "Default Error")
        return BaseError(statusCode: 108, errorDescription: description)
    }
    
    static var stillLoadingResults: BaseError {
        let description = NSLocalizedString("BaseError.StillLoadingResults", comment: "Default Error")
        return BaseError(statusCode: 109, errorDescription: description)
    }
    
    static var newEmailConfirmed: BaseError {
        let description = NSLocalizedString("BaseError.NewEmailConfirmed", comment: "Default Error")
        return BaseError(statusCode: 110, errorDescription: description)
    }
    
    static var fetchResultsError: BaseError {
        let description = NSLocalizedString("BaseError.FetchResultsError", comment: "Default Error")
        return BaseError(statusCode: 111, errorDescription: description)
    }
}
