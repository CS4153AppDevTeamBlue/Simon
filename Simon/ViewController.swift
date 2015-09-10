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
    
    
    // ===== Public variables and constants ===== //
    
    
    var ButtonPattern = [String]()
    var IndexArray = [UInt32]()
    var GameIsPlaying = false;
    var ContinuePlaying = false;
    
    var InputIndex = 0
    var Score = 0
    var HighScore = 0
    
    let InitialPatternLength = 1;
    
    let PatternAudioPlayer = AVQueuePlayer()
    
    
    // ===== Outlet declarations ===== //
    
    
    // This is for debugging/prototyping purposes only and should be removed in
    // the final build.
    @IBOutlet weak var ButtonPatternLabel: UILabel!
    
    @IBOutlet weak var ScoreLabel: UILabel!
    @IBOutlet weak var HighScoreLabel: UILabel!
    
    @IBOutlet weak var StartNewGameButton: UIButton!
    
    
    // ===== UIViewController overrides ===== //
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // ===== Start New Game button (Entry point) ===== //
    
    
    @IBAction func StartGameBuittonPress(sender: AnyObject) {
        
        GameIsPlaying = true
        
        //Taking this out because it doesn't hide the button on press
        if let _ = StartNewGameButton {
            StartNewGameButton.hidden = true
        }
        
        let seconds = 1.0
        let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
                self.InitNewButtonPattern()
            }
        )
        
    }
    
    
    // ===== Button press handling ===== //
    
    
    @IBAction func RedButtonPress(sender: AnyObject) {
        
        if GameIsPlaying {
            PatternAudioPlayer.removeAllItems()
            AddButtonAudioToPatternPlayer(0)
            PatternAudioPlayer.play()
        
            HandleInputPattern(0)
        }
        
    }
    
    @IBAction func GreenButtonPress(sender: AnyObject) {
        
        if GameIsPlaying {
            PatternAudioPlayer.removeAllItems()
            AddButtonAudioToPatternPlayer(1)
            PatternAudioPlayer.play()
            
            HandleInputPattern(1)
        }
    }
    
    @IBAction func YellowButtonPress(sender: AnyObject) {
        
        if GameIsPlaying {
            PatternAudioPlayer.removeAllItems()
            AddButtonAudioToPatternPlayer(2)
            PatternAudioPlayer.play()
            
            HandleInputPattern(2)
        }
        
    }
    
    @IBAction func BlueButtonPress(sender: AnyObject) {
        
        if GameIsPlaying {
            PatternAudioPlayer.removeAllItems()
            AddButtonAudioToPatternPlayer(3)
            PatternAudioPlayer.play()
            
            HandleInputPattern(3)
        }
        
    }
    
    
    // =====
    
    
    func AddButtonAudioToPatternPlayer(inputIndex: UInt32) {
        
        switch(inputIndex) {
            
            case 0 :
                
                let buttonSoundFile =  NSBundle.mainBundle().URLForResource("Simon_Red", withExtension: "wav")!
                let audioItem = AVPlayerItem(URL: buttonSoundFile)
                PatternAudioPlayer.insertItem(audioItem, afterItem: nil)
                break
            
            case 1 :
                
                let buttonSoundFile =  NSBundle.mainBundle().URLForResource("Simon_Green", withExtension: "wav")!
                let audioItem = AVPlayerItem(URL: buttonSoundFile)
                PatternAudioPlayer.insertItem(audioItem, afterItem: nil)
                break
            
            case 2 :
                
                let buttonSoundFile =  NSBundle.mainBundle().URLForResource("Simon_Yellow", withExtension: "wav")!
                let audioItem = AVPlayerItem(URL: buttonSoundFile)
                PatternAudioPlayer.insertItem(audioItem, afterItem: nil)
                break
            
            case 3 :
                
                let buttonSoundFile =  NSBundle.mainBundle().URLForResource("Simon_Blue", withExtension: "wav")!
                let audioItem = AVPlayerItem(URL: buttonSoundFile)
                PatternAudioPlayer.insertItem(audioItem, afterItem: nil)
                break
            
            default :
                
                // may need to play error noise
                break
        }
        
    }
    
    
    // =====
    
    
    func HandleInputPattern(input: UInt32) {
        
        // If we hit the right button
        if ButtonPattern[InputIndex] == input.description {
            
            // If we are at the end of the pattern
            if InputIndex == ButtonPattern.count - 1 {
                
                IncreaseScore(1)
                
                //Check if won?
                if( Score < 13 || ContinuePlaying) {
                
                    let seconds = 1.5
                    let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
                    let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                
                    dispatch_after(dispatchTime, dispatch_get_main_queue(), {
                    
                            // here code perfomed with delay
                            // Reset input index
                            self.InputIndex = 0
                    
                            // Extend ButtonPattern
                            let newInt = UInt32(arc4random_uniform(4))
                            self.IndexArray.append(newInt)
                            self.ButtonPattern.append(newInt.description)
                    
                            // update the label
                            self.ButtonPatternLabel.text? += newInt.description
                    
                            // Animate Pattern
                            self.PlayButtonPattern(&self.IndexArray)
                    
                        }
                    )
                }
                
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
                    self.GameIsPlaying = false
                    self.StartNewGameButton.hidden = false
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
    
    
    
    
    
    func InitNewButtonPattern() {
        
        // Reset our input and clear the pattern
        InputIndex = 0
        ButtonPatternLabel.text = ""
        ButtonPattern.removeAll(keepCapacity: false)
        IndexArray.removeAll(keepCapacity: false)
        
        Score = 0
        ScoreLabel.text = "0"
        HighScoreLabel.text = HighScore.description
        
        // Throw a for loop right here to have the pattern start at any given
        // length.
        for var i = 0; i < InitialPatternLength; i++ {
            
            IndexArray.append(arc4random_uniform(4))
            ButtonPattern.append(IndexArray[i].description)
            
            // update the label
            ButtonPatternLabel.text? += ButtonPattern[i]
            
        }
        
        PlayButtonPattern(&IndexArray)
        
    }
    
    func IncreaseScore(points: Int) {
        
        Score += points
        ScoreLabel.text = Score.description
        
        if Score > HighScore {
            HighScore++
            HighScoreLabel.text = HighScore.description
        }
        
        if( Score == 13) {
            //You won!, Keep Playing?
            let alert = UIAlertController(title: "You Won!", message: "Continue Playing?", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { action in
                switch action.style{
                case .Default:
                    print("default")
                    
                    //Wait then add number and continue playing!
                    
                    self.ContinuePlaying = true
                    
                    let seconds = 1.5
                    let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
                    let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                    
                    dispatch_after(dispatchTime, dispatch_get_main_queue(), {
                        
                        // here code perfomed with delay
                        // Reset input index
                        self.InputIndex = 0
                        
                        // Extend ButtonPattern
                        let newInt = UInt32(arc4random_uniform(4))
                        self.IndexArray.append(newInt)
                        self.ButtonPattern.append(newInt.description)
                        
                        // update the label
                        self.ButtonPatternLabel.text? += newInt.description
                        
                        // Animate Pattern
                        self.PlayButtonPattern(&self.IndexArray)
                        
                        }
                    )
                
                case .Cancel:
                    print("cancel")
                    
                case .Destructive:
                    print("destructive")
                }
            }))
            alert.addAction(UIAlertAction(title: "No", style: .Default, handler: { action in
                switch action.style{
                case .Default:
                    print("default - No")
                    
                    self.GameIsPlaying = false
                    self.StartNewGameButton.hidden = false
                    self.Score = 0
                    self.ScoreLabel.text = "0"
                case .Cancel:
                    print("cancel - No")
                case .Destructive:
                    print("destructive - No")
                }
            }))
            self.presentViewController(alert, animated: true, completion: nil)


        }
        
    }
    
    func PlayButtonPattern(inout someArray: [UInt32]) {
        
        for var i = 0; i < someArray.count; i++ {
            AddButtonAudioToPatternPlayer(someArray[i])
        }
        
        PatternAudioPlayer.play() // plays queue but we may want to refactor this so we can make buttons light up
    
    }
    
}