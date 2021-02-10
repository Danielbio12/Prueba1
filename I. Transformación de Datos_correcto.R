# 23 de diciembre 

library(datos)
library(tidyverse)

# Datos de vuelos de Nueva York 2013
vuelos
?vuelos

# Para ver la tabla con los datos
view(vuelos)
# Int -> enteros
# dbl -> Dobles o números reales
# chr -> Caracteres o cadenas 
# dttm -> fechas + horas
# lgl -> lógico( T o F)
# fctr -> factores, variables categóricas
# date -> fecha

# Funciones dyplyr
# Filtrar o elegir las observaciones por sus valores (filter())
# Reordenar las filas (arrange())
# Seleccionar las variables por sus nombres (select())
# Crear nuevas variables con transformaciones de variables existentes (mutate())
# Contraer muchos valores en un solo resumen (summarise())

# Todas estas funciones se pueden usar junto con group_by(), que cambia el 
# alcance de cada función para que actúe ya no sobre todo el conjunto de 
# datos sino de grupo en grupo.

# Filtrar filas con filter() ------------

# Filtar un grupo de observaciones por sus valores, 
# nombre del data frame y datos a seleccionar
# Ejemplos los vuelos del 1 de enero

# Ejemplo, seleccionar todos los vuelos del 1 de enero
filter(vuelos, mes == 1, dia == 1)
# Para guardarlo
ene1 <- filter(vuelos, mes == 1, dia == 1)
# Guardar y mostrar 
(dic25 <- filter(vuelos, mes == 12, dia == 25))

# Usar operadores de comparación
# >, >=, <, <=, != (no igual) y == (igual) / (doble igual para igual a)
# Al usar igual igual significa exactamente igual
sqrt(2)^2 == 2
1 / 49 * 49 == 1
# Usar mejor near(), cercano aproximado para el dato
near(sqrt(2)^2, 2)
near(1 / 49 * 49, 1)

# operadores Booleanos: & es 'y', | es 'o', y ! es 'no'.
# Vuelos que partieron en diciembre o noviembre
filter(vuelos, mes == 11 | mes == 12)

filter(vuelos, mes == (11 | 12)) # Genera un error porque selecciona TRUE 1 -> enero
nov_dic <- filter(vuelos, mes %in% c(11, 12)) # Solución
# Seleccioine los valores de mes en (%in%) los que su valor sea igual a 11 o 12

# ley de De Morgan: !(x & y) es lo mismo que !x | !y,
# !(x | y) es lo mismo que !x & !y
# vuelos que no se retrasaron (en llegada o partida) en más de dos horas
filter(vuelos, !(atraso_llegada > 120 | atraso_salida > 120))
filter(vuelos  , atraso_llegada <= 120, atraso_salida <= 120)

# Ejemplos NA, valores desconocidos
NA > 5
10 == NA
NA + 10
NA / 2
NA == NA
x <- NA
y <- NA
x == y
is.na(x)

NA == NA

# Sea x la edad de María. No sabemos qué edad tiene.
x <- NA

# Sea y la edad de Juan. No sabemos qué edad tiene.
y <- NA

# ¿Tienen Juan y María la misma edad?
x == y
# ¡No sabemos!

# Determinar valores faltantes
is.na(x)

# Filter solo incluye valores TRUE, esxcluye FALSE y NA
df <- tibble(x = c(1, NA, 3))
filter(df, x > 1)
# Si tambien queremos que incluya los NA
filter(df, is.na(x) | x > 1)

