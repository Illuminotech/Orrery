//
//  OrreryViewController.swift
//  Orrery
//
//  Created by Michael Golden on 1/6/18.
//  Copyright © 2018 norobostudios. All rights reserved.
//

import Foundation
import SceneKit
import SpriteKit
import QuartzCore


class OrreryViewController: NSViewController {
    
    // MARK: - Properties 
    var scnView: SCNView!
    var scnScene: SCNScene!
    var cameraNode: SCNNode!
    var optionsWindow: NSWindowController!
    var optionsVC: OptionsViewController!
    var animationInterval: TimeInterval = 1
    weak var repeatingTimer: Timer?
    var optionsDate: NSDate = NSDate()
    var optionsValue: Double = 0.0
    
    var sun:CelestialBody!
    var mercury:CelestialBody!
    var venus:CelestialBody!
    var earth:CelestialBody!
    var mars:CelestialBody!
    var jupiter:CelestialBody!
    var saturn:CelestialBody!
    var uranus:CelestialBody!
    var neptune:CelestialBody!
    
    // MARK: - ViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupScene()
        spawnSun()
        setupCamera()
        setupOptionsPanel()
        spawnPlanets()
        
    }

    // MARK: - Initialization Methods
    
    func setupOptionsPanel() {
        let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
        optionsWindow = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "optionsWindow")) as! NSWindowController
        optionsWindow.window?.level = NSWindow.Level.floating
        optionsWindow.window?.makeKeyAndOrderFront(NSApp)
        
        optionsVC = optionsWindow.contentViewController as! OptionsViewController
        optionsVC.delegate = self
    }
    
    func setupView() {
        scnView = self.view as! SCNView
        scnView.allowsCameraControl = true
        scnView.autoenablesDefaultLighting = true
        //debug
        scnView.showsStatistics = true
        
    }
    
    func setupScene() {
        scnScene = SCNScene()
        scnView.scene = scnScene
    }
    
    func setupCamera() {
        cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 50)
        scnScene.rootNode.addChildNode(cameraNode)
    }
    
    // MARK: - Spawn 3d Elements
    
    func spawnSun() {
    
        sun = CelestialBody(body:CelestialBodies.sun)
        sun.bodyNode.rotation = SCNVector4Make(1, 0, 0, CGFloat(Double.pi/2));
        scnScene.rootNode.addChildNode(sun.bodyNode)
    
    }
    
    func spawnPlanets(){

        let date:NSDate = optionsDate
        // mercury
        mercury = CelestialBody(body:CelestialBodies.mercury)
        scnScene.rootNode.addChildNode(mercury.bodyNode)
        mercury.bodyNode.position = mercury.currentPosition(date: date)
        mercury.bodyNode.rotation = SCNVector4Make(1, 0, 0, CGFloat(Double.pi/2));
        drawOrbit(planet: mercury.bodyName, node: mercury)
        
        // venus
        venus = CelestialBody(body:CelestialBodies.venus)
        scnScene.rootNode.addChildNode(venus.bodyNode)
        venus.bodyNode.position = venus.currentPosition(date: date)
        venus.bodyNode.rotation = SCNVector4Make(1, 0, 0, CGFloat(Double.pi/2));
        drawOrbit(planet: venus.bodyName, node: venus)

        // earth
        earth = CelestialBody(body: CelestialBodies.earth)
        scnScene.rootNode.addChildNode(earth.bodyNode)
        earth.bodyNode.position = earth.currentPosition(date: date)
        earth.bodyNode.rotation = SCNVector4Make(1, 0, 0, CGFloat(Double.pi/2))
        drawOrbit(planet: earth.bodyName, node: earth)
        
        // mars
        mars = CelestialBody(body: CelestialBodies.mars)
        scnScene.rootNode.addChildNode(mars.bodyNode)
        mars.bodyNode.position = mars.currentPosition(date: date)
        mars.bodyNode.rotation = SCNVector4Make(1, 0, 0, CGFloat(Double.pi/2))
        drawOrbit(planet: mars.bodyName, node: mars)
        
        // jupiter
        jupiter = CelestialBody(body: CelestialBodies.jupiter)
        scnScene.rootNode.addChildNode(jupiter.bodyNode)
        jupiter.bodyNode.position = jupiter.currentPosition(date: date)
        jupiter.bodyNode.rotation = SCNVector4Make(1, 0, 0, CGFloat(Double.pi/2))
        drawOrbit(planet: jupiter.bodyName, node: jupiter)

        // saturn
        saturn = CelestialBody(body: CelestialBodies.saturn)
        scnScene.rootNode.addChildNode(saturn.bodyNode)
        saturn.bodyNode.position = saturn.currentPosition(date: date)
        saturn.bodyNode.rotation = SCNVector4Make(1, 0, 0, CGFloat(Double.pi/2))
        drawOrbit(planet: saturn.bodyName, node: saturn)

        // uranus
        uranus = CelestialBody(body: CelestialBodies.uranus)
        scnScene.rootNode.addChildNode(uranus.bodyNode)
        uranus.bodyNode.position = uranus.currentPosition(date: date)
        uranus.bodyNode.rotation = SCNVector4Make(1, 0, 0, CGFloat(Double.pi/2))
        drawOrbit(planet: uranus.bodyName, node: uranus)

        // neptune
        neptune = CelestialBody(body: CelestialBodies.neptune)
        scnScene.rootNode.addChildNode(neptune.bodyNode)
        neptune.bodyNode.position = neptune.currentPosition(date: date)
        neptune.bodyNode.rotation = SCNVector4Make(1, 0, 0, CGFloat(Double.pi/2))
        drawOrbit(planet: neptune.bodyName, node: neptune)
        
        startRepeatingTimer()
    }
    
    // MARK: - Update 3d Elements
    
    func cleanScene() {
        for node in scnScene.rootNode.childNodes {
            node.removeFromParentNode()
        }
    }
    
    func updatePlanetLocations() {
        if (mercury == nil) {
            return
        }
        
        let date:NSDate = optionsDate.addingTimeInterval(animationInterval)
        mercury.bodyNode.position = mercury.currentPosition(date: date)
        venus.bodyNode.position = venus.currentPosition(date: date)
        earth.bodyNode.position = earth.currentPosition(date: date)
        mars.bodyNode.position = mars.currentPosition(date: date)
        jupiter.bodyNode.position = jupiter.currentPosition(date: date)
        saturn.bodyNode.position = saturn.currentPosition(date: date)
        uranus.bodyNode.position = uranus.currentPosition(date: date)
        neptune.bodyNode.position = neptune.currentPosition(date: date)
    }

    func drawOrbit(planet:CelestialBodies, node:CelestialBody) {
        // TODO: turn cube markers into a solid line
        var i:Double = 0
        var planetYear:Double = 0 // a year for this planet in earth seconds
        var factor:Double = 1

        if node.bodyName == CelestialBodies.mercury {
            planetYear = 7.603e+6
            factor = 5
        } else if node.bodyName == CelestialBodies.venus {
            planetYear = 1.944e+7
            factor = 5
        } else if node.bodyName == CelestialBodies.earth {
            planetYear = 3.154e+7
            factor = 5
        } else if node.bodyName == CelestialBodies.mars {
            planetYear = 5.936e+7
            factor = 5
        } else if node.bodyName == CelestialBodies.jupiter {
            planetYear = 3.784e+8
            factor = 5
        } else if node.bodyName == CelestialBodies.saturn {
            planetYear = 9.3031e+8
            factor = 10
        } else if node.bodyName == CelestialBodies.uranus {
            planetYear = 2.6585e+9
            factor = 10
        } else if node.bodyName == CelestialBodies.neptune {
            planetYear = 5.203e+9
            factor = 10
        }

        while (i < planetYear) {
            i += (86400 * factor)
            let orbit:SCNNode = SCNNode(geometry:SCNBox(width: 0.01, height: 0.01, length: 0.01, chamferRadius: 0.0))
            orbit.position = node.currentPosition(date: NSDate.init(timeIntervalSinceNow: -i))
            scnScene.rootNode.addChildNode(orbit)
        }

    }
    
    // MARK: - Timer Methods
    
    func startRepeatingTimer() {
        repeatingTimer?.invalidate()
        
        let timer = Timer.scheduledTimer(timeInterval: 0.25, target: self, selector:#selector(self.prepareToUpdatePlanets), userInfo: nil, repeats: true)
        repeatingTimer = timer
    }
    
    @objc func prepareToUpdatePlanets() {
        var timeStep:Double = 0.25
        switch optionsValue {
        case 0:
            timeStep = 0.25
        case 25:
            timeStep = 604800 // one week in seconds
        case 50:
            timeStep = 2.628e+6 // one month
        case 75:
            timeStep = 3.154e+7 // one year
        case 100:
            timeStep = 3.154e+8 // 10 years
        case -25:
            timeStep = -604800 // - one week in seconds
        case -50:
            timeStep = -2.628e+6 // - one month
        case -75:
            timeStep = -3.154e+7 // - one year
        case -100:
            timeStep = -3.154e+8 // - 10 years
        default:
            timeStep = 0.25
        }
        
        animationInterval += timeStep
        
        updatePlanetLocations()
    }
    
}

// MARK: - Options Delegate

extension OrreryViewController: OptionsViewControllerDelegate {
    
    func didUpdateSlider(sliderValue:Double) {
        optionsValue = sliderValue
    }
    
    func didUpdateDate(newDate:NSDate) {
        optionsDate = newDate
        cleanScene()
        spawnSun()
        spawnPlanets()
    }
    
}
