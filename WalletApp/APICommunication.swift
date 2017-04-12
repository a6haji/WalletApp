//
//  APIConnection.swift
//  WalletApp
//
//  Created by Aly Haji on 2017-03-26.
//  Copyright © 2017 Aly Haji. All rights reserved.
//

import Foundation

var EndPoint = String()
var NotificationName = String()

class APICommunication {
    
    
    
    //Takes EndPointType, the method and the body to post and connect to API.
    //Posts response data to NotificationCenter with EndPointType NotificationName
    
    static func apirequest(data: EndPointTypes, httpMethod: String, httpBody: [String: Any]?) -> Void {
        
        
        let datatype = data
        EndPoint = getserveraddress(data: datatype)
        
        if httpMethod == "GET" && httpBody != nil {
            print("this is running the get method")
            EndPoint = createGetURL(httpBody: httpBody!, PreviousEndPoint: EndPoint)
        }
        
        let url = URL(string: EndPoint)
        var urlRequest = NSMutableURLRequest(url: url!)
        urlRequest.httpMethod = httpMethod
        
        
        if httpMethod=="POST" {
            createPostBody(urlRequest: &urlRequest, httpMethod: httpMethod, httpDictionary: httpBody)
        }
        
        
        
        let session = URLSession.shared
        
        let myCompletionHandler: (Data?, URLResponse?, Error?) -> Void = {
            (data, response, error) in
            // this is where the completion handler code goes
            
            guard error == nil else {
                print ("Error calling GET request")
                print (error!)
                return
            }
            
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            let dictionary: NSDictionary = ["response": responseData]
            
            
            DispatchQueue.main.async {
                
                //Listen to this notification in your viewcontroller to get data
                NotificationCenter.default.post(name:Notification.Name(rawValue:"MyNotification" + datatype.rawValue),
                                                object: nil,
                                                userInfo: dictionary as? [AnyHashable : Any])
            }
            
        }
        
        let task = session.dataTask(with: urlRequest as URLRequest, completionHandler: myCompletionHandler)
        
        task.resume()
        
    }
    
    static func createGetURL(httpBody: [String: Any], PreviousEndPoint: String) ->String{
        
        guard let urlextension = httpBody["date"] as? String else {
            print ("not correct parameters in GET Request")
            return EndPoint
        }
        return EndPoint + "?date=" + urlextension
        
    }
    
    
    static func createPostBody (urlRequest: inout NSMutableURLRequest, httpMethod: String, httpDictionary:[String:Any]?)
    {
        urlRequest.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
        let jsonData = try? JSONSerialization.data(withJSONObject: httpDictionary!)
        urlRequest.httpBody = jsonData
        urlRequest.allHTTPHeaderFields = ["Authorization":"Token 4ee282b0ddfd0ae8debeeae49115682869c5d00a",
                                          "Content-Type": "application/json"]
    }
    
    
    //Converts response data to Dictionary of type [String:Any] which can be parsed
    
    static func convertDatatoDictionary (data: Data) -> [String: Any]?
    {
        do {
            guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                else {
                    print("error trying to convert data to JSON")
                    return nil
            }
            
            return json
            
        } catch  {
            print("error trying to convert data to JSON")
            return nil
        }
    }
    
    
    
}
