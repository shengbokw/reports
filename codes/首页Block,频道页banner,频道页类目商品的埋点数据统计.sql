# 更新昨日频道banner的点击数据
INSERT INTO bi.bi_drpt_home_click 
SELECT 
    DATE(ms.time),
    CONCAT('频道-banner-', bb.event_arg),
    ms.platform,
    COUNT(1),
    COUNT(DISTINCT ms.cookie),
    SUM(IF(ms.user_id = '\'', 1, 0)),
    COUNT(DISTINCT (IF(ms.user_id = '\'', ms.cookie, 0))) - 1,
    SUM(IF(ms.user_id <> '\'', 1, 0)),
    COUNT(DISTINCT (IF(ms.user_id <> '\'', ms.cookie, 0))) - 1
FROM
    bi.tmp_logs_mobile_stat ms,
    mobile.mobile_banner_base bb
WHERE
   ms.p1 = 'cd*b' AND 
    ms.p5 = bb.id
        AND bb.type LIKE 'category%'
        AND bb.start_time < t
        AND bb.end_time >= p
        AND ms.time >= p
        AND ms.time < t
GROUP BY ms.platform,ms.p5;
# 更新昨日类目商品点击数据
INSERT INTO bi.bi_drpt_home_click 
SELECT 
	DATE(ms.time),
    CONCAT('频道-',
            (SELECT 
                    category_name
                FROM
                    mms.mms_category
                WHERE
                    mc.parent_category_code = category_code),
            '-',
            mc.category_name,'-商品'),
    ms.platform,
    COUNT(1),
    COUNT(DISTINCT ms.cookie),
    SUM(IF(ms.user_id = '\'', 1, 0)),
    COUNT(DISTINCT (IF(ms.user_id = '\'', ms.cookie, 0))) - 1,
    SUM(IF(ms.user_id <> '\'', 1, 0)),
    COUNT(DISTINCT (IF(ms.user_id <> '\'', ms.cookie, 0))) - 1
FROM
    bi.tmp_logs_mobile_stat ms,
    mms.mms_category mc
WHERE
    ms.p1 = 'cd:c*i'
        AND mc.category_code = SUBSTRING_INDEX(SUBSTRING_INDEX(ms.p2, ':', - 1), '*', 1)
        AND ms.time >= p
        AND ms.time < t
GROUP BY mc.category_code, ms.platform;