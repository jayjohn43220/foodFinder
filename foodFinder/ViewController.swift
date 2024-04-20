//
//  ViewController.swift
//  foodFinder
//
//  Created by Jayden John on 4/20/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var beefTap: UITapGestureRecognizer!
    @IBOutlet var chickenTap: UITapGestureRecognizer!
    @IBOutlet var lambTap: UITapGestureRecognizer!
    @IBOutlet var porkTap: UITapGestureRecognizer!
    @IBOutlet var seafoodTap: UITapGestureRecognizer!
    @IBOutlet var veganTap: UITapGestureRecognizer!
    @IBOutlet var vegetarianTap: UITapGestureRecognizer!
    var categoryChosen = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

    }


    @IBAction func beefTapped(_ sender: Any) {
    categoryChosen = "beef"
        print("Beef button tapped")
        self.performSegue(withIdentifier: "toCategorySegue", sender: beefTap)
        
    }
    
    @IBAction func chickenTapped(_ sender: Any) {
        print("Chicken button tapped")
        self.performSegue(withIdentifier: "toCategorySegue", sender: chickenTap)
    }
    
    @IBAction func lambTapped(_ sender: Any) {
        print("Lamb button tapped")
        self.performSegue(withIdentifier: "toCategorySegue", sender: lambTap)
    }
    
    @IBAction func porkTapped(_ sender: Any) {
        print("Pork button tapped")
        self.performSegue(withIdentifier: "toCategorySegue", sender: porkTap)

    }
    
    @IBAction func seafoodTapped(_ sender: Any) {
        print("Seafood button tapped")
        self.performSegue(withIdentifier: "toCategorySegue", sender: seafoodTap)

    }
    
    @IBAction func veganTapped(_ sender: Any) {
        print("Vegan button tapped")
        self.performSegue(withIdentifier: "toCategorySegue", sender: veganTap)
        
    }
    
    @IBAction func vegetarianTapped(_ sender: Any) {
        print("Vegetarian button tapped")
        self.performSegue(withIdentifier: "toCategorySegue", sender: vegetarianTap)

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCategorySegue" {
            // Ensure the destination view controller is of type categoryViewController
            guard let categoryVC = segue.destination as? categoryViewController else {
                return
            }
            
            // Check the sender to determine which button was tapped
            if let senderButton = sender as? UITapGestureRecognizer {
                if senderButton == beefTap {
                    categoryVC.category = "Beef"
                } else if senderButton == chickenTap {
                    categoryVC.category = "Chicken"
                } else if senderButton == lambTap {
                    categoryVC.category = "Lamb"
                } else if senderButton == porkTap {
                    categoryVC.category = "Pork"
                } else if senderButton == seafoodTap {
                    categoryVC.category = "Seafood"
                } else if senderButton == veganTap {
                    categoryVC.category = "Vegan"
                } else if senderButton == vegetarianTap {
                    categoryVC.category = "Vegetarian"
                }
            }
        }
    }
}




