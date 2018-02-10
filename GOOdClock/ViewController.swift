import UIKit

class ViewController: clockViewController {
    
    @IBOutlet weak var time_label: UILabel!
    @IBOutlet weak var date_label: UILabel!
    @IBOutlet weak var second_label: UILabel!
    
    @IBOutlet weak var Ename_label: UILabel!
    @IBOutlet weak var Etime_label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        super.c.mainColorItem = [time_label,date_label,Ename_label]
        super.c.subColorItem = [Etime_label,second_label]
        super.c.bg = self.view
    }
    
    @objc override func displayClock() {
        super.displayClock()
        
        // 0から始まる時刻の場合は「 H:MM:SS」形式にする
        var zeroNasiHour:String = super.hour
        if zeroNasiHour.hasPrefix("0") {
            if let range = zeroNasiHour.range(of: "0") {
                zeroNasiHour.replaceSubrange(range, with: " ")
            }
        }
        
        if (s.設定[.日本語表示にする]?.設定値)!{
            time_label.text = super.ampm + zeroNasiHour + "時" + super.minute + "分"
            second_label.text = super.second + "秒"
        }else{
            time_label.text = super.ampm + " " + zeroNasiHour + ":" + super.minute
            second_label.text = ":" + super.second
        }
        
        if s.設定[.秒単位を表示する]?.設定値 == false{
            second_label.alpha = 0
        }else{
            second_label.alpha = 1
        }
        
        date_label.text = super.date
        
        Ename_label.text = super.eTitleText
        Etime_label.text = super.eTimeText
    }
}

