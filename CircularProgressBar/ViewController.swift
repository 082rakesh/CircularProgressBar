//
//  ViewController.swift
//  CircularProgressBar
//
//  Created by r.f.kumar.mishra on 27/02/19.
//  Copyright © 2019 r.f.kumar.mishra. All rights reserved.
//

import UIKit

/**
 A view controller that manages progress bar
 */
class ViewController: UIViewController {

    static let audioUrl = "https://www.dropbox.com/s/r6lr4zlw12ipafm/SpeedTracker_movie.mov?dl=1"
    @IBOutlet weak var progressRing: RMCircularProgressBar!

    var percant: CFloat = 0.0 {
        didSet {
            setBar(progress: CGFloat(percant))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupProgresBar()
        downloadAudio()
    }
    
    /**
     Setsup progress bar
     */
    private func setupProgresBar() {
        progressRing.backgroundRingColor = .white
        progressRing.outerRingColor = .green
        progressRing.innerRingColor = .red
        progressRing.lineWidth = 5
    }

    /**
     This method is setting the progress
     - Parameters: progress continues value
     */
    @objc func setBar(progress: CGFloat) {
        progressRing.setProgress(to: progress, withAnimation: true)
    }
    
    /**
     This method is used to download the audio file
     */
    func downloadAudio() {
        let downloadRequest = URLRequest(url: NSURL(string: ViewController.audioUrl)! as URL)
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: self, delegateQueue: OperationQueue.main)
        let downloadTask = session.downloadTask(with: downloadRequest)
        downloadTask.resume()
    }
}

extension ViewController: URLSessionDelegate, URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        // TODO
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64,totalBytesExpectedToWrite: Int64) {
    
        percant = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        print("percant: \(percant)")
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if error != nil {
            print(error?.localizedDescription ?? "response error")
        } else {
            print("finish")
        }
    }
}
