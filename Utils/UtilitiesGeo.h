/*
 *  UtilitiesGeo.h
 *
 *  Created by Gary Morris on 3/6/11.
 *  Copyright 2011 Gary A. Morris. All rights reserved.
 *
 * This file is part of SDK_Utilities.repo
 *
 * This is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This file is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this file. If not, see <http://www.gnu.org/licenses/>.
 */

#ifndef UtilitiesGeo_h
#define UtilitiesGeo_h

// distance conversion factors
#define MILES_TO_METERS_FACTOR (1609.344)	/* exact */
#define MILES_TO_FEET_FACTOR   (5280)		/* exact */

#define METERS_TO_MILES_FACTOR (1/MILES_TO_METERS_FACTOR)
#define METERS_TO_FEET_FACTOR  (3.2808399)

#define NM_TO_METERS_FACTOR    (1852)		/* exact */
#define NM_TO_FEET_FACTOR      (6076.11549)	/* approx */

// earth radius is for a spherical earth model
#define EARTH_RADIUS_METERS    (6372797.6)

#define SPEED_OF_LIGHT_MPS     (299792458)	/* exact */

// degrees/radians conversion macros
#define Deg_to_Rad(X) (X*M_PI/180.0) 
#define Rad_to_Deg(X) (X*180.0/M_PI)


/*-------------------------------------------------------------------------
 * Given two lat/lon points on earth, calculates the heading
 * from lat1/lon1 to lat2/lon2.  
 * 
 * lat/lon params in radians
 * result in radians
 *-------------------------------------------------------------------------*/
double headingInRadians(double lat1, double lon1, double lat2, double lon2);

/*-------------------------------------------------------------------------
 * Given two lat/lon points on earth, calculates the heading
 * from lat1/lon1 to lat2/lon2.  
 * 
 * lat/lon params in degrees
 * result in degrees
 *-------------------------------------------------------------------------*/
double headingInDegrees(double lat1, double lon1, double lat2, double lon2);

/*-------------------------------------------------------------------------
 * Given a starting lat/lon point on earth, distance (in meters)
 * and bearing, calculates destination coordinates lat2/lon2.
 *
 * all params in radians
 *-------------------------------------------------------------------------*/
void destCoordsInRadians(double lat1, double lon1, 
						 double distanceMeters, double bearing,
						 double* lat2, double* lon2);

/*-------------------------------------------------------------------------
 * Given a starting lat/lon point on earth, distance (in meters)
 * and bearing, calculates destination coordinates lat2/lon2.
 *
 * all params in degrees
 *-------------------------------------------------------------------------*/
void destCoordsInDegrees(double lat1, double lon1, 
						 double distanceMeters, double bearing,
						 double* lat2, double* lon2);


// Normalize a heading in degrees to be within -179.999999° to 180.00000°
double normalize180(double heading);
float  normalize180f(float heading);

// Normalize a heading in degrees to be within 0° to 359.999999°
double normalize360(double heading);
float  normalize360f(float heading);

/*-------------------------------------------------------------------------
 * Compute Great Circle distance in meters from point 1 to point 2
 * -- latitude/longitude arguments must be in radians
 * -- result is in meters
 *-------------------------------------------------------------------------*/
double distanceInMetersFromRadians(double lat1, double lat2, double lon1, double lon2);

/*-------------------------------------------------------------------------
 * Compute Great Circle distance in meters from point 1 to point 2
 * -- latitude/longitude arguments in degrees
 * -- result is in meters
 *-------------------------------------------------------------------------*/
double distanceInMetersFromDegrees(double lat1, double lat2, double lon1, double lon2);

#endif

