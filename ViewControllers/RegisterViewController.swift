//
//  RegisterViewController.swift
//  Newsys
//
//  Created by Yiğit Sağlam on 19.07.2026.
//

import UIKit

class RegisterViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Hesap Oluştur"
    }

    @IBAction func registerTapped(_ sender: Any) {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let confirmPassword = confirmPasswordTextField.text, !confirmPassword.isEmpty else {
            showAlert(message: "Lütfen tüm alanları doldur.")
            return
        }

        guard password == confirmPassword else {
            showAlert(message: "Şifreler eşleşmiyor.")
            return
        }

        guard password.count >= 6 else {
            showAlert(message: "Şifre en az 6 karakter olmalı.")
            return
        }

        Task {
            do {
                try await AuthService.shared.signUp(email: email, password: password)
                await MainActor.run {
                    navigationController?.dismiss(animated: true)
                }
            } catch {
                await MainActor.run {
                    showAlert(message: "Kayıt başarısız: \(error.localizedDescription)")
                }
            }
        }
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Uyarı", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default))
        present(alert, animated: true)
    }
}
