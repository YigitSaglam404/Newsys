//
//  NewsCell.swift
//  Newsys
//
//  Created by Yiğit Sağlam on 13.07.2026.
//

import UIKit

class NewsCell: UICollectionViewCell {
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupAppearance()
    }
    
    func configure(with article: Article) {
            titleLabel.text = article.title

            guard let imageUrlString = article.urlToImage,
                  let imageUrl = URL(string: imageUrlString) else {
                articleImageView.image = nil
                return
            }

            URLSession.shared.dataTask(with: imageUrl) { [weak self] data, _, _ in
                guard let data = data, let image = UIImage(data: data) else { return }
                DispatchQueue.main.async {
                    self?.articleImageView.image = image
                }
            }.resume()
        
            sourceLabel.text = article.source.name.uppercased()
        
        }
    
    private func setupAppearance() {
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .white

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 8
        layer.masksToBounds = false

        articleImageView.layer.cornerRadius = 12
        articleImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        articleImageView.clipsToBounds = true
        articleImageView.contentMode = .scaleAspectFill
    }
}
