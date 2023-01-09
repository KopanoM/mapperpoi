//
//  String+Extensions.swift
//  HellowWorld
//
//  Created by Mac on 2023/01/09.
//

import Foundation

extension String{
    
    var formatPhoneCall : String {
        self.replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "+", with: "")
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")
            .replacingOccurrences(of: "-", with: "")
    }
}
