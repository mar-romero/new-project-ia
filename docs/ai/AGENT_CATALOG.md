# Catálogo portable de agentes y skills

## Qué es igual y qué no

Este repositorio ofrece el mismo contrato operativo en Codex, Claude Code,
OpenCode, Cursor, Gemini CLI y GitHub Copilot:

- siete roles con el mismo cuerpo de instrucciones;
- catorce skills canónicas;
- `AGENTS.md` y `AI_POLICY.md` como reglas del proyecto;
- el ciclo `REQUEST → TASK → RISK → IMPLEMENT → CHECKS → REVIEW → CLOSE`;
- un solo escritor por tarea y revisión independiente cuando el riesgo lo
  requiere.

Esto no vuelve idénticos los modelos. Calidad, latencia, precio, ventana de
contexto, selección automática, permisos y herramientas siguen dependiendo
del proveedor, la versión, el plan y la política de la organización.

## Roles

| Rol | Úselo cuando | Entrega esperada |
|---|---|---|
| `explorer` | Hay que localizar archivos, flujo, invariantes o tests | Mapa pequeño del código relevante; no edita |
| `planner` | La tarea es ambigua, transversal o de riesgo alto | Plan, criterios, fallos, tests y rollback; no edita |
| `implementer` | La tarea y sus criterios ya están aceptados | Cambio mínimo, tests, diff y evidencia; único escritor |
| `reviewer` | Existe un candidato congelado con checks | Intenta falsificarlo y termina en `PASS` o `CHANGES_REQUIRED` |
| `test-auditor` | Importa saber si los tests detectan defectos reales | Huecos, falsos positivos y evidencia mínima necesaria |
| `security-reviewer` | Cambian límites de confianza, permisos o datos sensibles | Escenarios de ataque/fallo, impacto y mitigación |
| `docs-researcher` | El comportamiento depende de documentación externa actual | Contrato compacto, fuentes oficiales, fecha y limitaciones |

No invoque todos los roles por rutina. Una modificación trivial puede hacerse
directamente con un check focalizado. Una tarea normal suele necesitar un
implementer y un reviewer; agregue especialistas sólo por una razón concreta.

## Skills disponibles

Las skills se cargan bajo demanda para no ocupar contexto con instrucciones
irrelevantes.

| Grupo | Skills | Propósito |
|---|---|---|
| Ciclo de trabajo | `task-intake`, `implementation-loop`, `task-close` | Definir, implementar y cerrar una tarea con evidencia |
| Decisiones y fuentes | `source-research`, `architecture-decision`, `decision-escalation` | Verificar contratos, comparar opciones duraderas y pedir decisiones humanas |
| Ingeniería | `software-engineering`, `test-strategy`, `systemic-defect-triage` | Diseño simple y universal, pruebas útiles y diagnóstico de causas comunes |
| Revisión y división | `independent-review`, `chained-work`, `work-unit-commits` | Falsificar candidatos y mantener unidades revisables |
| Colaboración | `github-issue`, `cognitive-doc-design` | Issues accionables y documentación fácil de escanear/verificar |

Codex, Cursor, OpenCode, Gemini CLI y Copilot descubren
`.agents/skills/` nativamente. Claude Code usa wrappers mínimos en
`.claude/skills/` que apuntan a la misma fuente canónica. Gemini solicita
consentimiento al activar una skill. El implementer de Claude precarga sólo
`software-engineering`; el resto se mantiene bajo demanda.

## Cómo invocar un rol

| Herramienta | Invocación práctica | Inspección |
|---|---|---|
| Codex | Escriba “usa el agente `explorer` para…”; el agente principal también puede delegar por descripción | Revise `.codex/agents/` y las skills cargadas |
| Claude Code | `@explorer <tarea>` o delegación automática | `/agents`, `/skills`, `/memory` |
| OpenCode | `@explorer <tarea>` o selección automática por descripción | Inspeccione agentes y skills disponibles |
| Cursor | Pida explícitamente el rol o permita la delegación automática; adminístrelo en Customize → Agents | Customize → Agents/Rules/Skills |
| Gemini CLI | Comience el prompt con `@explorer <tarea>` | `/agents`, `/skills list`, `/skills reload` |
| GitHub Copilot CLI | Seleccione con `/agent`, o `copilot --agent explorer --prompt "<tarea>"` | `/agent` y `/instructions` |

