//
//  recipeViewController.swift
//  foodFinder
//
//  Created by Jayden John on 4/20/24.
//

import UIKit
import SafariServices
struct APIResponse: Codable {
    let meals: [APIMeal]
}

struct APIMeal: Codable {
    let idMeal: String
    let strMeal: String
    let strInstructions: String
    let strMealThumb: String
    let strIngredient1: String?
    let strIngredient2: String?
    let strIngredient3: String?
    let strIngredient4: String?
    let strIngredient5: String?
    let strIngredient6: String?
    let strIngredient7: String?
    let strIngredient8: String?
    let strIngredient9: String?
    let strIngredient10: String?
    let strIngredient11: String?
    let strIngredient12: String?
    let strIngredient13: String?
    let strIngredient14: String?
    let strIngredient15: String?
    let strIngredient16: String?
    let strIngredient17: String?
    let strIngredient18: String?
    let strIngredient19: String?
    let strIngredient20: String?
    let strMeasure1: String?
    let strMeasure2: String?
    let strMeasure3: String?
    let strMeasure4: String?
    let strMeasure5: String?
    let strMeasure6: String?
    let strMeasure7: String?
    let strMeasure8: String?
    let strMeasure9: String?
    let strMeasure10: String?
    let strMeasure11: String?
    let strMeasure12: String?
    let strMeasure13: String?
    let strMeasure14: String?
    let strMeasure15: String?
    let strMeasure16: String?
    let strMeasure17: String?
    let strMeasure18: String?
    let strMeasure19: String?
    let strMeasure20: String?
    let strYoutube: String?
    
}


class recipeViewController: UIViewController {
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var chosenMealLabel: UILabel!
    @IBOutlet weak var ingredientLabel: UILabel!
    var selectedMealName = ""
    var youtubeLink = ""
    var imageLink = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        chosenMealLabel.text = selectedMealName
        // Call the API and fetch data
        let apiUrl = "https://www.themealdb.com/api/json/v1/1/search.php?s=" + selectedMealName
        guard let url = URL(string: apiUrl) else {
            print("Invalid API URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                    if let error = error {
                        print("Error fetching data: \(error)")
                        return
                    }
                    
                    guard let data = data else {
                        print("No data received")
                        return
                    }
                    
                    // Parse JSON data into APIResponse
                    do {
                        let decoder = JSONDecoder()
                        let apiResponse = try decoder.decode(APIResponse.self, from: data)
                        
                        if let apiMeal = apiResponse.meals.first {
                            // Extract relevant information from the meal
                            let instructions = apiMeal.strInstructions
                            
                            var ingredients: [String] = []
                            var measures: [String] = []
                            
                            self?.imageLink = apiMeal.strMealThumb
                            self?.youtubeLink = apiMeal.strYoutube!
                            let mirror = Mirror(reflecting: apiMeal)
                            
                            for case let (label?, value) in mirror.children {
                                if label.starts(with: "strIngredient"), let ingredient = value as? String, !ingredient.isEmpty {
                                    ingredients.append(ingredient)
                                }
                                
                                if label.starts(with: "strMeasure"), let measure = value as? String {
                                    measures.append(measure)
                                }
                            }
                            
                            // Combine measures and ingredients into formatted strings
                            var ingredientLines: [String] = []
                            for (index, ingredient) in ingredients.enumerated() {
                                let measure = measures[index]
                                let ingredientLine = "\(measure) \(ingredient)"
                                ingredientLines.append(ingredientLine.trimmingCharacters(in: .whitespaces))
                            }
                            
                            // Update UI on the main thread
                            DispatchQueue.main.async {
                                self?.instructionsLabel.text = instructions
                                let formattedIngredients = ingredientLines.joined(separator: ", ")
                                self?.ingredientLabel.text = formattedIngredients
                            }
                            
                        } else {
                            print("No meal found")
                        }
                        
                    } catch {
                        print("Error decoding JSON: \(error)")
                    }
                    
                }.resume()
            }
    

    
    @IBAction func youtubeButton(_ sender: Any) {
        print("YouTube Button Tapped")
        let targetURL = URL(string: youtubeLink)!
        UIApplication.shared.open(targetURL, options: [:],completionHandler: nil)
    }
    
    
    @IBAction func imageButton(_ sender: Any) {
        print("Image Button Tapped")
        let targetURL = URL(string: imageLink)!
        let svc = SFSafariViewController(url: targetURL)
        present(svc, animated: true, completion: nil)
    }
}
