/// App内所有固定的链接
library;

const defaultBackendUrl = 'https://api.backend.cust.team';

/// App后端地址
String backendUrl = defaultBackendUrl;

/// 题库资源地址
String get tikuResUrl => '$backendUrl/res/tiku';

/// 科目图标地址
String get courseImgUrl => '$tikuResUrl/img';

/// 加群地址
const joinQQGroupUrl =
    'http://qm.qq.com/cgi-bin/qm/qr?_wv=1027&k=0_gE5gvMGjaXO7h_ldEHzKIRvgYx95Yi&group_code=795305110';

/// 本项目开源地址
const openSourceUrl =
    'https://github.com/CustedNG/toast_tiku_neumorphic_flutter';
