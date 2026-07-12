//
//  ViewController.swift
//  Newsys
//
//  Created by Yiğit Sağlam on 12.07.2026.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        testFetchNews()
    }

    private func testFetchNews() {
        Task {
            do {
                let service = NewsService()
                let articles = try await service.fetchTopHeadlines()
                print("Toplam \(articles.count) haber geldi")
                for article in articles {
                    print("- \(article.title)")
                }
            } catch {
                print("Hata oluştu: \(error)")
            }
        }
    }
}

