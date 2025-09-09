ac-24f845e7-c755-470b-9e2e-c13f0ed0509f


declare @AccessToken XML
exec [MV_CreateToken] 'ac-24f845e7-c755-470b-9e2e-c13f0ed0509f', @AccessToken out
select @AccessToken