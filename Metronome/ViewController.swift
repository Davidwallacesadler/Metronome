//
//  ViewController.swift
//  Metronome
//
//  Created by David Sadler on 9/16/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import UIKit
import AVKit

class ViewController: UIViewController, UIPickerViewDelegate,UIPickerViewDataSource {
    
    // MARK: - PickerView DataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return beatsPerMinuteOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let integerStr = "\(beatsPerMinuteOptions[row])"
        let title = NSAttributedString(string: integerStr, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        return title
    }
    
    // MARK: - PickerView Delegate
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedBeatsPerMinute = beatsPerMinuteOptions[row]
        updateLabel()
    }
    
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        updateLabel()
        setupPickerView()
        self.beatsPerMinutePickerView.selectRow(59, inComponent: 0, animated: false)
    }
    
    // MARK: - Internal Properties
    
    var selectedBeatsPerMinute: Int = 60
    var beatsPerMinuteOptions: [Int] {
        get {
            var numbers = [Int]()
            for i in 1...250 {
                numbers.append(i)
            }
            return numbers
        }
    }
    let soundKey = "beat"
    var player: AVAudioPlayer?
    var bpmTimer: Timer?
    var beatHappened: Bool = false
    var pauseStatus: Bool = true
    let pauseImage: UIImage? = UIImage.init(named: "pauseButton")
    let playImage: UIImage? = UIImage.init(named: "playButton")
    
    // MARK: - Outlets
    
    @IBOutlet weak var beatsPerMinutePickerView: UIPickerView!
    @IBOutlet weak var currentBeatsPerMinuteLabel: UILabel!
    @IBOutlet weak var playAndPauseButton: UIButton!
    @IBOutlet weak var playPauseButton: UIButton!
    
    // MARK: - Action
    
    @IBAction func playButtonPressed(_ sender: Any) {
        pauseStatus = !pauseStatus
        updatePlayButton()
        if pauseStatus == false {
            // Start a repeating timer that is
            let interval: Double = 60.0 / Double(selectedBeatsPerMinute)
            bpmTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true, block: { timer in
                self.playClick()
            })
        } else {
            bpmTimer?.invalidate()
        }
    }
    
    // MARK: - Methods
    
    func setupPickerView() {
        self.beatsPerMinutePickerView.delegate = self
        self.beatsPerMinutePickerView.dataSource = self
    }

    func updateLabel() {
        self.currentBeatsPerMinuteLabel.text = "\(selectedBeatsPerMinute)"
    }
    
    func playClick() {
        guard let fileUrl = Bundle.main.url(forResource: soundKey, withExtension: "m4a") else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            player = try AVAudioPlayer(contentsOf: fileUrl, fileTypeHint: AVFileType.m4a.rawValue)
            guard let player = player else { return }
            player.play()
        } catch {
            print(error.localizedDescription)
        }
    }

    func updatePlayButton() {
        guard let pauseImage = pauseImage, let playImage = playImage else { return }
        if pauseStatus {
            playPauseButton.setImage(playImage, for: .normal)
        } else {
            playPauseButton.setImage(pauseImage, for: .normal)
        }
    }
}
