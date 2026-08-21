# Portable AI Engineering Harness

Starter universal para desarrollar software con agentes de IA sin depender de
un único proveedor. El repositorio ofrece el mismo contrato de trabajo, los
mismos siete roles y las mismas skills canónicas en:

- Codex;
- Claude Code;
- Cursor;
- Gemini CLI;
- OpenCode;
- GitHub Copilot CLI.

Cada herramienta usa su formato nativo. Las instrucciones comunes viven una
sola vez y un arnés detecta adaptadores incompletos, permisos inseguros, modelos
incorrectos y contenido divergente.

> [!IMPORTANT]
> Portabilidad no significa rendimiento idéntico. El flujo, los roles y las
> skills son equivalentes; calidad, precio, latencia, contexto, permisos y
> disponibilidad de modelos dependen del proveedor, versión, plan y política de
> cada organización.

## Qué incluye

- Un ciclo verificable: `REQUEST → TASK → RISK → IMPLEMENT → CHECKS → REVIEW → CLOSE`.
- Siete agentes especializados con un solo implementador/escritor por tarea.
- Diecinueve skills cargadas bajo demanda para ahorrar contexto y tokens.
- Una skill universal de ingeniería de software, independiente del lenguaje.
- Adaptadores nativos para los seis proveedores soportados.
- Modelos, esfuerzo y límites de trabajo configurados por rol y proveedor.
- Permisos de mínimo privilegio dentro de lo que soporta cada herramienta.
- Plantillas para tareas, specs, ADRs, revisiones y contratos externos.
- Un arnés determinista y CI para detectar drift de configuración.

## Qué no incluye

- Una aplicación o stack tecnológico preseleccionado.
- Credenciales, API keys, suscripciones o créditos de proveedores.
- Instalación global automática de ningún CLI.
- Garantía de que todos los modelos estén habilitados en todas las cuentas.
- Un reemplazo para revisión humana, sandboxing o políticas organizacionales.

## Inicio rápido

### 1. Crear el proyecto

Use este repositorio como template o clónelo:

```bash
git clone <URL_DEL_REPOSITORIO> mi-proyecto
cd mi-proyecto
```

Si lo usa como starter, conserve `.agents/`, los adaptadores de proveedor,
`AGENTS.md`, `AI_POLICY.md`, `scripts/` y la estructura documental.

### 2. Personalizar la identidad

Antes de programar:

1. Reemplace `<PROJECT_NAME>` en `AGENTS.md`.
2. Complete `docs/product/PRODUCT_VISION.md`.
3. Complete `docs/product/ROADMAP.md`.
4. Registre stack, comandos e invariantes en `docs/ai/PROJECT_MEMORY.md`.
5. Adapte los niveles de riesgo y gates humanos al dominio real.

### 3. Instalar un proveedor

