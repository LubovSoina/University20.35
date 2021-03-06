select distinct c.id                                                        contextID,
                c.title                                                     team_context,
                t.title                                                     team_title,
                t.id                                                        teamID,
                ty.title 'Тип команды',
                concat('https://pt.2035.university/team/view?id=', t.id) as pt_team_link,
                ui.leaderID,
                concat(ui.lastname, ' ', ui.firstname, ' ', ui.middlename)  FIO,
                group_concat(distinct tu.role) roles,
                group_concat(distinct tag.guid)                             tags,
                t.createDT                                                  team_create_date,
                u.title                                                     uni,
                p.id                                                        proj_id,
                p.title                                                     proj_title,
                pty.title as 'тип проекта',
                concat('https://pt.2035.university/project/',p.guid) pt_project_link,
                p.boards as trello,
                c1.title                                                    project_context,
                p.createDT                                                  proj_createDT
from (select * from people.team t where t.active = 1 and t.createDT > '2020-04-10 14:10:21') t
    left join people.type ty on t.typeID=ty.id
         left join people.university u on t.universityID = u.id
         left join people.team_user tu on tu.teamID = t.id
         left join people.context_team ct on t.id = ct.teamID
         left join people.context c on ct.contextID = c.id
         left join (select pt.teamID, p.id, p.boards, p.guid, p.createDT,p.title,p.typeID
                    from people.project_team pt
                             inner join people.project p on pt.projectID = p.id
                    where p.active = 1) p on t.id = p.teamID
    left join people.project_type pty on pty.uuid=p.typeID
         left join people.context_project cp on p.id = cp.projectID
         left join people.context c1 on c1.id = cp.contextID
         left join people.user_info ui on ui.userID = tu.userID
         left join people.user_tag ut on ut.userID = tu.userID
         left join people.tag tag on ut.tagID = tag.id
where  tag.guid like '%ss20%'
group by c.id, c.title, t.title, t.id, ui.leaderID, p.id,
         concat(ui.lastname, ' ', ui.firstname, ' ', ui.middlename)
