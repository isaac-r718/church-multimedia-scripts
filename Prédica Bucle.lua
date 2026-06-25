local obs = obslua

-- Nombres de tus escenas de cámaras
local scene_atras = "Cámara Abajo"
local scene_izq = "Cámara Izquierda"
local scene_arriba = "Cámara Arriba"

-- Nombres del indicador visual local indicator_on = "[ 🟢 ON ]   Transición Prédica" local indicator_off = "[ 🔴 OFF ]  Transición Prédica"

local is_running = false
local step = 0
local hotkey_id = obs.OBS_INVALID_HOTKEY_ID

-- Función para cambiar el nombre de la escena indicadora
function update_indicator(active)
-- Busca la escena sin importar si está en ON o en OFF actualmente
local source = obs.obs_get_source_by_name(indicator_on)
if not source then
source = obs.obs_get_source_by_name(indicator_off)
end

if source then
    if active then
        obs.obs_source_set_name(source, indicator_on)
    else
        obs.obs_source_set_name(source, indicator_off)
    end
    obs.obs_source_release(source)
end


end

-- Función para cambiar de cámara
function switch_scene(scene_name)
local source = obs.obs_get_source_by_name(scene_name)
if source ~= nil then
obs.obs_frontend_set_current_scene(source)
obs.obs_source_release(source)
else
print("Error: No se encontró la escena '" .. scene_name .. "'")
end
end

-- Lógica del bucle
function sequence_step()
if not is_running then return end

obs.timer_remove(sequence_step)

if step == 0 then
    switch_scene(scene_atras)
    obs.timer_add(sequence_step, 64000)
    step = 1
elseif step == 1 then
    switch_scene(scene_izq)
    obs.timer_add(sequence_step, 34000)
    step = 2
elseif step == 2 then
    switch_scene(scene_arriba)
    obs.timer_add(sequence_step, 34000)
    step = 0
end


end

function start_sequence()
if not is_running then
is_running = true
step = 0
update_indicator(true)
sequence_step()
print("Loop started")
end
return true
end

function stop_sequence()
if is_running then
is_running = false
update_indicator(false)
obs.timer_remove(sequence_step)
print("Loop stopped")
end
return true
end

-- Función que se ejecuta al presionar el Hotkey
function toggle_sequence(pressed)
if not pressed then return end
if is_running then
stop_sequence()
else
start_sequence()
end
end

-- Botones para la interfaz del script
function btn_start(props, p) start_sequence(); return true end
function btn_stop(props, p) stop_sequence(); return true end

function script_properties()
local props = obs.obs_properties_create()
obs.obs_properties_add_button(props, "start_btn", "Start Loop", btn_start)
obs.obs_properties_add_button(props, "stop_btn", "Stop Loop", btn_stop)
return props
end

-- Guardado y carga del Hotkey en OBS
function script_load(settings)
hotkey_id = obs.obs_hotkey_register_frontend("toggle_auto_cam", "Start/Stop Auto Camera Loop", toggle_sequence)
local hotkey_save_array = obs.obs_data_get_array(settings, "toggle_auto_cam")
obs.obs_hotkey_load(hotkey_id, hotkey_save_array)
obs.obs_data_array_release(hotkey_save_array)
end

function script_save(settings)
local hotkey_save_array = obs.obs_hotkey_save(hotkey_id)
obs.obs_data_set_array(settings, "toggle_auto_cam", hotkey_save_array)
obs.obs_data_array_release(hotkey_save_array)
end