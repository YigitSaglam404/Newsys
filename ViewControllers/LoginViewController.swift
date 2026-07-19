//
//  LoginViewController.swift
//  Newsys
//
//  Created by Yiğit Sağlam on 19.07.2026.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func loginTapped(_ sender: Any) {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showAlert(message: "Lütfen email ve şifreni gir.")
            return
        }

        Task {
            do {
                try await AuthService.shared.signIn(email: email, password: password)
                await MainActor.run {
                    dismiss(animated: true)
                }
            } catch {
                await MainActor.run {
                    showAlert(message: "Giriş başarısız: \(error.localizedDescription)")
                }
            }
        }
    }

    @IBAction func registerTapped(_ sender: Any) {
        guard let registerVC = storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") else {
            return
        }
        navigationController?.pushViewController(registerVC, animated: true)
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Uyarı", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }
}
