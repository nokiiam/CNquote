//
//  Quote.swift
//  CNquote
//
//  Created by Romain on 03/07/2019.
//  Copyright © 2019 Romain. All rights reserved.
//

import Foundation

class Quote {
    var quoteString : String
    var date : Int
    var score : Int
    var vote : Int
    var id : Int
    
    init(quote : String, date : String, score : String, vote : String, id : String){
        quoteString = quote
        self.date = Int(date) ?? 0
        self.score = Int(score) ?? 0
        self.vote = Int(vote) ?? 0
        self.id = Int(id) ?? 0
    }
}
