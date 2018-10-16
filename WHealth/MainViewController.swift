//
//  MainViewController.swift
//  WHealth
//
//  Created by Jovito Royeca on 12.10.18.
//  Copyright © 2018 Jovito Royeca. All rights reserved.
//

import UIKit
import FontAwesome_swift

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        guard let items = self.tabBar.items else {
            return
        }
        
        // add tab icons
        items[0].image = UIImage.fontAwesomeIcon(name: .bookOpen,
                                                 style: .solid,
                                                 textColor: UIColor.blue,
                                                 size: CGSize(width: 30, height: 30))
        items[1].image = UIImage.fontAwesomeIcon(name: .notesMedical,
                                                 style: .solid,
                                                 textColor: UIColor.blue,
                                                 size: CGSize(width: 30, height: 30))
        items[2].image = UIImage.fontAwesomeIcon(name: .stethoscope,
                                                 style: .solid,
                                                 textColor: UIColor.blue,
                                                 size: CGSize(width: 30, height: 30))
        items[3].image = UIImage.fontAwesomeIcon(name: .mapMarkerAlt,
                                                 style: .solid,
                                                 textColor: UIColor.blue,
                                                 size: CGSize(width: 30, height: 30))
        
    }


}

