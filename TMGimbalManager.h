//
//  TMGimbalManager.h
//  
//
//  Created by Tushar Mohan on 04/11/16.
//  Copyright © 2016 Tushar Mohan. All rights reserved.
//

#import <Gimbal/Gimbal.h>
#import <Foundation/Foundation.h>

//Update the macro with your API key, obtained from manager.gimbal.com
#define API_KEY @"YOUR_APP_API_KEY_FROM_GIMBAL"

/**
 This is used as for a callback to the controller whenever the user is entering a Geofenced location/Beacon marked region
 @param currentVisitInfo holds the details of the region exited
 */
typedef void (^GetInfoOnEntryWith)(GMBLVisit* currentVisitInfo);

/**
 This is used as for a callback to the controller whenever the user is exiting a Geofenced location/Beacon marked region
 @param currentExitInfo holds the details of the region exited
 */
typedef void (^GetInfoOnExitWith)(GMBLVisit* currentExitInfo);


/**
 This is used for a callback to the controller whenever getCLLCoordinateForCurrentLocationAnd: method is called

 @param location the current location of the device
 */
typedef void (^CurrentCLLocation)(CLLocation* location);

@interface TMGimbalManager : NSObject <GMBLPlaceManagerDelegate>

/**
  Identifies this application instance. Unique across all the applications.
 */
@property NSString* applicationInstanceIdentifier;


/**
 Stores the current detected location of the device
 */
@property CLLocation* currentDetectedLocation;


/**
 Fetch the shared instance of the singleton

 @return returns the instance if already initialised, else initialises and then returns
 */
+ (instancetype)getSharedInstance;


/**
 Stops all the Gimbal services (GMBLPlaceManager, GMBLCommunicationManager and GMBLEstablishedLocationManager)
 */
+ (void)stopAllServices;


/**
 Returns the Gimbal services state.
 @return NO if start was not called, or stop was called, on GMBLPlaceManager, GMBLCommunicationManager and GMBLEstablishedLocationManager. Else returns YES
 */
+ (BOOL)isServiceStarted;


/**
 Generates a new applicationInstanceIdentifier
 */
+ (void)resetApplicationIdentifier;


/**
 Starts all the Gimbal services (GMBLPlaceManager, GMBLCommunicationManager and GMBLEstablishedLocationManager)
 */
- (void)startAllServicesWithEntry:(GetInfoOnEntryWith)entryCaller andExit:(GetInfoOnExitWith)exitCaller;


/**
 Fetches the current location of the device

 @param isContinous sends the callback method repeatedly if set to YES
 @param callback    the callback method that the calling controller needs to execute
 */
- (void)getCLLocationContinously:(BOOL)isContinous callback:(CurrentCLLocation)callback;
@end
