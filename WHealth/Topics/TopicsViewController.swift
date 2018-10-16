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
    let searchController = UISearchController(searchResultsController: nil)
    let viewModel = TopicsViewModel()
    
    // MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search"
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            tableView.tableHeaderView = searchController.searchBar
        }
        tableView.keyboardDismissMode = .onDrag
        
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

            dest.viewModel = TopicViewModel(withTopic: topic)
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
            self.tableView.reloadData()
            MBProgressHUD.hide(for: self.view, animated: true)
        }.catch { error in
            print("\(error)")
            self.loadLocalData()
        }
    }
    
    func loadLocalData() {
        let webService = WebServiceAPI()
        
        firstly {
            webService.loadTopics()
        }.then { (topics: [[String: Any]]) in
            CoreDataAPI.sharedInstance.save(topics)
        }.done {
            self.viewModel.fetchData()
            self.tableView.reloadData()
            MBProgressHUD.hide(for: self.view, animated: true)
        }.catch { error in
            print("\(error)")
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    @objc func doSearch() {
        viewModel.queryString = searchController.searchBar.text ?? ""
        viewModel.fetchData()
        tableView.reloadData()
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
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return viewModel.sectionIndexTitles()
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return viewModel.sectionForSectionIndexTitle(title: title, at: index)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.titleForHeaderInSection(section: section)
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

// MARK: UISearchResultsUpdating
extension TopicsViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(doSearch), object: nil)
        perform(#selector(doSearch), with: nil, afterDelay: 0.5)
    }
}

// MARK: UISearchResultsUpdating
extension TopicsViewController : UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        viewModel.searchCancelled = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchCancelled = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if viewModel.searchCancelled {
            searchBar.text = viewModel.queryString
        } else {
            viewModel.queryString = searchBar.text ?? ""
        }
    }
}


