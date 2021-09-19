//
//  PlayerDetailsView+Gesture.swift
//  Podcasts
//
//  Created by Artem Ekimov on 15.09.2021.
//

import UIKit

extension PlayerDetailsView {
    
@objc func handlePan(gesture: UIPanGestureRecognizer) {

    if gesture.state == .changed {
        handlePanChanged(gesture: gesture)
    } else if gesture.state == .ended {
        handlePanEnded(gesture: gesture)
    }
}

func handlePanChanged(gesture: UIPanGestureRecognizer) {
    let translation = gesture.translation(in: self.superview)
    self.transform = CGAffineTransform(translationX: 0, y: translation.y)
    
    self.miniPlayerView.alpha = 1 + translation.y / 200
    self.maximizedStackView.alpha = -translation.y / 200
}

func handlePanEnded(gesture: UIPanGestureRecognizer) {
    
        let velocity = gesture.velocity(in: self.superview)
        let translation = gesture.translation(in: self.superview)

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut) {
            print("ended")
            self.transform = .identity
            
            if translation.y < -200 || velocity.y < -600 {
                UIApplication.mainTabBarController()?.maximizedPlayerDetails(episode: nil)
            } else {
                self.miniPlayerView.alpha = 1
                self.maximizedStackView.alpha = 0
            }
        }
}

@objc func handleTapMaximize() {
    UIApplication.mainTabBarController()?.maximizedPlayerDetails(episode: nil)
}
}
