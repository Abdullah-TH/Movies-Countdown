//
//  ViewController.swift
//  UpcomingMovies
//
//  Created by Abdullah Althobetey on 04/12/2017.
//  Copyright © 2017 Abdullah Althobetey. All rights reserved.
//

import UIKit

class UpcomingMoviesViewController: UIViewController
{
    // MARK: Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: ViewController Methods
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        tableView.reloadData()
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
    
    private func getPrettyDate(date: Date?) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        if let date = date
        {
            return dateFormatter.string(from: date)
        }
        
        return "Unknown"
    }
    
    private func getNumberOfDaysUntil(date: Date) -> Int
    {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        if today <= date
        {
            let differance = calendar.dateComponents([.day], from: today, to: date)
            return differance.day!
        }
        else // today > date
        {
            let differance = calendar.dateComponents([.day], from: date, to: today)
            return -differance.day!
        }
    }

    // MARK: Actions
    
    @IBAction func goToSettings(_ sender: UIBarButtonItem)
    {
    }
}

extension UpcomingMoviesViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return Movie.userMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UpcomingMovieCell", for: indexPath) as! UpcomingMovieTableViewCell
        let movie = Movie.userMovies[indexPath.row]
        cell.movieNameLabel.text = movie.title
        cell.releaseDateLabel.text = getPrettyDate(date: movie.releaseDate)
        setCellPosterImage(cell: cell, path: movie.posterPath)
        
        let daysUntilRelease = getNumberOfDaysUntil(date: movie.releaseDate!)
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
            cell.countdownLabel.text = "\(daysUntilRelease)"
        }
        
        return cell
    }
}

extension UpcomingMoviesViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 90
    }
}








