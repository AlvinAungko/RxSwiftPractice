//
//  DummyObjects.swift
//  NewsApp
//
//  Created by Aung Ko Ko on 25/09/2022.
//

import Foundation

final class DummyObjects
{
    private var name:String?
    public var tag: Tag
    
    init(name:String,tag:Tag)
    {
        self.name = name
        self.tag = tag
        
    }
    
    public func getName() -> String
    {
        return self.name ?? ""
    }
    
    public func getTag() -> Tag
    {
        return self.tag
    }
}

enum Tag {
    case simpleTag (tag:String)
    case advanceTag (tag:String,advanceTag:String)
}
