//
//  TopicViewModel.swift
//  WHealth
//
//  Created by Jovito Royeca on 16.10.18.
//  Copyright © 2018 Jovito Royeca. All rights reserved.
//

import UIKit

class TopicViewModel: NSObject {
    var _topic: Topic?
    
    init(withTopic topic: Topic) {
        super.init()
        _topic = topic
    }
    
    func nameDisplay() -> String? {
        guard let topic = _topic else {
            return nil
        }
        
        return "Name: \(topic.name != nil ? topic.name! : "")"
    }
    
    func aggregateCountDisplay() -> String? {
        guard let topic = _topic else {
            return nil
        }
        
        return "Aggregate Count: \(topic.aggregateCount)"
    }
    
    func styleDisplay() -> String? {
        guard let topic = _topic else {
            return nil
        }
        
        return "Style: \(topic.style != nil ? topic.style! : "")"
    }
}
