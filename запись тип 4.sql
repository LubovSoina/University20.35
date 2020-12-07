select distinct c.title,
                c.id,
                u.title,
                t.title,
                concat(ui.lastname, ' ', ui.firstname, ' ', ui.middlename) FIO,
                ui.leaderID,
                j.data,
                jt.title,
                j.createDT


from people.journal_type jt
         left join people.journal j on jt.id = j.typeID
         left join people.team t on t.id = j.teamID
         left join people.user_info ui on j.creatorID = ui.userID
         left join people.university u on t.universityID = u.id
         left join people.context_team ct on t.id = ct.teamID
         left join people.context c on ct.contextID = c.id


where jt.id = 4 and j.createDT>='2020-11-02' and j.createDT<'2020-11-08' and c.id =287
