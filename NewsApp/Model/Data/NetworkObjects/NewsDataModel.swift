//
//  NewsDataModel.swift
//  NewsApp
//
//  Created by Aung Ko Ko on 23/09/2022.
//

import Foundation
import RealmSwift


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
    
    public func saveNews(realM:Realm,newsObject:NewsObject) -> NewsObject? {
        
        newsObject.totalResults = self.totalResults ?? 0
        newsObject.status = self.status ?? ""
        guard let articles = self.articles else {
            return nil
        }
        
        newsObject.listOfArticles.append(objectsIn: articles.map({
            $0.toArticleObject(realM: realM)
        }))
        
        return newsObject
    }
    
    public func toNewsObject(realM:Realm) -> NewsObject?
    {
        guard let articles = articles else {
            return nil
        }

        
        let newsObject = NewsObject()
        newsObject.totalResults = self.totalResults ?? 0
        newsObject.status = self.status ?? "undefined"
        newsObject.listOfArticles.append(objectsIn:articles.map({
            $0.toArticleObject(realM: realM)
        }))
        return newsObject
    }
    
}

struct Article:Codable {
    
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
    
    public func toArticleObject(realM:Realm) -> ArticleObject
    {
        let articleObject = ArticleObject()
        
        articleObject.source = (self.source?.toSourceObject(realM: realM))!
        articleObject.title = self.title ?? "undefined"
        articleObject.author = self.author ?? "undefined"
        articleObject.articleDescription = self.description ?? "undefined"
        articleObject.publishedAt = self.publishedAt ?? "undefined"
        articleObject.content = self.content ?? ""
        articleObject.url = self.url?.absoluteString ?? "undefined"
        articleObject.urlToImage = self.urlToImage?.absoluteString ?? "undefined"
        
        return articleObject
    }
}

struct Source:Codable
{
    let id,name:String?
    
    enum CodingKeys:String,CodingKey
    {
        case id,name
    }
    
    public func toSourceObject(realM:Realm) -> SourceObject
    {
        let sourceObject = SourceObject()
        
        sourceObject.id = self.id ?? "undefined"
        sourceObject.name = self.name ?? "undefined"
        
        return sourceObject
    }
}
