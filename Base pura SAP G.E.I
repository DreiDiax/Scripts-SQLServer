WITH bp AS(	
	SELECT
		FORMAT(fecha, 'dd/MM/yyyy') as fecha,
		Hora,
		[ID citacion],
		Paciente,
		[Texto causal modificacion],
		[Unidad organizativa],
		Aseguradora,
		[Creado por],
		([Nombre medico] + ' ' +	[Apellido medico]) as Medico,
		[Sala cita],
		[Indicador anulacion],
		[Causal modificacion],
		ROW_NUMBER() OVER (
			PARTITION BY FORMAT(fecha, 'dd/MM/yyyy'), Hora, Paciente, [ID citacion], [Unidad organizativa]
			ORDER BY Paciente, [Unidad organizativa], fecha, [Indicador anulacion], [Causal modificacion]
		) AS rn
	FROM
		CentroContacto.dbo.Base_Pura_Sap
		where fecha BETWEEN '2025-04-01' and '2025-04-30'
)
SELECT
	bp.fecha,
	bp.[ID citacion],
	bp.[Texto causal modificacion],
	bp.[Unidad organizativa],
	bp.Aseguradora,
	bp.[Creado por],
	bp.Medico,
	bp.[Sala cita]
FROM bp
WHERE bp.rn = 1
ORDER BY bp.Paciente, bp.[Unidad organizativa], bp.fecha, bp.[Indicador anulacion], bp.[Causal modificacion]
