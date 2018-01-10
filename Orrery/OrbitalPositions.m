//
//  OrbitalPositions.m
//  Orrery
//
//  Created by Michael Golden on 1/8/18.
//  Copyright © 2018 norobostudios. All rights reserved.
//

#import "OrbitalPositions.h"
#include <math.h>

#define PI          3.14159265358979323846
#define RADEG       (180.0/PI)
#define DEGRAD      (PI/180.0)
#define sind(x)     sin((x)*DEGRAD)
#define cosd(x)     cos((x)*DEGRAD)
#define tand(x)     tan((x)*DEGRAD)
#define asind(x)    (RADEG*asin(x))
#define acosd(x)    (RADEG*acos(x))
#define atand(x)    (RADEG*atan(x))
#define atan2d(y,x) (RADEG*atan2((y),(x)))


@implementation OrbitalPositions

// normalize degree values to always be between 0 and 360
double rev( double x )
{
    return  x - floor(x/360.0)*360.0;
}

// just incase I need to calculate the cubed root of a degree
double cbrtd( double x )
{
    if ( x > 0.0 )
        return exp( log(x) / 3.0 );
    else if ( x < 0.0 )
        return -cbrt(-x);
    else /* x == 0.0 */
        return 0.0;
}


- (SCNVector3)cartisianPositionForPlanet:(NSInteger)celestialBody atDate:(NSDate *)date {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    
    NSInteger day = [components day];
    NSInteger month = [components month];
    NSInteger year = [components year];
    
    // get the day number from the formula
    NSInteger dayNumber = 367*year - (7*(year + ((month+9)/12)))/4 + (275*month)/9 + day - 730530;
    NSDictionary *oeDict = [self orbitalElementsFor:celestialBody dayNumber:dayNumber];
    
    // get the orbital elements for our date
    CGFloat N = ((NSNumber *)oeDict[@"N"]).doubleValue;
    CGFloat M = ((NSNumber *)oeDict[@"M"]).doubleValue;
    CGFloat e = ((NSNumber *)oeDict[@"e"]).doubleValue;
    CGFloat a = ((NSNumber *)oeDict[@"a"]).doubleValue;
    CGFloat i = ((NSNumber *)oeDict[@"i"]).doubleValue;
    CGFloat w = ((NSNumber *)oeDict[@"w"]).doubleValue;
    
    CGFloat E0 = M + 180/PI * e * sind(M) * (1 + e * cosd(M));
    CGFloat E1 = E0 - (E0 - 180/PI * e * sind(E0) - M) / (1 - e * cosd(E0));
    
    CGFloat xi = a * (cosd(E1) - e);
    CGFloat yi = a * sqrt(1 - e*e) * sind(E1);
    
    CGFloat r = sqrt( xi*xi + yi*yi );
    CGFloat v = atan2d( yi, xi );
    
    CGFloat xeclip = r * ( cosd(N) * cosd(v+w) - sind(N) * sind(v+w) * cosd(i) );
    CGFloat yeclip = r * ( sind(N) * cosd(v+w) + cosd(N) * sind(v+w) * cosd(i) );
    CGFloat zeclip = r * sind(v+w) * sind(i);
    
    return SCNVector3Make(xeclip, yeclip, zeclip);
}

