//
//  FirebasePractice.swift
//  NewsApp
//
//  Created by Aung Ko Ko on 02/10/2022.
//

import Foundation
import FirebaseFirestore
import FirebaseCore

final class FireBasePractice:BaseRepository {
    static let shared = FireBasePractice()
    private var ref:DocumentReference?
    
    private override init() {
        super.init()
//        addANewDocumentToFireStore()
    }
    
    func addANewDocumentToFireStore()
    {
        let dummyDictionary:Dictionary<String,Any> = ["Name":"Alvin","age":"21"]
        db.collection("Users").document("Alvin").setData(dummyDictionary) {
            guard let error = $0 else {
                return
            }
            debugPrint(error.localizedDescription)
        }
    }
    
    func retrieveDocumentsFromFireStore()
    {
        let docRef = db.collection("Dummy").document("User")
        docRef.getDocument { (doc,error) in
            guard let document = doc, document.exists,error == nil else {
                debugPrint("No Document Found")
                return
            }
            
            guard let response = document.data() else {
                return
            }
            
            response.forEach { (key,value) in
                debugPrint("\(key) : \(value)")
            }
        }
    }
    
}
