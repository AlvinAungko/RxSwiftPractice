//
//  ArticleRealMModeLayer.swift
//  NewsApp
//
//  Created by Aung Ko Ko on 30/09/2022.
//

import Foundation

protocol ArticlePersistanceLayerProtocol
{
    
    //MARK: To Do
    func saveArticles(articles:Array<Article>)
    func getArticlesFromLocalDatabase(completion:@escaping(Array<Article>)->Void)
}

struct ArticlePersistanceLayer:ArticlePersistanceLayerProtocol
{
    static let shared = ArticlePersistanceLayer()
    
    func saveArticles(articles: Array<Article>) {
        debugPrint("")
    }
    
    func getArticlesFromLocalDatabase(completion: @escaping (Array<Article>) -> Void) {
        debugPrint("")
    }
    
}
