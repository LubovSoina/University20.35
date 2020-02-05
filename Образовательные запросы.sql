select distinct team_users.context                                               context,
                team_users.contextID                                             contextID,
                concat(ui1.lastname, ' ', ui1.firstname, ' ', ui1.middlename) as 'ФИО',
                ui1.leaderID                                                  as leaderID,
                team_users.teamID                                                teamID,
                team_users.team                                                  team,
                team_users.role                                                  role,
                ue.id                                                            edurequestID,
                ue.description                                                as 'Чему хотят научиться',
                ue.type                                                       as 'Уровень задачи',
                ue.reason                                                     as 'Описание задачи',
                ue.isPersonal                                                 as 'Типа за себя ли оставил?',
                ue.createDT                                                   as 'Дата создания',
                uec.competenceTitle                                           as 'Сектор знаний',
                uet.toolTitle                                                 as 'Инструменты',
                ui2.leaderID                                                  as 'Лидерайди за кого оставили запрос',
                concat(ui2.lastname, ' ', ui2.firstname, ' ', ui2.middlename) as 'ФИО за кого оставили запрос'
from (select distinct tu.userID,                                      #отбираем запросы людей, у которых есть команда
                      t.title  as team,
                      t.id     as teamID,
                      tu.role  as role,
                      lc.id    as contextID,
                      lc.title as context
      from people.team_user tu
               left join people.team t on tu.teamID = t.id
               left join people.context_team ct on tu.teamID = ct.teamID
               left join people.context c on ct.contextID = c.id
               left join labs.context lc on c.uuid = lc.uuid
      where lc.id in (142, 146, 132, 130, 153, 135, 145, 139, 166, 140, 167, 144, 147, 131, 175)) team_users   #здесь можно вставить или удалить id контекстов (из LABS !!!)
         left join people.user_info ui on team_users.userID = ui.userID
         left join ple.user_info ui1 on ui1.leaderID = ui.leaderID
         inner join ple.user_edurequest ue on ui1.userID = ue.userID
         left join ple.user_edurequest_competence uec on uec.userEdurequestID = ue.id
         left join ple.user_edurequest_tool uet on uet.userEdurequestID = ue.id
         left join ple.user_edurequest_user ueu on ue.id = ueu.userEdurequestID
         left join ple.user_info ui2 on ui2.userID = ueu.userID
where ui.leaderID not in (285904, 120408, 56129, 253433, 79918, 66276, 12274, 310842, 326040, 292928, 62575, 301300,  #убираем лидерайди сотрудников
                          345006, 357686, 253657, 530684, 118193, 670928, 697574, 665799,
                          631044, 60731, 253433, 29709, 663034, 120408, 253657, 285904, 670928, 60731)
