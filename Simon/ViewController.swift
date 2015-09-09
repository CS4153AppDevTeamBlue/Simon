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
    var indexArray: [UInt32] = []
    var gameBeingPlayed = false;
    
    var InputIndex = 0
    var Score = 0
    var HighScore = 0
    
    var currentLength = 1;
    
    var audioQueue = AVQueuePlayer()
    
    
    
    // This is for debugging/prototyping purposes only and should be removed in
    // the final build.
    @IBOutlet weak var ButtonPatternLabel: UILabel!
    @IBOutlet weak var ScoreLabel: UILabel!
    @IBOutlet weak var HighScoreLabel: UILabel!
    @IBOutlet weak var startNewGame: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        // Make our initial button pattern
        //ResetButtonPattern()
        
    }
    
    @IBAction func StartGameBuittonPress(sender: AnyObject) {
        gameBeingPlayed = true
        startNewGame.hidden = true
        let seconds = 1.0
        let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            self.ResetButtonPattern()
        })
    }
    
    @IBAction func RedButtonPress(sender: AnyObject) {
        if(gameBeingPlayed) {
        audioQueue.removeAllItems()
        ButtonPressed(0)
        audioQueue.play()
        
        HandleInputPattern(0)
        }
        
    }
    
    @IBAction func GreenButtonPress(sender: AnyObject) {
        if(gameBeingPlayed) {
        ButtonPressed(1)
        HandleInputPattern(1)
        audioQueue.play()
        }
    }
    
    @IBAction func YellowButtonPress(sender: AnyObject) {
        if(gameBeingPlayed) {
        ButtonPressed(2)
        HandleInputPattern(2)
        audioQueue.play()
        }
    }
    
    @IBAction func BlueButtonPress(sender: AnyObject) {
        if(gameBeingPlayed) {
        ButtonPressed(3)
        HandleInputPattern(3)
        audioQueue.play()
        }
    }
    
    func ButtonPressed(inputIndex: UInt32)
    {
        switch(inputIndex)
        {
        case 0 :
                    let buttonSoundFile =  NSBundle.mainBundle().URLForResource("Simon_Red", withExtension: "wav")!
                    LoadButtonSound(buttonSoundFile)
                    break
        case 1 :
                    let buttonSoundFile =  NSBundle.mainBundle().URLForResource("Simon_Green", withExtension: "wav")!
                    LoadButtonSound(buttonSoundFile)
                    break
        case 2 :
                    let buttonSoundFile =  NSBundle.mainBundle().URLForResource("Simon_Yellow", withExtension: "wav")!
                    LoadButtonSound(buttonSoundFile)
                    break
        case 3 :
                    let buttonSoundFile =  NSBundle.mainBundle().URLForResource("Simon_Blue", withExtension: "wav")!
                    LoadButtonSound(buttonSoundFile)
                    break
        default :
                    // may need to play error noise
                    break
        }
        
    }
    
    func LoadButtonSound(buttonSoundFile: NSURL)
    {
    
        let audioItem = AVPlayerItem(URL: buttonSoundFile)
        audioQueue.insertItem(audioItem, afterItem: nil)
    
    }
    
    
    
    func HandleInputPattern(input: UInt32) {
        
        // If we hit the right button
        if ButtonPattern[InputIndex] == input.description {
            
            // If we are at the end of the pattern
            if InputIndex == ButtonPattern.count - 1 {
                let seconds = 1.5
                let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
                let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                
                dispatch_after(dispatchTime, dispatch_get_main_queue(), {
                    //Increase Score
                    self.increaseScore()
                    
                    // here code perfomed with delay
                    // Reset input index
                    self.InputIndex = 0
                    
                    // Extend ButtonPattern
                    let newInt = UInt32(arc4random_uniform(4))
                    self.indexArray.append(newInt)
                    self.ButtonPattern.append(newInt.description)
                    
                    // update the label
                    self.ButtonPatternLabel.text? += newInt.description
                    
                    // Animate Pattern
                    self.PlayButtonPattern(&self.indexArray)
                    
                })
                
                // If we are not at the end of the pattern
            } else {
                // Move on to the next button in the pattern
                InputIndex++
            }
            
            // If we hit the wrong button
        } else {
            //Fire alertview box
            let alert = UIAlertController(title: "Simon Didn't say that!", message: "You hit the wrong button!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
                switch action.style{
                case .Default:
                    print("default")
                    
                    //Reset score and Button Pattern
                    self.gameBeingPlayed = false
                    self.startNewGame.hidden = false
                    self.Score = 0
                    self.ScoreLabel.text = "0"
                    //self.ResetButtonPattern()
                    
                case .Cancel:
                    print("cancel")
                    
                case .Destructive:
                    print("destructive")
                }
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func ResetButtonPattern() {
        // Reset our input and clear the pattern
        InputIndex = 0
        ButtonPatternLabel.text = ""
        ButtonPattern.removeAll(keepCapacity: false)
        indexArray.removeAll(keepCapacity: false)
        
        Score = 0
        ScoreLabel.text = "0"
        HighScoreLabel.text = HighScore.description
        
        
        // Throw a for loop right here to have the pattern start at any given
        // length.
        for(var i = 0; i < currentLength; i++)
        {
            indexArray.append(arc4random_uniform(4))
            ButtonPattern.append(indexArray[i].description) //not sure what this is going to do so left it in --K.Angel
            
            // update the label
            ButtonPatternLabel.text? += ButtonPattern[i]
            
        }
        PlayButtonPattern(&indexArray)
        
        
    }
    
    func increaseScore( ) {
        Score++
        ScoreLabel.text = Score.description
        if Score > HighScore {
            HighScore++
            HighScoreLabel.text = HighScore.description
        }
    }
    
    func PlayButtonPattern(inout someArray: [UInt32])
    {
        for (var i = 0; i < someArray.count; i++)
        {
            ButtonPressed(someArray[i])
        }
        
        audioQueue.play() // plays queue but we may want to refactor this so we can make buttons light up
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}