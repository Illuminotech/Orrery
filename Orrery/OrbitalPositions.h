//
//  OrbitalPositions.h
//  Orrery
//
//  Created by Michael Golden on 1/8/18.
//  Copyright © 2018 norobostudios. All rights reserved.
//

#import <Foundation/Foundation.h>
@import SceneKit;

typedef NS_ENUM(NSInteger, CB)
{
    CBSun,
    
    CBMercury,
    CBVenus,
    CBEarth,
    CBMars,
    CBJupiter,
    CBSaturn,
    CBUranus,
    CBNeptune,
    
    CBPluto,
    CBEris,
    CBCeres,
    CBHaumea,
    CBMakemake
};

@interface OrbitalPositions : NSObject

@property CB cb;

- (SCNVector3)cartisianPositionForPlanet:(NSInteger)planet atDate:(NSDate *)date;

@end
