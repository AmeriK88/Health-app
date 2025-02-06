# **Guía de Colaboración con Git y GitHub**

## **1. Configuración Inicial**

   ```

### **c. Clonar el Repositorio**

1. **Obtener la URL del Repositorio:**
   - En la página principal del repositorio en GitHub, haz clic en el botón **Code** y copia la URL (HTTPS o SSH).

2. **Clonar el Repositorio:**
   ```bash
   git clone https://github.com/tu-usuario/tu-repositorio.git
   ```
   o, si usas SSH:
   ```bash
   git clone git@github.com:tu-usuario/tu-repositorio.git
   ```

## **2. Estrategia de Ramas (Branching Strategy)**

### **a. Ramas Principales**

- `main`: Código en producción. Siempre estable y listo para desplegar. NUNCA TOCAR NI HACER MODIFICACIONES
- `development`: Código en desarrollo. Integración de nuevas funcionalidades antes de pasar a `main`.

### **b. Ramas de Características (Feature Branches)**

- `feature/nombre-de-la-caracteristica`: Desarrollo de nuevas funcionalidades.

### **c. Flujo de Trabajo Recomendado**

1. **Crear una Rama de Característica:**
   - Ir a la rama desarrollo y crear nueva rama + nombre de nueva funcionalidad

   ```bash
   git checkout development
   git pull origin development
   git checkout -b feature/nueva-funcionalidad
   ```

2. **Desarrollar en la Rama de Característica:**
   ```bash
   git add .
   git commit -m "Agregar nueva funcionalidad para gestionar usuarios"
   ```

3. **Sincronizar con `development`:**
   - Antes de hacer un merge, volver a development. Hacer pull de la rama en origen por posbiles cambios existentes. Finalmente hacemos merge
   ```bash
   git checkout development
   git pull origin development
   git checkout feature/nueva-funcionalidad
   git merge development
   ```
   - **Nota:** Resolver cualquier conflicto que surja.

4. **Crear un Pull Request (PR):**
   - Navega a la pestaña **Pull requests** en GitHub.
   - Haz clic en **New pull request**.
   - Selecciona `development` como base y `feature/nueva-funcionalidad` como comparación.
   - Revisa los cambios y crea el PR.
   - Asigna revisores para la revisión de código.

5. **Revisión y Aprobación:**
   - Revisar el código del PR.
   - Realizar comentarios si es necesario.
   - Fusionar (`merge`) el PR en `development` una vez aprobado.

6. **Eliminar la Rama de Característica:**
   ```bash
   git branch -d feature/nueva-funcionalidad
   git push origin --delete feature/nueva-funcionalidad
   ```


## **3. Mejores Prácticas para la Colaboración**

### **a. Comunicación Clara**

- **Descripciones Detalladas en los PRs:** Explica qué hace la funcionalidad y por qué.
- **Comentarios en el Código:** Añade comentarios en áreas complejas.
- **Reuniones Regulares:** Discute progreso, problemas y próximos pasos.

### **b. Revisión de Código (Code Review)**

- **Revisar PRs de Manera Constructiva:** Enfócate en mejorar el código.
- **Asegurar la Calidad del Código:** Verifica que siga las convenciones del proyecto.

### **c. Gestión de Issues**

- **Crear Issues para Tareas y Bugs:** Rastrea tareas, funcionalidades y errores.
- **Asignar Issues:** Asigna tareas específicas a cada colaborador.


## **4. Flujo de Trabajo Ejemplo**


3. **Revisión:**
   ```bash
   git push origin feature/nueva-funcionalidad
   ```
   - Crear un Pull Request en GitHub hacia `development`.
   - Revisar el código y fusionarlo.

4. **Integración:**
   - Repetir el proceso para cada nueva característica o corrección.
   - Regularmente fusionar `development` en `main` para producción.

## **5. Recursos Adicionales**

- [Pro Git Book](https://git-scm.com/book/en/v2)
- [GitHub Docs](https://docs.github.com/)
- [Learn Git Branching](https://learngitbranching.js.org/)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# IFF
# MANUAL DE CÁLCULO DEL ÍNDICE DE FORMA FÍSICA (IFF)

## 1. OBJETIVO DEL ÍNDICE

El objetivo del **Índice de Forma Física (IFF)** es obtener un número único (de 1 a 100) que represente la **condición física y hábitos saludables** de una persona, considerando diversos factores:

- **Datos fisiológicos** (frecuencia cardiaca en reposo, VO₂ máx, etc.)  
- **Actividad física diaria** (pasos, minutos de ejercicio)  
- **Descanso** (horas de sueño)  
- **Hábitos de vida** (hidratación, consumo de alcohol, tabaco, estrés)  
- **Bienestar subjetivo** (estado de ánimo, motivación, etc.)

Este documento expone:

1. **Estructura** (categorías y ponderaciones).  
2. **Tablas de referencia** para normalizar cada variable (0-100).  
3. **Fórmula de cálculo** y ejemplos.  

El manual está pensado para que los desarrolladores **implementen** la lógica y las tablas en un sistema (web, app, etc.) y ofrezcan una puntuación final a los usuarios.

---

## 2. ESTRUCTURA GENERAL

 **5 categorías** principales, cada una con un **peso** en la fórmula final:



Salud fisica (30%)

| Parámetro                         | Opcional | Nombre en Programación         | Variable Asociada               | Método de Evaluación                    |
|------------------------------------|----------|----------------------------------|---------------------------------|---------------------------------|
| Frecuencia Cardíaca en Reposo    | No       | fcr                              | salud_fisica                    | Medido en latidos por minuto    |
| VO₂ máx                          | No       | vo2max                           | salud_fisica                    | Medido en ml/kg/min             |
| % Grasa Corporal                   | No       | body_fat_percentage              | salud_fisica                    | Porcentaje (%)                  |
| Presión Arterial                   | Sí       | blood_pressure                    | salud_fisica                    | mmHg (sistólica/diastólica)          |
| Circunferencia Cintura/Cadera      | Sí       | waist_hip_circumference           | salud_fisica                    | Medido en cm                    |
| Fuerza Muscular                    | Sí       | muscle_strength                   | salud_fisica                    | Test de fuerza (kg o N)         |

Actividad Física (25%)

| Parámetro                         | Opcional | Nombre en Programación         | Variable Asociada               | Método de Evaluación                    |
|------------------------------------|----------|----------------------------------|---------------------------------|---------------------------------|
| Pasos Diarios                      | No       | daily_steps                       | actividad_fisica                | Contador de pasos               |
| Minutos de Ejercicio               | No       | exercise_minutes                  | actividad_fisica                | Minutos diarios                 |
| Calorías Activas                   | No       | active_calories                   | actividad_fisica                | Calorías quemadas                |
| Intensidad del Ejercicio           | Sí       | exercise_intensity                | actividad_fisica                | Escala de 1 a 10                |
| Tipo de Actividad                  | Sí       | activity_type                      | actividad_fisica                | Texto descriptivo               |
| FC Media Ejercicio                 | Sí       | avg_hr_exercise                   | actividad_fisica                | Medido en latidos por minuto    |

Sueño y Recuperación (15%)

| Parámetro                         | Opcional | Nombre en Programación         | Variable Asociada               | Método de Evaluación                    |
|------------------------------------|----------|----------------------------------|---------------------------------|---------------------------------|
| Horas de Sueño                     | No       | sleep_hours                        | sueno_recuperacion              | Total de horas dormidas         |
| Calidad del Sueño                  | Sí       | sleep_quality                      | sueno_recuperacion              | Escala de 1 a 5                 |
| Interrupciones del Sueño            | Sí       | sleep_interruptions                | sueno_recuperacion              | Sí/No                          |

Hábitos de Vida (15%)

| Parámetro                         | Opcional | Nombre en Programación         | Variable Asociada               | Método de Evaluación                    |
|------------------------------------|----------|----------------------------------|---------------------------------|---------------------------------|
| Ingesta de Agua                    | No       | water_intake                       | habitos_vida                    | Litros por día                 |
| Alcohol                            | No       | alcohol_consumption               | habitos_vida                    | Unidades por semana             |
| Tabaco                             | No       | tobacco_use                        | habitos_vida                    | Cigarrillos por día            |
| Estrés                             | No       | stress_level                       | habitos_vida                    | Escala de 1 a 10                |
| Alimentación                       | No       | nutrition                          | habitos_vida                    | Evaluación cualitativa (buena/regular/mala) |
| Horarios de Alimentación           | Sí       | meal_timing                        | habitos_vida                    | Registro de horarios            |
| Uso de Suplementos                 | Sí       | supplement_use                     | habitos_vida                    | Sí/No                          |
| Horas Frente a Pantallas           | Sí       | screen_time                        | habitos_vida                    | Horas diarias                   |
| Consumo de Café                    | Sí       | caffeine_intake                    | habitos_vida                    | Tazas por día                  |

Bienestar Subjetivo (15%)

| Parámetro                         | Opcional | Nombre en Programación         | Variable Asociada               | Método de Evaluación                    |
|------------------------------------|----------|----------------------------------|---------------------------------|---------------------------------|
| Estado de Ánimo                   | No       | mood                              | bienestar_subjetivo             | Escala de 1 a 10                |
| Motivación                          | No       | motivation                         | bienestar_subjetivo             | Escala de 1 a 10                |
| Percepción de Energía               | Sí       | energy_perception                  | bienestar_subjetivo             | Escala de 1 a 5                 |
| Nivel de Estrés Percibido            | Sí       | perceived_stress                   | bienestar_subjetivo             | Escala de 1 a 10                |
| Satisfacción General                | Sí       | general_satisfaction               | bienestar_subjetivo             | Escala de 1 a 10                |



Los porcentajes (**pesos**) son orientativos. Se pueden modificar según las prioridades del proyecto.

**Fórmula general**:

IFF = (S_Salud × w_Salud) + (S_Actividad × w_Actividad) + (S_Descanso × w_Descanso) + (S_Hábitos × w_Hábitos) + (S_Bienestar × w_Bienestar)

shell
Copiar
Editar

donde cada `S_x` es una **sub-puntuación (0-100)** y `w_x` es el porcentaje convertido a decimal (por ej. 0.30, 0.25, etc.).

---

## 3. TABLAS DE REFERENCIA (0-100)

Para transformar **cada variable** (FC reposo, pasos, etc.) a una escala de **0 a 100**, necesitamos establecer **valores mínimos (0 pts)** y **valores óptimos (100 pts)**. Al final, haremos **interpolación lineal**. En los casos en que “menos es mejor” (frecuencia cardiaca, % de grasa), se invierte la fórmula.

### 3.1 Frecuencia Cardiaca en Reposo (FCR)

| Grupo de Edad | 0 pts (muy alta) | 100 pts (excelente) |
|---------------|------------------|----------------------|
| H 16-25       | > 90 lpm         | ≤ 55 lpm            |
| H 25-35       | > 90 lpm         | ≤ 58 lpm            |
| H 35-50       | > 95 lpm         | ≤ 60 lpm            |
| H 50-65       | > 100 lpm        | ≤ 65 lpm            |
| H 65+         | > 100 lpm        | ≤ 70 lpm            |
| M 16-25       | > 95 lpm         | ≤ 60 lpm            |
| M 25-35       | > 95 lpm         | ≤ 62 lpm            |
| M 35-50       | > 100 lpm        | ≤ 65 lpm            |
| M 50-65       | > 105 lpm        | ≤ 70 lpm            |
| M 65+         | > 105 lpm        | ≤ 75 lpm            |

> **Ejemplo de cálculo**:  
> Hombre de 30 años (25-35) con FCR = 64.  
> - 0 pts = > 90 lpm, 100 pts = ≤ 58 lpm.  
> ```
> Score_FCR = (90 - 64) / (90 - 58) * 100 ≈ 81.25
> ```

### 3.2 VO₂ máx (mL/kg/min) *(opcional)*

| Grupo de Edad | 0 pts (muy bajo) | 100 pts (excelente) |
|---------------|------------------|----------------------|
| H 16-25       | < 30             | ≥ 52                |
| H 25-35       | < 28             | ≥ 50                |
| H 35-50       | < 26             | ≥ 45                |
| H 50-65       | < 24             | ≥ 40                |
| H 65+         | < 20             | ≥ 35                |
| M 16-25       | < 25             | ≥ 42                |
| M 25-35       | < 23             | ≥ 38                |
| M 35-50       | < 20             | ≥ 35                |
| M 50-65       | < 18             | ≥ 32                |
| M 65+         | < 15             | ≥ 28                |

*(Usar tablas detalladas según edad y sexo. Se interpolan valores intermedios.)*

### 3.3 Saturación de oxígeno (SpO₂) *(opcional)*

- **0 pts** si < 92%  
- **100 pts** si ≥ 97%  
- Intermedio: interpolar linealmente.

### 3.4 % de Grasa Corporal *(opcional)*

#### Hombres

| Grupo de Edad | 0 pts (muy alto) | 100 pts (excelente) |
|---------------|------------------|----------------------|
| 16-25         | ≥ 30%            | ≤ 10%               |
| 25-35         | ≥ 30%            | ≤ 12%               |
| 35-50         | ≥ 35%            | ≤ 15%               |
| 50-65         | ≥ 38%            | ≤ 18%               |
| 65+           | ≥ 40%            | ≤ 20%               |

#### Mujeres

| Grupo de Edad | 0 pts (muy alto) | 100 pts (excelente) |
|---------------|------------------|----------------------|
| 16-25         | ≥ 40%            | ≤ 18%               |
| 25-35         | ≥ 42%            | ≤ 20%               |
| 35-50         | ≥ 45%            | ≤ 25%               |
| 50-65         | ≥ 48%            | ≤ 28%               |
| 65+           | ≥ 50%            | ≤ 30%               |

### 3.5 Pasos Diarios

*(Escala genérica, se puede personalizar por edad/sexo.)*

- **0 pts** < 2.500 pasos/día  
- **100 pts** ≥ 10.000 pasos/día  
- Interpolar valores intermedios.

*(Algunos proponen 12.000 pasos como óptimo para jóvenes y ~8.000 para mayores; se puede ajustar.)*

### 3.6 Minutos de Actividad Moderada/Intensa

- **0 pts** = 0-10 min/día  
- **100 pts** = ≥ 40-45 min/día  

*(La OMS recomienda 150 min/semana (~21 min/día) como mínimo. Se puede usar 40 min/día para 100 pts.)*

### 3.7 Horas de Sueño

- **0 pts** = ≤ 5 h  
- **100 pts** = ≥ 8 h (adulto medio)  

*(Se puede afinar por edad.)*

### 3.8 Hidratación (litros/día)

- **0 pts** = ≤ 1 L  
- **100 pts** = ≥ 2.5 L (mujeres) o ≥ 3 L (hombres)  

*(Ajustar según complexión, clima, actividad, etc.)*

### 3.9 Consumo de Alcohol

- **0 pts**: consumo elevado (> 20 UBE/semana)  
- **100 pts**: abstinencia (0 alcohol)  

*(Entre medio, se puede graduar.)*

### 3.10 Tabaquismo

- **0 pts**: fumador intenso (> 10 cig/día)  
- **~50 pts**: fumador moderado (1-5 cig/día)  
- **100 pts**: no fuma  

### 3.11 Estrés Percibido (1-5)

*(1 = muy bajo, 5 = muy alto)*

Score_estrés = 100 - ((Valor - 1) / 4 * 100)

markdown
Copiar
Editar

- Ej.: Estrés = 3 → Score = 100 - 50 = 50

### 3.12 Estado de Ánimo (1-5)

*(1 = muy bajo, 5 = excelente)*

Score_ánimo = ((Valor - 1) / 4) * 100

markdown
Copiar
Editar

- Ej.: Ánimo = 4 → Score = 75

### 3.13 Motivación para Entrenar (1-5)

*(1 = nula, 5 = muy alta)*

Score_motivación = ((Valor - 1) / 4) * 100

yaml
Copiar
Editar

- Ej.: Motivación = 1 → Score = 0

---

## 4. PASOS PARA EL CÁLCULO

1. **Clasificar** al usuario por sexo y edad (opcional, si quieres tablas específicas).  
2. **Reunir** los datos: FCR, pasos, horas de sueño, etc.  
3. **Aplicar** la **tabla de referencia** correspondiente a cada variable y convertir el valor real en una puntuación (0-100).  
4. **Promediar** o **ponderar** cada grupo de variables (por ej., dentro de “Salud Física” si se usan FCR, VO₂ máx, %grasa, etc.).  
5. **Ponderar cada categoría** (Salud Física, Actividad, Descanso, Hábitos, Bienestar) según los pesos definidos (ej. 30%, 25%, 15%, 15%, 15%).  
6. **Sumar** todas las categorías para obtener el **IFF final** (0-100).  
7. **Interpretar**: un valor bajo (<40) indica muchos aspectos mejorables; un valor alto (>80) indica excelente forma/hábitos.

---

## 5. EJEMPLO DE IMPLEMENTACIÓN (PSEUDOCÓDIGO)

```plaintext
function calcularIFF(datosUsuario):
    # 1. Calcular sub-scores (0-100) de cada variable
    scoreFCR = convertirFrequenciaCardiaca(datosUsuario.FCR, datosUsuario.sexo, datosUsuario.edad)
    scorePasos = convertirPasos(datosUsuario.pasosDiarios, datosUsuario.sexo, datosUsuario.edad)
    scoreSueño = convertirHorasSueño(datosUsuario.sueño)
    scoreEstrés = convertirEstrés(datosUsuario.estres) 
    # ... etc. para cada variable

    # 2. Promediar en cada categoría

    # Ej: Salud Fisica
    if tenemosVO2:
       subSalud = average(scoreFCR, scoreVO2, ...)
    else:
       subSalud = scoreFCR  # si no hay VO2

    # Ej: Actividad
    subActividad = average(scorePasos, scoreMinActividad, ...)

    # Ej: Descanso
    subDescanso = scoreSueño

    # Ej: Habitos
    subHabitos = average(scoreAgua, scoreAlcohol, scoreTabaco, scoreEstrés, ...)

    # Ej: Bienestar
    subBienestar = average(scoreAnimo, scoreMotivacion)

    # 3. Aplicar ponderaciones
    wSalud = 0.30
    wActividad = 0.25
    wDescanso = 0.15
    wHabitos = 0.15
    wBienestar = 0.15

    IFF = (subSalud * wSalud)
        + (subActividad * wActividad)
        + (subDescanso * wDescanso)
        + (subHabitos * wHabitos)
        + (subBienestar * wBienestar)

    return round(IFF, 0)  # o con decimales
