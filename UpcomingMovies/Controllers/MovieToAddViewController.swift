//
//  MovieToAddViewController.swift
//  UpcomingMovies
//
//  Created by Abdullah Althobetey on 04/12/2017.
//  Copyright © 2017 Abdullah Althobetey. All rights reserved.
//

import UIKit

class MovieToAddViewController: UIViewController
{
    // MARK: Outlets
    
    @IBOutlet weak var moviePosterImageView: UIImageView!
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var movieGenresLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var overviewTextView: UITextView!
    @IBOutlet weak var posterActivityIndicator: UIActivityIndicatorView!
    
    // MARK: Properties
    
    var movie: Movie!
    let cdStack = CoreDataStack.shared
    let context = CoreDataStack.shared.persistentContainer.viewContext
    
    // MARK: ViewController Methods
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        movieGenresLabel.text = "" // to remove interface builder default text
        for genre in movie.genres
        {
            if movieGenresLabel.text == ""
            {
                movieGenresLabel.text?.append(genre)
            }
            else
            {
                movieGenresLabel.text?.append(" - \(genre)")
            }
        }
        
        movieNameLabel.text = movie.title
        releaseDateLabel.text = "Releasing " + movie.releaseDateString
        overviewTextView.text = movie.overview
        setMoviePosterImage(path: movie.posterPath)
        
        if overviewTextView.text == ""
        {
            overviewTextView.text = "No description available."
            overviewTextView.textColor = UIColor.gray
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        cdStack.delegate = self
    }
    
    // MARK: Helper Methods
    
    private func setMoviePosterImage(path: String)
    {
        posterActivityIndicator.startAnimating()
        DispatchQueue.global(qos: .background).async
        {
            TheMovieDBAPIManager.downloadMoviePoster(size: .large, path: self.movie.posterPath) { (posterImage) in
                
                self.moviePosterImageView.image = posterImage
                self.posterActivityIndicator.stopAnimating()
            }
        }
    }
    
    // MARK: Actions

    @IBAction func addMovie(_ sender: UIButton)
    {
        let userMovie = UserMovie(entity: UserMovie.entity(), insertInto: context)
        userMovie.id = Int32(movie.id)
        userMovie.title = movie.title
        userMovie.posterPath = movie.posterPath
        userMovie.genres = NSArray(array: movie.genres.map({ NSString(string: $0) }))
        userMovie.overview = movie.overview
        userMovie.releaseDate = movie.releaseDate
        userMovie.isCountdownBottom = true 
        
        cdStack.saveContext()
        
        let alertController = UIAlertController(title: nil, message: "\(movie.title) sucessfully added to your list!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension MovieToAddViewController: CoreDataStackDelegate
{
    func errorLoadingPersistentContainer(error: NSError)
    {
        showAlert(title: "Error loading data", message: error.localizedDescription)
    }
    
    func errorSaving(error: NSError)
    {
        showAlert(title: "Error saving data", message: error.localizedDescription)
    }
}

























