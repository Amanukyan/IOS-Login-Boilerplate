//
//  UserCell.swift
//  Login
//
//  Created by Alex Manukyan on 4/10/19.
//  Copyright © 2019 Alex Manukyan. All rights reserved.
//

import UIKit

class UserCell: UICollectionViewCell {
    
    //Views
    var textLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        prepareView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension UserCell{
    func prepareView(){
        
        // text Label
        textLabel = UILabel()
        textLabel.frame = self.bounds
        textLabel.frame.origin.y = frame.height - textLabel.frame.height
        textLabel.textColor = UIColor.white
        textLabel.font = Globals.fontHeavy
        addSubview(textLabel)
        
    }
}