Sólo necesita instalar y autenticar una de las herramientas. Consulte
[Instalación por proveedor](#instalación-por-proveedor).

### 4. Validar el starter

En macOS, Linux, WSL o Git Bash:

```bash
bash scripts/check-harness.sh
```

En PowerShell con Git for Windows:

```powershell
& 'C:\Program Files\Git\bin\bash.exe' scripts/check-harness.sh
```

Resultado esperado:

```text
Checking project starter harness...
HARNESS CHECK PASSED.
```

### 5. Iniciar la herramienta desde la raíz

Abra el repositorio en el proveedor elegido y use un prompt explícito:

```text
Usa el agente explorer para mapear el repositorio. No edites archivos.
Devuelve sólo archivos relevantes, flujo, tests, invariantes y riesgos.
```

Después puede iniciar una tarea real:

```text
Usa task-intake para definir esta funcionalidad y sus criterios de aceptación:
<descripción de la funcionalidad>.
```

## Compatibilidad

| Herramienta | Reglas del proyecto | Agentes | Skills | Invocación recomendada |
|---|---|---|---|---|
| Codex | `AGENTS.md` | `.codex/agents/*.toml` | `.agents/skills/` | “Usa el agente `explorer`…” |
| Claude Code | `CLAUDE.md` importa las políticas | `.claude/agents/*.md` | `.claude/skills/` enlaza las canónicas | `@explorer <tarea>` |
| Cursor | `AGENTS.md` | `.cursor/agents/*.md` | `.agents/skills/` | Pida el rol o use delegación automática |
| Gemini CLI | `GEMINI.md` importa las políticas | `.gemini/agents/*.md` | `.agents/skills/` | `@explorer <tarea>` |
| OpenCode | `opencode.json` carga las políticas | `.opencode/agents/*.md` | `.agents/skills/` | `@explorer <tarea>` |
| Copilot CLI | `.github/copilot-instructions.md` | `.github/agents/*.agent.md` | `.agents/skills/` | `/agent` o `copilot --agent explorer ...` |

Para tareas importantes nombre el rol de forma explícita. El enrutamiento
automático depende del modelo principal y puede variar entre proveedores.

## Instalación por proveedor

Los comandos siguientes son ejemplos oficiales verificados el 20 de agosto de
2026. Revise siempre la documentación enlazada porque instaladores, modelos y
requisitos pueden cambiar.

### Codex

Instalador para macOS/Linux:

```bash
curl -fsSL https://chatgpt.com/codex/install.sh | sh
```

Alternativa mediante npm:

```bash
npm install -g @openai/codex
```

Inicie desde el repositorio y autentíquese:

```bash
codex
```

Use `/status`, `/model` y `/permissions` para comprobar el workspace, modelo,
esfuerzo y permisos efectivos. Codex lee `AGENTS.md` al iniciar la sesión y usa
los perfiles de `.codex/agents/`.

Documentación: [Codex CLI](https://developers.openai.com/codex/cli/) y
[AGENTS.md](https://developers.openai.com/codex/guides/agents-md/).

### Claude Code

macOS, Linux o WSL:

```bash
curl -fsSL https://claude.ai/install.sh | bash
```

Windows PowerShell:

```powershell
irm https://claude.ai/install.ps1 | iex
```

Inicie y verifique:

```bash
claude
claude --version
```

Dentro de Claude Code use `/memory`, `/agents` y `/skills`. `CLAUDE.md` importa
`AGENTS.md` y `AI_POLICY.md`; los roles y wrappers de skills son nativos de
Claude.

Documentación: [instalación](https://code.claude.com/docs/en/installation) y
[subagentes](https://code.claude.com/docs/en/sub-agents).

### Cursor

Puede abrir la carpeta con el IDE de Cursor o instalar Cursor CLI en macOS,
Linux y Windows mediante WSL:

```bash
curl https://cursor.com/install -fsS | bash
cursor-agent --version
cursor-agent
```

En el IDE inspeccione `Customize → Agents/Rules/Skills`. Cursor descubre
`AGENTS.md`, `.cursor/agents/` y `.agents/skills/`.

Documentación: [instalación de Cursor CLI](https://docs.cursor.com/en/cli/installation)
y [subagentes](https://cursor.com/docs/subagents).

### Gemini CLI

Requiere Node.js 20 o posterior:

```bash
npm install -g @google/gemini-cli
gemini
```

Autentíquese con Google o con el método habilitado por su organización. Use
`/agents`, `/skills list`, `/skills reload`, `/model` y `/stats model` para
comprobar descubrimiento, modelo y consumo. Gemini solicita consentimiento al
activar una skill.

Documentación: [instalación](https://geminicli.com/docs/get-started/installation/),
[subagentes](https://geminicli.com/docs/core/subagents/) y
[Agent Skills](https://geminicli.com/docs/cli/using-agent-skills/).

### OpenCode

macOS, Linux o WSL:

```bash
curl -fsSL https://opencode.ai/install | bash
```

Alternativa con npm:

```bash
npm install -g opencode-ai
```

Inicie la TUI:

```bash
opencode
```

Ejecute `/connect` para elegir un proveedor y `opencode models` para listar los
modelos realmente disponibles. Este starter usa OpenCode Zen como base; Zen es
opcional y pago. Puede cambiarlo por cualquier proveedor conectado.

Documentación: [inicio](https://opencode.ai/docs),
[agentes V2](https://opencode.ai/v2/docs/agents) y
[modelos V2](https://opencode.ai/v2/docs/models).

### GitHub Copilot CLI

Con npm requiere Node.js 22 o posterior:

```bash
npm install -g @github/copilot
copilot
```

En Windows también puede usar:

```powershell
winget install GitHub.Copilot
```

En la primera sesión ejecute `/login`. Use `/agent`, `/instructions` y `/model`
para inspeccionar la configuración. Si Copilot pertenece a una organización, el
administrador debe habilitar la política de Copilot CLI.

Documentación: [inicio de Copilot CLI](https://docs.github.com/en/copilot/how-tos/copilot-cli/cli-getting-started)
y [custom agents](https://docs.github.com/en/copilot/reference/custom-agents-configuration).

## Cómo está organizado

```text
.
├── AGENTS.md                         # política canónica del proyecto
├── AI_POLICY.md                      # seguridad y uso responsable
├── CLAUDE.md / GEMINI.md             # entradas específicas de proveedor
├── opencode.json                     # entrada de OpenCode
├── .agents/
│   ├── roles/                        # cuerpos canónicos de los 7 roles
│   └── skills/                       # skills canónicas y extensibles
├── .codex/agents/                    # adaptadores Codex
├── .claude/agents/ y .claude/skills/ # adaptadores Claude
├── .cursor/agents/                   # adaptadores Cursor
├── .gemini/agents/                   # adaptadores Gemini
├── .opencode/agents/                 # adaptadores OpenCode
├── .github/agents/                   # adaptadores Copilot
├── docs/                             # memoria, arquitectura y contratos
├── tasks/ y specs/                   # unidades de trabajo verificables
└── scripts/check-harness.sh          # validación de estructura y paridad
```

### Fuente canónica y adaptadores

Los cuerpos neutrales viven en `.agents/roles/`. Cada proveedor necesita
frontmatter o TOML diferente para declarar modelo, herramientas, permisos y
límites. El adaptador agrega esos metadatos, pero su cuerpo debe ser idéntico al
canónico.

Las skills viven en `.agents/skills/`. Codex, Cursor, Gemini, OpenCode y Copilot
las descubren allí. Claude requiere wrappers mínimos en `.claude/skills/`, que
apuntan a la misma fuente en lugar de duplicar conocimiento.

El arnés comprueba inventario, metadatos exactos, permisos, cuerpos, referencias
de skills, archivos huérfanos y YAML/TOML ambiguo.

## Flujo de trabajo

```text
REQUEST
  ↓
TASK + criterios de aceptación
  ↓
RISK (R0 / R1 / R2 / R3)
  ↓
IMPLEMENT (un solo escritor)
  ↓
DETERMINISTIC CHECKS
  ↓
INDEPENDENT REVIEW cuando corresponde
  ↓
CLOSE + evidencia + riesgos residuales
```

| Riesgo | Ejemplo | Evidencia mínima |
|---|---|---|
| R0 | Documentación, formato, rename mecánico | Check focalizado |
| R1 | Feature, bugfix o refactor normal | Tests, checks y revisión independiente |
| R2 | Persistencia, concurrencia, integración externa, cálculo importante | Spec/plan, tests fuertes y revisión especialista |
| R3 | Secretos, auth, destrucción, producción irreversible | Revisión adversarial y aprobación humana explícita |

No cree tareas y agentes por ceremonia. Un cambio trivial puede ser directo. Un
cambio significativo debe dejar evidencia durable en el repositorio.

## Agentes incluidos

| Rol | Responsabilidad | Puede editar |
|---|---|---|
| `explorer` | Mapear archivos, flujo, tests, invariantes y riesgos | No |
| `planner` | Convertir incertidumbre en plan, criterios, tests y rollback | No |
| `implementer` | Implementar una tarea aceptada y ejecutar checks | Sí; único escritor |
| `reviewer` | Intentar falsificar un candidato congelado | No |
| `test-auditor` | Evaluar si los tests detectan defectos reales | No |
| `security-reviewer` | Auditar límites de confianza y escenarios de ataque | No |
| `docs-researcher` | Verificar contratos técnicos en fuentes oficiales | No |

Use sólo los agentes necesarios. No todos los cambios requieren los siete.

## Skills incluidas

| Grupo | Skills |
|---|---|
| Ciclo | `task-intake`, `implementation-loop`, `task-close` |
| Fuentes y decisiones | `source-research`, `grounded-evidence`, `technical-spike`, `architecture-decision`, `decision-escalation` |
| Ingeniería y QA | `software-engineering`, `test-strategy`, `systemic-defect-triage`, `web-dogfood` |
| Revisión y unidades | `independent-review`, `judgment-day`, `chained-work`, `work-unit-commits` |
| Colaboración | `github-issue`, `cognitive-doc-design` |
| Autoría portable | `portable-skill-authoring` |

Las skills se cargan bajo demanda. La skill `software-engineering` promueve
soluciones simples, legibles y reutilizables; aplica YAGNI, alta cohesión, bajo
acoplamiento, testing, seguridad y arquitectura sólo cuando el problema lo
justifica. No impone Python, TypeScript, .NET, Rust ni otro lenguaje.

## Modelos configurados

El perfil inicial busca calidad con costo controlado: modelos rápidos para
descubrimiento, modelos de programación para implementar y modelos fuertes de
razonamiento para planificar o revisar.

| Rol | Codex | Claude | Cursor | Gemini | OpenCode Zen | Copilot |
|---|---|---|---|---|---|---|
| `explorer` | GPT-5.6 Luna · low | Haiku · low | Composer 2.5 · fast | Gemini 3 Flash | GPT-5.6 Luna · 12 steps | Claude Haiku 4.5 · low |
| `docs-researcher` | GPT-5.6 Terra · medium | Sonnet · medium | Grok 4.6 · medium | Gemini 3 Flash | GPT-5.6 Terra · 18 steps | Gemini 3.7 Flash · medium |
| `implementer` | GPT-5.6 Sol · high | Sonnet · high | Composer 2.5 · standard | Gemini 3.1 Pro | GPT-5.6 Sol · 30 steps | GPT-5.3-Codex · high |
| `planner` | GPT-5.6 Sol · high | Opus · high | Grok 4.6 · high | Gemini 3.1 Pro | GPT-5.6 Sol · 20 steps | GPT-5.4 · high |
| `reviewer` | GPT-5.6 Sol · xhigh | Opus · high | Grok 4.6 · xhigh | Gemini 3.1 Pro | GPT-5.6 Sol · 20 steps | GPT-5.4 · high |
| `security-reviewer` | GPT-5.6 Sol · xhigh | Opus · high | Grok 4.6 · xhigh | Gemini 3.1 Pro | GPT-5.6 Sol · 24 steps | GPT-5.4 · high |
| `test-auditor` | GPT-5.6 Terra · high | Sonnet · high | Grok 4.6 · high | Gemini 3.1 Pro | GPT-5.6 Terra · 18 steps | GPT-5.4 · high |

Detalles de turnos, timeouts, fallbacks y decisiones:
[MODEL_ROUTING.md](docs/ai/MODEL_ROUTING.md).

### Por qué no usa el modelo más caro para todo

- Explorar archivos no necesita el mismo presupuesto que revisar autorización.
- Cada subagente consume su propio contexto; paralelizar sin necesidad aumenta
  tokens y costo.
- Esfuerzo alto no garantiza mejor resultado en tareas simples.
- Los modelos frontier se reservan para código y decisiones con impacto.
- Los límites de turnos/pasos evitan loops innecesarios.

## Modificar los modelos

Sí: todos los modelos son configurables. Puede usar los IDs disponibles en su
plan, volver a `inherit` donde el proveedor lo soporte o reemplazar la base de
OpenCode por otro proveedor.

| Proveedor | Archivo | Campos principales |
|---|---|---|
| Codex | `.codex/agents/<rol>.toml` | `model`, `model_reasoning_effort` |
| Claude | `.claude/agents/<rol>.md` | `model`, `effort`, `maxTurns` |
| Cursor | `.cursor/agents/<rol>.md` | `model`, parámetros como `[effort=high]` |
| Gemini | `.gemini/agents/<rol>.md` | `model`, `temperature`, `max_turns`, `timeout_mins` |
| OpenCode | `.opencode/agents/<rol>.md` | `model`, `steps` |
| Copilot | `.github/agents/<rol>.agent.md` | `model`, `reasoningEffort` |

Ejemplos:

```toml
# Codex
model = "gpt-5.6-sol"
model_reasoning_effort = "high"
```

```yaml
# Claude Code
model: opus
effort: high
maxTurns: 20
```

```yaml
# Cursor
model: claude-opus-5[effort=high]
```

```yaml
# Gemini CLI
model: gemini-3.1-pro-preview
temperature: 0.1
max_turns: 20
timeout_mins: 10
```

```yaml
# OpenCode V2
model: opencode/gpt-5.6-sol
steps: 20
```

```yaml
# GitHub Copilot CLI
model: gpt-5.4
reasoningEffort: high
```

### Cambiar la base de OpenCode

OpenCode identifica modelos como `proveedor/modelo`. Para reemplazar Zen:

1. Ejecute `/connect` en OpenCode.
2. Ejecute `opencode models`.
3. Copie el ID exacto, por ejemplo `otro-proveedor/modelo-disponible`.
4. Reemplace `model:` en los perfiles `.opencode/agents/`.
5. Si usa variantes, defínalas según la configuración V2 y selecciónelas como
   `modelo#variante`; no agregue `reasoningEffort` al frontmatter del agente.

### Mantener el arnés sincronizado

El arnés fija intencionalmente el perfil esperado. Después de cambiar modelos:

1. Actualice las tablas de perfil en `scripts/check-harness.sh`.
2. Actualice `docs/ai/MODEL_ROUTING.md`.
3. Registre fuentes actuales si cambió el contrato del proveedor.
4. Ejecute:

```bash
CHECK_HARNESS_SELFTEST=1 bash scripts/check-harness.sh
```

Si el arnés falla después de un cambio intencional, no lo desactive: actualice
la expectativa exacta. Así un rename o upgrade no degrada silenciosamente todos
los agentes.

### Fallbacks y restricciones de cuenta

- Los aliases `opus`, `sonnet` y `haiku` de Claude son móviles y pueden resolver
  versiones diferentes en Anthropic, Bedrock, Vertex o Foundry.
- Cursor puede reemplazar un modelo bloqueado por plan o administración.
- Gemini 3.1 Pro Preview depende del rollout, cuota y configuración de cuenta.
- OpenCode necesita un proveedor conectado; Zen requiere cuenta y facturación.
- Copilot Auto puede ignorar el modelo del subagente y usar el de la sesión.
- Codex puede ofrecer modelos diferentes según plan, workspace o versión.

Compruebe siempre el modelo efectivo en la herramienta antes de una tarea de
alto riesgo.

## Personalizar agentes y skills

### Modificar un agente existente

1. Cambie primero el cuerpo canónico en `.agents/roles/<rol>.md`.
2. Copie exactamente ese cuerpo en cada adaptador nativo.
3. No cambie permisos sólo para solucionar un problema de modelo.
4. Ejecute el arnés para confirmar paridad.

### Crear un agente nuevo

1. Defina una responsabilidad concreta y no solapada.
2. Cree el cuerpo neutral en `.agents/roles/<rol>.md`.
3. Cree adaptadores para los seis proveedores.
4. Aplique mínimo privilegio y un modelo proporcional al riesgo.
5. Añada el rol al inventario esperado del arnés.
6. Documente cómo se invoca y cuándo no debe usarse.

No agregue agentes sólo para representar títulos de equipo. Un agente se
justifica cuando necesita instrucciones, herramientas o contexto diferentes.

### Crear o modificar una skill

Primero decida con el usuario si debe estar disponible en todos los proveedores
o sólo en uno. No suponga portabilidad desde un pedido genérico de “crear una
skill”.

Para una skill portable, pida a cualquier agente:

```text
Usa portable-skill-authoring. Crea la skill <nombre> para todos los proveedores.
```

El flujo crea `.agents/skills/<skill>/SKILL.md` como fuente canónica y ejecuta:

```bash
bash scripts/sync-portable-skills.sh --write
bash scripts/sync-portable-skills.sh --check
bash scripts/check-harness.sh
```

Una carpeta directa cuyo nombre comienza con `_`, por ejemplo
`.agents/skills/_shared/`, es sólo para recursos compartidos entre skills. No
lleva `SKILL.md`, no es invocable y no genera un adaptador de proveedor.

El sincronizador genera sólo el wrapper de Claude Code. Codex, Cursor, Gemini,
OpenCode y Copilot descubren la skill canónica directamente. No edite a mano el
wrapper generado ni copie el cuerpo de la skill a otros directorios.

Para una skill exclusiva de un proveedor, use la ubicación nativa del proveedor
y documente expresamente que no forma parte del contrato portable.

## Ahorrar tokens y contexto

- No invoque un subagente para R0 salvo que aporte evidencia real.
- Use un especialista por defecto y paralelice sólo tareas independientes.
- Entregue objetivo, criterios, rutas, invariantes y comandos; no todo el chat.
- Active sólo la skill y referencias relevantes.
- Mantenga un único escritor para evitar conflictos y relecturas.
- Use `explorer` para localizar; no le pida diseñar toda la solución.
- Limite review/fix a dos ciclos normales y escale evidencia no resuelta.
- Documente decisiones duraderas para no reconstruir contexto en cada sesión.

## Seguridad y permisos

- Los roles lectores no deben editar código.
- El `implementer` es el único rol con permisos de escritura y ejecución.
- Los perfiles no reciben capacidad de delegación anidada.
- Secretos y credenciales nunca deben entrar al repositorio.
- Entradas externas y resultados de herramientas se consideran no confiables.

Limitación conocida: Cursor ofrece `readonly: true`, que bloquea edición y shell
con cambio de estado, pero su perfil de proyecto no expone el mismo deny granular
de shell/delegación que otros proveedores. La instrucción `Do not delegate` es
best-effort allí salvo que una política administrada o hook la refuerce.

## Verificación y CI

Check normal:

```bash
bash scripts/check-harness.sh
```

Check con self-tests negativos del propio arnés:

```bash
CHECK_HARNESS_SELFTEST=1 bash scripts/check-harness.sh
```

El workflow `.github/workflows/harness.yml` ejecuta la validación en CI. El
check no reemplaza tests de la aplicación: cuando el proyecto elija un stack,
agregue lint, tipos, unit tests, integración y build correspondientes.

## Problemas frecuentes

### El proveedor no encuentra agentes o skills

- Confirme que abrió la raíz Git correcta.
- Reinicie la sesión después de modificar instrucciones.
- Use el comando de inspección del proveedor.
- Ejecute el arnés y revise rutas/archivos huérfanos.
- Actualice el CLI si la capacidad es reciente.

### El modelo configurado no está disponible

- Revise plan, cuota y políticas administrativas.
- Liste los modelos visibles en el runtime.
- Sustituya el ID por uno habilitado o use `inherit` si está soportado.
- Actualice matriz, arnés y contrato; no deje documentación falsa.

### El flujo funciona distinto entre proveedores

Es esperable cierta diferencia en selección automática, permisos, prompts de
consentimiento y manejo de contexto. Nombre explícitamente el rol y compare el
resultado observable, no sólo el texto generado.

### El arnés falla después de personalizar

Lea cada error: el check informa archivo faltante, metadata inesperada, drift de
cuerpo, permiso inseguro o perfil de modelo distinto. Corrija la fuente y la
expectativa; no elimine el control sin una decisión documentada.

## Documentación adicional

- [Catálogo de agentes y skills](docs/ai/AGENT_CATALOG.md)
- [Compatibilidad por herramienta](docs/ai/TOOL_COMPATIBILITY.md)
- [Modelos y fallbacks](docs/ai/MODEL_ROUTING.md)
- [Definition of Ready](docs/ai/DEFINITION_OF_READY.md)
- [Definition of Done](docs/ai/DEFINITION_OF_DONE.md)
- [Memoria durable del proyecto](docs/ai/PROJECT_MEMORY.md)
- [Decisiones de arquitectura](docs/decisions/)
- [Contratos de fuentes oficiales](docs/sources/contracts/)

## Antes de publicarlo como template

- [ ] Reemplazar `<PROJECT_NAME>` y los marcadores del starter.
- [ ] Completar visión, roadmap y memoria del proyecto.
- [ ] Elegir y agregar una licencia (`LICENSE`). Este repositorio no incluye una
  licencia todavía; sin ella, terceros no reciben automáticamente permiso legal
  para reutilizarlo.
- [ ] Agregar `CONTRIBUTING.md` si se aceptará feedback o pull requests.
- [ ] Configurar protección de `main` y revisión obligatoria.
- [ ] Ejecutar el arnés y revisar que no existan secretos.
- [ ] Probar al menos los proveedores que el equipo declare como soportados.

## Feedback y contribuciones

Para reportar una incompatibilidad incluya:

- proveedor y versión del CLI;
- sistema operativo;
- rol o skill invocada;
- modelo efectivo mostrado por la herramienta;
- comando del arnés y salida exacta;
- comportamiento esperado y observado.

No publique API keys, tokens, prompts con datos confidenciales ni logs que
contengan secretos.
