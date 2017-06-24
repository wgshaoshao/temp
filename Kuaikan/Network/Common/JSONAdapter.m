//
//  HTJSONAdapter.m
//
//  Created by Pat Ren on 12-1-11.
//

#import "JSONAdapter.h"

@implementation NSString (JSONAdapter)
- (id)jsonValue {
    
    if (self.length <= 0) {
        return nil;
    }
    
    NSError *error = nil;
    id jsonValue = [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding]
                                                   options:NSJSONReadingMutableLeaves
                                                     error:&error];
    
    if (error) {
        return nil;
    }
    return jsonValue;
    
}


@end

@implementation NSData (JSONAdapter)
- (id)jsonValue {
    
    if (self.length <= 0) {
        return nil;
    }

    NSError *error = nil;
    id jsonValue = [NSJSONSerialization JSONObjectWithData:self
                                                   options:NSJSONReadingMutableContainers
                                                     error:&error];
    
    if (error) {
        return nil;
    }
    return jsonValue;

}
@end

@implementation NSDictionary (JSONAdapter)

- (NSString *)jsonString {
    
    if (self.allKeys.count <= 0) {
        return nil;
    }
    
    NSError* error = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:kNilOptions
                                                         error:&error];
    if (error) {
        return nil;
    }
    NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                 encoding:NSUTF8StringEncoding];
    return jsonString;
    
}

@end

@implementation NSArray (JSONAdapter)

- (NSString *)jsonString {
    
    if (self.count <= 0) {
        return nil;
    }
    
    NSError* error = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:kNilOptions
                                                         error:&error];
    if (error) {
        return nil;
    }
    NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                 encoding:NSUTF8StringEncoding];
    return jsonString;
    
}

@end
