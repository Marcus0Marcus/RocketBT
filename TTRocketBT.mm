#import "TTRocketBT.h"

@implementation TTRocketBT



#pragma mark - public methods

static NSMutableDictionary* messageNameHandler = nil;
// sharedSingleton -> register<name,block>  addDispatcherHandler -> startServer 

+ (instancetype)sharedSingleton {
    static TTRocketBT* _sharedSingleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedSingleton = [[self alloc] init];
        messageNameHandler = [[NSMutableDictionary alloc] init];
    });
    return _sharedSingleton;
}
- (void) addDispatchHandler:(NSString *) name dispatchHandler:(rbt_message_handler) dispatch_handler{
    [messageNameHandler setObject:dispatch_handler forKey:name];
}

- (void) startServer:(NSString*) centerName{
    CPDistributedMessagingCenter *messageCenter = [objc_getClass("CPDistributedMessagingCenter") centerNamed:centerName];
    rocketbootstrap_distributedmessagingcenter_apply(messageCenter);
    [messageCenter runServerOnCurrentThread];
    NSArray* messageNames = [messageNameHandler allKeys];
    for(NSString* messageName in messageNames){
        [messageCenter registerForMessageName:messageName target:self selector:@selector(interfaceHandleMessage:userInfo:)];
    }

}

- (NSDictionary *)interfaceHandleMessage:(NSString *)name userInfo:(NSDictionary *)info{
    
    if(!messageNameHandler[name]){
        return nil;
    }
    rbt_message_handler rbt_handler = messageNameHandler[name];
    return rbt_handler(info);
}



-(NSDictionary*) sendMessageWithName:(NSString*) name userInfo:(NSMutableDictionary*)info centerNamed:(NSString*) centerName{
    CPDistributedMessagingCenter *messageCenter = [objc_getClass("CPDistributedMessagingCenter") centerNamed:centerName];
    rocketbootstrap_distributedmessagingcenter_apply(messageCenter);
    NSError *error;
    return [messageCenter sendMessageAndReceiveReplyName:name userInfo:info error:&error];
}
@end
