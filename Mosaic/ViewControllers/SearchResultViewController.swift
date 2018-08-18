//
//  SearchResultViewController.swift
//  Mosaic
//
//  Created by Zedd on 2018. 8. 18..
//  Copyright © 2018년 Zedd. All rights reserved.
//

import UIKit

class SearchResultViewController: UIViewController {

    
    static func create() -> SearchResultViewController? {
        return UIStoryboard(name: "Search", bundle: nil).instantiateViewController(withIdentifier: classNameToString) as? SearchResultViewController
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
class SearchResultCountTableViewCell: UITableViewCell {
    
    @IBOutlet weak var countLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

class SearchResultTableViewCell: UITableViewCell {
    
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.descriptionLabel.font = UIFont.nanumRegular(size: 13)
        self.descriptionLabel.textColor = UIColor(hex: "#474747")
        self.dateLabel.font = UIFont.nanumBold(size: 10)
        self.dateLabel.textColor = UIColor(hex: "#999999")
        //self.commentLabel.font = UIFont.
    }
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
