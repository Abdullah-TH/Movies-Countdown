//
//  Movie.swift
//  UpcomingMovies
//
//  Created by Abdullah Althobetey on 05/12/2017.
//  Copyright © 2017 Abdullah Althobetey. All rights reserved.
//

import UIKit

struct Movie
{
    var id: Int
    var title: String
    var posterPath: String
    var genres: [String]
    var overview: String
    var releaseDateString: String
    
    var releaseDate: Date? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: releaseDateString)
    }
}








