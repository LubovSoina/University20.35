WITH uid AS
         (SELECT untiID,

                 concat(ui.lastname, ' ', ui.firstname) fi,
                 ui.leaderID,
                 group_concat(distinct tag.guid)        tags

          FROM ple.user_info as ui
                   left join ple.user_tag ut on ut.userID = ui.userID
                   left join ple.tag tag on ut.tagID = tag.id
          WHERE ui.untiID IS NOT NULL
            and ut.userID in (select ut.userID
                              from ple.user_tag ut
                                       left join ple.tag tag on ut.tagID = tag.id
                              where tag.title in ('p1_student_ss20', 'p0_student_ss20'))
          group by untiID, concat(ui.lastname, ' ', ui.firstname), ui.leaderID)

SELECT distinct uid.*,
                ui.uid,
                cus.course_id,
                c.title,
                c.edx_url,
                cus.created_at,
                cus.dt_finish,
                course_level,
                if(tags like '%sfu%', 'ЮФУ',
                   if(tags like '%vstu%', 'Воронежский ГТУ',
                      if(tags like '%vyatsu%', 'ВятГУ',
                         if(tags like '%mits%', 'МИТУ-МАСИ',
                            if(tags like '%rsue%', 'РГЭУ (РИНХ)',
                               if(tags like '%sevsu%', 'СевГУ',
                                  if(tags like '%ncfu%', 'СКФУ',
                                     if(tags like '%tolsu%', 'Тольяттинский ГУ',
                                        if(tags like '%chuvsu%', 'Чувашский ГУ',
                                            if(tags like '%ugrasu%', 'Югорский ГУ',
                                               if(tags like '%p0%', 'У2035',' ') ) ) )))))))) 'вуз'
FROM cat.rall_courseuserstatus AS cus
         left join cat.plp_course c on cus.course_id = c.id
         LEFT JOIN cat.social_auth_usersocialauth ui ON cus.user_id = ui.user_ID AND ui.uid IS NOT null
         inner join uid on uid.untiID = ui.uid
WHERE cus.is_active = 1
  AND cus.created_at >= '2020-04-10'
