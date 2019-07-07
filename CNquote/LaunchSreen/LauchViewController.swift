//
//  LauchViewController.swift
//  CNquote
//
//  Created by Romain on 03/07/2019.
//  Copyright © 2019 Romain. All rights reserved.
//

import UIKit

class LauchViewController: UIViewController {
    let api = ApiService()
    @IBOutlet weak var quoteLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let q : Quote = api.getRandomQuote()
        
        quoteLabel.text = "\n" + q.quoteString + "\n"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            let newView = self.storyboard?.instantiateViewController(withIdentifier: "QuotesView") as! QuotesTableViewController
            self.navigationController?.pushViewController(newView, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
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
