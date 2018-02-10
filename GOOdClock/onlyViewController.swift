import UIKit

class onlyViewController: clockViewController {
    
    @IBOutlet weak var hour_label: UILabel!
    @IBOutlet weak var minute_label: UILabel!
    @IBOutlet weak var second_label: UILabel!
    
    @IBOutlet weak var kari_label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        super.c.mainColorItem = [hour_label,minute_label,second_label]
//        super.c.bg = self.view
    }

    @objc override func displayClock() {
        super.displayClock()
        
        hour_label.text = super.hour
        minute_label.text = ":" + super.minute
        second_label.text = super.secondWithColon
    }
}
