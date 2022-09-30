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
    
    let networkingAgent = NetworkingAgent.shared
    
    private init() {}
    
    func fetchNewsFromAPI<T>(networkCall: NewsNetwork, decoder: T.Type, completion: @escaping (Response<T>) -> Void) where T : Decodable, T : Encodable {
        
        switch networkCall {
        case .appleWebsite(let query, let from, let to, let sortBy):
            NewsModelLayer.shared.fetchNewsFromAPI(networkCall: .appleWebsite(query: query, from: from, to: to, sortBy: sortBy), decoder: NewsDataResponse.self) {
                switch $0
                {
                case.success(let appleNews):
                    debugPrint(appleNews.articles?.count ?? 0)
                case.failure(let errorMessage):
                    debugPrint(errorMessage)
                }
            }
        case .topHeadLines(let country, let category):
            NewsModelLayer.shared.fetchNewsFromAPI(networkCall: .topHeadLines(country: country, category: category), decoder: NewsDataResponse.self) {
                switch $0
                {
                case.success(let topHeadLines):
                    debugPrint(topHeadLines.articles?.count ?? 0)
                case.failure(let errorMessage):
                    debugPrint(errorMessage)
                }
            }
        }
        
    }
    
    
}
