//
//  recipeViewController.swift
//  foodFinder
//
//  Created by Jayden John on 4/20/24.
//

import UIKit

struct MealsResponse: Codable {
    let meals: [Meal]
}

struct Meal: Codable {
    let strMeal: String
    let strMealThumb: String
    let idMeal: String
}

class categoryViewController: UIViewController {
    
    @IBOutlet weak var categoryChosenLabel: UILabel!
    var category = ""
    var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryChosenLabel.text = category
        print("Category: " + category)
        
        // Create and configure UIScrollView
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Fetch meals data from API
        guard let url = URL(string: "https://www.themealdb.com/api/json/v1/1/filter.php?c=" + category) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching data: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            // JSON response into MealsResponse
            do {
                let decoder = JSONDecoder()
                let mealsResponse = try decoder.decode(MealsResponse.self, from: data)
                print(mealsResponse)
                DispatchQueue.main.async {
                    self.createMealViews(mealsResponse.meals)
                }
                
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }
    
    func createMealViews(_ meals: [Meal]) {
        let mealViewHeight: CGFloat = 150 // Height of each meal view
        let scrollViewContentWidth = UIScreen.main.bounds.width - 40 // Width of the scrollView's content area
        
        var currentY: CGFloat = 50 // Initial y-coordinate for the first meal view
        
        // Loop through meals array to create meal views
        for meal in meals {
            // Create a section/part view for each meal
            let mealContainerView = UIView()
            mealContainerView.translatesAutoresizingMaskIntoConstraints = false
            mealContainerView.backgroundColor = .lightGray
            mealContainerView.layer.cornerRadius = 8
            scrollView.addSubview(mealContainerView)
            
            NSLayoutConstraint.activate([
                mealContainerView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: currentY),
                mealContainerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
                mealContainerView.widthAnchor.constraint(equalToConstant: scrollViewContentWidth), // Set container width
                mealContainerView.heightAnchor.constraint(equalToConstant: mealViewHeight)
            ])
            
            // Create label to display meal name
            let nameLabel = UILabel()
            nameLabel.translatesAutoresizingMaskIntoConstraints = false
            nameLabel.text = meal.strMeal
            nameLabel.textAlignment = .center
            nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
            mealContainerView.addSubview(nameLabel)
            
            NSLayoutConstraint.activate([
                nameLabel.topAnchor.constraint(equalTo: mealContainerView.topAnchor, constant: 20),
                nameLabel.leadingAnchor.constraint(equalTo: mealContainerView.leadingAnchor, constant: 20),
                nameLabel.trailingAnchor.constraint(equalTo: mealContainerView.trailingAnchor, constant: -20),
                nameLabel.bottomAnchor.constraint(equalTo: mealContainerView.bottomAnchor, constant: -20) // Constrain within the container view
            ])
            // Create UIImageView to display meal thumbnail
            let thumbnailImageView = UIImageView()
            thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
            thumbnailImageView.contentMode = .scaleAspectFit
            
            // Load and display image from URL
            if let imageUrl = URL(string: meal.strMealThumb) {
                URLSession.shared.dataTask(with: imageUrl) { data, response, error in
                    if let error = error {
                        print("Error loading image: \(error)")
                        return
                    }
                    
                    guard let imageData = data else {
                        print("No image data received")
                        return
                    }
                    
                    
                    // Create UIImage from imageData on the main thread
                    DispatchQueue.main.async {
                        if let image = UIImage(data: imageData) {
                            thumbnailImageView.image = image
                        } else {
                            print("Failed to create UIImage from data")
                        }
                        

                        
                        // Add thumbnailImageView to mealContainerView and set constraints
                        mealContainerView.addSubview(thumbnailImageView)
                        
                        NSLayoutConstraint.activate([
                            thumbnailImageView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
                            thumbnailImageView.leadingAnchor.constraint(equalTo: mealContainerView.leadingAnchor, constant: 20),
                            thumbnailImageView.trailingAnchor.constraint(equalTo: mealContainerView.trailingAnchor, constant: -20),
                            thumbnailImageView.bottomAnchor.constraint(equalTo: mealContainerView.bottomAnchor, constant: -20)
                        ])
                        
                        // Debug: Print mealContainerView frame after adding subviews
                        print("Meal container view frame: \(mealContainerView.frame)")
                    }
                }.resume()
            } else {
                print("Invalid image URL: \(meal.strMealThumb)")
            }
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(mealContainerTapped(_:)))
            mealContainerView.addGestureRecognizer(tapGesture)
            
            // Update currentY for the next meal view
            currentY += mealViewHeight + 20 // Add spacing between meal views
        }
        
        // Set content size of the scroll view based on the last meal container view
        scrollView.contentSize = CGSize(width: scrollViewContentWidth, height: currentY + 20)
    }
    @objc func mealContainerTapped(_ sender: UITapGestureRecognizer) {
        guard let mealContainerView = sender.view else { return }
        
        // Get the meal name from the tapped meal container
        if let nameLabel = mealContainerView.subviews.compactMap({ $0 as? UILabel }).first {
            let mealName = nameLabel.text ?? ""
            print("Tapped Meal Name: \(mealName)")
            
            // Perform segue to recipeViewController and pass the mealName
            performSegue(withIdentifier: "toRecipeSegue", sender: mealName)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRecipeSegue" {
            if let destinationVC = segue.destination as? recipeViewController {
                if let mealName = sender as? String {
                    destinationVC.selectedMealName = mealName
                }
            }
        }
    }
}
