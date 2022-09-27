//
//  NewsArticlesCollectionViewCell.swift
//  NewsApp
//
//  Created by Aung Ko Ko on 24/09/2022.
//

import UIKit

class NewsArticlesCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "NewsArticlesCollectionViewCell"
    
    private let stackView:UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.axis = .vertical
        stackView.distribution = .fill
        return stackView
    }()
    
    private let imageView:UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 15
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    
    private let newsTitle:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
       
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
        self.contentView.addSubview(self.stackView)
        self.stackView.addArrangedSubview(self.imageView)
        self.stackView.addArrangedSubview(self.newsTitle)
        roundAndAddShadowsToTheCorners()
    }
    
    required init?(coder: NSCoder) {
       fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        activateConstraints()
        
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
        self.newsTitle.text = article.title ?? "No Data from the server"
        self.imageView.image = UIImage(named: "Airpods")
        
    }
}

extension NewsArticlesCollectionViewCell
{
    private func activateConstraints()
    {
        self.stackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 0).isActive = true
        self.stackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        self.stackView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        self.stackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        self.imageView.heightAnchor.constraint(equalTo: self.stackView.heightAnchor, multiplier: 0.75).isActive = true
    }
    
    private func roundAndAddShadowsToTheCorners()
    {
        Utils.addShadowCorners(self.contentView)
    }
}


