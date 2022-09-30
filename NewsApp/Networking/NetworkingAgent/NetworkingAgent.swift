//
//  NetworkingAgent.swift
//  NewsApp
//
//  Created by Aung Ko Ko on 23/09/2022.
//

import Foundation
import Alamofire

enum NewsNetwork
{
    case appleWebsite(query:String,from:String,to:String,sortBy:String)
    case topHeadLines(country:String,category:String)
}

enum Response<T:Codable>
{
    case success(T)
    case failure(String)
}

protocol NewsNetworkProtocol
{
    func fetchNewsFromAPI<T:Codable>(networkCall:NewsNetwork,decoder:T.Type,completion:@escaping(Response<T>)->Void)
    
}


final class NetworkingAgent:NewsNetworkProtocol
{
    
    static let shared = NetworkingAgent()
    
    private init() {}
    
    func fetchNewsFromAPI<T>(networkCall:NewsNetwork,decoder: T.Type, completion: @escaping (Response<T>) -> Void) where T : Decodable, T : Encodable {
        
        switch networkCall
        {
        case .appleWebsite(let query, let from, let to, let sortBy):
            AF.request(Endpoint.articles(query: query, from: from, to: to,sortBy:sortBy )).responseDecodable(of:decoder){
                guard let response = $0.response else {return}
                let codeSuccessRange = 200..<300
                if codeSuccessRange.contains(response.statusCode)
                {
                    switch $0.result
                    {
                    case.success(let listOfApple):completion(.success(listOfApple))
                    case.failure(let error):completion(.failure(error.localizedDescription))
                    }
                } else {
                    completion(.failure("The code returns with \(response.statusCode)"))
                }
            }
            
        case.topHeadLines(let country, let category):
            AF.request(Endpoint.headlines(country: country, category: category)).responseDecodable(of:decoder){
                guard let response = $0.response else {
                    return
                }
                let codeSuccessRange = 200..<300
                if codeSuccessRange.contains(response.statusCode)
                {
                    switch $0.result
                    {
                    case.success(let topHeadLinesResponse):
                        completion(.success(topHeadLinesResponse))
                    case.failure(let error):
                        completion(.failure(error.localizedDescription))
                    }
                } else {
                    completion(.failure("The code returns with \(response.statusCode)"))
                }
            }
            
            
        }
        
    }
}
