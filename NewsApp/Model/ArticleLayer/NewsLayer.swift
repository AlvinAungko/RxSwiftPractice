//
//  ArticleModelLayer.swift
//  NewsApp
//
//  Created by Aung Ko Ko on 30/09/2022.
//

import Foundation

protocol NewsModelLayerProtocol
{
    func getNewsFromNewsModelLayer(completion:@escaping(Response<Article>)->Void)
}

struct NewsModelLayer:NewsNetworkProtocol,NewsModelLayerProtocol {
    
    private let networkingAgent = NetworkingAgent.shared
    static let shared = NewsModelLayer()
    
    private init() {}
    
    func fetchNewsFromAPI<T>(networkCall: NewsNetwork, decoder: T.Type, completion: @escaping (Response<T>) -> Void) where T : Decodable, T : Encodable {
        
        switch networkCall
        {
            case .appleWebsite(let query, let from, let to, let sortBy):
            self.networkingAgent.fetchNewsFromAPI(networkCall: .appleWebsite(query: query, from: from, to: to, sortBy: sortBy), decoder: decoder) {
                switch $0
                {
                case.success(let data):
                    completion(.success(data))
                case.failure(let errorMessage):
                    completion(.failure(errorMessage))
                }
            }
        case .topHeadLines(let country, let category):
            self.networkingAgent.fetchNewsFromAPI(networkCall: .topHeadLines(country: country, category: category), decoder: decoder) {
                switch $0 {
                case.success(let data):
                    completion(.success(data))
                case.failure(let errorMessage):
                    debugPrint(errorMessage)
                }
            }
        }
        
    }
    
    func getNewsFromNewsModelLayer(completion: @escaping (Response<Article>) -> Void) {
        debugPrint("To Do")
    }
}
