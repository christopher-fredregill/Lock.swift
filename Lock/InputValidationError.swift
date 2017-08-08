// InputValidationError.swift
//
// Copyright (c) 2016 Auth0 (http://auth0.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation

enum InputValidationError: Error {
    case mustNotBeEmpty
    case notAnEmailAddress
    case notAUsername
    case notAOneTimePassword
    case notAPhoneNumber
    case passwordPolicyViolation(result: [RuleResult])
    case doesNotMatch(String)

    func localizedMessage(withConnection connection: DatabaseConnection) -> String {
        switch self {
        case .notAUsername:
            let format = "Can only contain between %d to %d alphanumeric characters and \'_\'.".i18n(key: "com.auth0.lock.input.username.error", comment: "invalid username")
            return String(format: format, connection.usernameValidator.min, connection.usernameValidator.max)
        default:
            return self.localizedMessage()
        }
    }

    func localizedMessage() -> String {
        switch self {
        case .notAnEmailAddress:
            return "Must be a valid email address".i18n(key: "com.auth0.lock.input.email.error", comment: "invalid email")
        case .mustNotBeEmpty:
            return "Must not be empty".i18n(key: "com.auth0.lock.input.empty.error", comment: "empty input")
        case .notAOneTimePassword:
            return "Must be a valid numeric code".i18n(key: "com.auth0.lock.input.otp.error", comment: "invalid otp")
        case .notAPhoneNumber:
            return "Must be a valid phone number".i18n(key: "com.auth0.lock.input.phone.error", comment: "invalid phone")
        case .passwordPolicyViolation(let result):
            return result.first?.message ?? "Password does not fulfill policy".i18n(key: "com.auth0.lock.input.policy.error", comment: "policy violation")
        case .doesNotMatch(let type):
            return "\(type) do not match".i18n(key: "com.auth0.lock.input.nomatch.error", comment: "input does not match")
        default:
            return "Invalid input".i18n(key: "com.auth0.lock.input.generic.error", comment: "generic input error")
        }
    }
}
