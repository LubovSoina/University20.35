select c.title 'context',
       m.id,
       m.uuid,
       m.untiID,
       m.title,
       m.text,
       m.isPush 'пуш',
       m.source 'источник',
       m.createDT 'дата создания',
       m.readDT 'дата прочтения'
from msg.message m
         left join msg.context c on m.contextID = c.id
