//
//  TopicsViewController.swift
//  WHealth
//
//  Created by Jovito Royeca on 12.10.18.
//  Copyright © 2018 Jovito Royeca. All rights reserved.
//

import UIKit
import MBProgressHUD

class TopicsViewController: UIViewController {
    // MARK: Variables
    let viewModel = TopicsViewModel()
    
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        viewModel.fetchData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if viewModel.isEmpty() {
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(self.json2CoreDataDone(_:)),
                                                   name: Notification.Name(Notifications.JSON2CoreDataDone),
                                                   object: nil)
            MBProgressHUD.showAdded(to: self.view, animated: true)
            CoreDataAPI.sharedInstance.json2CoreData()
        }
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "showDetails" {
//            guard let dest = segue.destination as? DetailsViewController,
//                let company = sender as? Company else {
//                    return
//            }
//
//            dest.viewModel = DetailsViewModel(withCompany: company)
//        }
    }
    
    // MARK: Notifications handler
    @objc func json2CoreDataDone(_ notification: Notification) {
        viewModel.fetchData()
        MBProgressHUD.hide(for: self.view, animated: true)
        tableView.reloadData()
        NotificationCenter.default.removeObserver(self,
                                                  name: Notification.Name(Notifications.JSON2CoreDataDone),
                                                  object: nil)
    }
}

// MARK: UITableViewDataSource
extension TopicsViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(inSection: section)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",
                                                       for: indexPath)
        let topic = viewModel.object(forRowAt: indexPath)
        
        cell.textLabel?.text = topic.name
        return cell
    }
}

// MARK: UITableViewDelegate
extension TopicsViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let topic = viewModel.object(forRowAt: indexPath)
        performSegue(withIdentifier: "showDetails", sender: topic)
    }
}

