//
//  Movie.swift
//  UpcomingMovies
//
//  Created by Abdullah Althobetey on 05/12/2017.
//  Copyright © 2017 Abdullah Althobetey. All rights reserved.
//

import Foundation

struct Movie
{
    var id: Int
    var title: String
    var posterPath: String
    var genreIDs: [Int]
    var overview: String
    var releaseDateString: String 
}
