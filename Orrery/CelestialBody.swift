//
//  CelestialBody.swift
//  Orrery
//
//  Created by Michael Golden on 1/6/18.
//  Copyright © 2018 norobostudios. All rights reserved.
//

import Foundation
import SceneKit

@objc enum CelestialBodies:Int {
    case sun = 0
    
    case mercury
    case venus
    case earth
    case mars
    case jupiter
    case saturn
    case uranus
    case neptune
    
    case pluto
    case eris
    case ceres
    case haumea
    case makemake
}

class CelestialBody:NSObject {
    
    var bodyName:CelestialBodies
    var bodyNode:SCNNode
    
    
    init(body:CelestialBodies) {
        bodyName = body
        bodyNode = SCNNode(geometry: SCNSphere(radius: 1.0))
        super.init()
        
        switch body {
        case .sun:
            // First number is objects radius at 1/1000000 miles scale
            // Second number is a subjective scaling factor to improve the planets UI.
            bodyNode = celestialFromValues(radius: 0.432228 * 0.5)
            bodyNode.geometry?.firstMaterial?.diffuse.contents = NSImage(named: NSImage.Name(rawValue: "sunmap"))
        case .mercury:
            bodyNode = celestialFromValues(radius: 0.001516 * 10)
            bodyNode.geometry?.firstMaterial?.diffuse.contents = NSImage(named: NSImage.Name(rawValue: "mercurymap"))
        case .venus:
            bodyNode = celestialFromValues(radius: 0.003760 * 10)
            bodyNode.geometry?.firstMaterial?.diffuse.contents = NSImage(named: NSImage.Name(rawValue: "venusmap"))
        case .earth:
            bodyNode = celestialFromValues(radius: 0.003959 * 10)
            bodyNode.geometry?.firstMaterial?.diffuse.contents = NSImage(named: NSImage.Name(rawValue: "earthmap1k"))
        case .mars:
            bodyNode = celestialFromValues(radius: 0.002106 * 10)
            bodyNode.geometry?.firstMaterial?.diffuse.contents = NSImage(named: NSImage.Name(rawValue: "mars_1k_color"))
        case .jupiter:
            bodyNode = celestialFromValues(radius: 0.43441 * 0.50)
            bodyNode.geometry?.firstMaterial?.diffuse.contents = NSImage(named: NSImage.Name(rawValue: "jupitermap"))
        case .saturn:
            bodyNode = celestialFromValues(radius: 0.36184 * 0.50)
            bodyNode.geometry?.firstMaterial?.diffuse.contents = NSImage(named: NSImage.Name(rawValue: "saturnmap"))
        case .uranus:
            bodyNode = celestialFromValues(radius: 0.15759 * 0.50)
            bodyNode.geometry?.firstMaterial?.diffuse.contents = NSImage(named: NSImage.Name(rawValue: "uranusmap"))
        case .neptune:
            bodyNode = celestialFromValues(radius: 0.15299 * 0.50)
            bodyNode.geometry?.firstMaterial?.diffuse.contents = NSImage(named: NSImage.Name(rawValue: "neptunemap"))
        
            // TODO: add dwarf planets to the model
        case .pluto:
            bodyNode = celestialFromValues(radius: 0.0007384)
        case .eris:
            bodyNode = celestialFromValues(radius: 0.0007227)
        case .ceres:
            bodyNode = celestialFromValues(radius: 0.000294)
        case .haumea:
            bodyNode = celestialFromValues(radius: 0.000507)
        case .makemake:
            bodyNode = celestialFromValues(radius: 0.000717)
        }
    }
    
    func celestialFromValues(radius:CGFloat) -> SCNNode {
        let body:SCNSphere = SCNSphere(radius: radius)
        let bodyNode = SCNNode(geometry: body)
        bodyNode.position = currentPosition(date: NSDate(timeIntervalSinceNow: 0.0))
        return bodyNode
    }
    
    func addRingsToSaturn(node:SCNNode) {
        let ring = SCNNode(geometry: SCNTube(innerRadius: 0.250, outerRadius: 0.400, height: 0.01))
        node.addChildNode(ring)
        ring.rotation = SCNVector4Make(1, 0, 0, CGFloat(0.471238898))
    }
    
    func currentPosition(date:NSDate) -> SCNVector3 {
        let orbitalPosition:OrbitalPositions = OrbitalPositions()
        let vector = orbitalPosition.cartisianPosition(forPlanet:bodyName.rawValue as Int, at: date as Date!)
        return vector
    }
    
}
