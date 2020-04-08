# view con sueldos promedios
CREATE VIEW sueldo_total AS
SELECT 
	sueldo.anho as anho,
	(sueldo.nombres || ' ' || sueldo.apellido_paterno || ' ' || sueldo.apellido_materno) AS nombre_completo,
        sueldo.contrato as tipo_contrato, 
        sueldo.estamento as estamento,
        sueldo.grado as grado,
        sueldo.calificacion_profesional_formacion as calificacion_profesional_formacion, 
        sueldo.cargo_o_funcion as cargo_o_funcion,
       SUM(sueldo.B_remuneracion_bruta)/12 AS sueldo_promedio,
       unidad.sigla as unidad
FROM sueldo
LEFT JOIN  unidad ON sueldo.codigo_unidad = unidad.codigo
GROUP BY (sueldo.nombres, sueldo.apellido_paterno, sueldo.apellido_materno, 
		  sueldo.anho, sueldo.contrato, sueldo.estamento, sueldo.grado, 
		  sueldo.calificacion_profesional_formacion, sueldo.cargo_o_funcion, 
		  unidad.sigla) 
order by sueldo_promedio DESC ; 



# 
SELECT SUM(foo.sueldo_final) as gasto_en_sueldos, 
 MAX(foo.sueldo_final) as maximo, 
  MIN(foo.sueldo_final) as minimo
FROM
( SELECT nombre_completo, SUM(sueldo_promedio) as sueldo_final, estamento FROM sueldo_total 
	WHERE ( estamento = 'Académico'  OR estamento = 'Directivo')
	AND unidad = 'FCFM'
	GROUP BY (nombre_completo, estamento)
	ORDER BY sueldo_final DESC
) as foo;




# ver sueldos de directivos y otros
# 10% de academicos que ganan sobre 2M
SELECT SUM(foo.sueldo_final)*0.1 as ahorro 
FROM
( SELECT nombre_completo, SUM(sueldo_promedio) as sueldo_final, estamento FROM sueldo_total 
	WHERE ( estamento = 'Académico'  OR estamento = 'Directivo')
	AND unidad = 'FCFM'
	GROUP BY (nombre_completo, estamento)
	HAVING SUM(sueldo_promedio) > 2000000
	ORDER BY sueldo_final DESC
) as foo;



 -- Tablas suma promedio y funcionarios, agrupados por contrato, estamento
 -- 1206 FCFM
SELECT '1 NOV' as mes, estamento, contrato, 
	COUNT(*) as n_funcionarios,
	SUM(B_remuneracion_bruta) as suma, 
	ROUND(AVG(B_remuneracion_bruta),0) as promedio
FROM sueldo
WHERE codigo_unidad = 1206
	AND anho = 2019
	AND mes = 'nov'
	GROUP by (estamento, contrato, mes)

UNION 

SELECT '2 NOV' as mes, '-' ,'HONORARIOS',
	COUNT(*) AS n_funcionarios, 
	SUM(honorario_total_bruto/n_cuotas) as sumHonorarios,
	ROUND(AVG(honorario_total_bruto/n_cuotas), 0) as avgHonorarios
FROM Honorarios
WHERE  codigo_unidad = 1206
	AND anho = 2019
	AND mes = 'nov'

UNION 

SELECT '3 TOTAL CONTRATA Y PLANTA' as mes, '-', '-',
	COUNT(*) as n_funcionarios,
	SUM(B_remuneracion_bruta) as sumTotal,
	ROUND(AVG(B_remuneracion_bruta), 0) as avgTotal
FROM sueldo
WHERE codigo_unidad = 1206
	AND anho = 2019
	AND mes = 'nov'

UNION

SELECT '4 TOTAL TOTAL' as mes, '-', '-',
	SUM(P.n_funcionarios) as n_funcionarios,
	SUM(P.sueldos) as sumTotal,
	ROUND(SUM(P.sueldos)/SUM(P.n_funcionarios), 0) as avgTotal
FROM
( 
	SELECT 
		COUNT(*) AS n_funcionarios, 
		SUM(honorario_total_bruto/n_cuotas) as sueldos
	FROM Honorarios
	WHERE  codigo_unidad = 1206
		AND anho = 2019
		AND mes = 'nov'

	UNION 

	SELECT 
		COUNT(*) as n_funcionarios,
		SUM(B_remuneracion_bruta) as sueldos
	FROM sueldo
	WHERE codigo_unidad = 1206
		AND anho = 2019
		AND mes = 'nov'
) as P
ORDER BY mes, promedio



# Academicos o Directivos con sueldos mayores a 2500000

SELECT SUM(B_remuneracion_bruta) as gasto_en_sueldos, 
	 	AVG(B_remuneracion_bruta) as average, 
  		COUNT(*) as cuenta
FROM sueldo
WHERE ( estamento = 'Académico'  OR estamento = 'Directivo')
AND codigo_unidad = 1206
AND MES = 'nov'
AND anho = 2019
AND B_remuneracion_bruta > 2500000	
	

