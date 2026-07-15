//
//  DetailViewController.swift
//  Newsys
//
//  Created by Yiğit Sağlam on 15.07.2026.
//

import UIKit
import SafariServices

class DetailViewController: UIViewController {
    
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    
    var article: Article?


    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()

        // Do any additional setup after loading the view.
    }
    private func configureView() {
            guard let article = article else { return }

            titleLabel.text = article.title
            title = article.source.name
        
            descriptionLabel.text = buildDescriptionText(from: article)
        
            guard let imageUrlString = article.urlToImage,
                  let imageUrl = URL(string: imageUrlString) else {
                return
            }

            URLSession.shared.dataTask(with: imageUrl) { [weak self] data, _, _ in
                guard let data = data, let image = UIImage(data: data) else { return }
                DispatchQueue.main.async {
                    self?.articleImageView.image = image
                }
            }.resume()
        }
    
    private func buildDescriptionText(from article: Article) -> String {
        var combinedText = article.description ?? ""

        if let content = article.content {
            let cleanedContent = removeCharCountSuffix(from: content)
            if !cleanedContent.isEmpty {
                combinedText += "\n\n" + cleanedContent
            }
        }

        return combinedText
    }

    private func removeCharCountSuffix(from text: String) -> String {
        guard let range = text.range(of: "[+", options: .backwards) else {
            return text
        }
        return String(text[..<range.lowerBound]).trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    @IBAction func readMoreTapped(_ sender: Any) {
        guard let article = article,
                      let url = URL(string: article.url) else {
                    return
    }
        let safariVC = SFSafariViewController(url: url)
                present(safariVC, animated: true)
    }

    

}
