//
//  ViewController.swift
//  RMPlayer
//
//  Created by Michealbad on 16/3/22.
//  Copyright © 2016年 Michealbad. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices

class ViewController: UIViewController {
    
    var avplayer: AVPlayer!
    var dateFormatter: NSDateFormatter! = NSDateFormatter()
    var duration: CMTime!
    var background: UIImageView!
    var lrcViewDelegate: LrcViewDelegate!
    var LRCTime: [String] = []
    var isDragging: Bool = false
    
    @IBOutlet weak var audioProcessing: UISlider!
    @IBOutlet weak var processingTime: UILabel!
    @IBOutlet weak var durationTime: UILabel!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var song: UILabel!
    @IBOutlet weak var singerAndAlbum: UILabel!
    @IBOutlet weak var loadedProcessing: UIProgressView!
    @IBOutlet weak var LrcView: UITableView!
    
    var resourceLoader: RMAvassetResourceLoader = RMAvassetResourceLoader()
    
    enum PlayerStatus: Int {
        case playing = 0
        case paused
    }
    
    private var status: PlayerStatus = .paused
    
    func songURL() -> NSURL {
        //http://www.abstractpath.com/files/audiosamples/sample.mp3
        //http://www.baidu190.com/md5/691f75227b6a645659da4128f7478145.mp3
        //http://www.baidu190.com/md5/648FF8889D04E92DB3E8C8C1981CB6C6.mp3
        //http://www.baidu190.com/md5/691f75227b6a645659da4128f7478145.mp3 viva la vida
        return NSURL(string: "http://m2.music.126.net/WO9d282kU2iGYcztn1xNdw==/1234751557993488.mp3")!
    }
    
    func songWithCoutomScheme(scheme: String) -> NSURL {
        let compnents = NSURLComponents(URL: self.songURL(), resolvingAgainstBaseURL: false)
        compnents?.scheme = scheme
        
        return (compnents?.URL)!
    }
    
    func playSong() {
        resourceLoader.cachedFilePath = NSTemporaryDirectory().stringByAppendingString("cached.mp3")
        let possibleData = NSData(contentsOfFile: resourceLoader.cachedFilePath as String) as NSData!
        if possibleData != nil && possibleData?.length != 0 {
            resourceLoader.loadFromDisk = true
            resourceLoader.songData = possibleData.mutableCopy() as! NSMutableData
        } else {
            resourceLoader.loadFromDisk = false
            resourceLoader.songData = nil
        }
        
        let asset = AVURLAsset(URL: self.songWithCoutomScheme("streaming"), options: nil)
        asset.resourceLoader.setDelegate(resourceLoader, queue: dispatch_get_main_queue())
        
        let playerItem = AVPlayerItem(asset: asset)
        playerItem.addObserver(self, forKeyPath: "status", options: .New, context: nil)
        playerItem.addObserver(self, forKeyPath: "loadedTimeRanges", options: .New, context: nil)
        avplayer = AVPlayer(playerItem: playerItem)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.background = UIImageView(frame: self.view.bounds)
        self.background.image = UIImage(named: "background")
        self.background.contentMode = .ScaleAspectFill
        self.view.addSubview(self.background)
        self.view.sendSubviewToBack(self.background)
        let thumbImage = UIImage(named: "thumb")
        self.audioProcessing.setThumbImage(thumbImage, forState: .Normal)
        self.audioProcessing.setThumbImage(thumbImage, forState: .Highlighted)
        
        self.playSong()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //self.loadedProcessing.frame.origin.y += 10
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        let playerItem = object as! AVPlayerItem
        if keyPath == "status" {
            //print("here")
            if playerItem.status == .ReadyToPlay {
                print("ready to play")
                
                self.duration = playerItem.duration
                self.makeSlider(duration)
                self.prepareLRC()
                self.observePlayback()
                
                self.avplayer.play()
                self.setStatus(.playing)
                self.playBtn.setImage(UIImage(named: "pause"), forState: .Normal)
            } else if playerItem.status == .Failed {
                self.setStatus(.paused)
                print("fail playing audio")
                print(playerItem.error)
            }
        } else if keyPath == "loadedTimeRanges" {
            let totalSeconds = CMTimeGetSeconds(playerItem.duration)
            let loadedSeconds = self.availableDuration()
            self.loadedProcessing.setProgress(Float(loadedSeconds/totalSeconds), animated: true)
        }
    }
    
    func makeSlider(duration: CMTime) {
        self.audioProcessing.maximumValue = Float(CMTimeGetSeconds(duration))
        self.audioProcessing.setValue(0, animated: false)
        
        self.durationTime.text = self.convertTime(CMTimeGetSeconds(duration))
    }
    
    func observePlayback() {
        weak var weakSelf = self
        self.avplayer.addPeriodicTimeObserverForInterval(CMTimeMake(1, 1), queue: nil) {
            processing in
            let currentTime = Double(processing.value) / Double(processing.timescale)
            
            if self.isDragging == false {
                weakSelf?.audioProcessing.setValue(Float(currentTime), animated: true)
                weakSelf?.processingTime.text = weakSelf?.convertTime(currentTime)
                weakSelf?.durationTime.text = "-"+(weakSelf?.convertTime(CMTimeGetSeconds(weakSelf!.duration) - currentTime))!
            }
            self.scrollToLRCline()
        }
    }
    
