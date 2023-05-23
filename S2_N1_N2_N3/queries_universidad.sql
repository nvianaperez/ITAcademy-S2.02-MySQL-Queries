--- 1 ---
SELECT P.apellido1, P.apellido2, P.nombre FROM persona P WHERE P.tipo = 'alumno' ORDER BY P.apellido1, P.apellido2, P.nombre;
--- 2 ---
SELECT P.nombre, P.apellido1, P.apellido2 FROM persona P WHERE P.tipo = 'alumno' AND P.telefono IS NULL;
--- 3---
SELECT P.nif, P.nombre, P.apellido1, P.apellido2 FROM persona P WHERE P.tipo = 'alumno' and YEAR(P.fecha_nacimiento) = 1999;
--- 4 ---
SELECT P.nif, P.nombre, P.apellido1, P.apellido2 FROM persona P WHERE P.tipo = 'profesor' AND P.telefono IS NULL AND P.nif LIKE '%K';
--- 5 ---
SELECT id, nombre FROM asignatura WHERE cuatrimestre = 1 AND curso = 3 AND id_grado = 7;
--- 6 ---
SELECT P.apellido1, P.apellido2, P.nombre, D.nombre AS 'Nombre departamento' 
FROM persona P LEFT JOIN profesor PR ON (P.id = PR.id_profesor)
LEFT JOIN  departamento D ON (PR.id_departamento = D.id)
ORDER BY P.apellido1, P.apellido2, P.nombre;
--- 7 ---
-- Retorna un llistat amb el nom de les assignatures, 
-- any d'inici i any de fi del curs escolar 
-- de l'alumne/a amb NIF 26902806M.
SELECT P.nif, A.nombre AS 'Asignaturas del alumno', C.anyo_inicio, C.anyo_fin
FROM persona P INNER JOIN alumno_se_matricula_asignatura AL ON (P.id = AL.id_alumno)
INNER JOIN asignatura A ON (AL.id_asignatura = A.id)
INNER JOIN curso_escolar C ON (AL.id_curso_escolar = C.id)
WHERE P.nif LIKE '26902806M';
--- 8 ---
-- Retorna un llistat amb el nom de tots els departaments 
-- que tenen professors/es que imparteixen alguna assignatura 
-- en el Grau en Enginyeria Informàtica (Pla 2015).
SELECT D.nombre AS 'Departamentos relacionados con GEI', A.nombre AS 'Nombre asignatura'
FROM Departamento D INNER JOIN profesor PR ON (D.id = PR.id_departamento)
INNER JOIN asignatura A ON (PR.id_profesor = A.id_profesor)
INNER JOIN grado G ON (A.id_grado = G.id)
WHERE G.nombre = 'Grado en Ingeniería Informática (Plan 2015)';
--- 9 ---
-- Retorna un llistat amb tots els alumnes 
-- que s'han matriculat en alguna assignatura 
-- durant el curs escolar 2018/2019.
SELECT P.nif AS 'Alumnos matriculados en curso 2018/2019', A.nombre, C.anyo_inicio 
FROM persona P INNER JOIN alumno_se_matricula_asignatura AL ON (P.id = AL.id_alumno)
INNER JOIN asignatura A ON (AL.id_asignatura = A.id)
INNER JOIN curso_escolar C ON (AL.id_curso_escolar = C.id)
WHERE C.anyo_inicio = 2018;


--- LEFT JOIN  AND RIGHT JOIN ---

--- 1 ---
-- Retorna un llistat amb els noms de tots els professors/es 
-- i els departaments que tenen vinculats. 
-- El llistat també ha de mostrar aquells professors/es que no tenen cap departament associat. 
-- El llistat ha de retornar quatre columnes, nom del departament, 
-- primer cognom, segon cognom i nom del professor/a. 
-- El resultat estarà ordenat alfabèticament de menor a major 
-- pel nom del departament, cognoms i el nom.
SELECT P.apellido1, P.apellido2, P.nombre, D.nombre AS 'Nombre departamento' FROM persona P
INNER JOIN profesor PR ON (P.id = PR.id_profesor)
LEFT JOIN departamento D ON (PR.id_departamento = D.id)
ORDER BY D.nombre, P.apellido1, P.apellido2, P.nombre;

-- tots els professors tenen departament -- 12 rows
SELECT PR.id_profesor, D.id FROM profesor PR LEFT JOIN departamento D ON (PR.id_departamento = D.id);

--- 2 ---
-- Retorna un llistat amb els professors/es que no estan associats a un departament.
-- retorna 0 rows
SELECT P.apellido1, P.apellido2, P.nombre FROM persona P 
RIGHT JOIN profesor PR ON (P.id = PR.id_profesor)
LEFT JOIN departamento D ON (PR.id_departamento = D.id)
WHERE D.id IS NULL;

--- 3 ---
-- Retorna un llistat amb els departaments que no tenen professors/es associats.
SELECT D.nombre FROM departamento D LEFT JOIN profesor PR ON (D.id = PR.id_departamento)
WHERE PR.id_profesor IS NULL;

--- 4 ---
-- Retorna un llistat amb els professors/es que no imparteixen cap assignatura.
SELECT P.apellido1, P.apellido2, P.nombre FROM persona P 
RIGHT JOIN profesor PR ON (P.id = PR.id_profesor) 
LEFT JOIN asignatura A ON (PR.id_profesor = A.id_profesor) WHERE A.id_profesor IS NULL;

--- 5 ---
-- Retorna un llistat amb les assignatures que no tenen un professor/a assignat.
SELECT A.nombre FROM asignatura A LEFT JOIN profesor PR ON (A.id_profesor = PR.id_profesor)
WHERE A.id_profesor IS NULL;