# Ejercicios 
# 1 vuelos que
# retraso de llegada de dos o más horas
(filter(vuelos, atraso_llegada >= 120))
# volaron a Houston IAH oHOU
(filter(vuelos, destino %in% c('IAH','HOU')))
filter(vuelos, destino == 'IAH'|destino == 'HOU')
# operados por United, American O Delta
View(aerolineas)
(filter(vuelos, aerolinea %in% c('AA', 'DL', 'UA')))
filter(vuelos, aerolinea == 'UA'|aerolinea == 'AA'| aerolinea =='DL')
# partieron en invierno (julio, agosto y septiembre)
(filter(vuelos, mes %in% c(7,8,9)))
filter(vuelos, mes == 7 | mes == 8 | mes == 9) 
# Llegaron más de dos horas tarde, pero no salieron tarde
(filter(vuelos, atraso_llegada > 120 & atraso_salida <= 0))
view(filter(vuelos, atraso_llegada > 120 & atraso_salida <= 0))
# Se retrasaron por lo menos una hora, pero repusieron más de 30 minutos en vuelo
(filter(vuelos, atraso_llegada <= 60 & tiempo_vuelo > 30 ))
# Partieron entre la medianoche y las 6 a.m. (incluyente)
(filter(vuelos, horario_salida >= 0000 & horario_salida <= 600))
View(filter(vuelos, horario_salida >= 0000 & horario_salida <= 600))
# 2 Between 
?between # valores entre
# Ejemplo
(filter(vuelos, (between(mes, 7, 9))))
(filter(vuelos, (between(horario_salida, 0000, 600))))
# 3 datos NA 
(filter(vuelos, is.na(horario_salida))) # 8255
# atraso_salida, horario_llegada, atraso_llegada, codigo_cola, tiempo_vuelo
# datos no colectados
# 4 
NA ^ 0 # Cualquier numero elevado a la 0 es 1
NA | TRUE # Eligo | que es o seleciona uno o otro 
FALSE & NA # Eligo & que es y seleciona ambos pone F
NA * 0

# Reordenar las filas con arrange() --------------
# Cambiar el orden de las filas
arrange(vuelos, anio, mes, dia) # organiza por año luego mes luego dia
# para ordenar en orden descendente
arrange(vuelos, desc(atraso_salida))
# Los NA siempre se ordenan al final
df <- tibble(x = c(5, 2, NA))
arrange(df, x)
arrange(df, desc(x))

# Ejercicios
# 1 horario_llegada NA al comienzo
arrange(vuelos, desc(is.na(horario_llegada)))
arrange(df, desc(is.na(df))) # Valores faltantes al comienzo
arrange(vuelos, desc(is.na(atraso_salida)))
# 2
arrange(vuelos, desc(atraso_salida)) # Vuelos más retrasados
arrange(vuelos, atraso_salida) # Vuelos que salieron más temprano
# 3 vuelos que viajaron a mayor velocidas (V=d/t)
arrange(vuelos, desc(distancia/tiempo_vuelo))
view(arrange(vuelos, desc(distancia/tiempo_vuelo)))
# 4
arrange(vuelos, distancia) # Vuelos que volaron más cerca
view(arrange(vuelos, distancia)) 
arrange(vuelos, desc(distancia)) # Vuelos que volaron más lejos

# Seleccionar columnas con select() --------

# Seleccionar subconjuntos

# Seleccionar columnas por nombre
select(vuelos, anio, mes, dia)
# Seleccionar todas las columnas entre anio y dia (incluyente)
select(vuelos, anio:dia)
# Seleccionar todas las columnas excepto aquellas entre anio en dia (incluyente)
select(vuelos, -(anio:dia))

# funciones auxiliares que puedes usar dentro de select()
starts_with("abc")
select(vuelos, starts_with('hor')) 
# ejempolo selecionar columnas empiezan por hor
ends_with("xyz")
select(vuelos, ends_with('llegada')) 
# ejempolo selecionar columnas finalizan por llegada
contains("ijk")
select(vuelos, contains('pro')) 
# ejempolo selecionar columnas que contengan pro
matches("(.)\\1")
num_range("x", 1:3)
?select # mas detalles

#Renombrar una columna
rename(vuelos, cola_num = codigo_cola)
View(rename(vuelos, cola_num = codigo_cola))

# Mover columnas al inicio del data frame everything()
select(vuelos, fecha_hora, tiempo_vuelo, everything())

# Ejercicios
# 1 seleccionar por salida, llegada u horario atraso con starts contains o ends
# horario_salida,atraso_salida,horario_llegada, y atraso_llegada de vuelos
# 2 nada raro
select(vuelos, horario_llegada, horario_llegada, horario_llegada)
# 3 one_of
vars <- c ("anio", "mes", "dia", "atraso_salida", "atraso_llegada")
?one_of
select(vuelos, one_of(vars))
?select
# 4 Por defecto no distingue mayusculas minusculas
select(vuelos, contains("SALIDA"))
select(vuelos, contains("SALIDA", ignore.case = F))
select(vuelos, contains("salida", ignore.case = F))
