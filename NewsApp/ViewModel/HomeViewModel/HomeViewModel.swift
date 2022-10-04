//
//  ViewModel.swift
//  NewsApp
//
//  Created by Aung Ko Ko on 23/09/2022.
//

import Foundation

protocol HomeViewModelProtcol
{
    func fetchNewsFromHomeViewModel<T:Codable>(networkCall:NewsNetwork,completion:@escaping(Response<T>)->Void)
}

final class HomeViewModel:BaseRepository,NewsNetworkProtocol
{
    public static let shared = HomeViewModel()
    
    let newsModelLayer = NewsModelLayer.shared
    let articlePersistantLayer = ArticlePersistanceLayer.shared
    let contentPersistanceLayer = ContentTypeRepository.shared
    let networkingAgentShared = NetworkingAgent.shared
    
    private override init() {
        super.init()
    }
    
    func fetchNewsFromAPI<T>(networkCall: NewsNetwork, decoder: T.Type, completion: @escaping (Response<T>) -> Void) where T: Decodable, T : Encodable {
        
        switch networkCall {
        case .appleWebsite(let query, let from, let to, let sortBy):
            
            guard let appleNews = realM.object(ofType: ContentTypeObject.self, forPrimaryKey: ContentTypeMapper.apple.rawValue) else {
                newsModelLayer.fetchNewsFromAPI(networkCall: .appleWebsite(query: query, from: from, to: to, sortBy: sortBy), decoder: NewsDataResponse.self) { [weak self] in
                    
                    guard let self = self else { return }
                    switch $0
                    {
                    case.success(let appleNews):
                        //                    debugPrint("Total apple news => \(appleNews.totalResults ?? 0)")
                        self.contentPersistanceLayer.saveContentTypeWithAssociatedNewsObject(contentType: .apple, newsResponse: appleNews)
                        self.contentPersistanceLayer.getNewsFromLocalDatabase(content: .apple) {
                            switch $0
                            {
                            case.success(let appleNews):
                                guard let appleNews = appleNews as? T else {
                                    return
                                }
                                
                                completion(.success(appleNews))
                                
                            case.failure(let errorMessage):
                                completion(.failure(errorMessage))
                            }
                        }
                    case.failure(let errorMessage):
                        debugPrint(errorMessage)
                    }
                    
                }
                return
            }
            
            completion(.success(appleNews.newsObject?.toNewsDataResponse() as! T))
            
        case .topHeadLines(let country, let category):
            
            guard let topHeadLines = realM.object(ofType: ContentTypeObject.self, forPrimaryKey: ContentTypeMapper.topHeadLines.rawValue) else {
                newsModelLayer.fetchNewsFromAPI(networkCall: .topHeadLines(country: country, category: category), decoder: NewsDataResponse.self) {
                    switch $0
                    {
                    case.success(let topHeadLines):
                        self.contentPersistanceLayer.saveContentTypeWithAssociatedNewsObject(contentType: .topHeadLines, newsResponse: topHeadLines)
                        self.contentPersistanceLayer.getNewsFromLocalDatabase(content: .topHeadLines) {
                            switch $0
                            {
                            case.success(let topHeadLines):
                                guard let topHeadLines = topHeadLines as? T else {
                                    return
                                }
                                
                                completion(.success(topHeadLines))
                                
                            case.failure(let errorMessage):
                                completion(.failure(errorMessage))
                            }
                        }
                    case.failure(let errorMessage):
                        debugPrint(errorMessage)
                    }
                }
                return
            }
            
            completion(.success(topHeadLines.newsObject?.toNewsDataResponse() as! T))
            
        }
        
    }
    
    
}

extension HomeViewModel:HomeViewModelProtcol
{
    func fetchNewsFromHomeViewModel<T>(networkCall: NewsNetwork, completion: @escaping (Response<T>) -> Void) where T : Decodable, T : Encodable {
        switch networkCall {
        case .appleWebsite(let query, let from, let to, let sortBy):
            guard let data = realM.object(ofType: ContentTypeObject.self, forPrimaryKey: ContentTypeMapper.apple.rawValue) else {
                networkingAgentShared.fetchNewsFromAPI(networkCall: .appleWebsite(query: query, from: from, to: to, sortBy: sortBy), decoder: NewsDataResponse.self) {
                    switch $0 {
                    case.success(let newsDataResponse):
                        completion(.success(newsDataResponse as! T))
                    case.failure(let errorMessage):
                        completion(.failure(errorMessage))
                    }
                }
                return
            }
            guard let newsArticle = data.newsObject?.toNewsDataResponse() as? T else {
                return
            }
            completion(.success(newsArticle))
        case .topHeadLines(let country, let category):
            guard let newsArticle = realM.object(ofType: ContentTypeObject.self, forPrimaryKey: ContentTypeMapper.topHeadLines.rawValue) else {
                self.networkingAgentShared.fetchNewsFromAPI(networkCall: .topHeadLines(country: country, category: category), decoder: NewsDataResponse.self) {
                    switch $0 {
                    case.success(let newsDataResponse):
                        guard let topHeadLines = newsDataResponse as? T else {
                            return
                        }
                        completion(.success(topHeadLines))
                    case.failure(let errorMessage):
                        completion(.failure(errorMessage))
                    }
                }
                return
            }
            guard let topHeadLines = newsArticle.newsObject?.toNewsDataResponse() as? T else {
                return
            }
            
            completion(.success(topHeadLines))
        }
    }
}
