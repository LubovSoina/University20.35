SELECT leaderID,
       u.email,
       ui.phone,
       ui.jobPosition,
       lastname,
       firstname,
       middlename,
       jobCompanyTitle,
       birthday,
       group_concat(distinct tag.guid),
       pu.city,
       untiID
FROM ple.target_user tu
         left join ple.user_info ui on ui.userID = tu.userID
         left join ple.target t on t.id = tu.targetID
         left join ple.user_tag ut on ut.userID = ui.userID
         left join ple.tag tag on ut.tagID = tag.id
         left join sso.profiler_user pu on ui.untiID = pu.id
         left join ple.user u on ui.userID = u.id
where t.id in (287,
               288,
               290,
               291,
               292,
               293,
               294,
               304,
               302,
               295,
               299,
               301,
               305,
               296,
               303,
               306)
  and leaderID is not null
group by ui.leaderID
