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

protocol MovieDetialDelegate
{
    func deleteUserMovie(_ movie: UserMovie)
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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: Properties
    
    var delegate: MovieDetialDelegate?
    var userMovie: UserMovie!
    var timer = Timer()
    var countdownStackViewCurrentConstraints = [NSLayoutConstraint]()
    let cdStack = CoreDataStack.shared
    
    // MARK: Computed Properties
    
    var countdownPosition: CountdownPosition {
        return userMovie.isCountdownBottom ? .bottom : .top
    }
    
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
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        cdStack.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "MovieDetailToMovieInfo"
        {
            let movieInfoVC = segue.destination as! MovieInfoViewController
            movieInfoVC.userMovie = userMovie
        }
    }
    
    // MARK: Helper Methods
    
    private func setupUI()
    {
        navigationItem.title = userMovie.title
        releaseDateLabel.text = "\(userMovie.allreadyReleased ? "Released" : "Releasing") \(userMovie.prettyDateString)"
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
        if let countdownComponents = userMovie.countdownComponents
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
        if let largePosterData = userMovie.largePoster
        {
            let posterImage = UIImage(data: largePosterData as Data)
            backgroundImageView.image = posterImage
        }
        else
        {
            activityIndicator.startAnimating()
            
            DispatchQueue.global(qos: .userInitiated).async {
                
                TheMovieDBAPIManager.downloadMoviePoster(size: .large, path: self.userMovie.posterPath, completion: { (posterImage) in
                    
                    self.userMovie.largePoster = UIImagePNGRepresentation(posterImage!) as NSData?
                    self.cdStack.saveContext()
                    self.backgroundImageView.image = posterImage
                    self.activityIndicator.stopAnimating()
                })
            }
        }
    }
    
    private func generateMovieWithCountdownImage() -> UIImage
    {
        // Hide toolbar and navigation bar
        navigationController?.navigationBar.isHidden = true
        toolbar.isHidden = true
        
        // Render view to an image
        
        let scale = UIScreen.main.scale
        let imageSize = CGSize(width: view.frame.size.width * scale, height: view.frame.size.height * scale)
        
        UIGraphicsBeginImageContextWithOptions(imageSize, view.isOpaque, scale)
        view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
        let movieWithCountdownImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Crop top empty space
        
        let heightToCrop = 64 * scale // points of navigation bar (44) + status bar (20) = (64)
        let  croppedImage = cropImage(imageToCrop: movieWithCountdownImage,
                                      toRect: CGRect(x: 0,
                                                     y: heightToCrop, // points of navigation bar (44) + status bar (20) = (64)
                                                     width: movieWithCountdownImage.size.width,
                                                     height: movieWithCountdownImage.size.height - heightToCrop))
        
        // Show toolbar and navbar
        navigationController?.navigationBar.isHidden = false
        toolbar.isHidden = false
        
        return croppedImage
    }
    
    func cropImage(imageToCrop:UIImage, toRect rect:CGRect) -> UIImage
    {
        let imageRef:CGImage = imageToCrop.cgImage!.cropping(to: rect)!
        let cropped:UIImage = UIImage(cgImage:imageRef)
        return cropped
    }
    
    // MARK: Actions
    
    @IBAction func shareMovie(_ sender: UIBarButtonItem)
    {
        let movieImage = generateMovieWithCountdownImage()
        let activityVC = UIActivityViewController(activityItems: [movieImage], applicationActivities: nil)
        
        activityVC.completionWithItemsHandler = { (activityType: UIActivityType?, completed: Bool, returnedItems: [Any]?, activityError: Error?) in
            
            if completed
            {
                self.dismiss(animated: true, completion: nil)
            }
            
        }
        
        present(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func deleteMovie(_ sender: UIBarButtonItem)
    {
        delegate?.deleteUserMovie(userMovie)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func toggleCountdownPosition(_ sender: UIBarButtonItem)
    {
        userMovie.isCountdownBottom = !userMovie.isCountdownBottom
        cdStack.saveContext()
        
        UIView.animate(withDuration: 0.2) {
            self.setupCountdownStackViewConstraints()
        }
    }
}

extension MovieDetailViewController: CoreDataStackDelegate
{
    func errorSaving(error: NSError)
    {
        showAlert(title: "Error saving data", message: error.localizedDescription)
    }
    
    func errorLoadingPersistentContainer(error: NSError)
    {
        showAlert(title: "Error loading data", message: error.localizedDescription)
    }
}










































