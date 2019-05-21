//時計汎用クラス

import UIKit
import EventKit

class clockViewController:UIViewController{
    let myEventStore:EKEventStore = EKEventStore()
    let s = 設定管理()
    let c = color_switch()
    let 🎨 = "test"
    
    var ampm:String = ""
    var date:String = ""
    
    var hour:String = ""
    var minute:String = ""
    var second:String = ""
    
    var eTitleText:String = ""
    var eTimeText:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        if s.設定[.環境光による昼夜モードの自動切り替え]?.設定値 == true{
            NotificationCenter.default.addObserver(self,
                                               selector: #selector(screenBrightnessDidChange(_:)),
                                               name: UIScreen.brightnessDidChangeNotification,
                                               object: nil)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        eventGet()
        // 一定間隔で実行
        if s.選択されたテーマのタイトル == .左右分割
            || s.選択されたテーマのタイトル == .スタンダード{
            let time2 = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(eventGet), userInfo: nil, repeats: true)
            time2.fire()
        }
        // 1秒ごとに「displayClock」を実行する
        let timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(displayClock), userInfo: nil, repeats: true)
        timer.fire()    // 無くても動くけどこれが無いと初回の実行がラグる

        if (s.設定[.夜テーマにする]?.設定値)!{
            c.dayNightChange("night")
        }else{
            c.dayNightChange("day")
        }

        if (s.設定[.緑ベースの配色にする]?.設定値)!{
            c.colorThemeChange(colorTheme: "color1")
        }
    }
    
    @objc func displayClock() {
        let hour_formatter = DateFormatter()
        let minute_formatter = DateFormatter()
        let date_formatter = DateFormatter()
        let second_formatter = DateFormatter()
        
        hour_formatter.dateFormat = "HH"
        minute_formatter.dateFormat = "mm"
        second_formatter.dateFormat = "ss"
        
        if (s.設定[.日本語表示にする]?.設定値)!{
            date_formatter.locale = NSLocale(localeIdentifier: "ja_JP") as Locale?
            date_formatter.dateFormat = "yyyy年MM月dd日 E曜日"
        }else{
            date_formatter.dateFormat = "yyyy/MM/dd EEE"
        }
        
        // 現在時刻を取得
        var hourTime = hour_formatter.string(from: Date())
        let minuteTime = minute_formatter.string(from: Date())
        let secondTime = second_formatter.string(from: Date())
        
        //24時間表示か確認
        if(s.設定[.二十四時間表示にする]?.設定値 == false){
            if (s.設定[.日本語表示にする]?.設定値)!{
                ampm = "午前"
            }else{
                ampm = "AM"
            }
            if Int(hourTime.substring(to:hourTime.index(hourTime.startIndex, offsetBy: 2))) != nil {
                if(Int(hourTime.substring(to: hourTime.index(hourTime.startIndex, offsetBy: 2)))! > 12) {
                    if (s.設定[.日本語表示にする]?.設定値)!{
                        ampm = "午後"
                    }else{
                        ampm = "PM"
                    }
                    hourTime = hour_formatter.string(from: Date()-60*60*12)
                }
            } else {
                print("変換できません")
            }
        }
        
        hour = hourTime
        minute = minuteTime
        second = secondTime

        date = date_formatter.string(from: Date())
    }
    func ampm付きhourMinute(a:Date) ->String{
        var e_ampm:String = ""
        var e_hour:String = ""
        var e_minute:String = ""
        var e_hour区切り文字:String = ""
        var e_minute区切り文字:String = ""
        var e_day:String = ""
        
        let hour_formatter = DateFormatter()
        let minute_formatter = DateFormatter()
        
        hour_formatter.dateFormat = "H"
        minute_formatter.dateFormat = "mm"
        
        // 現在時刻を取得
        var hourTime = hour_formatter.string(from: a)
        let minuteTime = minute_formatter.string(from: a)
        
        //24時間表示か確認
        if(s.設定[.二十四時間表示にする]?.設定値 == false){
            if (s.設定[.日本語表示にする]?.設定値)!{
                e_ampm = "午前 "
            }else{
                e_ampm = "AM "
            }
            if Int(hourTime.substring(to:hourTime.index(hourTime.startIndex, offsetBy: 2))) != nil {
                if(Int(hourTime.substring(to: hourTime.index(hourTime.startIndex, offsetBy: 2)))! > 12) {
                    if (s.設定[.日本語表示にする]?.設定値)!{
                        e_ampm = "午後 "
                    }else{
                        e_ampm = "PM "
                    }
                    hourTime = hour_formatter.string(from: a-60*60*12)
                }
            } else {
                print("変換できません")
            }
        }
        e_hour = hourTime
//      0から始まる時刻の場合は「 H:MM:SS」形式にする
        var zeroNasiHour:String = e_hour
        if zeroNasiHour.hasPrefix("0") {
            if let range = zeroNasiHour.range(of: "0") {
                zeroNasiHour.replaceSubrange(range, with: " ")
            }
        }
        e_minute = minuteTime
        
        //区切り文字の判断
        if (s.設定[.日本語表示にする]?.設定値)!{
            e_hour区切り文字 = "時"
            e_minute区切り文字 = "分"
        }else{
            e_hour区切り文字 = ":"
            e_minute区切り文字 = ""
        }
        
        let judgFormatter = DateFormatter()
        judgFormatter.dateFormat = "dd"
        //今の日付と，イベントの日付を見比べて違かったら'明日'をつける
        if(judgFormatter.string(from: Date()) != judgFormatter.string(from: a)) {
            if(s.設定[.日本語表示にする]?.設定値 == true){
                e_day = "明日 "
            }else if(s.設定[.日本語表示にする]?.設定値 == false){
                e_day = "tomorrow "
            }
        }
        return e_day +  e_ampm + e_hour + e_hour区切り文字 + e_minute + e_minute区切り文字
    }
    
    @objc func eventGet() {
        // イベントストアのインスタンスメソッドで述語を生成.
        var predicate = NSPredicate()
        predicate = myEventStore.predicateForEvents(withStart: Date(),
                                                    end: Date()+60*60*24,
                                                    calendars: nil)
        // 述語にマッチする全てのイベントをフェッチ.
        let events = myEventStore.events(matching: predicate)
        
        
        if !events.isEmpty {
            var w=0
            for i in events{
                if(w==0){
                    eTitleText = i.title
                    eTimeText = ampm付きhourMinute(a: i.startDate)
                    w=w+1
                }
            }
        }else{
            eTitleText =  "しばらく予定は\nないようです"
        }
    }
    
    @objc func screenBrightnessDidChange(_ notification: Notification) {
        if UIScreen.main.brightness < 0.5{//実際には0.2ぐらいが良さそう
            c.昼か夜か = "night"
        }else{
            c.昼か夜か = "day"
        }
        c.colorReload()
        print("明るさ変わった->",UIScreen.main.brightness)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
