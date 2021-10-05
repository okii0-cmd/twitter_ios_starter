//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by okii on 4/10/21.
//  Copyright © 2021 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    var tweetArray = [NSDictionary]()
    var numberOfTweet: Int!
    let myRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTweet()
        myRefreshControl.addTarget(self, action: #selector(loadTweet) , for: .valueChanged)
        tableView.refreshControl = myRefreshControl
    }
    
    
    
    @objc func loadTweet(){
        numberOfTweet = 20
        let myParam = ["count": numberOfTweet]
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParam, success:{ (tweets: [NSDictionary]) in
            self.tweetArray.removeAll()
            for tweet in tweets{
                self.tweetArray.append(tweet)
            }
            self.tableView.reloadData()
            self.myRefreshControl.endRefreshing()
        }, failure: { (Error) in
            print("Could not retreive tweets!")
        })
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath:IndexPath){
        if (indexPath.row + 1 == tweetArray.count){
            loadMoreTweet()
        }
    }
    


func loadMoreTweet(){
    let myParam = ["count": (numberOfTweet + 20)]
    let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
    TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParam, success:{ (tweets: [NSDictionary]) in
        self.tweetArray.removeAll()
        for tweet in tweets{
            self.tweetArray.append(tweet)
        }
        self.tableView.reloadData()
        self.myRefreshControl.endRefreshing()
    }, failure: { (Error) in
        print("Could not retreive tweets!")
    })
}



@IBAction func onLogout(_ sender: Any) {
    TwitterAPICaller.client?.logout()
    self.dismiss(animated: true, completion: nil)
    UserDefaults.standard.set(false, forKey: "userLoggedIn")
}

override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCellTableViewCell
    let user = tweetArray[indexPath.row]["user"] as! NSDictionary
    let imageUrl = URL(string: (user["profile_image_url_https"] as? String)!)
    let data = try? Data(contentsOf: imageUrl!)
    
    if let imageData = data{
        cell.profileImage.image = UIImage(data: imageData)
        
    }
    cell.profileImage.layer.cornerRadius = cell.profileImage.frame.size.width / 2
    cell.profileImage.clipsToBounds = true
    
    
    cell.userNameLabel.text = user["name"] as! String
    cell.tweetContent.text = tweetArray[indexPath.row]["text"] as! String
    cell.tweetTime.text = tweetArray[indexPath.row]["created_at"] as! String
    
    
    
    return cell// that's the cell we wanna show.
}





// MARK: - Table view data source

override func numberOfSections(in tableView: UITableView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 1
}

override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return tweetArray.count
}

}
