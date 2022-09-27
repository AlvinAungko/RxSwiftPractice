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
        let customLayout = UICollectionViewFlowLayout()
        customLayout.minimumLineSpacing = 30
        customLayout.itemSize = CGSize(width: UIScreen.main.bounds.width/1.5 - 15, height: 250)
        customLayout.scrollDirection = .horizontal
        customLayout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: customLayout)
        collectionView.register(NewsArticlesCollectionViewCell.self, forCellWithReuseIdentifier: NewsArticlesCollectionViewCell.identifier)
        collectionView.backgroundColor = UIColor(named: "BackgroundColor")
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setDataSourceAndDelegate()
        contentView.addSubview(self.collectionView)
        guard let color = UIColor(named: "BackgroundColor") else {
            debugPrint("No Color")
            return
        }
        
        self.contentView.backgroundColor = color
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
        
    }
    
}

extension HeadLineTableViewCell:UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        debugPrint(listOfArticles?.count ?? 0)
        return listOfArticles?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = self.collectionView.dequeReusableCells(identifier: NewsArticlesCollectionViewCell.identifier, indexPath: indexPath) as NewsArticlesCollectionViewCell
        
        guard let listOfArticles = self.listOfArticles else {
            debugPrint("Empty Cell")
            return UICollectionViewCell()
        }
        
        cell.getArticle(article: listOfArticles[indexPath.row])
        
        return cell
    }
    
    
}

extension HeadLineTableViewCell
{
    public func setArticles(articles:Array<Article>)
    {
        self.listOfArticles = articles
    }
}
