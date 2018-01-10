//
//  ScriptManager.swift
//  Orrery
//
//  Created by Michael Golden on 1/7/18.
//  Copyright © 2018 norobostudios. All rights reserved.
//

import Foundation
import JavaScriptCore

class ScriptManager {

    private static var sharedScriptManager: ScriptManager = {
        let scriptManager = ScriptManager(context:(JSContext(virtualMachine:JSVirtualMachine())))
        
        // Configuration
        // Add the required JS Files
        if let gruntFilePath = Bundle.main.path(forResource: "Gruntfile", ofType:"js") {
            let gruntFileLib = try! String(contentsOfFile: gruntFilePath)
            scriptManager.context.evaluateScript(gruntFileLib)
        }
        
        if let planetPositionPath = Bundle.main.path(forResource: "planet-positions", ofType:"js") {
            let planetPositionLib = try! String(contentsOfFile: planetPositionPath)
            scriptManager.context.evaluateScript(planetPositionLib)
        }
        
    
        return scriptManager
    }()
    
    let context: JSContext
    
    private init(context: JSContext) {
        self.context = context
    }
    
    class func shared() -> ScriptManager {
        return sharedScriptManager
    }
    
}
