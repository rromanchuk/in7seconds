/*
 Copyright 2009-2013 Urban Airship Inc. All rights reserved.

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:

 1. Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.

 2. Redistributions in binaryform must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided withthe distribution.

 THIS SOFTWARE IS PROVIDED BY THE URBAN AIRSHIP INC``AS IS'' AND ANY EXPRESS OR
 IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
 EVENT SHALL URBAN AIRSHIP INC OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
 OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "UABaseAppDelegateSurrogate.h"

@implementation UABaseAppDelegateSurrogate

- (void)forwardInvocation:(NSInvocation *)invocation {
    SEL selector = [invocation selector];

    // Throw the exception here to make debugging easier. We are going to forward the invocation to the
    // defaultAppDelegate without checking if it responds for the purpose of crashing the app in the right place
    // if the delegate does not respond which would be expected behavior. If the defaultAppDelegate is nil, we
    // need to exception here, and not fail silently.
    if (!self.defaultAppDelegate) {
        NSString *errorMsg = @"UABaseAppDelegateSurrogate defaultAppDelegate was nil while forwarding an invocation";
        NSException *defaultAppDelegateNil = [NSException exceptionWithName:@"UAMissingDefaultDelegate"
                                                                     reason:errorMsg
                                                                   userInfo:nil];
        [defaultAppDelegateNil raise];
    }

    BOOL responds = NO;

    //give the surrogate and default app delegates an opportunity to handle the message
    if ([self.surrogateDelegate respondsToSelector:selector]) {
        responds = YES;
        [invocation invokeWithTarget:self.surrogateDelegate];
    }
    if ([self.defaultAppDelegate respondsToSelector:selector]) {
        responds = YES;
        [invocation invokeWithTarget:self.defaultAppDelegate];
    }

    if (!responds) {
        //in the off chance that neither app delegate responds, forward the message
        //to the default app delegate anyway.  this will likely result in a crash,
        //but that way the exception will come from the expected location
        [invocation invokeWithTarget:self.defaultAppDelegate];
    }

}

- (BOOL)respondsToSelector:(SEL)selector {
    if ([super respondsToSelector:selector]) {
        return YES;
    } else {
        //if this isn't a selector we normally respond to, say we do as long as either delegate does
        if ([self.defaultAppDelegate respondsToSelector:selector] || [self.surrogateDelegate respondsToSelector:selector]) {
            return YES;
        }
    }

    return NO;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    NSMethodSignature *signature = nil;
    // First non nil method signature returns
    signature = [super methodSignatureForSelector:selector];
    if (signature) return signature;

    signature = [self.defaultAppDelegate methodSignatureForSelector:selector];
    if (signature) return signature;

    signature = [self.surrogateDelegate methodSignatureForSelector:selector];
    if (signature) return signature;

    // If none of the above classes return a non nil method signature, this will likely crash
    return signature;
}

@end
