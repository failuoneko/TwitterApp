//
//  TweetService.swift
//  TwitterApp
//
//  Created by L on 2021/10/10.
//

import Firebase

struct TweetService {
    static let shared = TweetService()
    
    // MARK: - upload data
    
    func postTweet(caption: String, type: PostTweetConfiguration, completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        var values = ["uid": uid,
                      "caption":caption,
                      "timestamp": Int(NSDate().timeIntervalSince1970),
                      "likes": 0,
                      "retweets": 0] as [String : Any]
        
        switch type {
        case .tweet:
            
            // 推文上傳後，推文ID上傳到"user_tweets"。
            REF_TWEETS.childByAutoId().updateChildValues(values) { error, ref in
                guard let tweetID = ref.key else { return }
                REF_USER_TWEETS.child(uid).updateChildValues([tweetID: 1], withCompletionBlock: completion)
            }
        case .reply(let tweet):
            
            // 回覆時獲取該User的username。
            values["replyingToUser"] = tweet.user.username
            
            // 回文。傳送values資料到tweet_replies。
            REF_TWEET_REPLIES.child(tweet.tweetID).childByAutoId().updateChildValues(values) { error, ref in
                guard let replayKey = ref.key else { return }
                REF_USER_REPLIES.child(uid).updateChildValues([tweet.tweetID: replayKey],withCompletionBlock: completion)
            }
        }
    }
    
    func likeTweet(tweet: Tweet, completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let likes = tweet.didLike ? tweet.likes - 1 : tweet.likes + 1
            
        if tweet.isReply {
            print("DEBUG: is reply like")
        } else {
            REF_TWEETS.child(tweet.tweetID).child("likes").setValue(likes)
            print("DEBUG: is not reply like")
        }
        
        if tweet.didLike {
            // unlike tweet
            REF_USER_LIKES.child(uid).child(tweet.tweetID).removeValue { error, ref in
                REF_TWEET_LIKES.child(tweet.tweetID).removeValue(completionBlock: completion)
            }
        } else {
            // like tweet
            REF_USER_LIKES.child(uid).updateChildValues([tweet.tweetID: 1]) { error, ref in
                REF_TWEET_LIKES.child(tweet.tweetID).updateChildValues([uid: 1], withCompletionBlock: completion)
            }
        }
    }
    
    // MARK: - fetch data
    
    func fetchTweets(completion: @escaping([Tweet]) -> Void) {
        
        var tweets: [Tweet] = []
        
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        REF_USER_FOLLOWING.child(currentUid).observe(.childAdded) { snapshot in
            let followingUid = snapshot.key
            
            REF_USER_TWEETS.child(followingUid).observe(.childAdded) { snapshot in
                let tweetID = snapshot.key
                
                self.fetchOneTweet(withTweetID: tweetID) { tweet in
                    tweets.append(tweet)
                    completion(tweets)
                }
            }
        }
        
        REF_USER_TWEETS.child(currentUid).observe(.childAdded) { snapshot in
            let tweetID = snapshot.key
            
            self.fetchOneTweet(withTweetID: tweetID) { tweet in
                tweets.append(tweet)
                completion(tweets)
            }
        }
    }
    
    func fetchUserTweets(forUser user: User, completion: @escaping([Tweet]) -> Void) {
        
        var tweets: [Tweet] = []
        
        // 從user_tweets獲取user.uid後，再去找到對應的tweet。
        REF_USER_TWEETS.child(user.uid).observe(.childAdded) { snapshot in
            let tweetID = snapshot.key
            
            self.fetchOneTweet(withTweetID: tweetID) { tweet in
                tweets.append(tweet)
                completion(tweets)
            }
        }
    }
    
    func fetchOneTweet(withTweetID tweetID: String, completion: @escaping(Tweet) -> Void) {
        REF_TWEETS.child(tweetID).observeSingleEvent(of: .value) { snapshot in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            UserService.shared.fetchUser(uid: uid) { user in
                let tweet = Tweet(user: user, tweetID: tweetID, dictionary: dictionary)
                completion(tweet)
            }
        }
    }
    
    func fetchUserReplies(forUSer user: User, completion: @escaping([Tweet]) -> Void) {
        var replies: [Tweet] = []
        REF_USER_REPLIES.child(user.uid).observe(.childAdded) { snapshot in
            let tweetKey = snapshot.key
            guard let replayKey = snapshot.value as? String else { return}
            
            REF_TWEET_REPLIES.child(tweetKey).child(replayKey).observeSingleEvent(of: .value) { snapshot in
                guard let dictionary = snapshot.value as? [String: Any] else { return }
                guard let uid = dictionary["uid"] as? String else { return }
                let replyID = snapshot.key
                
                UserService.shared.fetchUser(uid: uid) { user in
                    let reply = Tweet(user: user, tweetID: replyID, dictionary: dictionary)
                    replies.append(reply)
                    completion(replies)
                }
            }
        }
    }
    
    func fetchReplies(forTweet tweet: Tweet, completion: @escaping([Tweet]) -> Void) {
        var tweets: [Tweet] = []
        
        REF_TWEET_REPLIES.child(tweet.tweetID).observe(.childAdded) { snapshot in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            let tweetID = snapshot.key
            UserService.shared.fetchUser(uid: uid) { user in
                let tweet = Tweet(user: user, tweetID: tweetID, dictionary: dictionary)
                tweets.append(tweet)
                completion(tweets)
            }
        }
    }
    
    func fetchLikes(forUser user: User, completion: @escaping([Tweet]) -> Void) {
        var tweets: [Tweet] = []
        REF_USER_LIKES.child(user.uid).observe(.childAdded) { snapshot in
            let tweetID = snapshot.key // 獲取user_likes裡的key(tweetID)。
            self.fetchOneTweet(withTweetID: tweetID) { likedTweet in
                var tweet = likedTweet // likePage也顯示已按讚。
                tweet.didLike = true
                tweets.append(tweet)
                completion(tweets)
            }
        }
    }
    
    // 到user_likes的用戶ID裡確認是否有按讚的tweetID。
    func checkIsUserLikedTweet(_ tweet: Tweet, completion: @escaping(Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        REF_USER_LIKES.child(uid).child(tweet.tweetID).observeSingleEvent(of: .value) { snapshot in
            completion(snapshot.exists())
        }
    }
    
}
