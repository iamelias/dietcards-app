//
//  HomeViewController.swift
//  DietCards
//
//  Created by Elias Hall on 11/15/19.
//  Copyright © 2019 Elias Hall. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    var selectedCard = 8 //default card setting
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        
       // collectionView.contentOffset = CGPoint(x: 300.0, y: 0.0)
//        let w = UIScreen.main.bounds.width
//        let t = collectionView.bounds.maxX
//        let v = collectionView.
//        let h = UIScreen.main.bounds.height
//
//
//        collectionView.contentOffset = CGPoint(x: t, y: 0)
//

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
    
    
    //MARK: CELL DEFINITION
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let data = HomeViewController.daysOfWeek
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
        
        cell.configureCell(data[indexPath.row])
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "pushDetailView", sender: indexPath.row) //segue to CardTableViewController

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pushDetailView" { //segue used pushes to collectionView

            if segue.destination is CardTableViewController
            {
                let vc = segue.destination as? CardTableViewController //seguing to CardTableViewController
                vc?.selectedCard = sender as! Int //passing user selected day card as digit 0-6(Mon-Sun)
            }
        }
    }
}

