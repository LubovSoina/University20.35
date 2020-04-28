select distinct group_concat(distinct t.guid)                                                                'tags',
                ui.leaderID,

                concat(ui.lastname, ' ', ui.firstname, ' ', ui.middlename)                                as 'ФИО',

                tu.iniver                                                                                    'университет',
                group_concat(distinct tu.team)                                                               'Из какой команды',
                ue.id                                                                                        edurequestID,
                ue.description                                                                            as 'Чему хотят научиться',
                group_concat(distinct ue.type)                                                            as 'Уровень задачи',
                group_concat(distinct ue.reason)                                                          as 'Описание задачи',
                ue.isPersonal                                                                             as '1- оставил за себя и 0 - не за себя',
                ue.createDT                                                                               as 'Дата создания',
                if(group_concat(distinct uec.competenceTitle) is null, '-',
                   group_concat(distinct uec.competenceTitle))                                            as 'Сектор знаний',
                if(group_concat(distinct uet.toolTitle) is null, '-',
                   group_concat(distinct uet.toolTitle))                                                  as 'Инструменты',
                if(group_concat(distinct ui2.leaderID) is null, '-',
                   group_concat(distinct ui2.leaderID))                                                   as 'Лидерайди за кого оставили запрос',
                group_concat(distinct
                             concat(ui2.lastname, ' ', ui2.firstname, ' ', ui2.middlename))               as 'ФИО за кого оставили запрос'

from (select *
      from ple.tag t
      where t.guid in ('p1_team_ss20',
                       'p1_tracker_ss20',
                       'p1_author_ss20',
                       'p1_student_ss20',
                       'p1_vstu_student_ss20',
                       'p1_vyatsu_student_ss20',
                       'p1_kgsu_student_ss20',
                       'p1_mits_student_ss20',
                       'p1_rsue_student_ss20',
                       'p1_sevsu_student_ss20',
                       'p1_ncfu_student_ss20',
                       'p1_tolsu_student_ss20',
                       'p1_chuvsu_student_ss20',
                       'p1_sfu_student_ss20',
                       'p1_ugrasu_student_ss20',
                       'p0_student_ss20')) t
         inner join ple.user_tag ut on ut.tagID = t.id
         inner join ple.user_info ui on ut.userID = ui.userID
         inner join ple.user_edurequest ue on ui.userID = ue.userID
         left join ple.user_edurequest_competence uec on uec.userEdurequestID = ue.id
         left join ple.user_edurequest_tool uet on uet.userEdurequestID = ue.id
         left join ple.user_edurequest_user ueu on ue.id = ueu.userEdurequestID
         left join ple.user_info ui2 on ui2.userID = ueu.userID
         left join (select distinct ui.leaderID, t.title as team, t.id as teamID, u.title as iniver
                    from people.team_user tu
                             left join people.team t on tu.teamID = t.id
                             left join people.context_team ct on tu.teamID = ct.teamID
                             left join people.user_info ui on tu.userID = ui.userID
                             left join people.university u on t.universityID = u.id
                    where t.universityID in (27, 84, 275, 41, 135, 117, 10, 204, 127, 212, 121, 12, 56, 283)
                      and ct.contextID = 245) tu on ui.leaderID = tu.leaderID

where date(ue.createDT) > '2020-04-17'
group by ue.id, concat(ui.lastname, ' ', ui.firstname, ' ', ui.middlename)
