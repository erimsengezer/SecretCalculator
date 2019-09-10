//
//  ViewController.swift
//  SCalculate
//
//  Created by Erim Şengezer on 27.08.2019.
//  Copyright © 2019 Erim Şengezer. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var numberOnScreen: Double = 0
    var previousNumber: Double = 0
    var operation = 0
    var isPerformingOperation = false
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var resultLabel: UILabel!
    // Operations
    @IBOutlet weak var CButton: UIButton!
    @IBOutlet weak var percentButton: UIButton!
    @IBOutlet weak var thisButton: UIButton!
    @IBOutlet weak var multipleButton: UIButton!
    @IBOutlet weak var divisionButton: UIButton!
    @IBOutlet weak var additionButton: UIButton!
    @IBOutlet weak var subButton: UIButton!
    @IBOutlet weak var equalButton: UIButton!
    @IBOutlet weak var pointButton: UIButton!
    
    
    //  Numbers
    @IBOutlet weak var sevenButton: UIButton!
    @IBOutlet weak var eightButton: UIButton!
    @IBOutlet weak var nineButton: UIButton!
    @IBOutlet weak var fourButton: UIButton!
    @IBOutlet weak var fiveButton: UIButton!
    @IBOutlet weak var sixButton: UIButton!
    @IBOutlet weak var oneButton: UIButton!
    @IBOutlet weak var twobutton: UIButton!
    @IBOutlet weak var threeButton: UIButton!
    @IBOutlet weak var zeroButton: UIButton!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        

    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    @IBAction func numberPressed(_ sender: Any) {
        let tag = (sender as! UIButton).tag

        if isPerformingOperation == true {
            isPerformingOperation = false
            resultLabel.text = String(tag)
            numberOnScreen = Double(resultLabel.text!)!
        }else {
            let tag = (sender as! UIButton).tag
            resultLabel.text = resultLabel.text! + String(tag)
            numberOnScreen = Double(resultLabel.text!)!
        }
    }
    
    @IBAction func operatorPressed(_ sender: Any) {
        
        let tag = (sender as! UIButton).tag
        
        if tag == 10 {
            resultLabel.text = ""
            previousNumber = 0
            numberOnScreen = 0
            operation = 0
            
            return
        }
        
        // Operator tag number => x => 11, / => 12, + =>13,   - => 14, = => 15,
        
        if tag == 11 { // x
            isPerformingOperation = true
            previousNumber = Double(resultLabel.text!)!
            resultLabel.text = " "
            operation = tag
        }else if tag == 12 { // /
            isPerformingOperation = true
            previousNumber = Double(resultLabel.text!)!
            resultLabel.text = " "
            operation = tag
            
        }else if tag == 13 { //
            previousNumber += Double(resultLabel.text!)!
            isPerformingOperation = true
            resultLabel.text = " "
            operation = tag
            
        }else if tag == 14 { // -
            isPerformingOperation = true
            previousNumber = Double(resultLabel.text!)!
            resultLabel.text = " "
            operation = tag
        }else if tag == 15 { // =
            
            if resultLabel.text == "123"{
                performSegue(withIdentifier: "goToSecret", sender: nil)
            }else{
                if operation == 11 {
                    resultLabel.text = String(previousNumber * numberOnScreen)
                }else if operation == 12 {
                    resultLabel.text = String(previousNumber / numberOnScreen)
                }else if operation == 13 {
                    resultLabel.text = String(previousNumber + numberOnScreen)
                }else if operation == 14 {
                    resultLabel.text = String(previousNumber - numberOnScreen)
                }
            }
 
        }
        
        
    }
    
}

