select distinct t.id,
                t.title,
                ui.leaderID,
                ui.lastname,
                ui.firstname,
                ui.middlename,
                ui.phone,
                u.email,
                group_concat(distinct tag.guid) tags,
                su.requiredProgress                                      'прогересс',
                if(su.requiredProgress = 100, 'Закончил', 'Не закончил') 'статус',




               su.countRequired 'сколько обязательных активностей прошел',
su.createDT
from (select *
      from ple.target t
      where t.id in (287, 291, 292, 293, 294,305,296,288,290,
                                          303, 306)) t
         left join ple.target_user tu on tu.targetID = t.id
         left join ple.stage s on s.targetID = t.id
         left join ple.stage_user su on su.stageID = s.id and su.userID = tu.userID
         left join ple.activity_stage sa on s.id = sa.stageID
         left join ple.user_activity ua on ua.activityID = sa.activityID and ua.userID = tu.userID
         left join ple.activity a on ua.activityID = a.id
         left join ple.user_info ui on ua.userID = ui.userID
         left join ple.user u on ui.userID = u.id
         left join ple.user_tag ut on ui.userID = ut.userID
         left join ple.tag tag on ut.tagID = tag.id
where ui.leaderID is not null
group by  t.title, ui.leaderID, ui.lastname, ui.firstname, ui.middlename, ui.phone, u.email, if(su.requiredProgress = 100, 'Закончил', 'Не закончил'), t.id
