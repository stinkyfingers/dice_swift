//
//  ViewController.swift
//  DirtyDice
//
//  Created by John Shenk on 12/11/17.
//  Copyright © 2017 John Shenk. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    let verbs: [String:Int] = [
        "Compliment":0,
        "Touch":0,
        "Caress":0,
        "Massage":0,
        "Tickle":0,
        "Sing To":0,
        "Lick":1,
        "Taste":1,
        "Rub":1,
        "Nibble":1,
        "Kiss":1,
        "Finger":2,
        "Smell":2,
        "Tongue": 2,
        "Suck":3,
        "Spit On":3,
        "Eat Whipped Cream Off":3,
        "Rub Genitals On":3,
        ]
    
    let nouns: [String:Int] = [
        "Ear":0,
        "Neck":0,
        "Upper Back": 0,
        "Forehead":0,
        "Tummy":0,
        "Cheek":0,
        "Fingers":0,
        "Foot":1,
        "Knee":1,
        "Butt Cheek":1,
        "Lower Back":1,
        "Inner Thigh":1,
        "Chest":1,
        "Mouth":1,
        "Armpit":2,
        "Nipple":2,
        "Genitals": 2,
        "Area Between Toes":2,
        "Butthole":3,
        "Pussy/Penis":3,
        "Taint":3
        ]
    
    let nastinesses: [Int: String] = [0: "PG", 1: "PG-13", 2: "R", 3: "X"]
    var nastinessValue = 0
    
    var timer = Timer()
    var seconds = 60
    var timerIsRunning = false
    var secondsRemaining = 60
    var buttonColor = UIColor.green
    var buzzer: AVAudioPlayer = AVAudioPlayer()
    
    @IBOutlet weak var rollButton: UIButton!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var dirtLabel: UILabel!
    @IBOutlet weak var instruction: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet var setSeconds: UILabel!
    @IBOutlet weak var incrementer: UIStepper!
    @IBOutlet weak var selectedSeconds: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        timer.invalidate()
    }
    
    func getValues(max: Int, inputDict: [String:Int])->Array<String> {
        var output = [String]()
        for (val, rank) in inputDict {
            if rank <= max && rank > max - 2{
                output.append(val)
            }
        }
        return output
    }
    
    @IBAction func roll(sender: UIButton) {
        let selectedNouns = getValues(max:nastinessValue, inputDict:nouns)
        let selectedVerbs = getValues(max:nastinessValue, inputDict:verbs)
        let randVerb = arc4random_uniform(UInt32(selectedVerbs.count))
        let randNoun = arc4random_uniform(UInt32(selectedNouns.count))
        let verb = selectedVerbs[Int(randVerb)]
        let noun = selectedNouns[Int(randNoun)]
        runTimer()
        instruction.text = verb + " " + noun
        
    }

    @IBAction func handleSlider(sender: AnyObject) {
        nastinessValue = Int(round(slider.value))
        dirtLabel.text = nastinesses[nastinessValue]
    }
    
    @IBAction func handleStopButton(sender: UIButton) {
        stopTimer()
    }
    
    func runTimer() {
        secondsRemaining = seconds
        incrementer.isEnabled = false
        rollButton.isEnabled = false
        rollButton.backgroundColor = UIColor.gray
        timerLabel.textColor = UIColor.black
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        if (secondsRemaining <= 1) {
            buzz()
            stopTimer()
            return
        }
        secondsRemaining -= 1
        timerLabel.text = "\(secondsRemaining)"
    }
    
    func stopTimer() {
        timer.invalidate()
        timerLabel.text = "Time Up"
        timerLabel.textColor = UIColor.red
        instruction.text = ""
        secondsRemaining = seconds
        incrementer.isEnabled = true
        rollButton.isEnabled = true
        rollButton.backgroundColor = buttonColor
    }
    
    @IBAction func incrementTime(sender: UIStepper) {
        seconds = Int(sender.value)
        if selectedSeconds != nil {
            selectedSeconds.text = "Seconds: \(seconds)"
        }
    }
    
    func buzz() {
        let file = Bundle.main.path(forResource: "Air Horn-SoundBible.com-964603082 (1)", ofType: ".mp3")
        do {
            try buzzer = AVAudioPlayer(contentsOf: URL(fileURLWithPath: file!))
            buzzer.play()
        }
        catch {
            // TODO - handle exception
        }
    }
}

