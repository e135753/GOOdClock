import UIKit

//昼夜モードと配色パターンの変更を行うためのclass
class 🎨👩‍🎨{
    var 色 = "color0"
    var 昼か夜か = "day"
    var mainColorItem:[UILabel] = []
    var subColorItem:[UILabel] = []
    var bg:UIView? = nil
    
    //昼夜モードの配色に変更
    func colorReload(){
        let filePath = 色 + "/" + 昼か夜か
        for i in mainColorItem{
            i.textColor = UIColor(named: filePath + "1")
        }
        for i in subColorItem{
            i.textColor = UIColor(named: filePath + "2")
        }
        bg?.backgroundColor = UIColor(named: filePath + "3")
    }
    
    func dayNightChange(_ a:String){
        昼か夜か = a
        colorReload()
    }
    
    //配色パターンの変更
    func colorThemeChange(colorTheme:String){
        色 = colorTheme
        colorReload()
    }
}

