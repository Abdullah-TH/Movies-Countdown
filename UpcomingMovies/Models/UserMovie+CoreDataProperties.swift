//
//  UserMovie+CoreDataProperties.swift
//  UpcomingMovies
//
//  Created by Abdullah Althobetey on 23/12/2017.
//  Copyright © 2017 Abdullah Althobetey. All rights reserved.
//
//

import Foundation
import CoreData


extension UserMovie
{
    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserMovie>
    {
        return NSFetchRequest<UserMovie>(entityName: "UserMovie")
    }

    @NSManaged public var id: Int32
    @NSManaged public var title: String
    @NSManaged public var posterPath: String
    @NSManaged public var genres: NSObject
    @NSManaged public var overview: String
    @NSManaged public var releaseDateString: String
    @NSManaged public var smallPoster: NSData?
    @NSManaged public var largePoster: NSData?
    @NSManaged public var isCountdownBottom: Bool

}
