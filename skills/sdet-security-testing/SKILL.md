---
name: sdet-security-testing
description: >
  Testing de seguridad desde QA: OWASP Top 10 aplicado a casos de prueba, control de acceso, validación de entrada, gestión de secretos y análisis SAST/DAST/SCA.
  Trigger: seguridad, OWASP, SAST, DAST, SCA, vulnerabilidades, inyección, control de acceso, secretos
license: Apache-2.0
metadata:
  author: patesi
  version: "1.0"
  category: qa-core
---

# Testing de seguridad desde QA

Lo que un ingeniero de calidad puede y debe verificar sin ser especialista en seguridad ofensiva.

**Límite de alcance, explícito:** este skill cubre testing de seguridad como parte del trabajo de QA. **No reemplaza un pentest ni una auditoría profesional.** Cuando el sistema maneja dinero, datos personales sensibles o tiene exposición regulatoria, recomendá una evaluación especializada y decilo con claridad.

---

## OWASP Top 10 traducido a casos de prueba

| Riesgo | Qué probar concretamente |
|--------|--------------------------|
| **Control de acceso roto** | Acceder a un recurso ajeno cambiando el ID en la URL. Llamar a un endpoint de administrador con un token de usuario común. Operar sin token |
| **Fallos criptográficos** | Verificar HTTPS en todo el tráfico. Contraseñas con hash de algoritmo lento, nunca reversible. Datos sensibles fuera de logs y URLs |
| **Inyección** | Enviar `' OR '1'='1`, `<script>alert(1)</script>` y payloads de comandos en cada campo de entrada, incluidos cabeceras y parámetros |
| **Diseño inseguro** | ¿Hay límite de intentos de login? ¿Se puede saltar un paso obligatorio del flujo yendo directo a la URL siguiente? |
| **Configuración incorrecta** | Mensajes de error con stack traces. Endpoints de debug expuestos. Cabeceras de seguridad ausentes. Credenciales por defecto |
| **Componentes vulnerables** | Ejecutar análisis de dependencias y revisar el resultado, no solo generarlo |
| **Fallos de autenticación** | Sesión que no se invalida al cerrar sesión. Token que sigue válido tras cambiar la contraseña. Enumeración de usuarios por el mensaje de error |
| **Fallos de integridad** | Actualizaciones o dependencias sin verificación de origen |
| **Fallos de logging** | ¿Queda registro de un intento de acceso no autorizado? ¿Los logs incluyen contraseñas o tokens? |
| **SSRF** | Campos que aceptan una URL: probar direcciones internas como `localhost` o rangos privados |

---

## Control de acceso: el más frecuente y el más barato de probar

La mayoría de las vulnerabilidades reales en aplicaciones de negocio son de autorización, no de criptografía exótica.

**Matriz mínima.** Por cada recurso sensible, probá las cuatro celdas:

| | Recurso propio | Recurso ajeno |
|---|---|---|
| **Usuario común** | ✅ Debe permitir | ❌ Debe denegar |
| **Sin autenticar** | ❌ Debe denegar | ❌ Debe denegar |

Y además:

- [ ] Un usuario común no puede ejecutar operaciones de administrador
- [ ] La autorización se verifica **en el servidor**, no solo ocultando botones en la interfaz
- [ ] El identificador de recurso no es predecible, o el control compensa que lo sea
- [ ] Denegar devuelve 403/404 sin filtrar si el recurso existe

**Por qué importa el último punto:** responder 404 para "no existe" y 403 para "existe pero no es tuyo" le confirma al atacante qué IDs son válidos.

---

## Validación de entrada

Todo campo que acepta datos del usuario es una superficie de ataque. Por cada campo, probá:

| Categoría | Payloads |
|-----------|----------|
| SQL | `' OR '1'='1`, `'; DROP TABLE--`, `1' UNION SELECT` |
| XSS | `<script>alert(1)</script>`, `<img src=x onerror=alert(1)>`, `javascript:alert(1)` |
| Comandos | `; ls`, `\| whoami`, `$(id)` |
| Rutas | `../../etc/passwd`, `..\..\windows\win.ini` |
| Desbordamiento | Cadena de 10.000 caracteres |
| Tipos | Enviar texto donde se espera número; array donde se espera string; `null` |
| Unicode | Emoji, caracteres de control, bytes nulos |

**Regla clave:** la validación del cliente es usabilidad, **no seguridad**. Probá siempre contra la API directamente, saltándote la interfaz.

---

## Gestión de secretos

Verificaciones que cuestan minutos y evitan incidentes graves:

- [ ] No hay credenciales, tokens ni claves en el repositorio, ni en el historial de git
- [ ] Los secretos vienen de variables de entorno o de un gestor de secretos
- [ ] Los logs no imprimen contraseñas, tokens ni datos personales
- [ ] Los mensajes de error no exponen rutas internas, versiones ni estructura de la base de datos
- [ ] Hay un escáner de secretos en CI (gitleaks, trufflehog)

**El historial de git cuenta.** Un secreto borrado en un commit posterior sigue siendo accesible: hay que rotarlo, no solo borrarlo.

---

## Tipos de análisis automatizado

| Tipo | Qué analiza | Cuándo corre | Limitación |
|------|-------------|--------------|------------|
| **SAST** | El código fuente | En cada PR | Muchos falsos positivos; no ve fallos de lógica de negocio |
| **DAST** | La aplicación en ejecución | Contra un entorno desplegado | Lento; solo cubre lo que alcanza a recorrer |
| **SCA** | Las dependencias | En cada PR y de forma periódica | Reporta vulnerabilidades conocidas, no las propias |
| **Escáner de secretos** | Repositorio e historial | En cada commit | Solo detecta patrones conocidos |

**Empezá por SCA.** Es el de mejor retorno inmediato: la mayoría de las vulnerabilidades explotables en un proyecto típico vienen de dependencias desactualizadas, y la corrección suele ser subir una versión.

---

## Herramientas

| Uso | Herramientas |
|-----|--------------|
| Dependencias (SCA) | `npm audit`, `pip-audit`, Dependabot, Snyk, OWASP Dependency-Check |
| Código (SAST) | Semgrep, SonarQube, CodeQL, Bandit (Python) |
| Aplicación (DAST) | OWASP ZAP, Burp Suite |
| Secretos | gitleaks, trufflehog |
| Cabeceras y TLS | securityheaders.com, SSL Labs |

---

## Proporcionalidad

| Contexto | Alcance razonable |
|----------|-------------------|
| Proyecto personal sin datos de terceros | SCA en CI + revisar secretos + matriz de control de acceso |
| Producto con usuarios reales | Lo anterior + SAST + validación de entrada sistemática + cabeceras |
| Dinero, salud o datos personales sensibles | Todo lo anterior + DAST + **pentest profesional**. Decilo explícitamente |

---

## Límite ético y legal

**Probá únicamente sistemas sobre los que tenés autorización.** Ejecutar estas verificaciones contra un sistema de terceros sin permiso escrito es ilegal en la mayoría de las jurisdicciones, aunque la intención sea buena.

En un proyecto de cliente, la autorización para pruebas de seguridad se confirma con el cliente y se registra en su perfil antes de ejecutar nada.
