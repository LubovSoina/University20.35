select distinct c1.id                                                      contextID,
                c1.title                                                   proj_context,
                p.id,
                p.title                                                    proj,
                concat('https://pt.2035.university/project/', p.guid)      pt_project_link,
                p.boards as                                                trello,
                c1.title                                                   project_context,
                p.createDT                                                 'дата создания проекта',
                ui.leaderID,
                concat(ui.lastname, ' ', ui.firstname, ' ', ui.middlename) 'ФИО создателя проекта',
                group_concat(distinct tag.guid)


from (select * from people.project p where p.active = 1) p
         left join people.project_team pt on p.id = pt.projectID
         left join people.context_project cp on p.id = cp.projectID
         left join people.context c1 on cp.contextID = c1.id
         left join people.user_info ui on p.creatorID = ui.userID
         left join people.user_tag ut on ut.userID = ui.userID
         left join people.tag on ut.tagID = tag.id
where tag.guid like '%ss20%'
  and pt.teamID is null
group by c1.id, c1.title, p.id, p.title, c1.title, p.createDT, ui.leaderID,
         concat(ui.lastname, ' ', ui.firstname, ' ', ui.middlename)
