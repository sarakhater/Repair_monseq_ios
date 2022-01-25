//
//  SplashViewController.swift
//  Almonaseq
//
//  Created by unitlabs on 3/13/20.
//  Copyright © 2020 Sara Khater. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class SplashViewController: UIViewController {
    var player: AVPlayer?

fileprivate var playerObserver: Any?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
         self.setInitialVC();
       // loadVideo();
       // self.navigationController?.setNavigationBarHidden(true, animated: true);

        }

        private func loadVideo() {

            //this line is important to prevent background music stop
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
            } catch { }

            let path = Bundle.main.path(forResource: "lunchVideo", ofType:"mp4")

            player = AVPlayer(url: NSURL(fileURLWithPath: path!) as URL);
            let resetPlayer = {
                self.setInitialVC();
            }
            playerObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player?.currentItem, queue: nil) { notification in resetPlayer()
                
            }

            let playerLayer = AVPlayerLayer(player: player)

            playerLayer.frame = self.view.frame
            playerLayer.videoGravity = AVLayerVideoGravity.resizeAspect;
            playerLayer.zPosition = -1

            self.view.layer.addSublayer(playerLayer)

            player?.seek(to:kCMTimeZero)
            player?.play()
        }
    
    func setInitialVC() {
    
          let languageSet = UserDefaults.standard.bool(forKey: "language_set");
          if (!languageSet) {
              var mainController: UIViewController
              let storyboard = UIStoryboard(name: "Main", bundle: nil)
             var  navigationController =
                  storyboard.instantiateViewController(withIdentifier: "MainNavigationController") as! UINavigationController;
              
              mainController = UIStoryboard(name: "App", bundle: nil).instantiateViewController(withIdentifier: "LanguageVC") as! LanguageVC
            navigationController.setViewControllers([mainController], animated: false);
            navigationController.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency

              //sara
            navigationController.navigationBar.isTranslucent = false;

            self.navigationController?.present(navigationController, animated: true, completion: nil)

           // self.present(navigationController, animated: true, completion: nil);
          }
          else{
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
       var  navigationController =
                             storyboard.instantiateViewController(withIdentifier: "MainNavigationController") as! UINavigationController;
            
            var mainController: UIViewController
            mainController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewServiceViewController") as! NewServiceViewController
            navigationController.setViewControllers([mainController], animated: false);
            
                    navigationController.navigationBar.isTranslucent = false;
                navigationController.modalPresentationStyle = .fullScreen

            
            self.navigationController?.present(navigationController, animated: true, completion: nil)
        }

      }
    

}
