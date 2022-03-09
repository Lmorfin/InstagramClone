//
//  FeedViewController.swift
//  InstagramClone
//
//  Created by Luis Morfin on 2/27/22.
//

import UIKit
import Parse
import AlamofireImage
import MessageInputBar

class FeedViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,MessageInputBarDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    let commentBar = MessageInputBar()
    var showsCommentBar = false
    var posts = [PFObject]()
    var selectedPost: PFObject!
    
    //RefreshControl
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        commentBar.inputTextView.placeholder = "Add a comment..."
        commentBar.sendButton.title = "Post"
        commentBar.delegate = self
        
        //dismisses keyboard by dragging down the table view
        tableView.keyboardDismissMode = .interactive
        
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyBoardWillBeHidden(note:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        //create the comment
        let comment = PFObject(className: "Comment")
            comment["text"] = text
            comment["post"] = selectedPost
            comment["author"] = PFUser.current()!
    
            selectedPost.add(comment, forKey: "comments")
    
            selectedPost.saveInBackground { success, error in
    
                if success {
                    print("Comment saved.")
                } else {
                    print("Error saving comment..")
                }
            }
        tableView.reloadData()
        
        //clear and dismiss inputbar
        commentBar.inputTextView.text = nil
        
        showsCommentBar = false
        becomeFirstResponder()
        commentBar.inputTextView.resignFirstResponder()
        
    }
    
    @objc func keyBoardWillBeHidden(note: Notification) {
        commentBar.inputTextView.text = nil
        showsCommentBar = false
        becomeFirstResponder()
    }
    
    //these two fns adds the new bar from MessageInputBar
    override var inputAccessoryView: UIView? {
        return commentBar
    }
    
    //8mins video 5
    override var canBecomeFirstResponder: Bool {
        return showsCommentBar
    }
    
    @objc func onRefresh(){
         run(after: 2) {
             self.refreshControl.endRefreshing()
         }
    }
    
    func run(after wait: TimeInterval, closure: @escaping () -> Void) {
        let queue = DispatchQueue.main
        queue.asyncAfter(deadline: DispatchTime.now() + wait, execute: closure)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let query = PFQuery(className: "Posts")
        query.includeKeys(["author","comments","comments.author"])
        query.limit = 20
        
        query.findObjectsInBackground{ (posts,error) in
            if posts != nil {
                self.posts = posts!
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let post = posts[section]
        //whatever is on the left, if it's nil, set it equal to the right of ??
        let comments = (post["comments"] as? [PFObject]) ?? []
        
        return comments.count + 2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let post = posts[indexPath.section]
        let comments = (post["comments"] as? [PFObject]) ?? []
        
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell") as! PostTableViewCell
          
            
            let user = post["author"] as! PFUser
            cell.usernameLabel.text = user.username
            
            cell.captionLabel.text = post["caption"] as? String
            
            //image
            let imageFile = post["image"] as! PFFileObject
            let urlString = imageFile.url!
            let url = URL(string: urlString)!
            
            cell.photoView.af.setImage(withURL: url)
            
            return cell
        } else if indexPath.row <= comments.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentCell
            
            let comment = comments[indexPath.row - 1]
            cell.commentLabel.text = comment["text"] as? String
            let user = comment["author"] as! PFUser
            cell.nameLabel.text = user.username
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddCommentCell")!
            
            return cell
        }
    }
    
    

 
    
  
    @IBAction func onLogout(_ sender: Any) {
       //logs out from Parse
        PFUser.logOut()
        
        let main = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = main.instantiateViewController(withIdentifier: "LoginViewController")
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let delegate = windowScene.delegate as? SceneDelegate
        else {
            return
        }
        delegate.window?.rootViewController = loginViewController
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = posts[indexPath.section]
        //let comments = PFObject(className: "Comments")
        let comments = (post["comments"] as? [PFObject]) ?? []
        
        if indexPath.row == comments.count + 1 {
            showsCommentBar = true
            becomeFirstResponder()
            
            commentBar.inputTextView.becomeFirstResponder()
            
            selectedPost = post
        }
//        comment["text"] = "This is a random comment"
//        comment["post"] = post
//        comment["author"] = PFUser.current()!
//
//        post.add(comment, forKey: "comments")
//
//        post.saveInBackground { success, error in
//
//            if success {
//                print("Comment saved.")
//            } else {
//                print("Error saving comment..")
//            }
//        }
        
        
    }

  

}
