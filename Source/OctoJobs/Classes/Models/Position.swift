//
//  Position.swift
//  OctoJobs
//
//  Created by Tyler Stromberg on 10/7/14.
//  Copyright (c) 2014 Tyler Stromberg. All rights reserved.
//

import Foundation

@objc
class Position {
    let id: String
    let title: String
    let location: String
    let type: String
    let HTMLDescription: String
    let howToApply: String
    let company: String
    let companyURL: String?
    let companyLogoURL: String?
    let createdAt: NSDate?
    
    init(dictionary: NSDictionary) {
        id = dictionary["id"] as String
        title = dictionary["title"] as String
        location = dictionary["location"] as String
        type = dictionary["type"] as String
        HTMLDescription = dictionary["description"] as String
        howToApply = dictionary["how_to_apply"] as String
        company = dictionary["company"] as String
        
        if let URL = dictionary["company_url"] as? String {
            companyURL = URL
        }
        
        if let logoURL = dictionary["company_logo"] as? String {
            companyLogoURL = logoURL
        }
        
        var rawCreatedAt = dictionary["created_at"] as String
        createdAt = dateFormatter().dateFromString(rawCreatedAt)
    }
    
    func dateFormatter() -> NSDateFormatter {
        // FIXME: Make this static
        var formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier:"en_US_POSIX")
        formatter.dateFormat = "EEE MMM dd HH:mm:ss 'UTC' yyyy"
        formatter.timeZone = NSTimeZone(name: "UTC")
        
        return formatter
    }
}
