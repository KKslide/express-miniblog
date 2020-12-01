/**
 * 校验是否为url地址
 * @param {String} str_url 要传入的url参数
 */
const IsURL = function (str_url) { // 校验是否为网络地址
    var strRegex =
        "^((https|http|ftp|rtsp|mms)?://)" +
        "?(([0-9a-z_!~*'().&=+$%-]+: )?[0-9a-z_!~*'().&=+$%-]+@)?" + //ftp的user@
        "(([0-9]{1,3}.){3}[0-9]{1,3}" + // IP形式的URL- 199.194.52.184
        "|" + // 允许IP和DOMAIN（域名）
        "([0-9a-z_!~*'()-]+.)*" + // 域名- www.
        "([0-9a-z][0-9a-z-]{0,61})?[0-9a-z]." + // 二级域名
        "[a-z]{2,6})" + // first level domain- .com or .museum
        "(:[0-9]{1,4})?" + // 端口- :80
        "((/?)|" + // a slash isn't required if there is no file name
        "(/[0-9a-z_!~*'().;?:@&=+$,%#-]+)+/?)$";
    var re = new RegExp(strRegex);
    if (re.test(str_url)) {
        return true;
    } else {
        return false;
    }
}

/**
 * 深拷贝函数
 * @param {Object} obj 传入一个需要深度克隆的对象或数组
 */
const deepClone = function (obj) {
    var target = {};
    for (var key in obj) {
        if (Object.prototype.hasOwnProperty.call(obj, key)) {
            if (typeof obj[key] === 'object') {
                target[key] = deepClone(obj[key]);
            } else {
                target[key] = obj[key];
            }
        }
    }
    return target;
}

export { IsURL, deepClone }