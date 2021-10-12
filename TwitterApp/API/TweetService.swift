//
//  TweetService.swift
//  TwitterApp
//
//  Created by L on 2021/10/10.
//

import Firebase

struct TweetService {
    static let shared = TweetService()
    
    func postTweet(caption: String, completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let values = ["uid": uid,
                      "caption":caption,
                      "timestap": Int(NSDate().timeIntervalSince1970),
                      "likes": 0,
                      "retweets": 0] as [String : Any]
        
        REF_TWEETS.childByAutoId().updateChildValues(values, withCompletionBlock: completion)
    }
    
    func fetchTweets(completion: @escaping([Tweet]) -> Void) {
        
        var tweets: [Tweet] = []
        
        REF_TWEETS.observe(.childAdded) { snapshot in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            let tweetID = snapshot.key
            
            // 到tweet獲取uid，再用uid獲取user結構裡對應的用戶。
            UserService.shared.fetchUser(uid: uid) { user in
                let tweet = Tweet(user: user, tweetID: tweetID, dictionary: dictionary)
                tweets.append(tweet)
                completion(tweets)
            }
        }
    }
}
