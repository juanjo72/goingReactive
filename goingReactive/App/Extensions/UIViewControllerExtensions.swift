//
//  UIViewControllerExtensions.swift
//  goingReactive
//
//  Created by Juanjo García Villaescusa on 25/2/18.
//  Copyright © 2018 Juanjo García Villaescusa. All rights reserved.
//

import UIKit

extension UIViewController {
    func display(error: LocalizedError) {
        let alert = UIAlertController(title: "Error", message: error.errorDescription, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { action in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
