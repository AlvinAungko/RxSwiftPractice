//
//  RealMObjects.swift
//  NewsApp
//
//  Created by Aung Ko Ko on 29/09/2022.
//

import Foundation
import RealmSwift

class NewsObject : Object
{
    
    @Persisted var status:String?
    @Persisted var totalResults:Int?
    @Persisted var listOfArticles:List<ArticleObject>
   
}

class ArticleObject : Object {
    
    @Persisted var source:SourceObject
    @Persisted var author:String?
    @Persisted var title:String?
    @Persisted var articleDescription:String?
    @Persisted var url:String?
    @Persisted var urlToImage:String?
    @Persisted var publishedAt:String?
    @Persisted var content:String?
    
}

class SourceObject : Object
{
    @Persisted var id:Int?
    @Persisted var name:String?
}

