import UIKit
import EventKit

class LeftViewController: clockViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var time_label: UILabel!
    @IBOutlet weak var date_label: UILabel!
    @IBOutlet weak var table: UITableView!
    
    @IBOutlet weak var half_label: UILabel!
    var labelArray = [UILabel(), UILabel(), UILabel()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        super.c.mainColorItem = [time_label,half_label,date_label]
//        super.c.subColorItem = []
//        super.c.bg = self.view
    }

    @objc override func displayClock() {
        super.displayClock()
        time_label.text = super.hour + " " + super.minute
        half_label.text = super.ampm
        date_label.text = super.date
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (s.設定[.二十四時間表示にする]?.設定値)!{
            half_label.alpha = 0
        }else{
            half_label.alpha = 1
        }
        if (s.設定[.カレンダーイベントを非表示にする]?.設定値)!{
            table.alpha = 0
        }
    }
    @objc func Table_Reload(){
        table.reloadData()
    }
    func tableView(_ table: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        print("テーブルの更新ですよ")
        // イベントストアのインスタンスメソッドで述語を生成.
        var predicate = NSPredicate()
        predicate = myEventStore.predicateForEvents(withStart: Date(),
                                                    end: Date()+60*60*24,
                                                    calendars: nil)
        // 述語にマッチする全てのイベントをフェッチ.
        let events = myEventStore.events(matching: predicate)
        return events.count
    }
    
    func tableView(_ table: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("テーブルの更新ですよ2")
        // イベントストアのインスタンスメソッドで述語を生成.
        var predicate = NSPredicate()
        predicate = myEventStore.predicateForEvents(withStart: Date(),
                                                    end: Date()+60*60*24,
                                                    calendars: nil)
        // 述語にマッチする全てのイベントをフェッチ.
        let events = myEventStore.events(matching: predicate)
        // tableCell の ID で UITableViewCell のインスタンスを生成
        let cell = table.dequeueReusableCell(withIdentifier: "eventCell",
                                             for: indexPath)
        if !events.isEmpty {
            cell.textLabel?.text = events[indexPath.row].title
            
            let DateUtils = DateFormatter()
            DateUtils.dateFormat = "HH:mm"
            let displayTime = DateUtils.string(from: events[indexPath.row].startDate)
            cell.detailTextLabel?.text = displayTime
            
            let testDraw = draw(frame: CGRect(x: 0, y: 0,width: 1000, height: 1000))
            cell.addSubview(testDraw)
            testDraw.isOpaque = false
            return cell
        }
        return cell
    }
}
