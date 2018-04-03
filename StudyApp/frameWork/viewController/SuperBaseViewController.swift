//
//  SuperBaseViewController.swift
//  StudyApp
//


import UIKit

class SuperBaseViewController: YyBaseViewController {
    
    var titleImageView: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let labels = UILabel(frame: CGRect(x: 0, y: 0, width: 1, height: 1));
        self.view.addSubview(labels)
        self.automaticallyAdjustsScrollViewInsets = false;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
