# **Guía de Colaboración con Git y GitHub**

## **1. Configuración Inicial**

### **a. Otorgar Acceso al Repositorio**

1. **Invitar como Colaborador:**
   - Navega a tu repositorio en GitHub.
   - Ve a la pestaña **Settings** (Configuración).
   - Selecciona **Manage access** (Gestionar acceso) en el menú lateral.
   - Haz clic en **Invite a collaborator** (Invitar a un colaborador).
   - Introduce el nombre de usuario de GitHub de tu compañero y envía la invitación.
   - **Nota:** Tu compañero deberá aceptar la invitación para obtener acceso.

### **b. Configurar Git en la Máquina del Colaborador**

1. **Instalar Git:**
   - [Descargar Git](https://git-scm.com/downloads) e instálalo según tu sistema operativo.

2. **Configurar Git:**
   ```bash
   git config --global user.name "Nombre de Usuario"
   git config --global user.email "correo@ejemplo.com"
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

- `main`: Código en producción. Siempre estable y listo para desplegar.
- `development`: Código en desarrollo. Integración de nuevas funcionalidades antes de pasar a `main`.

### **b. Ramas de Características (Feature Branches)**

- `feature/nombre-de-la-caracteristica`: Desarrollo de nuevas funcionalidades.

### **c. Flujo de Trabajo Recomendado**

1. **Crear una Rama de Característica:**
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

### **d. Integración con `main`**

1. **Preparar para Desplegar:**
   - Asegúrate de que todas las funcionalidades en `development` estén probadas y estables.

2. **Crear un Pull Request hacia `main`:**
   - Similar al paso anterior, pero esta vez el PR es desde `development` hacia `main`.

3. **Fusionar y Desplegar:**
   - Fusiona el PR en `main` y procede con el despliegue a producción.

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

### **d. Documentación**

- **Mantener un `README.md` Actualizado:** Incluir instrucciones de instalación y uso.
- **Documentar Funcionalidades y Arquitectura:** Explica la estructura del proyecto.

### **e. Uso de GitHub Actions y Automatizaciones (Opcional)**

- **Integrar CI/CD:** Configura GitHub Actions para pruebas automáticas.
- **Automatizar Revisiones de Código:** Usa ESLint, Prettier o SonarQube.

## **4. Flujo de Trabajo Ejemplo**

1. **Planificación:**
   - Crear un Issue para una nueva funcionalidad o bug.
   - Asignar el Issue a un desarrollador.

2. **Desarrollo:**
   ```bash
   git checkout development
   git pull origin development
   git checkout -b feature/nueva-funcionalidad
   git add .
   git commit -m "Implementar nueva funcionalidad X"
   ```

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