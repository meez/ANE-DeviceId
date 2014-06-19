//////////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2012 Freshplanet (http://freshplanet.com | opensource@freshplanet.com)
//  
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//  
//    http://www.apache.org/licenses/LICENSE-2.0
//  
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//  
//////////////////////////////////////////////////////////////////////////////////////

#import "AirDeviceId.h"
#import <UIKit/UIKit.h>
#import <AdSupport/AdSupport.h>
#import "MacAddressUID.h"

FREContext AirDeviceIdCtx = nil;


@implementation AirDeviceId

#pragma mark - Singleton

static AirDeviceId *sharedInstance = nil;

+ (AirDeviceId *)sharedInstance
{
    if (sharedInstance == nil)
    {
        sharedInstance = [[super allocWithZone:NULL] init];
    }

    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedInstance];
}

- (id)copy
{
    return self;
}

@end


#pragma mark - C interface

/* This is a TEST function that is being included as part of this template. 
 *
 * Users of this template are expected to change this and add similar functions 
 * to be able to call the native functions in the ANE from their ActionScript code
 */
DEFINE_ANE_FUNCTION(IsSupported)
{
    NSLog(@"Entering IsSupported()");

    FREObject fo;

    FREResult aResult = FRENewObjectFromBool(YES, &fo);
    if (aResult == FRE_OK)
    {
        //things are fine
        NSLog(@"Result = %d", aResult);
    }
    else
    {
        //aResult could be FRE_INVALID_ARGUMENT or FRE_WRONG_THREAD, take appropriate action.
        NSLog(@"Result = %d", aResult);
    }
    
    NSLog(@"Exiting IsSupported()");
    
    return fo;
}

DEFINE_ANE_FUNCTION(getID) {
    
    NSLog(@"Entering getID()");
    FREObject fo = NULL;
    
    uint32_t stringArgLength;
    const uint8_t *stringArg;
    
    NSString *salt;
    if (FREGetObjectAsUTF8(argv[0], &stringArgLength, &stringArg) != FRE_OK) {
        salt = @"";
    }
    else {
        salt = [NSString stringWithUTF8String:(char*)stringArg];
    }
    
    // get the mac address id
    NSString* idString = [MacAddressUID uniqueIdentifierForSalt:salt];

    NSLog(@"id returned: %@", idString);
    FRENewObjectFromUTF8(strlen([idString UTF8String]), (const uint8_t *)[idString UTF8String], &fo);
    
    NSLog(@"Exiting getID()");
    return fo;
}

DEFINE_ANE_FUNCTION(getIDFV) {
    
    NSLog(@"Entering getIDFV()");
    FREObject fo = NULL;
    
    // get the id
    if ([[UIDevice currentDevice] respondsToSelector:@selector(identifierForVendor)]) {
       
        NSLog(@"identifierForVendor supported");
        NSString* idString = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        
        NSLog(@"id returned: %@", idString);
        FRENewObjectFromUTF8(strlen([idString UTF8String]), (const uint8_t *)[idString UTF8String], &fo);
    }
    
    NSLog(@"Exiting getIDFV()");
    return fo;
}

DEFINE_ANE_FUNCTION(getIDFA) {
    
    NSLog(@"Entering getIDFA()");
    FREObject fo = NULL;
    
    // get the id
    if ([[ASIdentifierManager sharedManager] respondsToSelector:@selector(advertisingIdentifier)]) {
        
        NSLog(@"advertisingIdentifier supported");
        NSString* idString = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
        NSLog(@"id returned: %@", idString);
        FRENewObjectFromUTF8(strlen([idString UTF8String]), (const uint8_t *)[idString UTF8String], &fo);
    }
    
    NSLog(@"Exiting getIDFA()");
    return fo;
}

DEFINE_ANE_FUNCTION(getModel)
{
    NSLog(@"Entering getModel()");

    FREObject fo = NULL;

    //TODO: Get actual model. @see https://github.com/erica/uidevice-extension for an example
    NSString* modString = @"iOS";
    FREResult aResult = FRENewObjectFromUTF8(strlen([modString UTF8String]), (const uint8_t *)[modString UTF8String], &fo);
    
    if (aResult == FRE_OK)
    {
        //things are fine
        NSLog(@"Result = %d", aResult);
    }
    else
    {
        //aResult could be FRE_INVALID_ARGUMENT or FRE_WRONG_THREAD, take appropriate action.
        NSLog(@"Result = %d", aResult);
    }
    
    NSLog(@"Exiting getModel()");
    
    return fo;
}

