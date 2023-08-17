
import UIKit
import Foundation
import CoreLocation


var greeting = "Hello, playground"

class MyView: UIView {
    var pageSize: CGSize = CGSize(width: 800, height: 600) {
        didSet {
            self.setNeedsLayout()
        }
    }
}

struct GPSTrack {
    private(set) var record: [(CLLocation, Date)] = []
}

extension GPSTrack {
    var timeStamps: [Date] {
        return record.map { $0.1 }
    }
}


class GPSTrackViewController: UIViewController {
    var track: GPSTrack = GPSTrack()
    lazy var preview: UIImage = {
        for point in track.record {
            
        }
        return UIImage()
    }()
}
