select concat('https://pt.2035.university/admin/project/view/', p.id) as link,
       p.id                                                           as proj_id,
       p.title                                                        as p_title,
       p.active                                                       as isActive,
       u.title                                                        as university,
       t.id                                                           as team_id,
       t.title                                                        as team,
       p.boards                                                       as trello_link,
       concat('https://trello.com/b/',bo.hash_id,'/') as link_from_pm_trace,
       p.about                                                        as description,
       p.technology,
       c.id                                                           as contextID,
       c.title                                                        as context,
       p.createDT                                                     as create_date,
       p.dt                                                           as edit_date
FROM people.project p
         left join people.project_team pt on pt.projectID = p.id
         left join people.team t on t.id = pt.teamID
         left join people.university u on u.id = t.universityID
         left join people.context_project cp on cp.projectID = p.id
         left join people.context c on c.id = cp.contextID
left join pm_trace.pm_trace_project pp on pp.guid=p.guid
left join pm_trace.pm_trace_board bo on bo.project_id=pp.id
where c.id in (127, 131, 115, 139, 120, 130, 124, 152, 125, 153, 129, 132, 116, 161, 117)
group by p.id
