//
//  NewsArticlesCollectionViewCell.swift
//  NewsApp
//
//  Created by Aung Ko Ko on 24/09/2022.
//

import UIKit

class NewsArticlesCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "NewsArticlesCollectionViewCell"
    
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
    }
    
    required init?(coder: NSCoder) {
       fatalError()
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
        
    }
}
