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