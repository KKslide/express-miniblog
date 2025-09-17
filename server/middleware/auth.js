// /middleware/auth.js

module.exports = function (req, res, next) {
  console.log('那看来是OK的咯???', req.session)
  if (req.session && req.session.logData && req.session.logData.login) {
    // 登录状态，放行
    return next();
  }

  // 未登录，拦截请求
  return res.status(401).json({
    code: 401,
    message: '未登录或登录已过期，请重新登录'
  });
};
