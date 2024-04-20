//
//  launchViewController.swift
//  foodFinder
//
//  Created by Jayden John on 4/20/24.
//

import UIKit

class launchViewController: UIViewController {
    @IBOutlet weak var logoImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logoImage.frame.origin.y = -logoImage.frame.size.height

        self.view.backgroundColor = UIColor(hue: 0.656, saturation: 0.787, brightness: 0.354, alpha: 1)

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.logoImage.frame.origin.y = 200.0
        self.logoImage.alpha = 0.0

        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseInOut, animations: {
            // Set the final position for the logoImage
            self.logoImage.frame.origin.y = 300.0
            
            // Set the final transparency (opacity) for the logoImage
            self.logoImage.alpha = 1.0
        }, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.performSegue(withIdentifier: "toHomeSegue", sender: nil)
       }
    }


//    override func performSegue(withIdentifier identifier: String, sender: Any?) {
//        performSegue(withIdentifier: "toHomeSegue", sender: nil)
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
