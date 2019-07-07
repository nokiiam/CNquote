//
//  APIServices.swift
//  CNquote
//
//  Created by Romain on 03/07/2019.
//  Copyright © 2019 Romain. All rights reserved.
//

import Foundation
import HTMLEntities

class ApiService {
    let baseurl = "https://chucknorrisfacts.fr/api/get?data=type:txt"
    var alreadyLoadedBestQuote : [Quote] = []
    var alreadyLoadedNewQuote : [Quote] = []
    var alreadyLoadedRandomQuote : [Quote] = []
    
    var allNewQuoteLoaded = false
    var allBestQuoteLoaded = false
    var allRandomQuoteLoaded = false
    
    var APIsephamore = DispatchSemaphore(value: 1)
    
    func loadQuote(_ url: URL) -> ([Quote], Int) {
        let semaphore = DispatchSemaphore(value: 0)
        var result: [Quote] = []
        var err = 0;
        
        let task = URLSession.shared.dataTask(with: url){
            (data, response, error) -> Void in
            guard error == nil else {
                print("Error while fetching quotes")
                err = 1
                semaphore.signal()
                return
            }
            guard let data = data,
                let json : [[String: String]] = try! JSONSerialization.jsonObject(with: data) as? [[String: String]] else {
                    print("Nil data received from ApiService service")
                    err = 1
                    semaphore.signal()
                    return
            }
            result = json.map{ Quote(quote: $0["fact"]!.htmlUnescape().replacingOccurrences(of: "<br />", with: ""), date: $0["date"]!, score: $0["points"]!, vote: $0["vote"]!, id: $0["id"]!)}
            semaphore.signal()
        }
        
        task.resume()
        semaphore.wait()
        return (result, err)
    }
    
    func loadMoreNewQuote() {
        if (allNewQuoteLoaded) {return}
        APIsephamore.wait()
        let PageToLoad = alreadyLoadedNewQuote.count / 99 + 1
        
        let url = URL(string: "\(baseurl);nb:99;page:\(PageToLoad)")!
        let (newquotes, err) = loadQuote(url)
        if (newquotes.count == 0 && err == 0) {
            allNewQuoteLoaded = true
            self.alreadyLoadedBestQuote = self.alreadyLoadedNewQuote.sorted {
                return $0.score > $1.score
            }
        } else {self.alreadyLoadedNewQuote += newquotes}
        APIsephamore.signal()
    }
    
    func loadMoreBestQuote() {
        if (allBestQuoteLoaded) {return}
        APIsephamore.wait()
        let PageToLoad = alreadyLoadedNewQuote.count / 99 + 1
        
        let url = URL(string: "\(baseurl);nb:99;page:\(PageToLoad);tri:top")!
        let (newquotes, err) = loadQuote(url)
        if (newquotes.count == 0 && err == 0) {
            allBestQuoteLoaded = true
            self.alreadyLoadedNewQuote = self.alreadyLoadedBestQuote.sorted {
                return $0.date > $1.date
            }
        } else {self.alreadyLoadedBestQuote += newquotes}
        APIsephamore.signal()
    }
    
    func loadMoreRandomQuote() {
        if (allRandomQuoteLoaded) {return}
        APIsephamore.wait()
        let PageToLoad = alreadyLoadedRandomQuote.count / 99 + 1
        
        let url = URL(string: "\(baseurl);nb:99;page:\(PageToLoad);tri:alea")!
        let (newquotes, err) = loadQuote(url)
        if (newquotes.count == 0 && err == 0) {
            allRandomQuoteLoaded = true
        } else {self.alreadyLoadedRandomQuote += newquotes}
        APIsephamore.signal()
    }
    
    
    
    func getBestQuote(index : Int) -> Quote? {
        while !allBestQuoteLoaded && alreadyLoadedBestQuote.count <= index {
            loadMoreBestQuote()
        }
        if index < alreadyLoadedBestQuote.count {return alreadyLoadedBestQuote[index]}
        return nil;
    }
    
    func getNewQuote(index : Int) -> Quote? {
        while !allNewQuoteLoaded && alreadyLoadedNewQuote.count <= index {
            loadMoreNewQuote()
        }
        if index < alreadyLoadedNewQuote.count {return alreadyLoadedNewQuote[index]}
        return nil;
    }
    
    func getRandomQuote() -> Quote {
        if alreadyLoadedBestQuote.count == 0 {loadMoreBestQuote()}
        let index = Int.random(in: 0..<alreadyLoadedBestQuote.count)
        return alreadyLoadedBestQuote[index]
    }
}
