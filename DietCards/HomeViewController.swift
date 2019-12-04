//
//  HomeViewController.swift
//  DietCards
//
//  Created by Elias Hall on 11/15/19.
//  Copyright © 2019 Elias Hall. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    var selectedCard = 8 //default card(doesn't exist)
    
    var retrievedCalSum = 0.0
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var homeTitleLabel: UILabel!
    
    enum Days: String {
        case Monday
        case Tuesday
        case Wednesday
        case Thursday
        case Friday
        case Saturday
        case Sunday
    }
    
    
    static let daysOfWeek: [String] = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.locale = Locale(identifier: "en_US")
        homeTitleLabel.text = dateFormatter.string(from: Date())
        homeTitleLabel.textColor = .black
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("Home View Will Appear Called")
    }
    
    @IBAction func dayButtonTapped(_ sender: Any) {
                
        collectionView.contentOffset = CGPoint(x: 50.0, y: 0.0)
        let button = sender as! UIButton
        print("Button: \(button.tag) was pressed")
        collectionView.reloadData()
        
        switch button.tag { //positions when day button is tapped
        case 1: collectionView.contentOffset = CGPoint(x: 0.0, y: 0.0)
        case 2: collectionView.contentOffset = CGPoint(x: 150.0, y: 0.0)
        case 3: collectionView.contentOffset = CGPoint(x: 385.0, y: 0.0)
        case 4: collectionView.contentOffset = CGPoint(x: 625.0, y: 0.0)
        case 5: collectionView.contentOffset = CGPoint(x: 830.0, y: 0.0)
        case 6: collectionView.contentOffset = CGPoint(x: 1075.0, y: 0.0)
        case 7: collectionView.contentOffset = CGPoint(x: 1360.0, y: 0.0)
        default:
            collectionView.contentOffset = CGPoint(x: 0.0, y: 0.0)
        }
    }
}

//MARK: * Collection View Code *

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let data = HomeViewController.daysOfWeek
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
                
        //cell.configureCell(with: Data[indexPath.row])
        
        cell.configureCell(data[indexPath.row])
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "pushDetailView", sender: indexPath.row)
        
//        let selectedCardID = indexPath.row //getting a selectedcard. 1'st card's ID is 0. Now I need to pass that selectedCardID to tableViewController so it can be saved as a property. Maybe I need to create a card object and assign it a selectedCardID and a total nutrition ID for display on card.
//        print("selected card: \(selectedCardID)")
//        self.selectedCard = selectedCardID
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pushDetailView" { //segue used pushes to collectionView
            
           // let testObject = CardData()
            
            
            if segue.destination is CardTableViewController
            {
                let vc = segue.destination as? CardTableViewController
                vc?.selectedCard = sender as! Int
            }
        }
    }
}

