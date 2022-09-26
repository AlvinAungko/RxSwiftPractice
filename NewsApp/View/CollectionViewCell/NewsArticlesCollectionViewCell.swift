//
//  NewsArticlesCollectionViewCell.swift
//  NewsApp
//
//  Created by Aung Ko Ko on 24/09/2022.
//

import UIKit

class NewsArticlesCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "NewsArticlesCollectionViewCell"
    
    private let newsTitle:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        label.textColor = .white
        return label
    }()
    
    
    
    private var article:Article?
    {
        didSet
        {
            if let data = article
            {
                self.setArticleToCollectionViewCell(article: data)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.newsTitle)
    }
    
    required init?(coder: NSCoder) {
       fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
}

extension NewsArticlesCollectionViewCell
{
    public func getArticle(article:Article)
    {
        self.article = article
    }
    
    private func setArticleToCollectionViewCell(article:Article)
    {
        self.newsTitle.text = article.title ?? ""
        
    }
}
