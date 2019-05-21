import UIKit
import EventKit

class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let 🎛 = 設定管理()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        accessApplication()
    }
    
    //画面遷移
    @IBAction func ApplyButton(_ sender: Any) {
        if 🎛.選択されたテーマのタイトル == .スタンダード{
            let targetViewController = storyboard!.instantiateViewController(withIdentifier: 🎛.選択されたテーマのタイトル.rawValue) as! ViewController
            self.present( targetViewController, animated: true)
        }else if 🎛.選択されたテーマのタイトル == .左右分割{
            let targetViewController = storyboard!.instantiateViewController(withIdentifier: 🎛.選択されたテーマのタイトル.rawValue) as! LeftViewController
            self.present( targetViewController, animated: true)
        }else if 🎛.選択されたテーマのタイトル == .シンプル{
            let targetViewController = storyboard!.instantiateViewController(withIdentifier: 🎛.選択されたテーマのタイトル.rawValue) as! onlyViewController
            self.present( targetViewController, animated: true)
        }
        
    }
    
    @IBOutlet weak var SettingTableView: UITableView!
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 0){
            return "テーマ"
        }
        else if(section == 1){
            return "詳細設定"
        }
        return "ラベル"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            return 🎛.テーマ.count
        }
        else if(section == 1){
            return 🎛.表示する設定項目の順番.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section == 0){
            🎛.選択されたテーマのタイトル = 🎛.テーマ[indexPath.row].タイトル!
            🎛.テーマをこれに変更し保存する(🎛.テーマ[indexPath.row].タイトル!)
            self.SettingTableView.reloadSections([indexPath.section], with: UITableView.RowAnimation.fade)
        }
        return
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.section == 0){
            return 100
        }
        else {
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let themecell: ThemeTableViewCell
        let advancedsettingcell: SwitchTableViewCell
        
        if(indexPath.section == 0){
            themecell = SettingTableView.dequeueReusableCell(withIdentifier: "ThemeCell", for: indexPath) as! ThemeTableViewCell
            themecell.ThemeImageView.image = 🎛.テーマ[indexPath.row].サムネ画像
            if (🎛.テーマ[indexPath.row].タイトル == 🎛.選択されたテーマのタイトル){
                themecell.CheckLabel.text = "✔️"
            }
            else {
                themecell.CheckLabel.text = ""
            }
            themecell.ThemeLabel.text = 🎛.テーマ[indexPath.row].タイトル?.rawValue
            
            return themecell
        }
        else{
            let こうもく:設定仕様.タイトル一覧 = 🎛.表示する設定項目の順番[indexPath.row]
            advancedsettingcell = SettingTableView.dequeueReusableCell(withIdentifier: "AdvancedSettingCell", for: indexPath) as! SwitchTableViewCell
            advancedsettingcell.textLabel?.text = こうもく.rawValue
            advancedsettingcell.textLabel?.backgroundColor = .clear
            advancedsettingcell.swtich.addTarget(self, action: #selector(checkButtonTapped), for: UIControl.Event.valueChanged)
            advancedsettingcell.swtich.setOn((🎛.設定[こうもく]?.設定値)!, animated: false)
            
            return advancedsettingcell
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    /*
     accessoryButtonTappedForRowWithIndexPathへパスを出す。
     これでOK.
     */
    @objc func checkButtonTapped(sender: UISwitch, event: UIEvent) {
        let hoge = sender.superview?.superview as! SwitchTableViewCell
        let touchIndex = SettingTableView.indexPath(for: hoge)?.row
        let a:設定仕様.タイトル一覧 = 🎛.表示する設定項目の順番[touchIndex!]
        if 🎛.設定[a]?.設定値 == true {
            🎛.設定[a]?.設定値 = false
        }else{
            🎛.設定[a]?.設定値  = true
        }
        🎛.設定値を保存(変更するkey: a.rawValue, 保存する値: (🎛.設定[a]?.設定値)!)
    }
    
    func accessApplication()
    {
        // カレンダー追加の権限ステータスを取得
        let authStatus = EKEventStore.authorizationStatus(for: .event)
        
        switch authStatus {
        case .authorized: break
        case .denied: break
        case .restricted: break
        case .notDetermined:
            EKEventStore().requestAccess(to: .event, completion: { (result:Bool, error:Error?) in
                if result {
                    //                    self.eventGet()
                } else {
                    // 使用拒否
                }
            })
        @unknown default:
            fatalError()
        }
    }
    
    @IBAction func backToTop(segue: UIStoryboardSegue) {}
    
}

