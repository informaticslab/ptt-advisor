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

#import <UIKit/UIKit.h>

#ifndef DEBUG
//#define DEBUG
#else
#endif

#ifdef DEBUG
	#define DebugLog(fmt, ...) NSLog((@"%s[Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
	#define LineLog() DebugLog(@"");
#else
	#define DebugLog(...)
	#define LineLog(...)
#endif

// Info Log always displays output regardless of the DEBUG setting
#define InfoLog(fmt, ...) NSLog((@"%s[Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);

