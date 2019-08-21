
//
//  TimeLineViewController.swift
//  Swift5FirebaseBasic1
//
//  Created by 萩　山登 on 2019/08/21.
//  Copyright © 2019 萩　山登. All rights reserved.
//

import UIKit
import Firebase


class TimeLineViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    
    
    var displayName = String()
    var comment = String()
    
    @IBOutlet var tableView: UITableView!
    
    let reflashControl = UIRefreshControl()
    
    var userName_Array = [String]()
    var comment_Array = [String]()
    
    
    var posts = [Post]()
    var posst = Post()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        reflashControl.attributedTitle = NSAttributedString(string: "引っ張って更新")
        reflashControl.addTarget(self, action: #selector(reflash), for: .valueChanged)
        
        tableView.addSubview(reflashControl)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        //データをとってくる
        fatchPost()
        tableView.reloadData()
        
        //tableviewを更新
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return posts.count
    }
    
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    //セルが構築される度に呼び出される
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let userNameLabel = cell.viewWithTag(1) as! UILabel
        userNameLabel.text = self.posts[indexPath.row].userName
        
        let comentLabel = cell.viewWithTag(2) as! UILabel
        comentLabel.text = self.posts[indexPath.row].comment
        
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 115
    }
    @objc func reflash(){
        
        //引っ張って更新された時に呼ばれる
        fatchPost()
        reflashControl.endRefreshing()
        //firebaseからデータを呼ぶ
        
    }
    
    func fatchPost(){
        
        self.posts = [Post]()
        self.userName_Array = [String]()
        self.comment_Array = [String]()
        self.posst = Post()
        //参照して取得する　postの部分を取得する
        let ref = Database.database().reference()
        ref.child("post").observeSingleEvent(of: .value)
        { (snap,error) in
            
            let postsSnap = snap.value as? [String:NSDictionary]
            
            if postsSnap == nil{
                return
            }
            self.posts = [Post]()
            //
            for(_,post) in postsSnap!{
                
                self.posst = Post()
                
                if let comment = post["comment"] as? String,
                    let userName = post["userName"] as? String{
                    
                    self.posst.comment = comment//comenntをポストクラスに代入
                    self.posst.userName = userName
                    
                    self.comment_Array.append(self.posst.comment)
                    self.userName_Array.append(self.posst.userName)
            }
                self.posts.append(self.posst)
            
        
    }
            
            self.tableView.reloadData()
        }//取ってくる部分
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
}
