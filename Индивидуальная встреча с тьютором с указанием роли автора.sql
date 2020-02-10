select distinct c.id                                                          as context_id,
                c.title                                                       as 'Название контекста',
                t.id                                                          as team_id,
                t.title                                                       as 'Название команды',
                j.id                                                          as j_id,
                jt.id                                                         as jt_id,
                jt.title                                                      as "Тип записи",
                ui.leaderID                                                   as 'leaderID автора',
                concat(ui.lastname, ' ', ui.firstname, ' ', ui.middlename)    as 'ФИО автора записи',
                tu.role                                                       as 'Роль автора',
                j.title                                                       as "Запись",
                j.description                                                 as "Описание записи",
                ui1.leaderID                                                  as 'leaderID о ком запись',
                concat(ui1.lastname, ' ', ui1.firstname, ' ', ui1.middlename) as 'ФИО о ком запись',
                j.createDT                                                    as 'Дата создания записи'
from people.journal j
         left join people.team_user tu on j.creatorID = tu.userID
         left join people.team t on t.id = tu.teamID
         left join people.journal_type jt on jt.id = j.typeID
         left join people.context_team ct on ct.teamID = tu.teamID
         left join people.context c on c.id = ct.contextID
         left join people.user_info ui on j.creatorID = ui.userID
         left join people.user_info ui1 on ui1.userID = j.userID
         left join labs.context lc on c.uuid = lc.uuid
where lc.id in (142, 146, 132, 130, 153, 135, 145, 139, 166, 140, 167, 144, 147, 131, 175)

  and jt.id = 3  #ID типа записи Индивидуальная встреча с тьютором