DEFINE_ANE_FUNCTION(getVersion)
{
    NSLog(@"Entering getVersion()");

    FREObject fo = NULL;
    
    NSString* verString = [[UIDevice currentDevice] systemVersion];
        
    NSLog(@"version returned: %@", verString);
    FREResult aResult = FRENewObjectFromUTF8(strlen([verString UTF8String]), (const uint8_t *)[verString UTF8String], &fo);
    
    if (aResult == FRE_OK)
    {
        //things are fine
        NSLog(@"Result = %d", aResult);
    }
    else
    {
        //aResult could be FRE_INVALID_ARGUMENT or FRE_WRONG_THREAD, take appropriate action.
        NSLog(@"Result = %d", aResult);
    }
    
    NSLog(@"Exiting getVersion()");
    
    return fo;
}

#pragma mark - ANE setup

/* AirDeviceIdExtInitializer()
 * The extension initializer is called the first time the ActionScript side of the extension
 * calls ExtensionContext.createExtensionContext() for any context.
 *
 * Please note: this should be same as the <initializer> specified in the extension.xml 
 */
void AirDeviceIdExtInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet) 
{
    NSLog(@"Entering AirDeviceIdExtInitializer()");

    *extDataToSet = NULL;
    *ctxInitializerToSet = &AirDeviceIdContextInitializer;
    *ctxFinalizerToSet = &AirDeviceIdContextFinalizer;

    NSLog(@"Exiting AirDeviceIdExtInitializer()");
}

/* AirDeviceIdExtFinalizer()
 * The extension finalizer is called when the runtime unloads the extension. However, it may not always called.
 *
 * Please note: this should be same as the <finalizer> specified in the extension.xml 
 */
void AirDeviceIdExtFinalizer(void* extData) 
{
    NSLog(@"Entering AirDeviceIdExtFinalizer()");

    // Nothing to clean up.
    NSLog(@"Exiting AirDeviceIdExtFinalizer()");
    return;
}

/* ContextInitializer()
 * The context initializer is called when the runtime creates the extension context instance.
 */
void AirDeviceIdContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet)
{
    NSLog(@"Entering ContextInitializer()");

    /* The following code describes the functions that are exposed by this native extension to the ActionScript code.
     * As a sample, the function isSupported is being provided.
     */
    *numFunctionsToTest = 6;

    FRENamedFunction* func = (FRENamedFunction*) malloc(sizeof(FRENamedFunction) * (*numFunctionsToTest));
    func[0].name = (const uint8_t*) "isSupported";
    func[0].functionData = NULL;
    func[0].function = &IsSupported;
    
    func[1].name = (const uint8_t*) "getID";
    func[1].functionData = NULL;
    func[1].function = &getID;
    
    func[2].name = (const uint8_t*) "getIDFV";
    func[2].functionData = NULL;
    func[2].function = &getIDFV;
    
    func[3].name = (const uint8_t*) "getIDFA";
    func[3].functionData = NULL;
    func[3].function = &getIDFA;
    
    func[4].name = (const uint8_t*) "getModel";
    func[4].functionData = NULL;
    func[4].function = &getModel;
    
    func[5].name = (const uint8_t*) "getVersion";
    func[5].functionData = NULL;
    func[5].function = &getVersion;

    *functionsToSet = func;

    AirDeviceIdCtx = ctx;

    NSLog(@"Exiting ContextInitializer()");
}

/* ContextFinalizer()
 * The context finalizer is called when the extension's ActionScript code
 * calls the ExtensionContext instance's dispose() method.
 * If the AIR runtime garbage collector disposes of the ExtensionContext instance, the runtime also calls ContextFinalizer().
 */
void AirDeviceIdContextFinalizer(FREContext ctx) 
{
    NSLog(@"Entering ContextFinalizer()");

    // Nothing to clean up.
    NSLog(@"Exiting ContextFinalizer()");
    return;
}


