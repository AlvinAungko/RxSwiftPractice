//
//  ViewModel.swift
//  NewsApp
//
//  Created by Aung Ko Ko on 23/09/2022.
//

import Foundation

final class HomeViewModel:NewsNetworkProtocol
{
    public static let shared = HomeViewModel()
    
    let newsModelLayer = NewsModelLayer.shared
    let articlePersistantLayer = ArticlePersistanceLayer.shared
    
    private init() {}
    
    func fetchNewsFromAPI<T>(networkCall: NewsNetwork, decoder: T.Type, completion: @escaping (Response<T>) -> Void) where T: Decodable, T : Encodable {
        
        switch networkCall {
        case .appleWebsite(let query, let from, let to, let sortBy):
            newsModelLayer.fetchNewsFromAPI(networkCall: .appleWebsite(query: query, from: from, to: to, sortBy: sortBy), decoder: NewsDataResponse.self) { [weak self] in
                
                guard let self = self else { return }
                switch $0
                {
                case.success(let appleNews):
                    guard let listOfAppleArticles = appleNews.articles else {
                        return
                    }
                    self.articlePersistantLayer.saveArticles(articles: listOfAppleArticles)
                    
                case.failure(let errorMessage):
                    debugPrint(errorMessage)
                }
            }
        case .topHeadLines(let country, let category):
            newsModelLayer.fetchNewsFromAPI(networkCall: .topHeadLines(country: country, category: category), decoder: NewsDataResponse.self) {
                switch $0
                {
                case.success(let topHeadLines):
                    guard let listOfHeadLineArticles = topHeadLines.articles else {
                        return
                    }
                    self.articlePersistantLayer.saveArticles(articles: listOfHeadLineArticles)
                    
                case.failure(let errorMessage):
                    debugPrint(errorMessage)
                }
            }
        }
        
    }
    
    
}
