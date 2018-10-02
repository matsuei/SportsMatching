//
//  TopViewController.swift
//  SportsMatching
//
//  Created by user on 2018/09/26.
//  Copyright © 2018年 iosearn. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SVProgressHUD
import FirebaseUI

class TopViewController: UIViewController,FUIAuthDelegate {
    
    
    @IBOutlet weak var AuthenticationButton: UIButton!
    @IBOutlet weak var GuestUserButton: UIButton!
    
    var authUI: FUIAuth { get { return FUIAuth.defaultAuthUI()!}}
    let providers: [FUIAuthProvider] = [
        FUIGoogleAuth(),
        FUIFacebookAuth(),
        //FUITwitterAuth(),
        FUIPhoneAuth(authUI:FUIAuth.defaultAuthUI()!),
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // サインインしているかチェック
        authUI.delegate = self
        self.authUI.providers = providers
        Auth.auth().addStateDidChangeListener{auth, user in
            if user != nil{
                //サインインしている
                self.present((self.storyboard?.instantiateViewController(withIdentifier:
                    "toMain"))!,animated: true,completion: nil)
            } else {
                //サインインしていない
                self.AuthenticationButton.backgroundColor = UIColor.red
                self.AuthenticationButton.frame.size = CGSize(width: 200, height: 100)
                self.GuestUserButton.backgroundColor = UIColor.yellow
                self.GuestUserButton.frame.size = CGSize(width: 200, height: 100)
                self.AuthenticationButton.addTarget(self,action: #selector(self.authenticationButtonTapped(sender:)),for: .touchUpInside)
                self.GuestUserButton.addTarget(self,action: #selector(self.guestUserButtonTapped(sender:)),for: .touchUpInside)
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func authenticationButtonTapped(sender : AnyObject) {
        // Google、Facebook、電話番号、メールの認証ボタンの画面に遷移
        let authViewController = authUI.authViewController()
        self.present(authViewController, animated: true, completion: nil)
    }
    
    //認証画面から離れたときに呼ばれる（キャンセルボタン押下含む）
    public func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?){
        // 認証に成功した場合
        if error == nil {
            self.present((self.storyboard?.instantiateViewController(withIdentifier:
                "toMain"))!,animated: true,completion: nil)
        }
    }
    
    // 匿名認証を行う（ゲストユーザー）
    @objc func guestUserButtonTapped(sender : AnyObject) {
        Auth.auth().signInAnonymously() { (user, error) in
            self.present((self.storyboard?.instantiateViewController(withIdentifier:
                "toMain"))!,animated: true,completion: nil)
        }
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
