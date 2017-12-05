//
//  TheMovieDBAPIManager.swift
//  UpcomingMovies
//
//  Created by Abdullah Althobetey on 05/12/2017.
//  Copyright © 2017 Abdullah Althobetey. All rights reserved.
//

import Foundation

class TheMovieDBAPIManager
{
    static func printRequestResult()
    {
        let request = TheMovieDBAPIRouter.discoverUpcomingMovies(page: 40, minReleaseDate: "2017-12-01").asURLRequest()
        print(request.url!.absoluteString)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            print(error ?? "No error")
            let statusCode = (response as! HTTPURLResponse).statusCode
            print("Status Code: \(statusCode)")
            let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments)
            print(json ?? "error parsing")
        }.resume()
    }
    
    static func getUpcomingMovies(page: Int, minReleaseDate: String, completion: @escaping (_ errorMessage: String?, _ movies: [Movie]?) -> Void)
    {
        let request = TheMovieDBAPIRouter.discoverUpcomingMovies(page: page, minReleaseDate: minReleaseDate).asURLRequest()
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            var movies = [Movie]()
            
            guard error == nil else
            {
                completion(error!.localizedDescription, nil)
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode == 200 else
            {
                completion("Got status code: \((response as! HTTPURLResponse).statusCode)", nil)
                return
            }
            
            guard let data = data else
            {
                completion("No data returned", nil)
                return
            }
            
            guard let json = try? JSONSerialization.jsonObject(with: data, options: []) else
            {
                completion("Cannot parse JSON", nil)
                return
            }
            
            guard let jsonDictionary = json as? [String: Any] else
            {
                completion("Cannot convert JSON to Foundation object [String: Any]", nil)
                return
            }
            
            guard let resultArray = jsonDictionary["results"] as? [[String: Any]] else
            {
                completion("Cannot find the results key", nil)
                return
            }
            
            for result in resultArray
            {
                if let id = result["id"] as? Int,
                   let title = result["title"] as? String,
                   let posterPath = result["poster_path"] as? String,
                   let genreIDs = result["genre_ids"] as? [Int],
                   let overview = result["overview"] as? String,
                   let releaseDateString = result["release_date"] as? String
                {
                    let movie = Movie(id: id, title: title, posterPath: posterPath, genreIDs: genreIDs, overview: overview, releaseDateString: releaseDateString)
                    movies.append(movie)
                }
            }
            
            completion(nil, movies)
        }
        
        task.resume()
    }
}













