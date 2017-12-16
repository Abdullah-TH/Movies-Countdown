//
//  MovieDetailViewController.swift
//  UpcomingMovies
//
//  Created by Abdullah Althobetey on 04/12/2017.
//  Copyright © 2017 Abdullah Althobetey. All rights reserved.
//

import UIKit

enum CountdownPosition
{
    case top
    case bottom
}

class MovieDetailViewController: UIViewController
{
    // MARK: Outlets
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var countdownStackView: UIStackView!
    @IBOutlet weak var yearsLabel: UILabel!
    @IBOutlet weak var monthsLabel: UILabel!
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var secondsLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var toolbar: UIToolbar!
    
    // MARK: Properties
    
    var movie: Movie!
    var timer = Timer()
    var countdownStackViewCurrentConstraints = [NSLayoutConstraint]()
    var countdownPosition = CountdownPosition.bottom
    
    // MARK: ViewController Methods
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            
            self.updateCountdownComponents()
        }
        
        setupUI()
        view.addSubview(countdownStackView)
        setupCountdownStackViewConstraints()
    }
    
    // MARK: Helper Methods
    
    private func setupUI()
    {
        navigationItem.title = movie.title
        releaseDateLabel.text = "\(movie.allreadyReleased ? "Released" : "Releasing") \(movie.prettyDateString)"
        setPosterImage()
    }
    
    private func setupCountdownStackViewConstraints()
    {
        countdownStackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.removeConstraints(countdownStackViewCurrentConstraints)
        countdownStackViewCurrentConstraints.removeAll()
        
        let leadingConst = NSLayoutConstraint(item: countdownStackView,
                                              attribute: .leading,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .leading,
                                              multiplier: 1,
                                              constant: 0)
        
        let trailingConst = NSLayoutConstraint(item: countdownStackView,
                                               attribute: .trailing,
                                               relatedBy: .equal,
                                               toItem: view,
                                               attribute: .trailing,
                                               multiplier: 1,
                                               constant: 0)
        
        let bottomConst = NSLayoutConstraint(item: countdownStackView,
                                             attribute: countdownPosition == .bottom ? .bottom : .top,
                                             relatedBy: .equal,
                                             toItem: countdownPosition == .bottom ? toolbar : view.safeAreaLayoutGuide,
                                             attribute: .top,
                                             multiplier: 1,
                                             constant: 0)
        
        leadingConst.isActive = true
        trailingConst.isActive = true
        bottomConst.isActive = true
        
        countdownStackViewCurrentConstraints.append(contentsOf: [leadingConst, trailingConst, bottomConst])
        
        // Rearrange the stackview
        let secondViewInStack = countdownStackView.arrangedSubviews[1]
        countdownStackView.insertArrangedSubview(secondViewInStack, at: 0)
    }
    
    private func updateCountdownComponents()
    {
        if let countdownComponents = movie.countdownComponents
        {
            yearsLabel.text = countdownComponents.years
            monthsLabel.text = countdownComponents.months
            daysLabel.text = countdownComponents.days
            hoursLabel.text = countdownComponents.hours
            minutesLabel.text = countdownComponents.minutes
            secondsLabel.text = countdownComponents.seconds
        }
        else
        {
            timer.invalidate() // movie allready released, no need to run the timer
        }
    }
    
    private func setPosterImage()
    {
        DispatchQueue.global(qos: .userInitiated).async {
            
            TheMovieDBAPIManager.downloadMoviePoster(size: .large, path: self.movie.posterPath, completion: { (posterImage) in
                
                self.backgroundImageView.image = posterImage
            })
        }
    }
    
    // MARK: Actions
    
    @IBAction func shareMovie(_ sender: UIBarButtonItem)
    {
    }
    
    @IBAction func deleteMovie(_ sender: UIBarButtonItem)
    {
    }
    
    @IBAction func toggleCountdownPosition(_ sender: UIBarButtonItem)
    {
        countdownPosition = countdownPosition == .bottom ? .top : .bottom
        
        UIView.animate(withDuration: 0.2) {
            self.setupCountdownStackViewConstraints()
        }
    }
}





