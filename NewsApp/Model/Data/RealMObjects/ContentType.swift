//
//  ContentType.swift
//  NewsApp
//
//  Created by Aung Ko Ko on 02/10/2022.
//

import Foundation
import RealmSwift

class ContentTypeObject:Object
{
    @Persisted(primaryKey: true)
    var name:String
    
    @Persisted
    var newsObject:NewsObject?
    
}
