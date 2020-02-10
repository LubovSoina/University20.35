select distinct c.id                                                       as context_id,
                c.title                                                    as 'Название контекста',

                t.id                                                       as team_id,
                t.title                                                    as 'Название команды',

                j.id                                                       as j_id,
                jt.id                                                      as jt_id,
                jt.title                                                   as "Тип записи",

                ui.leaderID                                                   leaderID,
                concat(ui.lastname, ' ', ui.firstname, ' ', ui.middlename) as 'ФИО автора записи',
                tu.role                                                    as 'Роль автора',

                j.title                                                    as "Запись",
                j.description                                              as "Описание записи",
                j.createDT                                                 as 'Дата создания записи'


from people.journal j
         left join people.team_user tu on j.creatorID = tu.userID
    and j.teamID = tu.teamID
         left join people.team t on t.id = j.teamID
         left join people.journal_type jt on jt.id = j.typeID
         left join people.context_team ct on ct.teamID = j.teamID
         left join people.context c on c.id = ct.contextID
         left join people.user_info ui on j.creatorID = ui.userID
left join labs.context lc on c.uuid = lc.uuid
where lc.id in (142, 146, 132, 130, 153, 135, 145, 139, 166, 140, 167, 144, 147, 131, 175)
