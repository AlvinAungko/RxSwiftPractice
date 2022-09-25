//
//  ViewModel.swift
//  NewsApp
//
//  Created by Aung Ko Ko on 23/09/2022.
//

import Foundation

final class HomeViewModel:MovieNetworkProtocol
{
    public static let shared = HomeViewModel()
    
    let networkingAgent = NetworkingAgent.shared
    
    private init() {}
    
    func fetchNewsFromAPI<T>(networkCall: NewsNetwork, decoder: T.Type, completion: @escaping (Response<T>) -> Void) where T : Decodable, T : Encodable {
        networkingAgent.fetchNewsFromAPI(networkCall: networkCall, decoder: decoder) {
            completion($0)
        }
    }
    
    
}
