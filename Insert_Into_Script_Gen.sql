DECLARE @SourceDbName VARCHAR(50) = '[rcchains_rconline_2021].[dbo].';
DECLARE @DestDbName VARCHAR(50) = '[rcchains_rconline_2021_2].[dbo].';

SELECT DISTINCT t.TABLE_NAME, 'SET IDENTITY_INSERT ' + (SELECT @DestDbName) + t.TABLE_NAME+' ON ' +
'INSERT INTO ' + (SELECT @DestDbName) + t.TABLE_NAME+'('
  +STUFF((SELECT DISTINCT ', ' + t1.COLUMN_NAME
         FROM INFORMATION_SCHEMA.COLUMNS t1
         WHERE t.TABLE_NAME = t1.TABLE_NAME
            FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)') 
        ,1,2,'') +')'+
		'SELECT '+

		STUFF((SELECT DISTINCT ', ' + t1.COLUMN_NAME
         FROM INFORMATION_SCHEMA.COLUMNS t1
         WHERE t.TABLE_NAME = t1.TABLE_NAME
            FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)') 
        ,1,2,'') 
		+' FROM '+ (SELECT @SourceDbName) + t.TABLE_NAME+
' 
SET IDENTITY_INSERT ' + (SELECT @DestDbName) + t.TABLE_NAME+ ' OFF'

FROM INFORMATION_SCHEMA.COLUMNS t;
