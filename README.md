LINK RENDER: https://juliosandoval-analisisb2026final.onrender.com

#  NetGuard GT - API REST de Gestión de Incidentes de Red

Este proyecto es un prototipo funcional de una API REST desarrollado en C# (.NET 8) con persistencia en SQLite. Su objetivo es automatizar y optimizar la administración, asignación y escalado de incidentes críticos en la infraestructura de telecomunicaciones de la empresa **NetGuard GT** en Guatemala.

---

## 1. Casos de Uso e Historias de Usuario 

A continuación se detallan los 10 escenarios clave del sistema, modelados bajo las reglas de negocio de la empresa:

### CU-01: Registro de un nuevo incidente de red
* **Historia de Usuario:** Como Analista de Monitoreo, quiero registrar un incidente en el sistema para que soporte técnico esté enterado de la falla en el nodo.
* **Criterio de Aceptación:** El sistema debe asignar de forma automática la fecha/hora actual, el estado `Registrado` y calcular el tiempo máximo de resolución según la severidad (`Critico` = 4h, `Urgente` = 12h, `Normal` = 24h).
* **Endpoint:** `POST /api/incidentes`

### CU-02: Consulta general del estado de la red
* **Historia de Usuario:** Como Coordinador de Operaciones, quiero listar todos los incidentes del sistema para evaluar qué fallas siguen abiertas en Guatemala.
* **Criterio de Aceptación:** Retorna el listado completo en JSON. Antes de renderizar, el sistema evalúa de forma dinámica si alguna alerta cumple condiciones de escalado automático.
* **Endpoint:** `GET /api/incidentes`

### CU-03: Asignación de técnico a incidente (Regla de Carga Máxima)
* **Historia de Usuario:** Como Despachador de Soporte, quiero asignar un técnico a un incidente para que proceda con la reparación en el sitio.
* **Criterio de Aceptación:** El sistema verifica si el técnico ya posee 3 tareas activas. Si `IncidentesActivos >= 3`, rebota la transacción con un error `400 Bad Request` para evitar sobrecarga laboral.
* **Endpoint:** `PUT /api/incidentes/{id}/asignar`

### CU-04: Validación de Especialidad del Técnico
* **Historia de Usuario:** Como Ingeniero de Operaciones, quiero que el sistema valide que el técnico asignado conozca la tecnología afectada.
* **Criterio de Aceptación:** Si el incidente indica problemas de "Microondas", el sistema restringe la asignación a técnicos con esa especialidad (a excepción del comodín de Fibra Óptica), devolviendo un error `400` si hay discrepancia.
* **Endpoint:** `PUT /api/incidentes/{id}/asignar` (Validación interna)

### CU-05: Reasignación y Liberación de Carga de Trabajo
* **Historia de Usuario:** Como Administrador de Red, quiero transferir un caso a un técnico diferente para acelerar la resolución del problema.
* **Criterio de Aceptación:** Al reasignar un incidente que ya tenía personal asignado, el sistema descuenta automáticamente `-1` al contador del técnico anterior antes de sumárselo al nuevo.
* **Endpoint:** `PUT /api/incidentes/{id}/asignar` (Lógica de reemplazo)

### CU-06: Transición Secuencial Obligatoria de Estados
* **Historia de Usuario:** Como Auditor de Calidad, quiero que los incidentes sigan obligatoriamente la ruta de estados `Registrado -> Asignado -> En Progreso -> Resuelto -> Cerrado`.
* **Criterio de Aceptación:** Si se intenta alterar el estado saltándose la secuencia (ej. de `Registrado` directo a `Cerrado`), el sistema deniega el cambio con un error de flujo inválido.
* **Endpoint:** `PUT /api/incidentes/{id}/estado`

