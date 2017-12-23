//
//  ViewController.swift
//  UpcomingMovies
//
//  Created by Abdullah Althobetey on 04/12/2017.
//  Copyright © 2017 Abdullah Althobetey. All rights reserved.
//

import UIKit
import CoreData

class UpcomingMoviesViewController: UIViewController
{
    // MARK: Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Properties
    
    let cdStack = CoreDataStack.shared
    let context = CoreDataStack.shared.persistentContainer.viewContext
    var userMovies = [UserMovie]()
    
    // MARK: ViewController Methods
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        cdStack.delegate = self

        let fetchRequest = UserMovie.fetchRequest() as NSFetchRequest<UserMovie>
        let sort = NSSortDescriptor(key: #keyPath(UserMovie.releaseDate), ascending: true)
        fetchRequest.sortDescriptors = [sort]
        do
        {
            userMovies = try context.fetch(fetchRequest)
            tableView.reloadData()
        }
        catch
        {
            showAlert(title: "Error", message: error.localizedDescription)
        }
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow
        {
            tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "MovieListToMovieDetail"
        {
            let movieDetailVC = segue.destination as! MovieDetailViewController
            movieDetailVC.userMovie = sender as! UserMovie
            movieDetailVC.delegate = self
        }
    }
    
    // MARK: Helper Methods
    
    private func setCellPosterImage(cell: UpcomingMovieTableViewCell, path: String)
    {
        DispatchQueue.global(qos: .userInitiated).async {
            
            TheMovieDBAPIManager.downloadMoviePoster(size: .small, path: path, completion: { (posterImage) in
                
                cell.posterImageView.image = posterImage
            })
        }
    }
    
    private func performDeletingUserMovie(at index: Int)
    {
        let movieToDelete = userMovies.remove(at: index)
        context.delete(movieToDelete)
        cdStack.saveContext()
        tableView.deleteRows(at: [IndexPath(row: index, section: 0)] , with: .automatic)
    }

    // MARK: Actions
    
    @IBAction func goToSettings(_ sender: UIBarButtonItem)
    {
    }
}

// MARK: MovieDetailDelegate

extension UpcomingMoviesViewController: MovieDetialDelegate
{
    func deleteUserMovie(_ movie: UserMovie)
    {
        if let index = userMovies.index(of: movie)
        {
            performDeletingUserMovie(at: index)
        }
    }
}

// MARK: UITableDataSource

extension UpcomingMoviesViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return userMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UpcomingMovieCell", for: indexPath) as! UpcomingMovieTableViewCell
        let movie = userMovies[indexPath.row]
        cell.movieNameLabel.text = movie.title
        cell.releaseDateLabel.text = movie.prettyDateString
        setCellPosterImage(cell: cell, path: movie.posterPath)
        
        let daysUntilRelease = movie.daysUntilRelease
        if daysUntilRelease > 0
        {
            cell.countDownBackgroundView.backgroundColor = UIColor.flatDarkBlue
            cell.untilOrSinceLabel.text = "days until"
            cell.countdownLabel.text = "\(daysUntilRelease)"
        }
        else if daysUntilRelease == 0
        {
            cell.countDownBackgroundView.backgroundColor = UIColor.flatGreen
            cell.countdownLabel.text = "Today!"
            cell.countDownLabelTopConstraint.constant = 20
            cell.untilOrSinceLabel.isHidden = true 
        }
        else if daysUntilRelease < 0
        {
            cell.countDownBackgroundView.backgroundColor = UIColor.flatRed
            cell.untilOrSinceLabel.text = "days since"
            cell.countdownLabel.text = "\( abs(Int32(daysUntilRelease)) )"
        }
        
        return cell
    }
}

// MARK: UITableViewDelegate

extension UpcomingMoviesViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let movie = userMovies[indexPath.row]
        performSegue(withIdentifier: "MovieListToMovieDetail", sender: movie)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            performDeletingUserMovie(at: indexPath.row)
        }
    }
}

// MARK: CoreDataStackDelegate

extension UpcomingMoviesViewController: CoreDataStackDelegate
{
    func errorLoadingPersistentContainer(error: NSError)
    {
        showAlert(title: "Error loadin data", message: error.localizedDescription)
    }
    
    func errorSaving(error: NSError)
    {
        showAlert(title: "Error saving data", message: error.localizedDescription)
    }
}




