Los nombres y descripciones son iguales para mejorar el enrutamiento, pero la
decisión automática del modelo puede variar. Para trabajo importante, nombre
el rol de forma explícita.

## Flujo recomendado

1. Defina resultado observable y criterios de aceptación; use `task-intake` si
   todavía son imprecisos.
2. Clasifique el riesgo. Use `planner`, `docs-researcher` o una skill sólo si
   la incertidumbre lo justifica.
3. Entregue al `implementer` la tarea, criterios, rutas relevantes y límites;
   no todo el historial del chat.
4. Ejecute checks deterministas y congele el candidato.
5. Para R1–R3, entregue al `reviewer` la tarea, el diff y los resultados
   exactos. El reviewer no debe ser quien implementó.
6. Cierre sólo con criterios cumplidos, hallazgos altos resueltos y riesgos
   residuales registrados.

Ejemplo compacto:

```text
Usa planner para T-012: devuelve sólo supuestos, plan, criterios, tests y rollback.
Usa implementer para T-012: modifica únicamente los archivos acordados y reporta checks exactos.
Usa reviewer para T-012: intenta falsificar el diff congelado y termina con un veredicto.
```

## Política para consumir menos contexto y tokens

- Empiece directo para R0; no cree una cadena de agentes para cambios
  mecánicos.
- Use un especialista por defecto. Paralelice sólo trabajos realmente
  independientes; cada subagente consume su propio contexto.
- Pase contratos compactos: objetivo, criterios, rutas, invariantes, comandos y
  evidencia. Evite copiar conversaciones o archivos completos.
- Active sólo la skill necesaria y lea sólo sus referencias relevantes.
- Mantenga un único escritor; evita diffs conflictivos y relecturas.
- Use el [perfil por rol](MODEL_ROUTING.md): modelos rápidos para descubrimiento
  y modelos fuertes para implementación y revisión. Eleve el esfuerzo sólo con
  evidencia; el arnés detecta cambios accidentales en este perfil.
- Limite los ciclos review/fix a dos; escale evidencia no resuelta en lugar de
  repetir agentes indefinidamente.
- Registre decisiones duraderas en el repositorio para no reconstruir contexto
  en cada sesión.

## Diferencias de seguridad y ejecución

| Herramienta | Diferencia relevante |
|---|---|
| Codex | Conserva los sandboxes y niveles de razonamiento originales del starter |
| Claude Code | Sus allowlists y `disallowedTools` restringen cada rol; requiere wrappers de skills |
| OpenCode | Usa permisos V2 cerrados y ordenados; use una versión compatible |
| Cursor | `readonly` bloquea ediciones y shell con cambio de estado, pero no ofrece en el perfil un deny completo de shell/delegación; `Do not delegate` es best-effort |
| Gemini CLI | Usa allowlists explícitas y no permite recursión de subagentes; cada activación de skill pide consentimiento |
| GitHub Copilot | Usa allowlists de herramientas; ningún perfil recibe el alias `agent`, por lo que no puede delegar desde estos roles |

Estas configuraciones reducen privilegios dentro de lo documentado, pero no
reemplazan políticas administradas, sandboxing, aprobaciones ni controles del
entorno.

## Modelos por rol

Cada adaptador declara un modelo y, cuando el proveedor lo permite, esfuerzo y
límite de turnos/pasos. Consulte la
[matriz completa, fallbacks y personalización segura](MODEL_ROUTING.md). Los
modelos efectivos pueden variar por plan, versión, cuota o política; esto no
cambia el cuerpo, los permisos ni las skills de ningún rol.

## Relación con Gentle-AI

Gentle-AI confirma el mismo principio: la portabilidad real usa una intención
común y adaptadores específicos por runtime. Su alcance incluye un configurador
e instalación de módulos; este starter mantiene archivos estáticos dentro del
repositorio porque siete roles y catorce skills no justifican todavía un
generador. El harness detecta drift y funciona inmediatamente después de
clonar, sin escribir configuración global del desarrollador.

## Comprobación local

Ejecute desde cualquier directorio del repositorio:

```bash
bash scripts/check-harness.sh
```

Para validar además los fixtures negativos del propio harness:

```bash
CHECK_HARNESS_SELFTEST=1 bash scripts/check-harness.sh
```