(Nota: average() se puede reemplazar por una suma ponderada si se desea dar más peso a ciertas variables dentro de cada categoría.)

6. LISTADO DE PREGUNTAS SUGERIDAS
Para capturar los datos, se recomiendan dos modos:

Con monitor de actividad (pulsera, reloj):

Sexo, edad, altura, peso
FC reposo, VO₂ máx (si está disponible)
Pasos diarios, calorías activas, minutos de actividad
Horas de sueño promedio
Hidratación, tabaco, alcohol, estrés, estado de ánimo, motivación
Sin monitor (cuestionario subjetivo):

Sexo, edad, altura, peso
Frecuencia cardiaca en reposo (si se puede medir manualmente)
Días/semana de ejercicio, tiempo de cada sesión
Si corre: cuántos minutos aguanta, a qué ritmo aproximado
Fuerza: peso que mueve o flexiones que realiza
Horas de sueño, calidad del sueño
Hidratación, tabaco, alcohol, estrés, estado de ánimo, motivación
7. EJEMPLO ILUSTRATIVO
Supongamos un usuario Hombre de 30 años con estos datos:

FCR: 70 lpm
Pasos: 6000/día
30 min de actividad moderada/día
6.5 h de sueño
Bebe 1.5 L agua, sin alcohol, sin tabaco, estrés = 2/5
Estado de ánimo = 4/5, Motivación = 3/5
Cálculo rápido
FCR (70, H 25-35)
0 pts = > 90 lpm, 100 pts = ≤58 lpm
Score_FCR ≈ 63
Pasos (6000)
0 pts < 3000, 100 pts ≥ 10000 → Score_pasos ≈ 43
Minutos de actividad (30)
0 pts = 0-10, 100 pts = ≥40 → Score_actividad ≈ 66
Sueño (6.5 h)
0 pts ≤5, 100 pts ≥8 → Score_sueño ≈ 50
Hidratación (1.5 L)
0 pts ≤1, 100 pts ≥3 → Score_agua ≈ 25
Alcohol = No → Score_alcohol = 100
Tabaco = No → Score_tabaco = 100
Estrés (2)
Score_estrés = 100 - ((2-1)/4 * 100) = 75
Estado de ánimo (4) → 75
Motivación (3) → 50
(Luego se promedian por categorías y se hace la fórmula final.)

