//
//  ParqametersViewController.swift
//  CNquote
//
//  Created by Romain on 03/07/2019.
//  Copyright © 2019 Romain. All rights reserved.
//

import UIKit

class ParametersViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        ParameterInput.text = Parameters.newName
    }

    @IBOutlet weak var ParameterInput: UITextField!
    
    @IBAction func SaveButton(_ sender: Any) {
        if (ParameterInput.text.hashValue != 0) {
            Parameters.newName = ParameterInput.text!
            navigationController?.popViewController(animated: true)
        }
    }
}
