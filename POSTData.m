//
//  POSTData.m
//  上传多个文件
//
//  Created by 田侠飞 on 16/6/4.
//  Copyright © 2016年 田侠飞. All rights reserved.
//

#import "POSTData.h"
#define KB @"hello"
@implementation POSTData
-(void)loadDataFromUrl:(NSURL *)urlString dataPaths:(NSArray *)paths dataDict:(NSDictionary *)dict dataFeildName :(NSString *)FeildName{
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:urlString];
    //    Content-Type:multipart/form-data; boundary=----WebKitFormBoundary1938w7lobaXhj623
    
    NSString * contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",KB];
    request.HTTPMethod =@"POST";
    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    //设置session
    
    NSURLSession * session = [NSURLSession sharedSession];
    
    
    NSURLSessionUploadTask * task = [session uploadTaskWithRequest:request fromData:[self bodyDataFromFeildName:FeildName dataPaths:paths dataDict:dict] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSString * str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        
        NSLog(@"%@",str);
        
    }];
    
    [task resume];
    
    
}

-(NSData *)bodyDataFromFeildName :(NSString*)FeildName dataPaths:(NSArray *)paths dataDict:(NSDictionary *)dict{
    NSMutableData * dataM = [NSMutableData data];
    
    
 
    for (NSString * path in paths) {
        
        NSString * fSting = [NSString stringWithFormat:@"--%@\r\n",KB];
        
        [dataM appendData:[fSting dataUsingEncoding:NSUTF8StringEncoding]];
        
        //第二行
        
        NSString * fileName = [path lastPathComponent];
        NSString * sString = [NSString stringWithFormat:@"Content-Disposition: form-data; name=%@; filename=%@\r\n",FeildName,fileName];
        [dataM appendData:[sString dataUsingEncoding:NSUTF8StringEncoding]];
        
        //第三行
        
        NSString * tString = [NSString stringWithFormat:@"Content-Type: pplication/octet-stream\r\n\r\n"];
        
        
        [dataM appendData:[tString dataUsingEncoding:NSUTF8StringEncoding]];
        //添加数据
        NSData * fileData  =[NSData dataWithContentsOfFile:path];
        
        [dataM appendData:fileData];
        
        //添加换行
        
        [dataM appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        
    }
    
    
    
    [dict enumerateKeysAndObjectsUsingBlock:^(NSString * key, NSString * value, BOOL * _Nonnull stop) {
        
        //    ------WebKitFormBoundary1938w7lobaXhj623
        //    Content-Disposition: form-data; name="status"
        //
        //    大傻逼
        //    ------WebKitFormBoundary1938w7lobaXhj623--
        
        
        NSString * fString = [NSString stringWithFormat:@"--%@\r\n",KB];
        
        [dataM appendData:[fString dataUsingEncoding:NSUTF8StringEncoding]];
        NSString * tString = [NSString stringWithFormat:@" Content-Disposition: form-data; name=%@\r\n\r\n",key];
        
        [dataM appendData:[tString dataUsingEncoding:NSUTF8StringEncoding]];
        
        //添加数据
        
        NSString * lstring =[NSString stringWithFormat:@"%@\r\n",value];
        
        [dataM appendData:[lstring dataUsingEncoding: NSUTF8StringEncoding]];
        
    }];
    
    //结束:
    NSString * lString = [NSString stringWithFormat:@"--%@--",KB];
    [dataM appendData:[lString dataUsingEncoding:NSUTF8StringEncoding]];
    return dataM.copy;
}

@end
