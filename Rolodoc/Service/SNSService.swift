//
//  SNSService.swift
//  Rolodoc
//
//  Created by Katherine Choi on 7/17/18.
//  Copyright © 2018 Katherine Choi. All rights reserved.
//

import Foundation
import AWSSNS

class SNSService {
    private init() {}
    static let shared = SNSService()
    
    let topicArn = "arn:aws:sns:us-west-1:216765677130:RolodocNews"
    
    
    func configure() {
        let credentialsProvider = AWSStaticCredentialsProvider(accessKey: "AKIAIAHWS2P743ZIRDPQ", secretKey: "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") // should hide this
        
        let serviceConfiguration = AWSServiceConfiguration(region: .usWest1, credentialsProvider: credentialsProvider)
        
        AWSServiceManager.default().defaultServiceConfiguration = serviceConfiguration
    }
    
    func register() {
        
        // saves this user and device (token) onto aws to create an endpoint.
        let arn = "arn:aws:sns:us-west-1:216765677130:app/APNS_SANDBOX/Rolodoc"
        
        guard let platformEndpointRequest = AWSSNSCreatePlatformEndpointInput() else {return}
        platformEndpointRequest.token = User.current.token
        platformEndpointRequest.platformApplicationArn = arn
        
        AWSSNS.default().createPlatformEndpoint(platformEndpointRequest).continue ({ (task) -> Any? in
            guard let endpoint = task.result?.endpointArn else { return nil }
            print(endpoint)
            self.subscribe(to: endpoint)
            return nil
        })
    }
    
    func subscribe(to endpoint: String) {
        guard let subscribeRequest = AWSSNSSubscribeInput() else {return}
        subscribeRequest.topicArn = topicArn
        subscribeRequest.protocols = "application"
        subscribeRequest.endpoint = endpoint
        
        AWSSNS.default().subscribe(subscribeRequest).continue ({ (task) -> Any? in
            print(task.error ?? "successfully subscribed")
            return nil
        })
    }
    
}

