//
//  FMPlayerViewController.swift
//  weibo
//
//  Created by 吴斌清 on 2016/12/19.
//  Copyright © 2016年 winphonesoftware. All rights reserved.
//

import UIKit
import MediaPlayer
import Jukebox

class FMPlayerViewController: UIViewController ,JukeboxDelegate{
    
    var url : String?
    
    var FMTitle : String?
    
    var FMNumber : String?
    
    var FMBgImage : String?
    
    
    @IBOutlet weak var bgImage: UIImageView!

    @IBOutlet weak var lastBtn: UIButton!
    
    @IBOutlet weak var nextBtn: UIButton!
    
    @IBOutlet weak var playBtn: UIButton!
    
    @IBOutlet weak var slider: UISlider!
    
    @IBOutlet weak var CurrentTimeLabel: UILabel!
    
    @IBOutlet weak var DurationLabel: UILabel!
    
    @IBOutlet weak var titleName: UILabel!
    
    @IBOutlet weak var listenNum: UILabel!
    
    var jukebox : Jukebox!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        if (jukebox != nil){
//            jukebox.stop()
//        }else{
//            jukebox = Jukebox(delegate: self, items: [JukeboxItem(URL: URL(string: self.url!)!)])!
//        }
        self.titleName.text = self.FMTitle
        self.listenNum.text = String(format:"收听:%@",self.FMNumber!)
        let bgImageUrl = URL(string:(self.FMBgImage)!)
        self.bgImage.kf.setImage(with:bgImageUrl)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
//        jukebox.play()
        FMPlayer.shareInstance.play(url: self.url!, delegate: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    
    // MARK:- Helpers -
    func populateLabelWithTime(_ label : UILabel, time: Double) {
        let minutes = Int(time / 60)
        let seconds = Int(time) - minutes * 60
        label.text = String(format: "%02d", minutes) + ":" + String(format: "%02d", seconds)
    }
    
    func resetUI(){
        DurationLabel.text = "00:00"
        CurrentTimeLabel.text = "00:00"
        slider.value = 0
    }
    
    
    // MARK:- JukeboxDelegate -
    func jukeboxDidLoadItem(_ jukebox: Jukebox, item: JukeboxItem) {
        print("Jukebox did load: \(item.URL.lastPathComponent)")
    }
    
    func jukeboxPlaybackProgressDidChange(_ jukebox: Jukebox) {
        
        if let currentTime = jukebox.currentItem?.currentTime, let duration = jukebox.currentItem?.meta.duration {
            let value = Float(currentTime / duration)
            slider.value = value
            populateLabelWithTime(CurrentTimeLabel, time: currentTime)
            populateLabelWithTime(DurationLabel, time: duration)
        } else {
            resetUI()
        }
    }
    
    
    func jukeboxStateDidChange(_ jukebox: Jukebox) {
        
        if jukebox.state == .ready {
            playBtn.setImage(UIImage(named: "play"), for: UIControlState())
        } else if jukebox.state == .loading  {
            playBtn.setImage(UIImage(named: "pause"), for: UIControlState())
        } else {
            let imageName: String
            switch FMPlayer.shareInstance.jukebox.state {
            case .playing, .loading:
                imageName = "pause"
            case .paused, .failed, .ready:
                imageName = "play"
            }
            playBtn.setImage(UIImage(named: imageName), for: UIControlState())
        }
        print("Jukebox state changed to \(FMPlayer.shareInstance.jukebox.state)")
    }
    
    func jukeboxDidUpdateMetadata(_ jukebox: Jukebox, forItem: JukeboxItem) {
        print("Item updated:\n\(forItem)")
    }
    
    override func remoteControlReceived(with event: UIEvent?) {
        if event?.type == .remoteControl {
            switch event!.subtype {
            case .remoteControlPlay :
                FMPlayer.shareInstance.play(url: self.url!, delegate: self)
            case .remoteControlPause :
                FMPlayer.shareInstance.pause()
            case .remoteControlNextTrack :
                FMPlayer.shareInstance.playNext()
            case .remoteControlPreviousTrack:
                FMPlayer.shareInstance.playPrevious()
            case .remoteControlTogglePlayPause:
                if FMPlayer.shareInstance.jukebox.state == .playing {
                    FMPlayer.shareInstance.pause()
                } else {
                    FMPlayer.shareInstance.play(url: self.url!, delegate: self)
                }
            default:
                break
            }
        }
    }
    
    @IBAction func sliderChange(_ sender: UISlider) {
        if let duration = FMPlayer.shareInstance.jukebox.currentItem?.meta.duration {
            FMPlayer.shareInstance.jukebox.seek(toSecond: Int(Double(slider.value) * duration))
        }
    }
    
    @IBAction func prevAction(_ sender: UIButton) {
        if let time = FMPlayer.shareInstance.jukebox.currentItem?.currentTime, time > 5.0 || FMPlayer.shareInstance.jukebox.playIndex == 0 {
            FMPlayer.shareInstance.jukebox.replayCurrentItem()
        } else {
            FMPlayer.shareInstance.jukebox.playPrevious()
        }
    }
    
    
    @IBAction func nextAction(_ sender: UIButton) {
        FMPlayer.shareInstance.jukebox.playNext()
    }
    
    @IBAction func playPauseAction(_ sender: UIButton) {
        switch FMPlayer.shareInstance.jukebox.state {
        case .ready :
            FMPlayer.shareInstance.jukebox.play(atIndex: 0)
        case .playing :
            FMPlayer.shareInstance.jukebox.pause()
        case .paused :
            FMPlayer.shareInstance.jukebox.play()
        default:
            FMPlayer.shareInstance.jukebox.stop()
        }
    }

    @IBAction func backLastController(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

}
