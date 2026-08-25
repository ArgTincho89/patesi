# Patesi — Referencias ISTQB

## ISTQB Foundation v4.0 — Referencias Clave

### Niveles de Testing (Syllabus Foundation v4.0 — Sección 5)

| Nivel | Qué evalúa | Quién |
|-------|-----------|-------|
| **Componente/Unitario** | Componentes individuales, white-box, desarrollador | Dev |
| **Integración** | Interacción de componentes, interfaces, contratos | Dev/QA |
| **Sistema** | Sistema completo, black-box, funcional + NF | QA |
| **Aceptación** | Validación de negocio, escenarios de usuario | PO/Cliente |

### Tipos de Testing (Syllabus Foundation v4.0 — Sección 5.2)

| Tipo | Propósito |
|------|----------|
| **Funcional** | ¿El sistema hace lo que debe? |
| **No funcional** (Performance, Seguridad, Usabilidad, etc.) | ¿Qué tan bien lo hace? |
| **Black-box** | Tests basados en especificaciones, sin conocimiento del código |
| **White-box** | Tests basados en la estructura del código |
| **Relacionado con cambios** (Confirmación, Regresión, Retest) | Testing después de cambios |

### Técnicas de Testing (Syllabus Foundation v4.0 — Sección 6)

#### Basadas en Especificación (Black-box)

| Técnica | Cómo funciona | Ejemplo |
|---------|---------------|---------|
| **Particiones de Equivalencia (EP)** | Dividir inputs en particiones, testear una por partición | Input 1-100: testear con 1, 50, 101 |
| **Análisis de Valores de Borde (BVA)** | Testear en los bordes de las particiones | Testear con 0, 1, 99, 100, 101 |
| **Tabla de Decisión** | Reglas de condiciones + acciones | Login: user+pass correcto → dashboard |
| **Transición de Estados** | Estados y transiciones | Orden: pendiente → pagado → enviado → entregado |
| **Testing de Use Case** | Flujos de use cases | Login éxito, login fallo, forgot password |

#### Basadas en Estructura (White-box)

| Técnica | Cobertura |
|---------|----------|
| **Cobertura de Sentencias** | Cada línea ejecutada al menos una vez |
| **Cobertura de Ramas** | Cada resultado de decisión (verdadero/falso) |
| **Cobertura de Caminos** | Cada camino posible a través del código |

#### Basadas en Experiencia

| Técnica | Cuándo usar |
|---------|------------|
| **Adivinanza de Errores** | Usar experiencia para adivinar dónde se esconden defectos |
| **Testing Exploratorio** | Aprendizaje simultáneo, diseño y ejecución |
| **Testing con Checklist** | Seguir una lista de verificación de defectos comunes |

### Proceso de Testing (Syllabus Foundation v4.0 — Sección 4)

| Actividad | Descripción |
|-----------|-------------|
| **Planificación** | Definir alcance, approach, recursos, cronograma |
| **Monitoreo y Control** | Seguir progreso contra el plan |
| **Análisis** | Analizar base de testing, identificar condiciones |
| **Diseño** | Diseñar casos de prueba, datos, entorno |
| **Implementación** | Preparar suites, entorno, datos |
| **Ejecución** | Correr tests, registrar resultados, reportar defectos |
| **Cierre** | Lecciones aprendidas, métricas, archivar |

### Ciclo de Vida del Defecto (Syllabus Foundation v4.0 — Sección 4.5)

```
Nuevo → Abierto → Fix → Retest → Cerrado
         ↓
      Diferido
         ↓
      Reabierto (si el fix falla)
```

---

## ISTQB Advanced Core — Referencias Clave

### Gestión de Testing (Módulo 2)

| Concepto | Descripción |
|----------|-------------|
| **Política de Testing** | Declaración a nivel organización de objetivos |
| **Estrategia de Testing** | Approach a nivel proyecto, alcance, técnicas |
| **Plan de Testing** | Plan detallado para un nivel específico |
| **Gestión Basada en Riesgos** | Usar riesgo para priorizar esfuerzo |
| **Taxonomía de Defectos** | Clasificación de tipos para análisis |
| **Métricas de Testing** | KPIs: tasa de pass, densidad de defectos, cobertura, DDE, DER |

### Automatización de Testing (Módulo 4)

| Concepto | Descripción |
|----------|-------------|
| **Pirámide de Automatización** | Muchos unit > menos API > menos UI |
| **ROI de Automatización** | Calcular: (costo manual × frecuencia) vs costo automatización |
| **Selección de Framework** | Basado en: stack, habilidad del equipo, costo mantenimiento |
| **Anti-patrones** | Testear UI para lógica de negocio, ignorar datos, locators frágiles |

### Testing Basado en Riesgos (Módulo 2)

| Factor de Riesgo | Peso en Patesi |
|-----------------|----------------|
| Impacto de negocio | 30% |
| Complejidad técnica | 25% |
| Frecuencia de cambio | 20% |
| Brecha de conocimiento | 15% |
| Dependencias | 10% |

---

## Estándares de Industria Referenciados

| Estándar | Cuándo lo usa Patesi |
|----------|---------------------|
| **ISTQB Foundation v4.0** | Terminología, niveles, técnicas |
| **ISTQB Advanced Core** | Gestión, riesgo, automatización |
| **ISO/IEC 25010** | Modelo de calidad SQEM (8 características) |
| **OWASP Top 10** | Guía de testing de seguridad |
| **WCAG 2.1** | Testing de accesibilidad (web) |

---

## Referencia de Métricas Clave

| Métrica | Definición | Objetivo |
|---------|-----------|----------|
| **DDE** (Efectividad de Detección) | Defectos encontrados en testing / total | >=88% Bajo, >=92% Medio, >=95% Alto |
| **DER** (Tasa de Escape) | Defectos en producción / total | <=12% Bajo, <=8% Medio, <=5% Alto |
| **Cobertura de Tests** | Requisitos con casos / total | 100% críticos, >=80% total |
| **Cobertura de Código** | Líneas/ramas cubiertas / total | Varía por NAQ (ver controles SQEM) |
| **Tasa de Automatización** | Tests automatizados / total | >=70% regresión en CI/CD |
| **Densidad de Defectos** | Defectos / KLOC | Dependiente del contexto |
