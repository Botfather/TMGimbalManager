//
//  TMGimbalManager.m
//  
//
//  Created by Tushar Mohan on 04/11/16.
//  Copyright © 2016 Tushar Mohan. All rights reserved.
//

#import "TMGimbalManager.h"

@interface TMGimbalManager ()
{
     GetInfoOnEntryWith _entryCallback;
     GetInfoOnExitWith  _exitCallback;
     CurrentCLLocation _currentLocationCallback;
    
     BOOL _isRequiredContinously;
     BOOL _isSentOnce;
}

@property (nonatomic) GMBLPlaceManager *placeManager;

@end

@implementation TMGimbalManager

+ (instancetype)getSharedInstance{
    static TMGimbalManager *sSharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sSharedInstance = [[TMGimbalManager alloc] init];
    });
    return sSharedInstance;
}

- (id)init{
    self = [super init];
    if(self)
    {
        [Gimbal setAPIKey:API_KEY options:nil];
        self.applicationInstanceIdentifier = [Gimbal applicationInstanceIdentifier];
        self.placeManager = [[GMBLPlaceManager alloc]init];
        self.placeManager.delegate = self;
    }
    return self;
}

+ (void)stopAllServices{
    [self isServiceStarted]?[Gimbal stop]:nil;
}

+ (BOOL)isServiceStarted{
    return [Gimbal isStarted];
}

+ (void)resetApplicationIdentifier{
    [self stopAllServices];
    [Gimbal resetApplicationInstanceIdentifier];
}

- (void)startAllServicesWithEntry:(GetInfoOnEntryWith)entryCaller andExit:(GetInfoOnExitWith)exitCaller{
    _entryCallback = entryCaller;
    _exitCallback  = exitCaller;
    [Gimbal start];
}

- (void)getCLLocationContinously:(BOOL)isContinous callback:(CurrentCLLocation)callback{
    _isRequiredContinously = isContinous;
    _isSentOnce = NO;
    _currentLocationCallback = callback;
}

# pragma mark - Gimbal Place Manager Delegate methods
- (void)placeManager:(GMBLPlaceManager*)manager didBeginVisit:(GMBLVisit*)visit
{
    _entryCallback(visit);
}

- (void)placeManager:(GMBLPlaceManager*)manager didEndVisit:(GMBLVisit*)visit
{
     _exitCallback(visit);
}

- (void)placeManager:(GMBLPlaceManager *)manager didDetectLocation:(CLLocation *)location{
    static CLLocation* previousLocation = nil;
    BOOL isUpdatedOnce;
    
    [location distanceFromLocation:previousLocation] == 0?isUpdatedOnce = YES:(isUpdatedOnce = NO);
    previousLocation = location;
    
    if((!_isSentOnce)||(_isSentOnce && _isRequiredContinously && !isUpdatedOnce))
    {
        _isSentOnce = YES;
        isUpdatedOnce = YES;
        self.currentDetectedLocation = location;
        _currentLocationCallback(location);
    }
    
}
@end
