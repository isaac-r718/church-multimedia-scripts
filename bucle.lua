obs = obslua
enabled = false
scenes = {"Cámara Arriba", "Cámara Abajo", "Cam Celular"}
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
        obs.timer_add(rotate_scene, 2000) -- 2000 ms = 2 segundos
    end
end

function script_properties()
    local props = obs.obs_properties_create()
    obs.obs_properties_add_bool(props, "enabled", "Activar Bucle de Cámaras")
    return props
end