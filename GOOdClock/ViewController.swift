import UIKit

class ViewController: clockViewController {
    
    @IBOutlet weak var time_label: UILabel!
    @IBOutlet weak var date_label: UILabel!
    @IBOutlet weak var second_label: UILabel!
    
    @IBOutlet weak var Ename_label: UILabel!
    @IBOutlet weak var Etime_label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        super.🎨.mainColorItem = [time_label,date_label,Ename_label]
        super.🎨.subColorItem = [Etime_label,second_label]
        super.🎨.bg = self.view
    }
    
    @objc override func displayClock() {
        super.displayClock()
        time_label.text = super.ampm付きhourMinute(a: Date())
        if (🎛.設定[.日本語表示にする]?.設定値)!{
            second_label.text = super.second + "秒"
        }else{
            second_label.text = ":" + super.second
        }
        
        if 🎛.設定[.秒単位を表示する]?.設定値 == false{
            second_label.alpha = 0
        }else{
            second_label.alpha = 1
        }
        
        date_label.text = super.date
        
        Ename_label.text = super.eTitleText
        Etime_label.text = super.eTimeText
    }
}

