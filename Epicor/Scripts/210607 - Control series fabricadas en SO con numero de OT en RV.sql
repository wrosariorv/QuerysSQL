
SELECT			A.*, 
				'------', 
				B.*
FROM			(
				SELECT			Company, PartNum, SerialNumber, SNStatus, JobNum, SNReference, CreatedInPlant, CreateDate 
				FROM			[CORPEPIDB].EpicorErp.Erp.SerialNo						SN				WITH (NoLock)
				WHERE			JobNum					<>			''
					AND			Company					=			'CO01'
				)		A
INNER JOIN		(
				SELECT			Company, PartNum, SerialNumber, SNStatus, JobNum, SNReference, CreatedInPlant, CreateDate
				FROM			[CORPEPIDB].EpicorErp.Erp.SerialNo						SN
				WHERE			JobNum					<>			''
					AND			Company					=			'CO02'
				)		B
	ON			A.PartNum			=			B.PartNum
	AND			A.SerialNumber		=			B.SerialNumber
	AND			A.JobNum			=			B.JobNum


