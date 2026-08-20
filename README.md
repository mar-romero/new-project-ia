# Starter de proyecto

## Resultado

Este directorio es una base para crear un repositorio nuevo con proceso de
trabajo, plantillas, controles de calidad y configuración de agentes. No
incluye una aplicación, una pila tecnológica ni dependencias de ejecución.

## Inicio rápido

1. Mueva o renombre `new-project` al nombre definitivo del repositorio.
2. Ejecute `git init`, cree el repositorio remoto y proteja `main` cuando
   corresponda.
3. Reemplace los marcadores `<PROJECT_NAME>` y complete
   `docs/product/PRODUCT_VISION.md`, `docs/product/ROADMAP.md` y
   `docs/ai/PROJECT_MEMORY.md`.
4. Ajuste `AGENTS.md` al dominio, los riesgos y las restricciones reales.
5. Seleccione la pila técnica mediante una tarea y, si la decisión tiene coste
   de cambio relevante, un ADR. Solo entonces agregue código, dependencias y
   comprobaciones de aplicación.
6. Ejecute `bash scripts/check-harness.sh` para comprobar la estructura base.

## Qué entrega

- Reglas de colaboración, riesgo, seguridad y revisión independiente.
- Plantillas para tareas, especificaciones, ADRs, contratos de fuentes y
  reportes de revisión.
- Una comprobación de estructura en CI que no necesita una pila técnica.
- Roles y habilidades de Codex de propósito general.

## Personalización por tipo de proyecto

| Tipo | Modifique primero | Añada o adapte |
|---|---|---|
| Web / API | Visión, modelo de amenazas, contrato de API y estrategia de integración | Pila frontend/backend, lint, tipos, tests de API y despliegue |
| Datos / ETL | Contratos de fuentes, semántica temporal, calidad y retención | Validación de esquemas, deduplicación, reintentos y un revisor de calidad de datos |
| IA | Objetivo de evaluación, conjuntos de prueba, métricas y reproducibilidad | Política de modelos, semillas, controles de fuga de datos y revisión de sesgos |
| Financiero / cuantitativo | Supuestos de unidades, precisión, tiempo, costes y riesgos | Especialistas de datos/cuantitativos, tests de simulación y gates humanos adicionales |

## Límites intencionados

Las reglas de esta base son genéricas. No copie políticas especializadas de
otro producto sin revisar que sus invariantes, requisitos legales y controles
de seguridad se apliquen al nuevo dominio.

new-project/
├── AGENTS.md                       ← reglas e identidad del proyecto
├── docs/
│   ├── product/
│   │   ├── PRODUCT_VISION.md       ← qué hace tu SaaS
│   │   └── ROADMAP.md              ← fases: reservas, clientes, pagos, etc.
│   └── ai/
│       └── PROJECT_MEMORY.md       ← decisiones duraderas: stack, módulos, límites
├── tasks/
│   ├── backlog/                    ← ideas futuras
│   ├── current/                    ← tarea en curso
│   └── templates/TASK.md           ← plantilla para crear tareas
├── .codex/
│   ├── config.toml                 ← configuración general de agentes
│   └── agents/                     ← definición de cada rol de agente
└── .agents/
    └── skills/                     ← instrucciones reutilizables para flujos concretos