8. CONSEJOS DE IMPLEMENTACIÓN
Validación de datos: Asegurarse de que el usuario no introduzca valores imposibles (ej. FCR de 200 lpm).
Datos opcionales: Si faltan datos (ej. VO₂ máx), omitirlos y ajustar la ponderación interna en la categoría.
Almacenamiento histórico: Para un mejor feedback, conviene guardar la evolución del IFF a lo largo del tiempo.
Personalizar feedback: Una vez se obtiene el IFF, se pueden dar recomendaciones (p.ej., “Mejorar tu hidratación subiría tu nota ~5 puntos”).
Advertencia médica: Esto no sustituye la valoración de un profesional; es una guía orientativa.
9. INTERPRETACIÓN DE LA PUNTUACIÓN
Se puede sugerir una escala cualitativa:

IFF > 80: “Excelente”. Forma física y hábitos muy buenos.
IFF 60-80: “Buena / Notable”. Con algunos detalles a pulir.
IFF 40-60: “Promedio / Mejorable”. Puntos débiles claros.
IFF < 40: “Baja”. Se recomienda hacer cambios significativos en estilo de vida.
(Cada desarrollador puede proponer su propia categorización.)

10. CONCLUSIÓN
El Índice de Forma Física (IFF) es una herramienta flexible que condensa múltiples aspectos de la salud (fisiología, actividad, descanso, hábitos, bienestar) en un solo valor de 1 a 100. Su poder radica en:

Motivar: dar un número que evoluciona con la conducta.
Identificar áreas de mejora de forma integral.
Adaptarse a distintos usuarios (con o sin monitor, distintas edades, objetivos, etc.).
Para implementarlo con éxito, los desarrolladores deben:

Incluir las tablas de referencia (o personalizarlas según su base de datos).
Estructurar un sistema que recoja respuestas o datos de sensores.
Aplicar la fórmula de puntuación.
Mostrar la nota final (IFF) y, si es posible, recomendaciones personalizadas al usuario.
Este manual proporciona la base necesaria; cada proyecto podrá ajustar variables, escalas y pesos a su realidad y ofrecer una experiencia más personalizada.

Fin del Manual
