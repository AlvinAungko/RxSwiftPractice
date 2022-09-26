//
//  HeadLineTableViewCell.swift
//  NewsApp
//
//  Created by Aung Ko Ko on 24/09/2022.
//

import UIKit

class HeadLineTableViewCell: UITableViewCell {
    
    static let identifier = "HeadLineTableViewCell"
    private var listOfArticles:Array<Article>?
    {
        didSet {
            if let _ = listOfArticles
            {
                self.collectionView.reloadData()
            }
        }
    }
    
    private let collectionView:UICollectionView = {
        let customLayout = UICollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: customLayout)
        collectionView.register(NewsArticlesCollectionViewCell.self, forCellWithReuseIdentifier: NewsArticlesCollectionViewCell.identifier)
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setDataSourceAndDelegate()
        contentView.addSubview(self.collectionView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    private func setDataSourceAndDelegate()
    {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
}

extension HeadLineTableViewCell:UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listOfArticles?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeReusableCells(identifier: NewsArticlesCollectionViewCell.identifier, indexPath: indexPath) as NewsArticlesCollectionViewCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 0, height: 0)
    }
}

extension HeadLineTableViewCell
{
    public func setArticles(articles:Array<Article>)
    {
        self.listOfArticles = articles
    }
}
