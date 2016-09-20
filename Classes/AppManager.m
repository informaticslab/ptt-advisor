//
//  Copyright 2011  U.S. Centers for Disease Control and Prevention
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software 
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "AppManager.h"

static AppManager *sharedAppManager = nil;

@implementation AppManager


@synthesize appName, dc, tableFont, agreedWithEula;


#pragma mark Singleton Methods
+ (id)singletonAppManager {
	@synchronized(self) {
		if(sharedAppManager == nil)
			[[self alloc] init];
	}
	return sharedAppManager;
}

+ (id)allocWithZone:(NSZone *)zone {
	@synchronized(self) {
		if(sharedAppManager == nil)  {
			sharedAppManager = [super allocWithZone:zone];
			return sharedAppManager;
		}
	}
	return nil;
}

- (id)copyWithZone:(NSZone *)zone {
	return self;
}

- (id)retain {
	return self;
}

- (unsigned long)retainCount {
	return UINT_MAX; //denotes an object that cannot be released
}

- (id)autorelease {
	return self;
}

- (id)init {
	if ((self = [super init])) {
		appName = @"PTT Advisor";
        agreedWithEula = FALSE;
        tableFont = [UIFont boldSystemFontOfSize: 16];
        dc = [[DataController alloc] init];
        [dc restartPatientEvaluation];
	}
	return self;
}

- (void)dealloc {

	// Should never be called, but just here for clarity really.
    [dc release];
    [sharedAppManager release];
	[appName release];
	[super dealloc];

}

-(NSString *)debugLabelText
{
    return [NSString stringWithFormat:@"Tree=%lu, Node=%lu, Footnotes=%lu", (unsigned long)self.dc.currDecisionTree.number, (unsigned long)self.dc.currDecisionTree.number, (unsigned long)[self.dc.currDecisionTree.footnotes getCount]];
}

-(BOOL)isDebugInfoEnabled
{
    // Get user preference
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL enabled = [defaults boolForKey:@"enableDebugInfo"];
    return enabled;
    
}
@end
