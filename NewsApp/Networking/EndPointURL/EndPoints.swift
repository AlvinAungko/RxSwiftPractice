//
//  EndPoints.swift
//  NewsApp
//
//  Created by Aung Ko Ko on 23/09/2022.
//

import Foundation
import Alamofire

public enum Endpoint
{
    case articles(query:String,from:String,to:String,sortBy:String)
    case headlines(country:String,category:String)
    
    
    private var baseURL:String
    {
        return Constants.baseUrlForApple
    }
    
    private var path:String {
        switch self {
            
        case .articles(_, _,_,_):
            return "/everything"
        case.headlines(_, _):
            return "/top-headlines"
        }
    }
    
    
    private var apiKey:String
    {
        return Constants.apiKey
    }
    
    private var url:URL {
        let urlComponent = NSURLComponents(string: self.baseURL.appending(self.path))
        if (urlComponent?.queryItems == nil) {
            urlComponent?.queryItems = []
        }
        
        switch self {
            
        case .articles(let query,let from,let to,let sortBy):
            urlComponent?.queryItems?.append(URLQueryItem(name: "q", value: query))
            urlComponent?.queryItems?.append(URLQueryItem(name: "from", value: from))
            urlComponent?.queryItems?.append(URLQueryItem(name: "to", value: to))
            urlComponent?.queryItems?.append(URLQueryItem(name: "sortBy", value: sortBy))
            urlComponent?.queryItems?.append(URLQueryItem(name: "apiKey", value: self.apiKey))
            
        case.headlines(let country, let category):
            urlComponent?.queryItems?.append(URLQueryItem(name: "country", value: country))
            urlComponent?.queryItems?.append(URLQueryItem(name: "category", value: category))
            urlComponent?.queryItems?.append(URLQueryItem(name: "apiKey", value: Constants.apiKey))
        }
        
        return (urlComponent?.url!)!
       
    }
}

extension Endpoint:URLConvertible
{
    public func asURL() throws -> URL {
        return self.url
    }
}
