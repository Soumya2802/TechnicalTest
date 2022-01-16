//
// Created by Alex Jackson on 01/03/2021.
//

import Foundation
import UIKit

final class PostDetailsViewController: UIViewController {

    // MARK: - Properties

    var postID: Int!
    private var loadedPost: Post?

    @IBOutlet private(set) var titleLabel: UILabel!
    @IBOutlet private(set) var bodyLabel: UILabel!
    @IBOutlet private(set) var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private(set) var showComments: UIButton!
    // MARK: - UIViewController Overrides

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if loadedPost == nil {
            activityIndicator.startAnimating()
            title = "Loading…"

            Post.loadPost(withID: postID) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let post):
                        self?.loadedPost = post
                        self?.title = post.title
                        self?.titleLabel.text = post.title
                        self?.bodyLabel.text = post.body

                    case .failure:
                        break
                    }

                    self?.activityIndicator.stopAnimating()
                }
            }
        }
       
    }
    @IBAction func showCommentsAction(_ sender: Any) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "PostCommentsViewController", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "PostComments") as! PostCommentsViewController
        
        newViewController.postID  = self.postID
                self.present(newViewController, animated: true, completion: nil)
    }
}
