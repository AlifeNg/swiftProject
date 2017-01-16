//
//  FMPlayer.swift
//  weibo
//
//  Created by lizhang on 2017/1/5.
//  Copyright © 2017年 winphonesoftware. All rights reserved.
//

import UIKit
import MediaPlayer
import Jukebox

class FMPlayer: NSObject{
    
    var playUrl:String = ""
    var jukebox : Jukebox!
    static var shareInstance: FMPlayer{
        struct MyStatic{
            static var instance :FMPlayer = FMPlayer()
        }
        return MyStatic.instance;
    }
    
    func play(url:String, delegate: FMPlayerViewController) {
        if jukebox != nil &&  url == playUrl{
            jukebox.play()
        }else{
            if jukebox != nil {
                jukebox.stop()
                jukebox = nil
            }
            playUrl = url
            jukebox = Jukebox(delegate: delegate, items: [JukeboxItem(URL: URL(string: playUrl)!)])!
            jukebox.play()
        }
    }
    
    func stop() {
        jukebox.stop()
    }
    
    func pause() {
        jukebox.pause()
    }
    
    func playNext() {
       jukebox.playNext()
    }
    
    func playPrevious() {
        jukebox.playPrevious()
    }
}
