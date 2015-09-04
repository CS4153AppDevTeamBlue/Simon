//
//  ViewController.swift
//  Simon
//
//  Created by Connor Eaves on 9/3/15.
//  Copyright (c) 2015 CS4153AppDevTeamBlue. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var ButtonPattern = [String]()
    
    var InputIndex = 0
    
    // This is for debugging/prototyping purposes only and should be removed in
    // the final build.
    @IBOutlet weak var ButtonPatternLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Make our initial button pattern
        ResetButtonPattern()
        
    }
    
    @IBAction func RedButtonPress(sender: AnyObject) {
        HandleInputPattern(0)
    }
    
    @IBAction func GreenButtonPress(sender: AnyObject) {
        HandleInputPattern(1)
    }
    
    @IBAction func YellowButtonPress(sender: AnyObject) {
        HandleInputPattern(2)
    }
    
    @IBAction func BlueButtonPress(sender: AnyObject) {
        HandleInputPattern(3)
    }
    
    func HandleInputPattern(input: Int) {
        
        // If we hit the right button
        if ButtonPattern[InputIndex] == input.description {
            
            // If we are at the end of the pattern
            if InputIndex == ButtonPattern.count - 1 {
                
                // Reset input index
                InputIndex = 0
                // Extend ButtonPattern
                var newIntString = Int(arc4random_uniform(4))
                ButtonPattern.append(newIntString.description)
                
                // Update ButtonPatternLabel
                ButtonPatternLabel.text! += newIntString.description
                
                // Animate Pattern
                
            // If we are not at the end of the pattern
            } else {
                // Move on to the next button in the pattern
                InputIndex++
            }
            
        // If we hit the wrong button
        } else {
            ResetButtonPattern()
        }
        
    }
    
    func ResetButtonPattern() {
        // Reset our input and clear the pattern
        InputIndex = 0
        ButtonPattern.removeAll(keepCapacity: false)
        
        // add an initial button to the pattern
        var newIntString = Int(arc4random_uniform(4))
        ButtonPattern.append(newIntString.description)
        
        // update the label
        ButtonPatternLabel.text = ButtonPattern[0]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

