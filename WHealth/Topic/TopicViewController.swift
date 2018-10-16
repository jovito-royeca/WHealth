//
//  TopicViewController.swift
//  WHealth
//
//  Created by Jovito Royeca on 15.10.18.
//  Copyright © 2018 Jovito Royeca. All rights reserved.
//

import UIKit

class TopicViewController: UIViewController {
    // MARL: Variables
    var viewModel: TopicViewModel!
    
    // MARK: Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var aggregateCountLabel: UILabel!
    @IBOutlet weak var styleLabel: UILabel!
    
    // MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        nameLabel.text = viewModel.nameDisplay()
        aggregateCountLabel.text = viewModel.aggregateCountDisplay()
        styleLabel.text = viewModel.styleDisplay()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
