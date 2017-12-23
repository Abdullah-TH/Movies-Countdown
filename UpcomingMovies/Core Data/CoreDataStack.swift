//
//  CoreDataStack.swift
//  UpcomingMovies
//
//  Created by Abdullah Althobetey on 22/12/2017.
//  Copyright © 2017 Abdullah Althobetey. All rights reserved.
//

import Foundation
import CoreData

protocol CoreDataStackDelegate
{
    func errorLoadingPersistentContainer(error: NSError)
    func errorSaving(error: NSError)
}

class CoreDataStack
{
    static let shared = CoreDataStack()
    
    var delegate: CoreDataStackDelegate?
    
    private init()
    {
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "UpcomingMovies")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            
            if let error = error as NSError?
            {
                self.delegate?.errorLoadingPersistentContainer(error: error)
            }
        })
        
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext ()
    {
        let context = persistentContainer.viewContext
        if context.hasChanges
        {
            do
            {
                try context.save()
            }
            catch
            {
                let nsError = error as NSError
                delegate?.errorSaving(error: nsError)
            }
        }
    }
}

























