//
//  RealMObjects.swift
//  NewsApp
//
//  Created by Aung Ko Ko on 29/09/2022.
//

import Foundation
import RealmSwift

//MARK: 

class NewsObject : Object
{
    @Persisted(primaryKey: true) var newsID:UUID
    @Persisted var status:String?
    @Persisted var totalResults:Int?
    @Persisted var listOfArticles:List<ArticleObject>
    
    public func toNewsDataResponse() -> NewsDataResponse
    {
        return NewsDataResponse(status: self.status, totalResults: self.totalResults, articles: self.listOfArticles.map({
            $0.convertToArticle()
        }))
    }
   
}

class ArticleObject : Object {
    
    @Persisted(primaryKey: true) var articeID: UUID
    @Persisted var source:SourceObject?
    @Persisted var author:String?
    @Persisted var title:String?
    @Persisted var articleDescription:String?
    @Persisted var url:String?
    @Persisted var urlToImage:String?
    @Persisted var publishedAt:String?
    @Persisted var content:String?
    @Persisted(originProperty: "listOfArticles") var relatedNews: LinkingObjects<NewsObject>
    
    public func convertToArticle() -> Article
    {
        
        return Article(source: source!.convertToSource(), author: self.author, title: self.title, description: self.articleDescription, url: URL(string: "\(self.url ?? "undefined")"), urlToImage: URL(string: "\(self.urlToImage ?? "undefined")"), publishedAt: self.publishedAt, content: self.content)
    }
    
}

class SourceObject : Object
{
    @Persisted(primaryKey: true) var id:String?
    @Persisted var name:String?
    @Persisted(originProperty: "source") var article:LinkingObjects<ArticleObject>
    
    public func convertToSource() -> Source
    {
        return Source(id: self.id ?? "undefined", name: self.name ?? "undefined")
    }
}

