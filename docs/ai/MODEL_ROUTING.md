# Enrutamiento de modelos por rol

## Objetivo

Este es un perfil inicial orientado a calidad con costo controlado. Los roles,
permisos, cuerpos y skills siguen siendo iguales entre herramientas; sólo cambia
la selección nativa de modelo y el presupuesto de trabajo. “Mejor” significa
adecuado para el rol según la documentación vigente, no ganador de un benchmark
universal.

## Perfil comprobado

| Rol | Codex | Claude Code | Cursor | Gemini CLI | OpenCode (Zen) | Copilot CLI |
|---|---|---|---|---|---|---|
| `explorer` | GPT-5.6 Luna · low | Haiku · low · 10 turnos | Composer 2.5 · fast | Gemini 3 Flash Preview · 12 turnos | GPT-5.6 Luna · 12 pasos | Claude Haiku 4.5 · low |
| `docs-researcher` | GPT-5.6 Terra · medium | Sonnet · medium · 16 turnos | Grok 4.6 · medium | Gemini 3 Flash Preview · 18 turnos | GPT-5.6 Terra · 18 pasos | Gemini 3.7 Flash · medium |
| `implementer` | GPT-5.6 Sol · high | Sonnet · high · 30 turnos | Composer 2.5 · standard | Gemini 3.1 Pro Preview · 30 turnos | GPT-5.6 Sol · 30 pasos | GPT-5.3-Codex · high |
| `planner` | GPT-5.6 Sol · high | Opus · high · 20 turnos | Grok 4.6 · high | Gemini 3.1 Pro Preview · 20 turnos | GPT-5.6 Sol · 20 pasos | GPT-5.4 · high |
| `reviewer` | GPT-5.6 Sol · xhigh | Opus · high · 20 turnos | Grok 4.6 · xhigh | Gemini 3.1 Pro Preview · 20 turnos | GPT-5.6 Sol · 20 pasos | GPT-5.4 · high |
| `security-reviewer` | GPT-5.6 Sol · xhigh | Opus · high · 24 turnos | Grok 4.6 · xhigh | Gemini 3.1 Pro Preview · 24 turnos | GPT-5.6 Sol · 24 pasos | GPT-5.4 · high |
| `test-auditor` | GPT-5.6 Terra · high | Sonnet · high · 18 turnos | Grok 4.6 · high | Gemini 3.1 Pro Preview · 18 turnos | GPT-5.6 Terra · 18 pasos | GPT-5.4 · high |

En Claude, `opus`, `sonnet` y `haiku` son aliases móviles: en el Anthropic API
actual apuntan a las familias 5, pero otros hosts empresariales pueden resolver
otra versión. Cursor usa el pool first-party: Composer 2.5 para búsqueda e
implementación, Grok 4.6 para investigación, planificación y revisión. Fast es
el default de Composer/Grok en Pro+; el perfil ancla `fast=false` en roles de
juicio e implementación y `fast=true` sólo en `explorer`. Grok documenta
`low`/`medium`/`high`/`xhigh`; Composer no documenta `effort`, sólo `fast`.
En el plan Start, Grok queda fijo en medium y velocidad estándar. Gemini no
expone un campo de esfuerzo directo por subagente; se usan temperatura baja y
límites de turnos. No se agregan presupuestos de thinking no documentados.
OpenCode V2 tampoco expone esfuerzo como campo del agente: el perfil usa nivel
de modelo y pasos; una variante requiere settings verificados y selección
`model#variant`.

## Por qué está distribuido así

- Exploración y búsqueda acotada usan modelos rápidos: normalmente entregan un
  mapa, no una decisión final.
- Implementación usa un modelo especializado o frontier con esfuerzo alto.
- Planificación, revisión y seguridad reciben los modelos de razonamiento más
  fuertes disponibles en el catálogo documentado de cada herramienta.
- Auditoría de tests y fuentes usa un modelo fuerte pero no siempre el más caro.
- Ningún rol usa esfuerzo `max` por defecto: debe justificarse con una evaluación
  donde `high` o `xhigh` haya omitido defectos importantes.

## Disponibilidad y fallback

La configuración versionada expresa intención; cada runtime decide la
disponibilidad efectiva según versión, plan, cuota y política de la organización.

| Herramienta | Comprobar antes de trabajo importante | Si el modelo no está disponible |
|---|---|---|
| Codex | Inspeccione `.codex/agents/` y el modelo reportado al iniciar el rol | Sustituya por un modelo habilitado de la misma familia/capacidad |
| Claude Code | Actualice el CLI; use `/model` y `/agents` | Use el alias disponible o cambie temporalmente a `inherit` |
| Cursor | Customize → Agents y el selector de modelos | Habilite el modelo en el plan/admin o use uno equivalente del catálogo visible |
| Gemini CLI | `/model` y `/agents` | Use el Pro/Flash visible o Auto; los IDs Preview dependen de rollout y cuota |
| OpenCode | `/connect` y `opencode models` | Conecte Zen y acepte su costo, o reemplace `opencode/...` por un proveedor/modelo ya conectado |
| Copilot CLI | `/model` y `/agent` | El CLI puede heredar el modelo de sesión; evite Auto si necesita respetar el modelo del subagente |

OpenCode Zen es opcional y pago. El repositorio no conecta cuentas, compra
créditos ni guarda credenciales. Copilot Auto puede reemplazar explícitamente
el modelo declarado por el modelo resuelto de la sesión.

## Cómo personalizar sin romper el contrato

1. Confirme el ID y los niveles de esfuerzo en la documentación actual y en el
   catálogo de su cuenta.
2. Cambie sólo los metadatos del adaptador correspondiente; no duplique ni
   modifique el cuerpo canónico del rol.
3. Actualice la matriz esperada en `scripts/check-harness.sh` y este documento.
4. Ejecute:

```bash
CHECK_HARNESS_SELFTEST=1 bash scripts/check-harness.sh
```

5. Para una decisión duradera, mida calidad, latencia, tokens y costo sobre
   tareas representativas. Sin esa evaluación, preserve este perfil o vuelva a
   `inherit`.

Fuentes y limitaciones verificadas están en
[`ROLE_MODEL_CONFIGURATION.md`](../sources/contracts/ROLE_MODEL_CONFIGURATION.md)
y la decisión en
[`ADR-004-role-model-routing.md`](../decisions/ADR-004-role-model-routing.md).
