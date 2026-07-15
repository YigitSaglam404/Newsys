//
//  ViewController.swift
//  Newsys
//
//  Created by Yiğit Sağlam on 12.07.2026.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var articles: [Article] = []
    private let newsService = NewsService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Newsys"
        collectionView.dataSource = self
        collectionView.delegate = self
        loadNews()
    }

    private func loadNews() {
            Task {
                do {
                    let fetchedArticles = try await newsService.fetchTopHeadlines()
                    articles = fetchedArticles
                    collectionView.reloadData()
                } catch {
                    print("Hata oluştu: \(error)")
                }
            }
        }
    }

    extension ViewController: UICollectionViewDataSource {
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return articles.count
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsCell", for: indexPath) as? NewsCell else {
                return UICollectionViewCell()
            }
            let article = articles[indexPath.item]
            cell.configure(with: article)
            return cell
        }
    }

    extension ViewController: UICollectionViewDelegateFlowLayout {
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width = collectionView.frame.width - 16
            return CGSize(width: width, height: 220)
        }

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        }

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 16
        }
}
    extension ViewController: UICollectionViewDelegate {
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            collectionView.deselectItem(at: indexPath, animated: true)

            let selectedArticle = articles[indexPath.item]

            guard let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else {
                return
            }

            detailVC.article = selectedArticle
            navigationController?.pushViewController(detailVC, animated: true)
        }
}
