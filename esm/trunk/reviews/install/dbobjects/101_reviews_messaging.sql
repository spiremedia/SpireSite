INSERT INTO [dbo].[messaging]
       ([id]
       ,[name]
       ,[subject]
       ,[moduleowner]
       ,[textcontent]
       ,[created]
       ,[changedby]
       ,[modified])
 VALUES
       ('8955AEDD-B044-6FD3-29F4EBE7301A039J'
       ,'User Review Admin Message'
       ,'A New Review was submitted'
       ,'reviews'
       ,'The review is [comment] by [username].'
       ,getDate()
       ,'8C8DD7E6-EA08-57D6-6556D3BB74048D54'
       ,getDate()
)
