//
//  ViewModel.swift
//  NewsApp
//
//  Created by Aung Ko Ko on 23/09/2022.
//

import Foundation

final class HomeViewModel:BaseRepository,NewsNetworkProtocol
{
    public static let shared = HomeViewModel()
    
    let newsModelLayer = NewsModelLayer.shared
    let articlePersistantLayer = ArticlePersistanceLayer.shared
    let contentPersistanceLayer = ContentTypeRepository.shared
    
    private override init() {
        super.init()
    }
    
    func fetchNewsFromAPI<T>(networkCall: NewsNetwork, decoder: T.Type, completion: @escaping (Response<T>) -> Void) where T: Decodable, T : Encodable {
        
        switch networkCall {
        case .appleWebsite(let query, let from, let to, let sortBy):
            
            guard let listOfNewsDataInDataBase = realM.objects(NewsObject.self).first else {
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
            
            completion(.success(listOfNewsDataInDataBase.toNewsDataResponse() as! T))
            
        case .topHeadLines(let country, let category):
            
            
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
        }
        
    }
    
    
}