- (NSDictionary *)orbitalElementsFor:(CB)celestialBody dayNumber:(NSInteger)dayNumber {
    NSMutableDictionary *orbitalElements = [NSMutableDictionary new];
    switch (celestialBody) {
        case CBSun: {
            
        }
            break;
        case CBMercury: {
            [orbitalElements setValue:@(rev(48.3313 + (3.24587E-5 * dayNumber))) forKey:@"N"];
            [orbitalElements setValue:@(rev(7.0047 + (5.00E-8 * dayNumber))) forKey:@"i"];
            [orbitalElements setValue:@(rev(29.1241 + (1.01444E-5 * dayNumber))) forKey:@"w"];
            [orbitalElements setValue:@0.387098 forKey:@"a"];
            [orbitalElements setValue:@(rev(0.205635 + (5.59E-10 * dayNumber))) forKey:@"e"];
            [orbitalElements setValue:@(rev(168.6562 + (4.0923344368 * dayNumber))) forKey:@"M"];
        }
            break;
        case CBVenus: {
            [orbitalElements setValue:@(rev(76.6799 + (2.46590E-5 * dayNumber))) forKey:@"N"];
            [orbitalElements setValue:@(rev(3.3946 + (2.75E-8 * dayNumber))) forKey:@"i"];
            [orbitalElements setValue:@(rev(54.8910 + (1.38374E-5 * dayNumber))) forKey:@"w"];
            [orbitalElements setValue:@0.723330 forKey:@"a"];
            [orbitalElements setValue:@(rev(0.006773 - (1.302E-9 * dayNumber))) forKey:@"e"];
            [orbitalElements setValue:@(rev(48.0052 + (1.6021302244 * dayNumber))) forKey:@"M"];
        }
            break;
        case CBEarth: {
            [orbitalElements setValue:@(rev(0 + (0 * dayNumber))) forKey:@"N"];
            [orbitalElements setValue:@(rev(0 + (0 * dayNumber))) forKey:@"i"];
            [orbitalElements setValue:@(rev(54.8910 + (4.70935E-5 * dayNumber))) forKey:@"w"];
            [orbitalElements setValue:@1.0 forKey:@"a"];
            [orbitalElements setValue:@(rev(0.016709 - (1.151E-9 * dayNumber))) forKey:@"e"];
            [orbitalElements setValue:@(rev(356.0470 + (0.9856002585 * dayNumber))) forKey:@"M"];
        }
            break;
        case CBMars: {
            [orbitalElements setValue:@(rev(49.5574 + (2.11081E-5 * dayNumber))) forKey:@"N"];
            [orbitalElements setValue:@(rev(1.8497 - (1.78E-8 * dayNumber))) forKey:@"i"];
            [orbitalElements setValue:@(rev(286.5016 + (2.92961E-5 * dayNumber))) forKey:@"w"];
            [orbitalElements setValue:@1.523688 forKey:@"a"];
            [orbitalElements setValue:@(rev(0.093405 + (2.516E-9 * dayNumber))) forKey:@"e"];
            [orbitalElements setValue:@(rev(18.6021 + (0.5240207766 * dayNumber))) forKey:@"M"];
        }
            break;
        case CBJupiter: {
            [orbitalElements setValue:@(rev(100.4542 + (2.76854E-5 * dayNumber))) forKey:@"N"];
            [orbitalElements setValue:@(rev(1.3030 - (1.557E-7 * dayNumber))) forKey:@"i"];
            [orbitalElements setValue:@(rev(273.8777 + (1.64505E-5 * dayNumber))) forKey:@"w"];
            [orbitalElements setValue:@5.20256 forKey:@"a"];
            [orbitalElements setValue:@(rev(0.048498 + (4.469E-9 * dayNumber))) forKey:@"e"];
            [orbitalElements setValue:@(rev(19.8950 + (0.0830853001 * dayNumber))) forKey:@"M"];
        }
            break;
        case CBSaturn: {
            [orbitalElements setValue:@(rev(113.6634 + (2.38980E-5 * dayNumber))) forKey:@"N"];
            [orbitalElements setValue:@(rev(2.4886 - (1.081E-7 * dayNumber))) forKey:@"i"];
            [orbitalElements setValue:@(rev(339.3939 + (2.97661E-5 * dayNumber))) forKey:@"w"];
            [orbitalElements setValue:@9.55475 forKey:@"a"];
            [orbitalElements setValue:@(rev(0.055546 - (9.499E-9 * dayNumber))) forKey:@"e"];
            [orbitalElements setValue:@(rev(316.9670 + (0.0334442282 * dayNumber))) forKey:@"M"];
        }
            break;
        case CBUranus: {
            [orbitalElements setValue:@(rev(74.0005 + (1.3978E-5 * dayNumber))) forKey:@"N"];
            [orbitalElements setValue:@(rev(0.7733 + (1.9E-8 * dayNumber))) forKey:@"i"];
            [orbitalElements setValue:@(rev(96.6612 + (3.0565E-5 * dayNumber))) forKey:@"w"];
            [orbitalElements setValue:@(rev(19.18171 - (1.55E-8 * dayNumber))) forKey:@"a"];
            [orbitalElements setValue:@(rev(0.047318 + (7.45E-9 * dayNumber))) forKey:@"e"];
            [orbitalElements setValue:@(rev(142.5905 + (0.011725806 * dayNumber))) forKey:@"M"];
        }
            break;
        case CBNeptune: {
            [orbitalElements setValue:@(rev(131.7806 + (3.0173E-5 * dayNumber))) forKey:@"N"];
            [orbitalElements setValue:@(rev(1.7700 - (2.55E-7 * dayNumber))) forKey:@"i"];
            [orbitalElements setValue:@(rev(272.8461 - (6.027E-6 * dayNumber))) forKey:@"w"];
            [orbitalElements setValue:@(rev(30.05826 + (3.313E-8 * dayNumber))) forKey:@"a"];
            [orbitalElements setValue:@(rev(0.008606 + (2.15E-9 * dayNumber))) forKey:@"e"];
            [orbitalElements setValue:@(rev(260.2471 + (0.005995147 * dayNumber))) forKey:@"M"];
        }
            break;
        default:
            break;
    }
    return orbitalElements;
}




@end
