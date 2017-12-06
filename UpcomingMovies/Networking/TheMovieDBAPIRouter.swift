//
//  TheMovieDBAPIRouter.swift
//  UpcomingMovies
//
//  Created by Abdullah Althobetey on 05/12/2017.
//  Copyright © 2017 Abdullah Althobetey. All rights reserved.
//

import Foundation

enum TheMovieDBAPIRouter
{
    // Possible requests
    case discoverMovies
    case discoverUpcomingMovies(page: Int, minReleaseDate: String)
    case getGenres
    
    // Base endpoint
    static let baseURLString = "https://api.themoviedb.org/3"
    
    // Set the method
    var method: String {
        
        switch self
        {
        case .discoverMovies, .discoverUpcomingMovies, .getGenres:
            return "GET"
        }
    }
    
    // Relative path
    var relativePath: String {
        switch self
        {
        case .discoverMovies, .discoverUpcomingMovies:
            return "/discover/movie"
        case .getGenres:
            return "/genre/movie/list"
        }
    }
    
    // Set up URL parameters (query items)
    var queryItems: [URLQueryItem] {
        
        var queryItems = [URLQueryItem]()
        queryItems.append(URLQueryItem(name: "api_key", value: "ae0291cad240b8e220d7190cb488fb57"))
        
        switch self
        {
        case .discoverUpcomingMovies(page: let page, minReleaseDate: let minReleaseDate):
            queryItems.append(URLQueryItem(name: "language", value: "en"))
            queryItems.append(URLQueryItem(name: "sort_by", value: "primary_release_date.asc"))
            queryItems.append(URLQueryItem(name: "page", value: "\(page)"))
            queryItems.append(URLQueryItem(name: "primary_release_date.gte", value: "\(minReleaseDate)"))
        default:
            break
        }
        
        return queryItems
    }
    
    // Set up HTTP request body parameters
    var parameters: [String: Any]? {
        switch self
        {
        default:
            return nil
        }
    }
    
    // Set up HTTP request headers
    var headers: [String: String]?
    {
        return [
            "content-type": "application/json"
        ]
    }
    
    // Construct the request from url, method and parameters
    public func asURLRequest() -> URLRequest
    {
        // Construct the URL
        var urlComponents = URLComponents(string: TheMovieDBAPIRouter.baseURLString)
        urlComponents?.queryItems = queryItems
        var url = urlComponents?.url
        url?.appendPathComponent(relativePath)
        
        // Create request
        var request = URLRequest(url: url!)
        
        // Set httpMethod
        request.httpMethod = method
        
        // Set URL qury items
        
        
        // If there are HTTP body parameters, and they can be converted to data, set httpBody
        if let parameters = parameters
        {
            if let parametersData = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            {
                request.httpBody = parametersData
            }
        }
        
        // Set headers
        if let headers = headers
        {
            request.allHTTPHeaderFields = headers
        }
        
        return request
    }

}








