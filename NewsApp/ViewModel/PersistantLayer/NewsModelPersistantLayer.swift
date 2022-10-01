//
//  ArticleRealMModeLayer.swift
//  NewsApp
//
//  Created by Aung Ko Ko on 30/09/2022.
//

import Foundation

protocol ArticlePersistanceLayerProtocol
{
    
    //MARK: To Do
    func saveArticles(news:NewsDataResponse)
    func getArticlesFromLocalDatabase(completion:@escaping(Response<NewsDataResponse>)->Void)
}

final class ArticlePersistanceLayer:BaseRepository,ArticlePersistanceLayerProtocol
{
    static let shared = ArticlePersistanceLayer()
    
    private override init() {
        super.init()
    }
    
    func saveArticles(news:NewsDataResponse) {
        
        let newsObject = NewsObject()
        
        let newsArticle = news.saveNews(realM: realM, newsObject: newsObject)
        
        guard let newsArticle = newsArticle else {
            return
        }
        
        do {
            try realM.write({
                realM.add(newsArticle, update: .modified)
            })
        } catch {
            debugPrint(error.localizedDescription)
        }
        
    }
    
    func getArticlesFromLocalDatabase(completion: @escaping (Response<NewsDataResponse>) -> Void) {
        let news:Array<NewsDataResponse> = realM.objects(NewsObject.self).map {
            $0.toNewsDataResponse()
        }
        guard let firstArticle = news.first else {
            return
        }
        
        completion(.success(firstArticle))
        
    }
    
}
