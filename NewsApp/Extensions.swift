//
//  Extensions.swift
//  NewsApp
//
//  Created by Aung Ko Ko on 24/09/2022.
//

import Foundation
import UIKit

extension UITableView
{
    public func dequeReusableCells<T:UITableViewCell>(identifier:String,indexPath:IndexPath)->T
    {
        guard let cell = dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? T else {
            return T()
        }
        
        return cell
    }
    
    public func registerCells<T:UITableViewCell>(cell:T.Type,identifier:String)
    {
        register(cell, forCellReuseIdentifier: identifier)
    }
}

extension UICollectionView
{
    public func dequeReusableCells<C:UICollectionViewCell>(identifier:String,indexPath:IndexPath)->C
    {
      guard let cell = dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? C else
        {
          return C()
        }
        
        return cell
        
    }
    
    public func registerCollectionViewCells<C:UICollectionViewCell>(cell:C.Type,identifier:String)
    {
        register(cell, forCellWithReuseIdentifier: identifier)
    }
}
