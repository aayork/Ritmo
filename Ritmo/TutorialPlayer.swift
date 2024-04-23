//
//  TutorialPlayer.swift
//  Ritmo
//
//  Created by Aidan York on 4/23/24.
//

import AVKit
import AVFoundation

class TutorialPlayer: ObservableObject {
    func openVideoPlayer(from viewController: UIViewController) {
        guard let path = Bundle.main.path(forResource: "tutorial_placeholder", ofType: "mp4") else {
            print("Invalid URL")
            return
        }
        
        let url = URL(fileURLWithPath: path)
        let player = AVPlayer(url: url)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        
        viewController.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
}
