USE EpicorERP

select                   [Source], BpMethodCode, DirectiveType, Name, DirectiveGroup
from                    
						[CORPEPIDB].EpicorERP.Ice.BpDirective
where                    
						cast(Body as nvarchar(max)) like '%Gastos Variables%'  and IsEnabled = 1 order by BpMethodCode

