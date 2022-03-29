//
//  ViewController.swift
//  MyFavoriteList
//
//  Created by Caner Çağrı on 29.03.2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(rightbarTapped))
    }
    
    @objc func rightbarTapped() {
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }


}