### CU-07: Cierre de Incidente y Liberación de Disponibilidad
* **Historia de Usuario:** Como Técnico de Campo, quiero marcar un incidente como `Resuelto` o `Cerrado` tras finalizar las reparaciones en la antena.
* **Criterio de Aceptación:** Al procesar un estado de cierre exitoso, el sistema reduce de inmediato la carga de trabajo activa del técnico asignado para que vuelva a estar disponible en la red.
* **Endpoint:** `PUT /api/incidentes/{id}/estado` (Liberación de recursos)

### CU-08: Escalado Automático por Retraso Crítico
* **Historia de Usuario:** Como Gerente de Infraestructura, quiero que las alertas críticas sin atender por más de 2 horas se marquen como prioritarias para evitar multas de la SIT.
* **Criterio de Aceptación:** Al consultar los incidentes, si un caso de severidad `Critico` o `Urgente` lleva más de 2 horas en estado `Registrado`, el campo `EscaladoAutomático` cambia a `true`.
* **Endpoint:** `GET /api/incidentes` (Disparador interno de control)

### CU-09: Trazabilidad e Historial de Auditoría de Cambios
* **Historia de Usuario:** Como Auditor de Seguridad, quiero ver una bitácora detallada de los movimientos del sistema para realizar análisis post-mortem.
* **Criterio de Aceptación:** Cada registro, asignación o mutación de estado genera una entrada de texto inmutable en una lista cronológica de auditoría.
* **Endpoint:** `GET /api/incidentes/historial`

### CU-10: Reportes Consolidados de Salud de Red
* **Historia de Usuario:** Como Director de NetGuard GT, quiero ver estadísticas generales de la operación para la toma de decisiones estratégicas en Guatemala.
* **Criterio de Aceptación:** Expone un JSON resumido con: Total de incidentes, casos activos, resueltos, porcentaje de escalados y un desglose de la carga actual por cada técnico.
* **Endpoint:** `GET /api/incidentes/reportes`

---

##  2. Informe de Utilización de Inteligencia Artificial (Paso 5 del Examen)

En cumplimiento con los requerimientos académicos del examen final, se detalla la integración de herramientas de IA generativa para la construcción del prototipo:

### Rationale de uso
Se empleó un asistente de Inteligencia Artificial como un **copiloto técnico de desarrollo (Pair Programming)**. La justificación principal fue acelerar el proceso de maquetación de la arquitectura limpia en .NET 8 y garantizar la rigurosidad matemática y lógica al momento de traducir las 8 reglas complejas del negocio de telecomunicaciones a código de C#.

### Herramientas utilizadas y Fase del ciclo de vida
* **Planificación y Diseño:** Análisis de la rúbrica del examen para la correcta separación de responsabilidades y definición del esquema relacional de SQLite.
* **Codificación (C#):** Implementación ágil de la estructura de controladores y abstracción de validaciones complejas de control de flujo en los modelos de dominio.
* **Pruebas (xUnit):** Generación de casos de prueba automatizados para validar que las restricciones lógicas operaran según lo esperado por NetGuard GT.

### Prompts clave utilizados (Ejemplos)
1. *"Genera una estructura de solución en .NET 8 que incluya un proyecto WebAPI y un proyecto de pruebas xUnit interconectados por consola."*
2. *"Escribe una función en C# para un modelo 'Incidente' que verifique si el cambio a un nuevo estado sigue un orden estrictamente lineal usando un Enum, impidiendo saltarse pasos."*
3. *"Configura un archivo Controller de ASP.NET Core que inicialice una base de datos SQLite con datos de prueba estáticos de técnicos y sitios si la tabla se encuentra vacía."*

### Análisis de la contribución de la IA
La IA redujo significativamente el tiempo de escritura de código repetitivo (*boilerplate code*), permitiendo al desarrollador enfocarse en la arquitectura de la solución, la correcta semántica de los códigos de respuesta HTTP y la verificación del cumplimiento estricto de la rúbrica del examen. La supervisión humana garantizó la correcta adaptación de las respuestas al contexto específico de Guatemala.

---

## 3. Instrucciones de Ejecución Local

1. **Ejecutar Pruebas de Reglas de Negocio:**
   ```bash
   dotnet test