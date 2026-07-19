//
//  AuthService.swift
//  Newsys
//
//  Created by Yiğit Sağlam on 19.07.2026.
//

import Foundation
import FirebaseAuth

enum AuthError: Error {
    case signUpFailed(String)
    case signInFailed(String)
    case signOutFailed(String)
}

class AuthService {

    static let shared = AuthService()

    private init() {}

    var currentUserEmail: String? {
        return Auth.auth().currentUser?.email
    }

    var isUserLoggedIn: Bool {
        return Auth.auth().currentUser != nil
    }

    func signUp(email: String, password: String) async throws {
        do {
            try await Auth.auth().createUser(withEmail: email, password: password)
        } catch {
            throw AuthError.signUpFailed(error.localizedDescription)
        }
    }

    func signIn(email: String, password: String) async throws {
        do {
            try await Auth.auth().signIn(withEmail: email, password: password)
        } catch {
            throw AuthError.signInFailed(error.localizedDescription)
        }
    }

    func signOut() throws {
        do {
            try Auth.auth().signOut()
        } catch {
            throw AuthError.signOutFailed(error.localizedDescription)
        }
    }
}
