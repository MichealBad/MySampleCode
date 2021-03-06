//
//  Services.swift
//  Musicgram
//
//  Created by Michealbad on 16/6/4.
//  Copyright © 2016年 Michealbad. All rights reserved.
//

import UIKit
import Foundation

// Class which contains services parameters like consumer key and secret
typealias ServicesValue = String

class Services {
    var parameters : [String: [String: ServicesValue]]
    
    init() {
        self.parameters = [:]
    }
    
    subscript(service: String) -> [String:ServicesValue]? {
        get {
            return parameters[service]
        }
        set {
            if let value = newValue  where !Services.parametersEmpty(value) {
                parameters[service] = value
            }
        }
    }
    
    func loadFromFile(path: String) {
        if let newParameters = NSDictionary(contentsOfFile: path) as? [String: [String: ServicesValue]] {
            
            for (service, dico) in newParameters {
                if parameters[service] != nil && Services.parametersEmpty(dico) { // no value to set
                    continue
                }
                updateService(service, dico: dico)
            }
        }
    }
    
    func updateService(service: String, dico: [String: ServicesValue]) {
        var resultdico = dico
        if let oldDico = self.parameters[service] {
            resultdico = oldDico
            resultdico += dico
        }
        self.parameters[service] = resultdico
    }
    
    static func parametersEmpty(dico: [String: ServicesValue]) -> Bool {
        return  Array(dico.values).filter({ (p) -> Bool in !p.isEmpty }).isEmpty
    }
    
    var keys: [String] {
        return Array(self.parameters.keys)
    }
}

func += <KeyType, ValueType> (inout left: Dictionary<KeyType, ValueType>, right: Dictionary<KeyType, ValueType>) {
    for (k, v) in right {
        left.updateValue(v, forKey: k)
    }
}
