import Foundation
import TwitterKit

class TWGetHomeTL {
    var tweets: [Tweet] = []
    var clientError: NSError?
    func twConect(TLcount:String) {
        //Twitterログイン認証トークンの有無を確認
        if Twitter.sharedInstance().sessionStore.hasLoggedInUsers() {
            if let session = Twitter.sharedInstance().sessionStore.session() {
                print(session.userID)
            } else {
                print("アカウントはありません")
            }
            print("ここまで通ってます")
            let session = Twitter.sharedInstance().sessionStore.session()
            let apiClient = TWTRAPIClient(userID: session?.userID)
            let request = apiClient.urlRequest(
                withMethod: "GET",
                url: "https://api.twitter.com/1.1/statuses/home_timeline.json",
                /*url: https://api.twitter.com/1.1/followers/list.json,*/
                parameters: [
                    "user_id": session?.userID,
                    "count": "10", // Intで10を渡すとエラーになる模様で、文字列にしてやる必要がある
                ],
                error: &clientError
            )
            apiClient.sendTwitterRequest(request) { response, data, error in // NSURLResponse?, NSData?, NSError?
                if let error = error {
                    print("エラーですよ")
                    print(error.localizedDescription)
                    let sessionStore = Twitter.sharedInstance().sessionStore

                    // アクティブなアカウントのsessionを取得
                    if let session = sessionStore.session() {
                        // userIDでログアウト
                        sessionStore.logOutUserID(session.userID)
                    }
                } else if let data = data, let _ = String(data: data, encoding: .utf8) {
                    let timelineParser = TimelineParser()
                    self.tweets = timelineParser.parse(data: data)
                }
            }
        } else {
            //Twitterログイン処理
            Twitter.sharedInstance().logIn(completion: { (session, error) in
                if session != nil {
                    //print("signed in as \(String(describing: session?.userName))")
                } else {
                    //print("error: \(String(describing: error?.localizedDescription))")
                }
            })
        }
    }
}
    

