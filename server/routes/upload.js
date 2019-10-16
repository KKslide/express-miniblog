var express = require('express');
var path = require('path');
var fs = require('fs');
var formidable = require("formidable");
var router = express.Router();

// 引入七牛模块  
var qiniu = require("qiniu");
var bucket = 'kkslide'; //要上传的空间名
var imageUrl = 'http://example.kkslide.fun/'; // 域名名称
var accessKey = 'FqmlgBwy5Y8JLxmW7ZKtVwiKPnX_piGG1fdb52Yk';
var secretKey = 'bo9whWlbwjd60aYQk5JzBYLOPtPmEyMx10ajEztK';
var mac = new qiniu.auth.digest.Mac(accessKey, secretKey);

var options = {
    scope: bucket,
    expires: 9999999999
};
var putPolicy = new qiniu.rs.PutPolicy(options);
var uploadToken = putPolicy.uploadToken(mac);
console.log('putPolicy------', putPolicy);
console.log('*************************************************');
console.log('uploadToken------', uploadToken);

var config = new qiniu.conf.Config();
config.zone = qiniu.zone.Zone_z0; // 华东地区服务器 
console.log('*************************************************');
console.log(config);
// *****以上的配置该有都有了***************************************************
// 图片上传
router.post('/upload', function (req, res, next) {
    var form = new formidable.IncomingForm()
    form.uploadDir = "./upload";
    form.keepExtentsions = true;
    form.parse(req, function (err, fields, files) {
        console.log('fields---',fields); // 空
        console.log('files---',files); // 有货
        console.log('------------------------------------------------------------------');

        // var fileName = files.file.path.split(path.sep).pop();
        // var localFile = files.file.path;
        var fileName = Object.values(files)[0].path.split(path.sep).pop();
        var localFile = Object.values(files)[0].path;
        var formUploader = new qiniu.form_up.FormUploader(config);
        var putExtra = new qiniu.form_up.PutExtra();
        var key = fileName;

        // 文件上传
        formUploader.putFile(uploadToken, key, localFile, putExtra, function (respErr, respBody, respInfo) {
            if (respErr) {
                res.end(JSON.stringify({ status: '-1', msg: '上传失败', error: respErr }));
            }
            if (respInfo.statusCode == 200) {
                var imageSrc = imageUrl + respBody.key;
                res.end(JSON.stringify({ status: '200', msg: '上传成功', imageUrl: imageSrc }));
                console.log(respBody);
            } else {
                res.end(JSON.stringify({ status: '-1', msg: '上传失败', error: JSON.stringify(respBody) }));
            }
            // 上传之后删除本地文件
            fs.unlinkSync(localFile);
        });

        /*
            fs.writeFile(filePath, dataBuffer, function (err) {
                if (err) {
                    res.end(JSON.stringify({ status: '102', msg: '文件写入失败' }));
                } else {

                    var localFile = filePath;
                    var formUploader = new qiniu.form_up.FormUploader(config);
                    var putExtra = new qiniu.form_up.PutExtra();
                    var key = fileName;

                    // 文件上传
                    formUploader.putFile(uploadToken, key, localFile, putExtra, function (respErr, respBody, respInfo) {
                        if (respErr) {
                            res.end(JSON.stringify({ status: '-1', msg: '上传失败', error: respErr }));
                        }
                        if (respInfo.statusCode == 200) {
                            var imageSrc = imageUrl + respBody.key;
                            res.end(JSON.stringify({ status: '200', msg: '上传成功', imageUrl: imageSrc }));
                        } else {
                            res.end(JSON.stringify({ status: '-1', msg: '上传失败', error: JSON.stringify(respBody) }));
                        }
                        // 上传之后删除本地文件
                        fs.unlinkSync(filePath);
                    });
                }
            });
        */
    });

});

module.exports = router;
