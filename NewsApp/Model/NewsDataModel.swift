//
//  NewsDataModel.swift
//  NewsApp
//
//  Created by Aung Ko Ko on 23/09/2022.
//

import Foundation

struct NewsDataResponse:Codable
{
    let status:String?
    let totalResults:Int?
    let articles:[Article]?
    
    enum CodingKeys:String,CodingKey
    {
        case status
        case totalResults,articles
    }
}

struct Source:Codable
{
    let id,name:String?
    
    enum CodingKeys:String,CodingKey
    {
        case id,name
    }
}

struct Article:Codable
{
    let source:Source?
    let author:String?
    let title:String?
    let description:String?
    let url:URL?
    let urlToImage:URL?
    let publishedAt:String?
    let content:String?
    
    enum CodingKeys:String,CodingKey
    {
        case author,title,description,url,urlToImage,
        publishedAt,content,source
        
    }
}
