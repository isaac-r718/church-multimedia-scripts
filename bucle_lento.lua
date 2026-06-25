obs = obslua
enabled = false
scenes = {"Cámara Arriba", "Cámara Abajo", "Cámara Izquierda"}
idx = 1

function rotate_scene()
    if not enabled then return end
    idx = idx + 1
    if idx > #scenes then idx = 1 end
    local source = obs.obs_get_source_by_name(scenes[idx])
    if source ~= nil then
        obs.obs_frontend_set_current_scene(source)
        obs.obs_source_release(source)
    end
end

function script_update(settings)
    enabled = obs.obs_data_get_bool(settings, "enabled")
    obs.timer_remove(rotate_scene)
    if enabled then
        -- 5000 ms = 5 segundos en total entre cada cambio de escena
        -- (4 segundos fija + 1 segundo de transición de Fade)
        obs.timer_add(rotate_scene, 5000) 
    end
end

function script_properties()
    local props = obs.obs_properties_create()
    obs.obs_properties_add_bool(props, "enabled", "Activar Bucle Lento (4s + 1s Fade)")
    return props
end