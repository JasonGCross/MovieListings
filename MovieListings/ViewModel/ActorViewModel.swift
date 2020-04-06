//
//  Actor.swift
//  Swift_to_CPP_command_line
//
//  Created by Jason Cross on 2020-04-04.
//  Copyright © 2020 Jason Cross. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI
import Combine

/**
 Encapsulates information about an Actor
 */
final class ActorViewModel : Identifiable, ObservableObject {
    
    // required by Identifiable; allows this to be used as a List item
    var id = UUID()
    
    // required by ObservableObject; allows this to notify subscribers of a change
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    // do not expose the Objective-C reference types outside
    private var actorWrapper : ActorWrapper
    
    // instead, wrap the desired properties in value types
    var name : String {
        get {
            return actorWrapper.name
        }
    }
    
    var age : Int {
        get {
            return Int(actorWrapper.age)
        }
    }
    
    private (set) var image : Image = Image(systemName: "photo")
    
    var imageUrl : URL? {
        get {
            guard nil != actorWrapper.imageUrl else {
                return nil
            }
            return actorWrapper.imageUrl
        }
    }
    
    init(actorWrapper: ActorWrapper) {
        self.actorWrapper = actorWrapper
    }
    
    /**
     Fetches image data from a (possibly remote) URL.
     
     Notifies any subscriber when the image data has been fetched.
     */
    public func fetchImage() {
        guard nil != self.imageUrl,
            String() != self.imageUrl!.absoluteString else {
            return
        }
        let task = URLSession.shared.dataTask(with: self.imageUrl!) { (data, response, error) in
            
            guard nil == error else {
                return
            }
            
            guard nil != response,
                nil != data,
                let uiImage = UIImage(data: data!) else {
                    return
            }
            
            DispatchQueue.main.async {
                self.image = Image(uiImage: uiImage)
                self.objectWillChange.send()
            }
        }
        task.resume()
    }
}
