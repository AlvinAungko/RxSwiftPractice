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
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
}

extension HeadLineTableViewCell:UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listOfArticles?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}

extension HeadLineTableViewCell
{
    public func setArticles(articles:Array<Article>)
    {
        self.listOfArticles = articles
    }
}
