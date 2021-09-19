//
//  CMTime.swift
//  Podcasts
//
//  Created by Artem Ekimov on 12.09.2021.
//

import AVKit

extension CMTime {
    func toDisplayString() -> String {
        
        if CMTimeGetSeconds(self).isNaN {
            return "--:--"
        }
        let totalSeconds = Int(CMTimeGetSeconds(self))
        
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds - hours * 3600) / 60
        let seconds = totalSeconds % 60
        
        let timeFormatString = String(format: "%02d:%02d:%02d", arguments: [hours, minutes, seconds])
        return timeFormatString
    }
}
