import UIKit

class draw: UIView {
    override func draw(_ rect: CGRect) {
        
        // UIBezierPath のインスタンス生成
        let line = UIBezierPath();
        
        // 起点
        line.move(to: CGPoint(x: 0, y: 10));
        // 帰着点
        line.addLine(to: CGPoint(x: 0, y: 75));
        line.addLine(to: CGPoint(x: 7, y: 75));
        line.addLine(to: CGPoint(x: 7, y: 10));
        // ラインを結ぶ
        //line.close()
        // ライン幅
        line.lineWidth = 1
        
        let aColor = UIColor(red: 0, green: 0.678, blue: 0.710, alpha: 1.0) //3番目に濃い色
        // 色の設定
        aColor.setFill()
        //塗りつぶし
        line.fill()
    }

}
