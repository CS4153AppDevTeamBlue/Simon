//
//  ViewController.swift
//  Simon
//
//  Created by Connor Eaves on 9/3/15.
//  Copyright (c) 2015 CS4153AppDevTeamBlue. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var ButtonPattern = [String]()
    
    var InputIndex = 0
    var Score = 0
    var HighScore = 0
    
    // UNIMPLEMENTED
    var MaxPatternLength = 20
    var currentLength = 12;
    
    // This is for debugging/prototyping purposes only and should be removed in
    // the final build.
    @IBOutlet weak var ButtonPatternLabel: UILabel!
    @IBOutlet weak var ScoreLabel: UILabel!
    @IBOutlet weak var HighScoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Make our initial button pattern
        ResetButtonPattern()
        
    }
    
    @IBAction func RedButtonPress(sender: AnyObject) {
        
        
        ButtonPressed(0)
        HandleInputPattern(0)
    }
    
    @IBAction func GreenButtonPress(sender: AnyObject) {
        
        ButtonPressed(1)
        HandleInputPattern(1)
    }
    
    @IBAction func YellowButtonPress(sender: AnyObject) {
        
        ButtonPressed(2)
        HandleInputPattern(2)
    }
    
    @IBAction func BlueButtonPress(sender: AnyObject) {
        
        
        ButtonPressed(3)
        HandleInputPattern(3)
    }
    
    func ButtonPressed(inputIndex: UInt32)
    {
        switch(inputIndex)
        {
        case 0 :
            do
            {
                    let buttonSoundFile =  NSBundle.mainBundle().URLForResource("Simon_Red", withExtension: "wav")!
                    PlayButtonSound(buttonSoundFile)
            }
        case 1 :
            do
            {
                    let buttonSoundFile =  NSBundle.mainBundle().URLForResource("Simon_Green", withExtension: "wav")!
                    PlayButtonSound(buttonSoundFile)
            }
            
        case 2 :
            do
            {
                    let buttonSoundFile =  NSBundle.mainBundle().URLForResource("Simon_Yellow", withExtension: "wav")!
                    PlayButtonSound(buttonSoundFile)
            }
        case 3 :
            do
            {
                    let buttonSoundFile =  NSBundle.mainBundle().URLForResource("Simon_Blue", withExtension: "wav")!
                    PlayButtonSound(buttonSoundFile)
            }
        
        default :
            do
            {
                    // may need to play error noise
            }
        }
        
    }
    
    func PlayButtonSound(buttonSoundFile: NSURL)
    {
        
        do {
            let buttonBeep = try AVAudioPlayer(contentsOfURL: buttonSoundFile, fileTypeHint: "wav")
            buttonBeep.play()
        }
            
        catch {
            //Need to handle error somehow
        }
    }
    
    func HandleInputPattern(input: UInt32) {
        
        // If we hit the right button
        if ButtonPattern[InputIndex] == input.description {
            
            Score++
            ScoreLabel.text = Score.description
            if Score > HighScore {
                HighScore++
                HighScoreLabel.text = HighScore.description
            }
            
            // If we are at the end of the pattern
            if InputIndex == ButtonPattern.count - 1 {
                
                // Reset input index
                InputIndex = 0
                // Extend ButtonPattern
                let newIntString = Int(arc4random_uniform(4))
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
        
        Score = 0
        ScoreLabel.text = "0"
        HighScoreLabel.text = HighScore.description
        var indexArray: [UInt32] = []
        
        // Throw a for loop right here to have the pattern start at any given
        // length.
        for(var i = 0; i < currentLength; i++)
        {
            indexArray.append(arc4random_uniform(4))
            ButtonPattern.append(indexArray.description) //not sure what this is going to do so left it in --K.Angel
            
        }
        // update the label
        ButtonPatternLabel.text = ButtonPattern[0]
    }
    
    
    
    
    func PlayButtonPattern(inout someArray: [UInt32])
    {
        for (var i = 0; i < someArray.count; i++)
        {
            ButtonPressed(someArray[i])
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}