//
//  UIViewControllerExtension.swift
//  UpcomingMovies
//
//  Created by Abdullah Althobetey on 23/12/2017.
//  Copyright © 2017 Abdullah Althobetey. All rights reserved.
//

import UIKit

extension UIViewController
{
    func showAlert(title: String, message: String?)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
