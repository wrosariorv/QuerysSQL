--Busca Domicilio de embarque con error


select * from RVF_VW_MOVI_DOMICILIO_DE_CLIENTE
where
CodigoCliente='40778'
and CodigoDomicilio in ('ALC-02','RCA-02')
and SUBSTRING(CodigoDomicilio,1,3) <> UnidadNeg

select /*CodigoDomicilio,SUBSTRING(CodigoDomicilio,1,3) , UnidadNeg,*/* from RVF_VW_MOVI_DOMICILIO_DE_CLIENTE
where
SUBSTRING(CodigoDomicilio,1,3) <> UnidadNeg
and SUBSTRING(CodigoDomicilio,1,3) != 'OUT'
and SUBSTRING(CodigoDomicilio,1,3) != 'MPL'
and SUBSTRING(CodigoDomicilio,1,3) != 'TLC'
and SUBSTRING(CodigoDomicilio,1,3) != 'TC-'
and SUBSTRING(CodigoDomicilio,1,3) != 'NE-'
and SUBSTRING(CodigoDomicilio,1,3) != 'KE-'
and SUBSTRING(CodigoDomicilio,1,3) != 'hii'
and SUBSTRING(CodigoDomicilio,1,3) != 'hHI'
and SUBSTRING(CodigoDomicilio,1,3) != 'acl'
and SUBSTRING(CodigoDomicilio,1,3) != 'AL-'
and SUBSTRING(CodigoDomicilio,1,3) != 'AQL'
and SUBSTRING(CodigoDomicilio,1,3) != 'HTI'
AND CodigoDomicilio not  in (
'737KEL-99',
'FRA640',
'PER2825',
'MfgSys',
'PER2823',
'CDEE',
'FISC-SM',
'UNFLE')
		  