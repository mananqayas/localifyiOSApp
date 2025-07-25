//
//  NavigationState.swift
//  localifyRedo
//
//  Created by Manan Qayas on 07/06/2025.
//

import Foundation
import SwiftUI

class NavigationState: ObservableObject {
    @Published  var selectedTab: Int = 0
    @Published var path = NavigationPath()
    @Published private(set) var routes: [Route] = []
    
    func push(_ route: Route) {
        path.append(route)
        routes.append(route)
    }
    
    func pop() {
        path.removeLast()
        if !routes.isEmpty {
            routes.removeLast()
        }
    }
    
    var currentRoute: Route? {
        return routes.last
    }
}

enum Route: Hashable {
    
   case home
    case signup
    case login
    case welcome
    case locationFields
    case businessAddress
    case aboutBusiness
    case tabView
    case chatDetailView(chat: ChatModel)
    case postDetailView(post: PostModel)
 
}

