
#import <Foundation/Foundation.h>
#import <AppSupport/CPDistributedMessagingCenter.h>
#import <rocketbootstrap/rocketbootstrap.h>
#import <objc/objc-runtime.h>
#import <dlfcn.h>
        

#pragma mark - macros


NS_ASSUME_NONNULL_BEGIN


typedef NSMutableDictionary*_Nonnull (^rbt_message_handler)(NSDictionary* user_info); // rbt message handler
@interface TTRocketBT : NSObject

#pragma mark - server methods
// 单例
+ (instancetype) sharedSingleton;

- (void) addDispatchHandler:(NSString *) name dispatchHandler:(rbt_message_handler) dispatch_handler;
- (void) startServer:(NSString*) centerName;


#pragma mark - client methods
-(NSDictionary*) sendMessageWithName:(NSString*) name userInfo:(NSMutableDictionary*)info centerNamed:(NSString*) centerName;

@end
NS_ASSUME_NONNULL_END

