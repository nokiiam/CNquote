//
//  QuotesTableViewController.swift
//  CNquote
//
//  Created by Romain on 03/07/2019.
//  Copyright © 2019 Romain. All rights reserved.
//

import UIKit

class QuotesTableViewController: UITableViewController {
    let api = ApiService()
    var quotesType : String = "recent"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        
        
        DispatchQueue.global().async(execute: {
            switch self.quotesType {
            case "recent":
                self.api.loadMoreNewQuote()
            case "best":
                self.api.loadMoreBestQuote()
            default:
                self.api.loadMoreRandomQuote()
            }
            DispatchQueue.main.async(execute: {self.tableView.reloadData()})
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        switch quotesType {
            case "recent":
                navigationController?.navigationBar.topItem?.title = "Nouvelles"
            case "best":
                navigationController?.navigationBar.topItem?.title = "Meilleures"
            default:
                navigationController?.navigationBar.topItem?.title = "Aléatoires"
        }
        tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch quotesType {
            case "recent":
                return api.alreadyLoadedNewQuote.count
            case "best":
                return api.alreadyLoadedBestQuote.count
            default:
                return api.alreadyLoadedRandomQuote.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuoteCell", for: indexPath) as! QuoteTableViewCell
        var quote : Quote
        switch quotesType {
            case "recent":
                quote = api.alreadyLoadedNewQuote[indexPath.row]
            case "best":
                quote = api.alreadyLoadedBestQuote[indexPath.row]
            default:
                quote = api.alreadyLoadedRandomQuote[indexPath.row]
        }
        
        cell.quoteLabel.text = replaceWithName(input: quote.quoteString)
        cell.idLabel.text = "#" + String(quote.id)
        cell.starsCosmosView.rating = Double(quote.score/quote.vote)
        return cell
    }
    
    func replaceWithName(input : String) -> String {
        if Parameters.newName == "" { return input }
        var tmp : String = input.replacingOccurrences(of: "Chuck Norris", with: Parameters.newName)
        tmp = tmp.replacingOccurrences(of: "chuck Norris", with: Parameters.newName)
        tmp = tmp.replacingOccurrences(of: "chuck norris", with: Parameters.newName)
        return tmp.replacingOccurrences(of: "Chuck norris", with: Parameters.newName)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        var count : Int
        switch quotesType {
            case "recent":
                count = api.alreadyLoadedNewQuote.count
            case "best":
                count = api.alreadyLoadedBestQuote.count
            default:
                count = api.alreadyLoadedRandomQuote.count
        }
        if indexPath.row >= count - 10  && !api.loading {
            DispatchQueue.global().async(execute: {
                switch self.quotesType {
                    case "recent":
                        self.api.loadMoreNewQuote()
                    case "best":
                        self.api.loadMoreBestQuote()
                    default:
                        self.api.loadMoreRandomQuote()
                }
                DispatchQueue.main.async(execute: {self.tableView.reloadData()})
            })
        }
    }
    
    @IBAction func filterButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Trier", message: "Trier les citations par :", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Nouvelles", style: .default, handler: { (_) in
            self.quotesType = "recent"
            if self.api.alreadyLoadedNewQuote.count == 0 {
                DispatchQueue.global().async(execute: {
                    self.api.loadMoreNewQuote()
                    DispatchQueue.main.async(execute: {self.tableView.reloadData()})
                })
            }
            self.navigationController?.navigationBar.topItem?.title = "Nouvelles"
            self.tableView.reloadData()
        }))
        
        alert.addAction(UIAlertAction(title: "Meilleures", style: .default, handler: { (_) in
            self.quotesType = "best"
            if self.api.alreadyLoadedBestQuote.count == 0 {
                DispatchQueue.global().async(execute: {
                    self.api.loadMoreBestQuote()
                    DispatchQueue.main.async(execute: {self.tableView.reloadData()})
                })
            }
            self.navigationController?.navigationBar.topItem?.title = "Meilleures"
            self.tableView.reloadData()
        }))
        
        alert.addAction(UIAlertAction(title: "Aléatoire", style: .default, handler: { (_) in
            self.quotesType = "random"
            if self.api.alreadyLoadedRandomQuote.count == 0 {
                DispatchQueue.global().async(execute: {
                    self.api.loadMoreRandomQuote()
                    DispatchQueue.main.async(execute: {self.tableView.reloadData()})
                })
            }
            self.navigationController?.navigationBar.topItem?.title = "Aléatoires"
            self.tableView.reloadData()
        }))
        
        alert.addAction(UIAlertAction(title: "Annuler", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }

}
