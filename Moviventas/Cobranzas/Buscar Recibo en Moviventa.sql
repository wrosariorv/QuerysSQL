select *  
FROM				[CORPSQLMULT2019].Moviventas.dbo.vw_cobranzas				C				WITH(NoLock) 
LEFT OUTER JOIN		RVF_VW_MOVI_TIPO_COBRANZA								T				WITH(NoLock) 
ON				C.codObservacion				=			T.CodeID 

where
CodVendedor is null or marca is null
Order by NroCobranza ASC
NroCobranza in ('1588','1909','2644')


select *  
FROM				[CORPSQLMULT2019].Moviventas.dbo.vw_cobranzas				C				WITH(NoLock) 
where
NroCobranza in ('55041','55260')
Order by NroCobranza ASC


}
Select * from [RVF_VW_IMP_RECIBO_HEADER]
where Recibo in ('1588','1909','2644')


select  * from RVF_TBL_IMP_RECIBO_LOG
where Recibo like '264%'

select  * from RVF_TBL_IMP_RECIBO_LOG
where Recibo like '190%'

select  * from RVF_TBL_IMP_RECIBO_LOG
where Recibo like '158%'

Select * from dbo.RVF_VW_IMP_RECIBO_HEADER