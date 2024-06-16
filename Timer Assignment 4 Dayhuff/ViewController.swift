//
//  ViewController.swift
//  Timer Assignment 4 Dayhuff
//
//  Created by Noah Dayhuff on 6/15/24.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var timeLabel: UILabel!;
    @IBOutlet weak var datePicker: UIDatePicker!;
    
    @IBOutlet weak var timerLabel: UILabel!;
    @IBOutlet weak var timerButton: UIButton!;
    
    var timer: Timer?
    var countdownTimer: Timer?
    var remainingTime: TimeInterval = 0
    var audioPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    func liveClock() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateLiveClock), userInfo: nil, repeats: true)
    }
    
    @objc func updateLiveClock() {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, dd MMM yyyy HH:mm:ss"
        timeLabel.text = formatter.string(from: Date())
        updateBackgroundImage()
    }
    
    func updateBackgroundImage() {
        let hour = Calendar.current.component(.hour, from: Date())
        let isDayTime = hour >= 6 && hour < 18
        view.backgroundColor = isDayTime ? UIColor.systemGray : UIColor.systemBlue
    }
    
    func setupDatePicker() {
        datePicker.datePickerMode = .countDownTimer
    }
    
    @IBAction func startTimerTapped(_ sender: UIButton) {
        if countdownTimer != nil {
            stopMusic()
        } else {
            startCountdown()
        }
    }
    
    func startCountdown() {
        remainingTime = datePicker.countDownDuration
        updateCountdownLabel()
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCountdown), userInfo: nil, repeats: true)
        timerButton.setTitle("Stop Timer", for: .normal)
    }
    
    @objc func updateCountdown() {
        if remainingTime > 0 {
            remainingTime -= 1
            updateCountdownLabel()
        } else {
            countdownTimer?.invalidate()
            countdownTimer = nil
            playMusic()
        }
    }
    
    func updateCountdownLabel() {
        let hours = Int(remainingTime) / 3600
        let minutes = Int(remainingTime) % 3600 / 60
        let seconds = Int(remainingTime) % 60
        timerLabel.text = String(format: "%02d:%02f:%02d", hours, minutes, seconds)
    }
        
    func playMusic() {
        guard let url = Bundle.main.url(forResource: "alarm", withExtension: "mp3") else { return }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
            timerButton.setTitle("Stop Music", for: .normal)
        } catch {
            print("Error playing music")
        }
    }
    
    func stopMusic() {
        audioPlayer?.stop()
        audioPlayer = nil
        timerButton.setTitle("Start Timer", for: .normal)
    }
}

