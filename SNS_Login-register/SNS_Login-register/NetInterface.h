//
//  NetInterface.h
//  SNS_Login-register
//
//  Created by xyz on 15/9/22.
//  Copyright (c) 2015年 xyz. All rights reserved.
//

#ifndef SNS_Login_register_NetInterface_h
#define SNS_Login_register_NetInterface_h

//登录接口地址
#define kLoginUrl @"http://10.0.8.8/sns/my/login.php"
//参数—》username=%@&password=%@

//注册接口地址
#define kRegisterUrl @"http://10.0.8.8/sns/my/register.php"
//参数?username=%@&password=%@&email=%@


//上传头像(post)
#define kUploadImage @"http://10.0.8.8/sns/my/upload_headimage.php"
//获取相册列表(post)
#define kPhotoList @"http://10.0.8.8/sns/my/album_list.php"

#endif
