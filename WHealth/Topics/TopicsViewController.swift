//
//  TopicsViewController.swift
//  WHealth
//
//  Created by Jovito Royeca on 12.10.18.
//  Copyright © 2018 Jovito Royeca. All rights reserved.
//

import UIKit
import MBProgressHUD
import PromiseKit

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
            loadRemoteData()
        }
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTopicDetails" {
            guard let dest = segue.destination as? TopicViewController,
                let topic = sender as? Topic else {
                    return
            }

//            dest.viewModel = DetailsViewModel(withCompany: company)
        }
    }
    
    // MARK: Custom methods
    func loadRemoteData() {
        let webService = WebServiceAPI()
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        firstly {
            webService.fetchTopics()
        }.then { (topics: [[String: Any]]) in
            CoreDataAPI.sharedInstance.save(topics)
        }.done {
            self.viewModel.fetchData()
            MBProgressHUD.hide(for: self.view, animated: true)
            self.tableView.reloadData()
        }.catch { error in
            print("\(error)")
            self.loadLocalData()
        }
    }
    
    func loadLocalData() {
        let webService = WebServiceAPI()
        
        if let topics = webService.loadTopics() {
            firstly {
                CoreDataAPI.sharedInstance.save(topics)
            }.done {
                self.viewModel.fetchData()
                MBProgressHUD.hide(for: self.view, animated: true)
                self.tableView.reloadData()
            }.catch { error in
                print("\(error)")
            }
        }
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
        performSegue(withIdentifier: "showTopicDetails", sender: topic)
    }
}

