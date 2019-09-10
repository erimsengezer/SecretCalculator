//
//  SecretScreen.swift
//  SCalculate
//
//  Created by Erim Şengezer on 27.08.2019.
//  Copyright © 2019 Erim Şengezer. All rights reserved.
//

import UIKit

class SecretScreen: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @IBAction func photosButton(_ sender: Any) {
        performSegue(withIdentifier: "goToPhotos", sender: nil)
    }
    @IBAction func videosButton(_ sender: Any) {
        print("Videos Button Clicked ")
    }
}
