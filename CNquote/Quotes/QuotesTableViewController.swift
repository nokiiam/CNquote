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
        
        switch quotesType {
            case "recent":
                api.loadMoreNewQuote()
            case "best":
                api.loadMoreBestQuote()
            default:
                api.loadMoreRandomQuote()
        }
        
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
        let count : Int = api.alreadyLoadedNewQuote.count
        if indexPath.row >= count - 5 {
            switch quotesType {
                case "recent":
                    api.loadMoreNewQuote()
                case "best":
                    api.loadMoreBestQuote()
                default:
                    api.loadMoreRandomQuote()
            }
            tableView.reloadData()
        }
    }
    
    @IBAction func filterButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Trier", message: "Trier les citations par :", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Nouvelles", style: .default, handler: { (_) in
            self.quotesType = "recent"
            if self.api.alreadyLoadedNewQuote.count == 0 {
                self.api.loadMoreNewQuote()
            }
            self.navigationController?.navigationBar.topItem?.title = "Nouvelles"
            self.tableView.reloadData()
        }))
        
        alert.addAction(UIAlertAction(title: "Meilleures", style: .default, handler: { (_) in
            self.quotesType = "best"
            if self.api.alreadyLoadedBestQuote.count == 0 {
                self.api.loadMoreBestQuote()
            }
            self.navigationController?.navigationBar.topItem?.title = "Meilleures"
            self.tableView.reloadData()
        }))
        
        alert.addAction(UIAlertAction(title: "Aléatoire", style: .default, handler: { (_) in
            self.quotesType = "random"
            if self.api.alreadyLoadedRandomQuote.count == 0 {
                self.api.loadMoreRandomQuote()
            }
            self.navigationController?.navigationBar.topItem?.title = "Aléatoires"
            self.tableView.reloadData()
        }))
        
        alert.addAction(UIAlertAction(title: "Annuler", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
