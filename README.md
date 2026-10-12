# Church Multimedia Scripts

> Colección de scripts en Lua y herramientas experimentales de automatización para OBS Studio y flujos de trabajo multimedia en transmisión de servicios religiosos, mediante **desarrollo asistido por IA** (Claude code & Gemini). *(Collection of automation scripts and tools for OBS Studio and live-streaming workflows).*

---

## ⚠️ Advertencia y Descargo de Responsabilidad

Estos scripts son **herramientas de prueba, snippets y utilidades personales** desarrolladas para experimentos específicos dentro de OBS Studio. 
* Pueden estar en desarrollo o requerir ajustes según la versión de OBS y tu configuración de escenas.
* Se comparten *tal cual* ("as is") como referencia de código o para uso en pruebas.

---

## 🛠️ Contenido del Repositorio

A continuación se detallan los scripts en Lua disponibles en esta colección:

| Archivo | Descripción |
|---|---|
| `Bucle_Predica.lua` / `Prédica Bucle.lua` | Automatización de bucles de video o escenas específicas para la prédica. |
| `Bucle_Rapido_NUM7.lua` | Variación/preset de bucle rápido en escena o fuente vinculada a numpad/tecla 7. |
| `Bucle_Rapido_NUM8.lua` | Variación/preset de bucle rápido para numpad/tecla 8. |
| `Bucle_Rapido_NUM9.lua` | Variación/preset de bucle rápido para numpad/tecla 9. |
| `Transición Prédica.lua` | Lógica para transiciones automáticas o guiadas hacia la escena de la prédica. |
| `bucle.lua` / `bucle_lento.lua` | Control de repetición y velocidad de reproducción de fuentes multimedia. |
| `playlist_inteligente.lua` | Manejo y lógica de reproducción de listas de contenido dentro de OBS. |

---

## 🚀 Requisitos e Instalación en OBS Studio

1. **Requisitos:**
   - OBS Studio (versión 28.0 o superior recomendada).
   - Soporte nativo de Lua activo en OBS Studio.

2. **Cómo cargar un script en OBS Studio:**
   - Abre OBS Studio.
   - Ve al menú superior: **Tools** > **Scripts** (o *Herramientas* > *Scripts*).
   - En la pestaña *Scripts*, haz clic en el botón **`+`** (abajo a la izquierda).
   - Selecciona el archivo `.lua` que deseas utilizar desde tu carpeta local.
   - Ajusta las propiedades del script en el panel derecho si aplica.

---

## 🔗 Proyecto Relacionado

Este repositorio complementa el ecosistema de herramientas de automatización locales de la iglesia:
* [church-control](https://github.com/isaac-r718/church-control): Sistema web de control remoto para reproductor de audio, timer de prédica y apagado del servidor local.

---

## 📝 Licencia

[MIT](LICENSE) © 2026 Isaac Ríos