    func prepareLRC() {
        self.lrcViewDelegate = LrcViewDelegate()
        self.lrcViewDelegate.LRC = self.expandLRCfromFile("paradise")
        
        self.LrcView.delegate = self.lrcViewDelegate
        self.LrcView.dataSource = self.lrcViewDelegate
        self.LrcView.reloadData()
    }
    
    func convertTime(seconds: Double) -> String {
        let date = NSDate(timeIntervalSince1970: seconds)
        if seconds/3600 >= 1 {
            self.dateFormatter.setLocalizedDateFormatFromTemplate("HH:mm:ss")
        } else {
            self.dateFormatter.setLocalizedDateFormatFromTemplate("mm:ss")
        }
        return self.dateFormatter.stringFromDate(date)
    }
    
    func availableDuration() -> NSTimeInterval {
        let loadedTimeRange = self.avplayer.currentItem?.loadedTimeRanges
        let timeRange = loadedTimeRange?.first?.CMTimeRangeValue
        let startPoint = CMTimeGetSeconds(timeRange!.start)
        let endPoint = CMTimeGetSeconds(timeRange!.end)
        //print("\(startPoint) \(endPoint)")
        return startPoint + endPoint
    }
    
    func scrollToLRCline() {
        let currentPlayingTime = self.convertTime(Double(self.avplayer.currentTime().value) / Double(self.avplayer.currentTime().timescale))
        for index in 1 ..< self.LRCTime.count {
            if currentPlayingTime == self.LRCTime[index] {
                self.LrcView.selectRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0), animated: true, scrollPosition: .Middle)
                break
            }
        }
    }
    
    @IBAction func playBtnClicked(sender: AnyObject) {
        switch self.status {
        case .paused:
            self.avplayer.play()
            self.setStatus(.playing)
        case .playing:
            self.avplayer.pause()
            self.setStatus(.paused)
        }
    }
    
    @IBAction func audioProcessingDidDragEnd(sender: AnyObject) {
        self.isDragging = false
        
        let slider = sender as! UISlider
        //print(slider.value)
        let time = CMTimeMakeWithSeconds(Double(slider.value), 1)
        
        self.processingTime.text = self.convertTime(Double(slider.value))
        self.scrollToLRCline()
        
        weak var weakSelf = self
        self.avplayer.seekToTime(time, completionHandler: { _ in
            weakSelf?.avplayer.play()
            weakSelf?.setStatus(.playing)
        })
    }
    
    @IBAction func audioProcessingIsDragging(sender: AnyObject) {
        self.isDragging = true
        
        let slider = sender as! UISlider
        self.processingTime.text = self.convertTime(Double(slider.value))
        self.durationTime.text = "-"+self.convertTime(CMTimeGetSeconds(self.duration) - Double(slider.value))
    }
    
    
    func textSong(song: String) {
        self.song.text = song
    }
    
    func textSingerAndAlbum(singer: String, album: String) {
        self.singerAndAlbum.text = singer + " - " + album
    }
    
    func setStatus(newStatus: PlayerStatus) {
        if newStatus == .playing {
            self.playBtn.setImage(UIImage(named: "pause"), forState: .Normal)
            self.status = .playing
        } else {
            self.playBtn.setImage(UIImage(named: "play"), forState: .Normal)
            self.status = .paused
        }
    }
    
    func expandLRCfromFile(fileName: String) -> [(String,String)]{
        let lrcPath = NSBundle.mainBundle().pathForResource(fileName, ofType: "txt")
        var lrcDictionary: [String:String] = [:]
        do {
            let lrcString = try String(contentsOfFile: lrcPath!)
            let lrcArray = lrcString.componentsSeparatedByString("\n")
            for index in 0  ..< lrcArray.count {
                let lineArray = lrcArray[index].componentsSeparatedByString("]")
                if lineArray[0].lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 8 {
                    for index1 in 0 ..< lineArray.count-1 {
                        let str1 = (lineArray[index1] as NSString).substringWithRange(NSRange(location: 3,length: 1))
                        let str2 = (lineArray[index1] as NSString).substringWithRange(NSRange(location: 6,length: 1))
                        if str1 == ":" && str2 == "." {
                            let lrcSQ = lineArray[lineArray.count - 1]
                            let timeLE = (lineArray[index1] as NSString).substringWithRange(NSRange(location: 1,length: 5))
                            self.LRCTime.append(timeLE)
                            lrcDictionary[timeLE] = lrcSQ
                        }
                    }
                }
            }
            var timeLrcArray = lrcDictionary.sort({
                dic1, dic2 in
                let lenght1 = dic1.0.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
                let lenght2 = dic2.0.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
                let count = lenght1>lenght2 ? lenght2 : lenght1
                var index = 0
                while index < count {
                    let c1 = (dic1.0 as NSString).characterAtIndex(index)
                    let c2 = (dic2.0 as NSString).characterAtIndex(index)
                    if c1 == c2 {
                        index += 1
                    } else {
                        return c1 < c2
                    }
                }
                return false
            })
            self.LRCTime.insert(" ", atIndex: 0)
            timeLrcArray.insert((" "," "), atIndex: 0)
            return timeLrcArray
        } catch let e {
            print(e)
        }
        return [("","")]
    }
}





















