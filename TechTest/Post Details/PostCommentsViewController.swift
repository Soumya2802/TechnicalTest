//
//  PostCommentsViewController.swift
//  TechTest
//
//  Created by Soumya Ammu on 1/10/22.
//

import UIKit

class PostCommentsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UITabBarDelegate {
    
    
    var postID:Int!
    private var loadedPost: [PostComments]?
    private var loadedPostOffline: [OfflineComments]?
    private var offlineCommentObject : OfflineComments = OfflineComments()
    //@IBOutlet private(set) var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var commentsTabBar: UITabBar!
    
    @IBOutlet weak var commentsTableView: UITableView!
    
    //UITableView to implement comment sections
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if commentsTabBar.selectedItem?.title == "Comments"{
            return self.loadedPost?.count ?? 0
        }else{
            return self.loadedPostOffline?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? PostCommentsTableViewCell
        if commentsTabBar.selectedItem?.title == "Comments"{
            let name = self.loadedPost?[indexPath.row].name ?? ""
            let comments = self.loadedPost?[indexPath.row].body ?? ""
            
            
            cell?.name.text = "Name :" + " " + name
            cell?.comment.text = "Comments :" + " " + comments
            
            var offlinePostIDArr = [Int]()
            var offlineIDArr = [Int]()
            
            for item in self.loadedPostOffline ?? []{
                offlineIDArr.append(Int(item.id))
                offlinePostIDArr.append(Int(item.postID))
               
            }
            
            if offlineIDArr.contains(self.loadedPost?[indexPath.row].id ?? -1) && offlinePostIDArr.contains(self.loadedPost?[indexPath.row].postId ?? -1){
                
                cell?.downloadButton.isEnabled = false
                cell?.downloadButton.setTitle("Dowloaded", for: .disabled)
                
            }else{
                
                cell?.downloadButton.isEnabled = true
                
            }
            
            cell?.downloadButton.isHidden = false
            cell?.downloadButton.tag = indexPath.row
            
            
            
            cell?.downloadButton.addTarget(self, action: #selector(dowloadAction(sender:)), for: .touchUpInside)
        }else{
            let name = self.loadedPostOffline?[indexPath.row].name ?? ""
            let comments = self.loadedPostOffline?[indexPath.row].comment ?? ""
            
            cell?.name.text = "Name :" + " " + name
            cell?.comment.text = "Comments :" + " " + comments

            cell?.downloadButton.isHidden = true
        }
        return cell ?? UITableViewCell()
    }
    
    @objc func dowloadAction(sender:UIButton){
        let offlineComment = OfflineComments(context: PersistentStorage.shared.context)
        offlineComment.id = Int16(self.loadedPost?[sender.tag].id ?? 0)
        offlineComment.postID = Int16(self.loadedPost?[sender.tag].postId ?? 0)
        offlineComment.name = self.loadedPost?[sender.tag].name
        offlineComment.comment = self.loadedPost?[sender.tag].body
        PersistentStorage.shared.saveContext()
        commentsTabBar.selectedItem = commentsTabBar.items?.first
        commentsTableView.reloadData()
    }
    
    
    func fetchOfflineComments(){
        
        do{
            let offlineComments = try PersistentStorage.shared.context.fetch(OfflineComments.fetchRequest())
            
            self.loadedPost?.removeAll()
//            for object in offlineComments{
//                PersistentStorage.shared.context.delete(object)
//            }
//            PersistentStorage.shared.saveContext()
            //self.loadedPostOffline = offlineComments
            
            var offlineCommentsForThePost = [OfflineComments]()
            
            for object in offlineComments{
                if object.postID == postID{
                    offlineCommentsForThePost.append(object)
                }
            }
           
            self.loadedPostOffline = offlineCommentsForThePost
            
        }catch let error{
           debugPrint(error)
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.title == "Offline Comments"{
            fetchOfflineComments()
            commentsTableView.reloadData()
        }else{
            loadedPost = nil
            if loadedPost == nil {
                //activityIndicator.startAnimating()
                title = "Loading…"

                PostComments.loadComments(withID: postID) { [weak self] result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let post):
                            self?.loadedPost = post
                            print(post)
                            self?.commentsTableView.reloadData()
                            
                        case .failure:
                            break
                        }

                        //self?.activityIndicator.stopAnimating()
                    }
                }
                
            }
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
                            
       // commentsTableView.register(UINib(nibName: "PostCommentsTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
        commentsTableView.register(UINib(nibName: "PostCommentsTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        commentsTabBar.selectedItem = commentsTabBar.items?.first
        loadedPost = nil
        fetchOfflineComments()
        if loadedPost == nil {
            //activityIndicator.startAnimating()
            title = "Loading…"

            PostComments.loadComments(withID: postID) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let post):
                        self?.loadedPost = post
                        print(post)
                        self?.commentsTableView.reloadData()
                        
                    case .failure:
                        break
                    }

                    //self?.activityIndicator.stopAnimating()
                }
            }
            
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
