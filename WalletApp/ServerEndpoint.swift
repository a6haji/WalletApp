//
//  ServerEndpoint.swift
//  WalletApp
//
//  Created by Aly Haji on 2017-03-26.
//  Copyright © 2017 Aly Haji. All rights reserved.
//

import Foundation

enum EndPointTypes : String {
    case Wallet = "Wallet"
}


func getserveraddress (data: EndPointTypes) -> String
{
    switch data{
        
    case .Wallet:
        print("Wallet passed in")
        EndPoint = "https://gist.githubusercontent.com/Shanjeef/3562ebc5ea794a945f723de71de1c3ed/raw/25da03b403ffa860dd68a9bfc84f562262ee5ca5/walletEndpoint"
        NotificationName = data.rawValue
        
    }
    
    return EndPoint
    
}
