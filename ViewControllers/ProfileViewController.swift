//
//  ProfileViewController.swift
//  Newsys
//
//  Created by Yiğit Sağlam on 19.07.2026.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var emailLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }

    private func updateUI() {
        if AuthService.shared.isUserLoggedIn {
            emailLabel.text = AuthService.shared.currentUserEmail
        } else {
            presentLoginScreen()
        }
    }

    private func presentLoginScreen() {
        guard let loginNav = storyboard?.instantiateViewController(withIdentifier: "LoginNavigationController") else {
            return
        }
        loginNav.modalPresentationStyle = .fullScreen
        present(loginNav, animated: true)
    }

    @IBAction func logoutTapped(_ sender: Any) {
        do {
            try AuthService.shared.signOut()
            updateUI()
        } catch {
            print("Çıkış yapılırken hata oluştu: \(error)")
        }
    }
}
