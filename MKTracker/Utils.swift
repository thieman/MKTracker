//
//  Utils.swift
//  MKTracker
//
//  Created by Travis Thieman on 5/6/16.
//  Copyright © 2016 Travis Thieman. All rights reserved.
//

import UIKit

class Utils {
    
    class func sizeOfAttributeString(str: NSAttributedString, maxWidth: CGFloat) -> CGSize {
        let size = str.boundingRectWithSize(CGSizeMake(maxWidth, 1000), options:(NSStringDrawingOptions.UsesLineFragmentOrigin), context:nil).size
        return size
    }
    
    class func imageFromText(text:String, font:UIFont, maxWidth:CGFloat, color:UIColor) -> UIImage {
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineBreakMode = NSLineBreakMode.ByWordWrapping
        paragraph.alignment = .Center
        
        let attributedString = NSAttributedString(string: text, attributes: [NSFontAttributeName: font, NSForegroundColorAttributeName: color, NSParagraphStyleAttributeName:paragraph])
        
        let size = self.sizeOfAttributeString(attributedString, maxWidth: maxWidth)
        UIGraphicsBeginImageContextWithOptions(size, false , 0.0)
        attributedString.drawInRect(CGRectMake(0, 0, size.width, size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

}