--- 6 ---
-- Retorna un llistat amb tots els departaments 
-- que no han impartit assignatures en cap curs escolar.
SELECT D.nombre FROM departamento D LEFT JOIN profesor PR ON (D.id = PR.id_departamento)
LEFT JOIN asignatura A ON (PR.id_profesor = A.id_profesor)
LEFT JOIN alumno_se_matricula_asignatura AL ON (A.id = AL.id_asignatura) 
WHERE AL.id_curso_escolar IS NULL;


--- CONSULTES RESUM ---
--- 1 ---
-- Retorna el nombre total d'alumnes que hi ha.
SELECT tipo, COUNT(*) FROM persona GROUP BY tipo;
SELECT COUNT(*) FROM persona WHERE tipo = 'alumno';
--- 2 ---
-- Calcula quants alumnes van néixer en 1999.
SELECT COUNT(nif) AS 'Alumnos nacido en 1999' FROM persona WHERE YEAR(fecha_nacimiento)=1999 AND tipo='alumno';
--- 3 ---
-- Calcula quants professors/es hi ha en cada departament. 
-- El resultat només ha de mostrar dues columnes, una amb el nom del departament 
-- i una altra amb el nombre de professors/es que hi ha en aquest departament. 
-- El resultat només ha d'incloure els departaments que tenen professors/es associats 
-- i haurà d'estar ordenat de major a menor pel nombre de professors/es.
SELECT D.nombre, COUNT(PR.id_profesor) FROM departamento D RIGHT JOIN profesor PR ON (D.id = PR.id_departamento) GROUP BY D.nombre ORDER BY COUNT(PR.id_profesor) DESC;
--- 4 ---
-- Retorna un llistat amb tots els departaments i el nombre de professors/es que hi ha en cadascun d'ells. 
-- Tingui en compte que poden existir departaments que no tenen professors/es associats. 
-- Aquests departaments també han d'aparèixer en el llistat.
SELECT D.nombre, COUNT(PR.id_profesor) FROM departamento D LEFT JOIN profesor PR ON (D.id = PR.id_departamento) GROUP BY D.nombre ORDER BY COUNT(PR.id_profesor) DESC;
--- 5 ---
-- Retorna un llistat amb el nom de tots els graus existents en la base de dades 
-- i el nombre d'assignatures que té cadascun. 
-- Tingues en compte que poden existir graus que no tenen assignatures associades. 
-- Aquests graus també han d'aparèixer en el llistat. 
-- El resultat haurà d'estar ordenat de major a menor pel nombre d'assignatures.
SELECT G.nombre, COUNT(A.nombre) FROM grado G LEFT JOIN asignatura A ON (G.id = A.id_grado) GROUP BY G.nombre ORDER BY COUNT(A.nombre) DESC;
--- 6 ---
-- Retorna un llistat amb el nom de tots els graus existents en la base de dades 
-- i el nombre d'assignatures que té cadascun, dels graus que tinguin més de 40 assignatures associades.
SELECT G.nombre, COUNT(A.id) AS 'Número de asignaturas' FROM grado G LEFT JOIN asignatura A ON (G.id = A.id_grado) GROUP BY G.nombre HAVING COUNT(A.id) > 40;
--- 7 ---
-- Retorna un llistat que mostri el nom dels graus 
-- i la suma del nombre total de crèdits que hi ha per a cada tipus d'assignatura. 
-- El resultat ha de tenir tres columnes: nom del grau, tipus d'assignatura 
-- i la suma dels crèdits de totes les assignatures que hi ha d'aquest tipus.
SELECT G.nombre, A.tipo AS 'Tipo de asignatura', SUM(A.creditos) AS 'Número total de créditos' 
FROM grado G LEFT JOIN asignatura A ON (G.id = A.id_grado) GROUP BY G.nombre, A.tipo;
--- 8 ---
-- Retorna un llistat que mostri quants alumnes s'han matriculat d'alguna assignatura en cadascun dels cursos escolars. 
-- El resultat haurà de mostrar dues columnes, una columna amb l'any d'inici del curs escolar i una altra amb el nombre d'alumnes matriculats.
SELECT CONCAT (C.anyo_inicio,' - ',C.anyo_fin) AS 'Curso_escolar', COUNT(DISTINCT AL.id_alumno) 
FROM curso_escolar C LEFT JOIN alumno_se_matricula_asignatura AL ON (C.id = AL.id_curso_escolar) 
GROUP BY Curso_escolar;
--- 9 ---
-- Retorna un llistat amb el nombre d'assignatures que imparteix cada professor/a. 
-- El llistat ha de tenir en compte aquells professors/es que no imparteixen cap assignatura. 
-- El resultat mostrarà cinc columnes: id, nom, primer cognom, segon cognom i nombre d'assignatures. 
-- El resultat estarà ordenat de major a menor pel nombre d'assignatures.
SELECT P.id, P.nombre, P.apellido1, P.apellido2, COUNT(A.id) AS 'Número_de_asignaturas' 
FROM persona P LEFT JOIN asignatura A ON (P.id = A.id_profesor) WHERE P.tipo = 'profesor'
GROUP BY P.id ORDER BY Número_de_asignaturas DESC;
--- 10 ---
-- Retorna totes les dades de l'alumne/a més jove.
SELECT * FROM persona WHERE tipo = 'alumno' ORDER BY DATE(fecha_nacimiento) DESC LIMIT 1;
--- 11 ---
-- Retorna un llistat amb els professors/es que tenen un departament associat i que no imparteixen cap assignatura.
SELECT P.* FROM persona P INNER JOIN profesor PR ON (P.id = PR.id_profesor) 
LEFT JOIN asignatura A ON (A.id_profesor = P.id) 
WHERE PR.id_departamento IS NOT NULL AND A.id_profesor IS NULL;
