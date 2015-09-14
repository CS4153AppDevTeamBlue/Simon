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
    
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var yellowButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var ButtonPatternLabel: UILabel!
    @IBOutlet weak var ScoreLabel: UILabel!
    @IBOutlet weak var HighScoreLabel: UILabel!
    @IBOutlet weak var StartNewGameButton: UIButton!
    
    var mytimer : NSTimer?
    var GameIsPlaying = false;
    var ContinuePlaying = false;
    
    var InputIndex = 0
    var SimonSequenceIndex = 0
    var Score = 0
    var HighScore = 0
    
    let InitialPatternLength = 1
    
    
    var aVPlayer : AVPlayer!
    var AudioPatternArray = [AudioIndexPair()]
    
    
    let GreenDefault = UIImage(named: "Green.png")!
    let GreenPressed = UIImage(named: "GreenPressed.png")!
    
    let RedDefault = UIImage(named: "Red.png")!
    let RedPressed = UIImage(named: "RedPressed.png")!
    
    let YellowDefault = UIImage(named: "Yellow.png")!
    let YellowPressed = UIImage(named: "YellowPressed.png")!
    
    let BlueDefault = UIImage(named: "Blue.png")!
    let BluePressed = UIImage(named: "BluePressed.png")!
    
    var greenButtonBeep : AVAudioPlayer?
    var redButtonBeep :AVAudioPlayer?
    var yellowButtonBeep :AVAudioPlayer?
    var blueButtonBeep :AVAudioPlayer?
    var audioAsset = AVURLAsset?()
    
    let greenButtonBeepSoundURL = NSBundle.mainBundle().URLForResource("Simon_Green", withExtension: "wav")!
    let redButtonBeepSoundURL =   NSBundle.mainBundle().URLForResource("Simon_Red", withExtension: "wav")!
    let yellowButtonBeepSoundURL =   NSBundle.mainBundle().URLForResource("Simon_Yellow", withExtension: "wav")!
    let blueButtonBeepSoundURL =   NSBundle.mainBundle().URLForResource("Simon_Blue", withExtension: "wav")!
    
    // ===== UIViewController overrides ===== //
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        greenButton.setImage(GreenDefault, forState: .Normal)
        redButton.setImage(RedDefault, forState: .Normal)
        yellowButton.setImage(YellowDefault, forState: .Normal)
        blueButton.setImage(BlueDefault, forState: .Normal)
        
        greenButtonBeep = PlayButtonBeep(greenButtonBeepSoundURL)
        redButtonBeep = PlayButtonBeep(redButtonBeepSoundURL)
        yellowButtonBeep = PlayButtonBeep(yellowButtonBeepSoundURL)
        blueButtonBeep = PlayButtonBeep(blueButtonBeepSoundURL)
        
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
        
        let newAudioIndexPair = AudioIndexPair()
        newAudioIndexPair.SoundFile = PickAudioFile(0)
        newAudioIndexPair.Index = 0
        
        HandleButtonPressEvent(newAudioIndexPair)
        
        if GameIsPlaying {
            HandleInputPattern(newAudioIndexPair)
        }
        
    }
    
    @IBAction func GreenButtonPress(sender: AnyObject) {
        
        let newAudioIndexPair = AudioIndexPair()
        newAudioIndexPair.SoundFile = PickAudioFile(1)
        newAudioIndexPair.Index = 1
        
        HandleButtonPressEvent(newAudioIndexPair)
        
        if GameIsPlaying {
            
            HandleInputPattern(newAudioIndexPair)
            
        }
    }
    
    @IBAction func YellowButtonPress(sender: AnyObject) {
        let newAudioIndexPair = AudioIndexPair()
        newAudioIndexPair.SoundFile = PickAudioFile(2)
        newAudioIndexPair.Index = 2
        
        HandleButtonPressEvent(newAudioIndexPair)
        
        if GameIsPlaying {
            
            HandleInputPattern(newAudioIndexPair)
            
        }
        
    }
    
    @IBAction func BlueButtonPress(sender: AnyObject) {
        
        let newAudioIndexPair = AudioIndexPair()
        newAudioIndexPair.SoundFile = PickAudioFile(3)
        newAudioIndexPair.Index = 3
        
        HandleButtonPressEvent(newAudioIndexPair)
        
        if GameIsPlaying {
            
            HandleInputPattern(newAudioIndexPair)
        }
        
    }
    
    
    // =====
    
    
    func PickAudioFile(inputIndex: UInt32) ->NSURL {
        
        switch(inputIndex) {
            
            case 0 :
            
                return  redButtonBeepSoundURL
            
            case 1 :
                
                return  greenButtonBeepSoundURL
            
            
            case 2 :
                
                return  yellowButtonBeepSoundURL
            
            
            case 3 :
                
                return  blueButtonBeepSoundURL
            
            
            default :
                
                return  blueButtonBeepSoundURL
        }
        
    }
    
    
    
    
    // =====
    
    
    func HandleInputPattern(inputObect: AudioIndexPair) {
        
        // If we hit the right button
        
        if AudioPatternArray[InputIndex].Index == inputObect.Index {
            
            // If we are at the end of the pattern
            if InputIndex == AudioPatternArray.count - 1 {
                
                IncreaseScore(1)
                
                //Check if won?
                if( Score < 13 || ContinuePlaying) {
                
                    let seconds = 1.0
                    let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
                    let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                
                    dispatch_after(dispatchTime, dispatch_get_main_queue(), {
                    
                        // here code perfomed with delay
                        // Reset input index
                        self.InputIndex = 0
                        
                        // Extend ButtonPattern
                        let newAudioIndexPair = AudioIndexPair()
                        newAudioIndexPair.Index = UInt32(arc4random_uniform(4))
                        newAudioIndexPair.SoundFile = self.PickAudioFile(newAudioIndexPair.Index)
                        self.AudioPatternArray.append(newAudioIndexPair)
                        
                        
                        // update the label
                        self.ButtonPatternLabel.text? += newAudioIndexPair.Index.description
                        
                        // Animate Pattern
                        self.SimonSequenceIndex = 0
                        self.PlayButtonPattern()
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
        
        AudioPatternArray.removeAll(keepCapacity: false)
        Score = 0
        ScoreLabel.text = "0"
        HighScoreLabel.text = HighScore.description
        
        // Throw a for loop right here to have the pattern start at any given
        // length.
        for var i = 0; i < InitialPatternLength; i++ {
            
            let newAudioIndexPair = AudioIndexPair()
            newAudioIndexPair.Index = UInt32(arc4random_uniform(4))
            newAudioIndexPair.SoundFile = PickAudioFile(newAudioIndexPair.Index)
            AudioPatternArray.append(newAudioIndexPair)
           
            
            // update the label
            
            ButtonPatternLabel.text? += newAudioIndexPair.Index.description
            
        }
        self.SimonSequenceIndex = 0
        PlayButtonPattern()
        
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
                        let newAudioIndexPair = AudioIndexPair()
                        newAudioIndexPair.Index = UInt32(arc4random_uniform(4))
                        newAudioIndexPair.SoundFile = self.PickAudioFile(newAudioIndexPair.Index)
                        self.AudioPatternArray.append(newAudioIndexPair)
                        
                        //let newInt = UInt32(arc4random_uniform(4))
                        //self.IndexArray.append(newInt)
                        //self.ButtonPattern.append(newInt.description)
                        
                        // update the label
                        self.ButtonPatternLabel.text? += newAudioIndexPair.Index.description
                        
                        // Animate Pattern
                        //self.PlayButtonPattern(&self.IndexArray)
                        self.SimonSequenceIndex = 0
                        self.PlayButtonPattern()
                        
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
    
    func PlayButtonBeep(nSURL: NSURL)->AVAudioPlayer{
        var audioPlayer : AVAudioPlayer?
        audioPlayer = try! AVAudioPlayer(contentsOfURL: nSURL)
        return audioPlayer!
    }
    
    func HandleButtonPressEvent(audioIndexPair: AudioIndexPair)
    {
        audioAsset = AVURLAsset(URL: audioIndexPair.SoundFile!)
        let seconds = audioAsset?.duration
        let delay = CMTimeGetSeconds(seconds!) * Double(NSEC_PER_SEC)  // nanoseconds per seconds
        let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay/2))
        
        switch(audioIndexPair.Index){
        case 0 :
            redButtonBeep!.play()
            
            redButton.setImage(RedPressed, forState: .Normal)
            dispatch_after(dispatchTime, dispatch_get_main_queue()) {
                self.redButton.setImage(self.RedDefault, forState: .Normal)
            }
            break
            
        case 1 :
            greenButtonBeep!.play()
            greenButton.setImage(GreenPressed, forState: .Normal)
            
            dispatch_after(dispatchTime, dispatch_get_main_queue()) {
                self.greenButton.setImage(self.GreenDefault, forState: .Normal)
            }
            
            break
            
            
        case 2 :
            yellowButtonBeep!.play()
            yellowButton.setImage(YellowPressed, forState: .Normal)
            
            dispatch_after(dispatchTime, dispatch_get_main_queue()) {
                self.yellowButton.setImage(self.YellowDefault, forState: .Normal)
            }
            
            break
            
            
        case 3 :
            blueButtonBeep!.play()
            blueButton.setImage(BluePressed, forState: .Normal)
            
            dispatch_after(dispatchTime, dispatch_get_main_queue()) {
                self.blueButton.setImage(self.BlueDefault, forState: .Normal)
            }
            
            break
            
            
        default :
            
            break
        }
        
        
    }
    
    func PlayButtonPattern() {
        
        let duration = 0.92
        mytimer = NSTimer.scheduledTimerWithTimeInterval(duration, target: self, selector:"CountUp", userInfo: nil, repeats: false)
        NSRunLoop.currentRunLoop().addTimer(self.mytimer!, forMode: NSRunLoopCommonModes)
        
    }
    
    func CountUp(){
        
        if (SimonSequenceIndex >= AudioPatternArray.count){return}
        
        HandleButtonPressEvent(AudioPatternArray[SimonSequenceIndex])
        PlayButtonPattern()
        SimonSequenceIndex++

    }

    
    
}