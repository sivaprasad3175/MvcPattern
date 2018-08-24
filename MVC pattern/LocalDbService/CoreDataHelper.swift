//
//  CoreDataHelper.swift
//  MVC pattern
//
//  Created by siva prasad on 24/08/18.
//  Copyright © 2018 SIVA PRASAD. All rights reserved.
//

import CoreData
import UIKit



class CoreDataHelper {
    
    
    func Savedata(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext

        let userEntity = NSEntityDescription.entity(forEntityName: "mvcdb", in: managedContext)!
        
        let user = NSManagedObject(entity: userEntity, insertInto: managedContext)
//        user.setValue("", forKey: <#T##String#>)

        do {
            try managedContext.save()
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }



    }
    

}



