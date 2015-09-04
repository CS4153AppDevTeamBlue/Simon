//
//  ViewController.swift
//  Simon
//
//  Created by Connor Eaves on 9/3/15.
//  Copyright (c) 2015 CS4153AppDevTeamBlue. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // Outlet for Label containing the generated button pattern
    // This is for debugging/prototyping purposes only and should be removed in
    // the final build.
    // Example: "10211310113"
    @IBOutlet weak var ButtonPatternLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Generate an array of ints (rangeing from 0-3) of length 1
        
        // Each button should increment am InputIndex int and each button should
        // pass it's 0-3 value into a function.
        
        // That function should check that it's 0-3 value matches the ButtonPattern
        // array at that index.
        
        // If it matches, proceed to the next index.
        // If it is index is the same as the length of ButtonPattern, append a new
        // random interger onto the end of ButtonPattern
        
        // If the numbers don't match, start over from the beginning to start building
        // a new ButtonPattern.
        
        // I hope this is a suitable algorithm. I don't have time to implement
        // this right now, but if anyone has a better way of going about it, feel
        // free to describe/implement it instead. This just seemed the simplest/
        // most straightforward.
        
        // - Connor Eaves
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

