import UIKit

extension UIView {
    var x: CGFloat {
        get {
            return self.frame.origin.x
        }
        set(value) {
            self.frame.origin.x = value
        }
    }
    var y: CGFloat {
        get {
            return self.frame.origin.y
        }
        set(value) {
            self.frame.origin.y = value
        }
    }
    var width: CGFloat {
        get {
            return self.frame.size.width
        }
        set(value) {
            self.frame.size.width = value
        }
    }
    var height: CGFloat {
        get {
            return self.frame.size.height
        }
        set(value) {
            self.frame.size.height = value
        }
    }
    var centerX: CGFloat {
        get {
            return self.center.x
        }
        set(value) {
            self.center.x = value
        }
    }
    var centerY: CGFloat {
        get {
            return self.center.y
        }
        set(value) {
            self.center.y = value
        }
    }
}