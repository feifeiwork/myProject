//
//  POSTData.h
//  上传多个文件
//
//  Created by 田侠飞 on 16/6/4.
//  Copyright © 2016年 田侠飞. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface POSTData : NSObject
-(void)loadDataFromUrl:(NSURL *)urlString dataPaths:(NSArray *)paths dataDict:(NSDictionary *)dict dataFeildName :(NSString *)FeildName;
@end
