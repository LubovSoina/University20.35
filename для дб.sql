with card_done as (select distinct t.universityID                                                        u_id,
                                   count(distinct json_unquote(json_extract(ta.data, '$.data.card.id'))) c_done

                   from pm_trace.pm_trace_action ta
                            left join pm_trace.pm_trace_board b on ta.board_id = b.id
                            left join pm_trace.pm_trace_project ptp on b.project_id = ptp.id
                            left join people.project p on p.guid = ptp.guid
                            left join people.project_team pt on p.id = pt.projectID
                            left join people.team t on pt.teamID = t.id
                            left join people.context_team ct on ct.teamID = t.id
                            left join people.context c on c.id = ct.contextID
                   where (json_unquote(json_extract(ta.data, '$.data.listAfter.name')) like '%one%' or
                          json_unquote(json_extract(ta.data, '$.data.listAfter.name')) like '%cдела%' or
                          json_unquote(json_extract(ta.data, '$.data.listAfter.name')) like '%Сдела%' or
                          json_unquote(json_extract(ta.data, '$.data.listAfter.name')) like '%отово%' or
                          json_unquote(json_extract(ta.data, '$.data.listAfter.name')) like '%ыполн%' or
                          json_unquote(json_extract(ta.data, '$.data.listAfter.name')) like '%остигнутые%' or
                          json_unquote(json_extract(ta.data, '$.data.listAfter.name')) like '%заверш%' or
                          json_unquote(json_extract(ta.data, '$.data.listAfter.name')) like '%Заверш%' or
                          json_unquote(json_extract(ta.data, '$.data.listAfter.name')) like '%ЗАВЕРШЕННЫЕ%' or
                          json_unquote(json_extract(ta.data, '$.data.listAfter.name')) like '%ешено%' or
                          json_unquote(json_extract(ta.data, '$.data.listAfter.name')) like '%сполненн%')
                     and t.id is not null
                     and c.id = 245
                     and t.universityID in (27, 275, 41, 135, 117, 10, 127, 212, 121, 12, 290, 283)
                     and t.universityID is not null
                     and t.active = 1
                     and p.active = 1
                     and date(ta.external_creation_time) > '2020-04-10'
                   group by t.universityID),
     memebers as (
         select t.universityID u_id, count(distinct tu.userID) members
         from (select t.id, t.title, t.universityID
               from people.team t
                        inner join people.context_team ct on t.id = ct.teamID
               where ct.contextID = 245
                 and t.active = 1) t
                 left join (select distinct tu.userID, tu.teamID
from people.team_user tu
         left join people.user_tag ut on ut.userID = tu.userID
         left join people.tag t on ut.tagID = t.id
where t.guid not like '%tracker_ss20%'
  and tu.userID not in (
    select tu.userID from people.team_user tu where tu.role = 'tutor' or tu.role = 'mentor'
)
             ) tu
                   on t.id = tu.teamID
                 
         group by t.universityID
     ),
     note as (
         select distinct u.id                 u_id,
                         count(distinct j.id) a
         from people.journal_type jt
                  left join people.journal j on j.typeID = jt.id
                  inner join people.team_user tu on j.teamID = tu.teamID
                  left join people.team t on t.id = tu.teamID
                  left join people.context_team ct on t.id = ct.teamID
                  inner join people.university u on t.universityID = u.id
         where jt.id = 20
           and u.id in (27, 84, 275, 41, 135, 117, 10, 204, 127, 212, 121, 12, 56, 283)
           and t.active = 1
           and ct.contextID = 245
         group by u.id
     ),
     razm as (with in_rzm as (select distinct json_unquote(json_extract(j.data, '$.journalID')) id,
                                              json_unquote(json_extract(j.data, '$.link'))      cards
                              from people.journal j
                              where j.typeID = 9
                                and j.createDT > '2020-04-10')
              select t.universityID u_id,
                     count(distinct cards) a
              from (select json_unquote(json_extract(j.data, '$.project_guid')) p_g,
                           j.id
                    from people.journal j
                    where j.typeID = 8
                      and j.createDT > '2020-04-10') j
                       left join in_rzm on in_rzm.id = j.id
                       left join people.project p on j.p_g = p.guid
                       left join people.project_team pt on p.id = pt.projectID
                       left join people.team t on pt.teamID = t.id
                       left join people.context_team ct on t.id = ct.teamID
              where p.active = 1
                and t.active = 1
                and t.universityID in (27, 275, 41, 135, 117, 10, 127, 212, 121, 12, 290, 283)
                and in_rzm.id is not null
                and ct.contextID = 245
              group by t.universityID)
select distinct u.id,u.title,card_done.c_done,
       note.a 'записей по семату',m.members,razm.a'размеченных'
from (select *
      from people.university u
      where u.id in (27, 275, 41,  117, 10, 127, 212, 121, 12, 290, 283)) u
         left join (select t.id, t.title, t.universityID
                    from people.team t
                             inner join people.context_team ct on t.id = ct.teamID
                    where ct.contextID = 245
                      and t.active = 1) t on t.universityID = u.id
         left join razm on razm.u_id = u.id
         left join note on note.u_id = u.id
         left join memebers m on m.u_id = u.id
         left join card_done on card_done.u_id = u.id
