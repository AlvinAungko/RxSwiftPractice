//
//  BaseRepository.swift
//  NewsApp
//
//  Created by Aung Ko Ko on 30/09/2022.
//

import Foundation
import RealmSwift
import FirebaseFirestore

open class BaseRepository:NSObject
{

   public let realM = try!Realm()
   public let db = Firestore.firestore()
    
    override init() {
        super.init()
        debugPrint(realM.configuration.fileURL?.absoluteString ?? "undefined")
    }
}
