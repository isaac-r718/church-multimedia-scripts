obs = obslua
enabled = false

-- Configuración de escenas en el orden exacto solicitado
scenes = {"Cámara Izquierda", "Cámara Arriba", "Cámara Abajo"}

-- Tiempos correspondientes en milisegundos:
-- 30s para Izquierda (30000ms), 30s para Arriba (30000ms), 60s para Abajo (60000ms)
durations = {30000, 30000, 60000}
idx = 1

function rotate_scene()
    if not enabled then return end

    -- Avanzar al siguiente índice de cámara
    idx = idx + 1
    if idx > #scenes then idx = 1 end

    local scene_name = scenes[idx]
    local next_duration = durations[idx]

    -- Ejecutar el cambio de escena en OBS
    local source = obs.obs_get_source_by_name(scene_name)
    if source ~= nil then
        obs.obs_frontend_set_current_scene(source)
        obs.obs_source_release(source)
    end

    -- El truco: Eliminamos el temporizador viejo y creamos uno nuevo 
    -- con los milisegundos específicos de la cámara que acaba de entrar
    obs.timer_remove(rotate_scene)
    obs.timer_add(rotate_scene, next_duration)
end

function script_update(settings)
    enabled = obs.obs_data_get_bool(settings, "enabled")
    obs.timer_remove(rotate_scene)
    
    if enabled then
        idx = 1 -- Forzar a empezar siempre con la Cámara Izquierda
        local source = obs.obs_get_source_by_name(scenes[idx])
        if source ~= nil then
            obs.obs_frontend_set_current_scene(source)
            obs.obs_source_release(source)
        end
        -- Programar el primer salto usando el tiempo de la primera escena (30 segundos)
        obs.timer_add(rotate_scene, durations[idx])
    end
end

function script_properties()
    local props = obs.obs_properties_create()
    obs.obs_properties_add_bool(props, "enabled", "Activar Bucle Pro (30s Izq / 30s Arriba / 1m Abajo)")
    return props
end