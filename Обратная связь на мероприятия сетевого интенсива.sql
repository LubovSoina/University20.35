 select t.id                                                                                                           as trackID,
     t.title as track,
       a.id as activityID,
       a.title as activity,
       le.id                                                                                                             eventID,
       le.title                                                          event,
       date(ti.startDT)                                                                                               as date,
       ufa.userID,
       ufa.ufa_id                                                                                                     as ans_id,
       ufa.value                                                                                                      as answer,
       ufa.title                                                                                                      as question,
       ufa.fq_id                                                                                                      as question_id,
       if(group_concat(distinct au.title) is null, group_concat(distinct au1.title),
          group_concat(distinct au.title))                                                                            as author
FROM labs.event le
         left join (select ufa.id ufa_id, ufa.value, fq.title, fq.id fq_id, ufa.eventID, ufa.userID
                    from labs.user_feedback_answer ufa
                             left join labs.feedback_question fq on fq.id = ufa.feedbackQuestionID
                   ) ufa on le.id = ufa.eventID

         left join labs.timeslot ti on le.timeslotID = ti.id
         left join labs.run r on r.id = le.runID
         left join labs.activity a on a.id = r.activityID
         left join labs.activity_track at on a.id = at.activityID
         right join labs.track t on at.trackID = t.id
         left join labs.event_author ea on le.id = ea.eventID
         left join labs.author au on ea.authorID = au.id
         left join labs.activity_author aa on a.id = aa.activityID
         left join labs.author au1 on au1.id = aa.authorID
         left join labs.context_track ct on ct.trackID = t.id
         left join labs.context c on c.id = ct.contextID
where c.id = 252
  and t.id in (206, 207, 208, 209, 212, 213, 214, 215, 216, 217, 218, 219, 220, 221)
  and le.isDeleted = 0
  and a.isDeleted = 0
  and r.isDeleted = 0 and ufa.value is not null
group by ufa.userID, t.title, a.id, a.title, le.id, le.title, date(ti.startDT), t.id, ufa.ufa_id, ufa.value, ufa.title, ufa.fq_id
