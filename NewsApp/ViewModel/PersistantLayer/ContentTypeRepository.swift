//
//  ContentTypeRepository.swift
//  NewsApp
//
//  Created by Aung Ko Ko on 02/10/2022.
//

import Foundation
import RealmSwift

enum ContentTypeMapper:String,CaseIterable{
    case apple = "apple"
    case topHeadLines = "topHeadLines"
}

protocol ContentRepositoryProtocol
{
    func saveContentTypeWithAssociatedNewsObject(contentType:ContentTypeMapper,newsResponse:NewsDataResponse)
    
    func getNewsFromLocalDatabase(content:ContentTypeMapper,completion:@escaping(Response<NewsDataResponse>)->Void)
}

final class ContentTypeRepository:BaseRepository
{
    static let shared = ContentTypeRepository()
    
    private override init() {
        super.init()
    }
}

extension ContentTypeRepository:ContentRepositoryProtocol
{
   
    func saveContentTypeWithAssociatedNewsObject(contentType: ContentTypeMapper, newsResponse: NewsDataResponse) {
        switch contentType {
        case .apple:
            let contentObject = ContentTypeObject()
            contentObject.name = contentType.rawValue
            contentObject.newsObject = newsResponse.toNewsObject(realM: realM)
            
            do {
                try realM.write {
                    realM.add(contentObject, update: .modified)
                }
            } catch {
                debugPrint(error.localizedDescription)
            }
           
        case .topHeadLines:
            let contentObject = ContentTypeObject()
            contentObject.name = contentType.rawValue
            contentObject.newsObject = newsResponse.toNewsObject(realM: realM)
            
            do {
                try realM.write({
                    realM.add(contentObject, update: .modified)
                })
            } catch {
                debugPrint(error.localizedDescription)
            }
            
        }
    }
    
    func getNewsFromLocalDatabase(content:ContentTypeMapper,completion: @escaping (Response<NewsDataResponse>) -> Void) {
        guard let contentObject = realM.object(ofType: ContentTypeObject.self, forPrimaryKey: content.rawValue) else {
            return
        }
        guard let newsObject = contentObject.newsObject else {
            return
        }
        
        completion(.success(newsObject.toNewsDataResponse()))
    }
}

