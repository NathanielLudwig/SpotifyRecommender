//
//  SliderTableViewCell.swift
//  SpotifyRecommender
//
//  Created by 90303054 on 5/11/20.
//  Copyright © 2020 90303054. All rights reserved.
//

import UIKit

class SliderTableViewCell: UITableViewCell {
    
    var attribute: Attribute?
    
    static let identifier = "SliderCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "SliderTableViewCell", bundle: nil)
    }
    
    public func configure(with title: String, attribute: Attribute) {
        self.attribute = attribute
        attributeLabel.text = title
        attributeSlider.minimumValue = attribute.minValue
        attributeSlider.maximumValue = attribute.maxValue
        attributeSlider.value = attribute.value
    }
    
    @IBOutlet weak var attributeLabel: UILabel!
    @IBOutlet weak var attributeSlider: UISlider!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
        
    }
    @IBAction func sliderChanged(_ sender: Any) {
        guard let index = AttributeTypes.shared.values.firstIndex(where: {$0.name == attribute?.name}) else { return }
        AttributeTypes.shared.values[index].value = attributeSlider.value
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
