import UIKit
import EventKit

class twitterViewController: clockViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var time_label: UILabel!
    @IBOutlet weak var date_label: UILabel!
    @IBOutlet weak var table: UITableView!
    
    @IBOutlet weak var half_label: UILabel!
    var labelArray = [UILabel(), UILabel(), UILabel()]
    var タイムライン取得:TWGetHomeTL = TWGetHomeTL()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.isScrollEnabled = false
        table.allowsSelection = false
        
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
        self.タイムライン取得.twConect(TLcount:"10")
        DispatchQueue.main.async {
            self.table.reloadData()
        }
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(Table_Reload), userInfo: nil, repeats: false)
        Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(Table_Reload), userInfo: nil, repeats: false)
//        // 1秒ごとに「displayClock」を実行する
        let timer2 = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(twitter_Reload), userInfo: nil, repeats: true)
        timer2.fire()
    }
    @objc func Table_Reload(){
        table.reloadData()
    }
    @objc func twitter_Reload(){
        self.タイムライン取得.twConect(TLcount:"10")
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(Table_Reload), userInfo: nil, repeats: false)
    }
    func tableView(_ table: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        // tweetsの配列内の要素数分を指定]
        if(self.タイムライン取得.tweets == nil){
            return 0
        }
        print(self.タイムライン取得.tweets.count)
        return self.タイムライン取得.tweets.count
    }
    
    func tableView(_ table: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "TweetTableViewCell") as! TweetTableViewCell
        
        // TweetTableViewCellの描画内容となるtweetを渡す
        cell.fill(tweet: (self.タイムライン取得.tweets[indexPath.row]))
        
        return cell
    }
    // セルの高さ指定をする処理
    func tableView(_ tableFunc: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // UITableViewCellの高さを自動で取得する値
        return UITableViewAutomaticDimension
    }
}

