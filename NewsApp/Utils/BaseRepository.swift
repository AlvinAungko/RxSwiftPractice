//
//  BaseRepository.swift
//  NewsApp
//
//  Created by Aung Ko Ko on 30/09/2022.
//

import Foundation
import RealmSwift

open class BaseRepository:NSObject
{

   public let realM = try!Realm()
    
    override init() {
        super.init()
        debugPrint(realM.configuration.fileURL?.absoluteString ?? "undefined")
    }
}
