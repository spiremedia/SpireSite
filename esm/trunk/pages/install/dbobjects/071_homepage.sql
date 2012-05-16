DELETE FROM sitepages;
INSERT INTO [dbo].[sitepages]
           ([id]
           ,[pagename]
           ,[pageurl]
           ,[title]
           ,[parentid]
           ,[description]
           ,[keywords]
           ,[ownerid]
           ,[status]
           ,[sort]
           ,[siteid]
           ,[modifiedby]
           ,[modifieddate]
           ,[summary]
           ,[template]
           ,[innavigation]
          
           ,[relocate]
           
          
           ,[subsite]
           ,[breadcrumbs]
           ,[urlpath]
           ,[showdate]
           ,[hidedate])
     VALUES
           ('8955AEDD-B044-6FD3-29F4EBE7301A0390'
           ,'Home'
           ,'Home'
           ,'Home'
           ,''
           ,'Home Page Description'
           ,'Home Page Keywords'
           ,'8C8DD7E6-EA08-57D6-6556D3BB74048D54'
           ,'Staged'
           ,1
           ,'AD1724FF-E347-83EA-18FD424840AD5849:staged'
           ,'8C8DD7E6-EA08-57D6-6556D3BB74048D54'
           ,null
           ,'Home Page Summary'
           ,'Home'
           ,0
         
           ,null
          ,''
          ,'Home'
           ,''
           ,null
           ,null);
INSERT INTO [dbo].[sitepages]
           ([id]
           ,[pagename]
           ,[pageurl]
           ,[title]
           ,[parentid]
           ,[description]
           ,[keywords]
           ,[ownerid]
           ,[status]
           ,[sort]
           ,[siteid]
           ,[modifiedby]
           ,[modifieddate]
           ,[summary]
           ,[template]
           ,[innavigation]
          
           ,[relocate]
           
          
           ,[subsite]
           ,[breadcrumbs]
           ,[urlpath]
           ,[showdate]
           ,[hidedate])
     VALUES
           ('8955AEDD-B044-6FD3-29F4EBE7301A0390'
           ,'Home'
           ,'Home'
           ,'Home'
           ,''
           ,'Home Page Description'
           ,'Home Page Keywords'
           ,'8C8DD7E6-EA08-57D6-6556D3BB74048D54'
           ,'Published'
           ,1
           ,'AD1724FF-E347-83EA-18FD424840AD5849:published'
           ,'8C8DD7E6-EA08-57D6-6556D3BB74048D54'
           ,null
           ,'Home Page Summary'
           ,'Home'
           ,0
           
           ,null
          ,''
          ,'Home'
           ,''
           ,null
           ,null);
           
