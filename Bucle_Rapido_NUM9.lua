obs = obslua
enabled = false
scene_idx = 0
scenes = {"Cámara Izquierda", "Cámara Arriba", "Cámara Abajo"}

function timer_loop()
    if not enabled then return end
    scene_idx = scene_idx + 1
    if scene_idx > #scenes then scene_idx = 1 end

    local transitions = obs.obs_frontend_get_transitions()
    for _, tr in ipairs(transitions) do
        if obs.obs_source_get_id(tr) == "fade_transition" then
            obs.obs_frontend_set_current_transition(tr)
            break
        end
    end
    obs.source_list_release(transitions)
    
    -- Corrección de la API de OBS aplicada aquí
    obs.obs_frontend_set_transition_duration(4000)

    local s = obs.obs_get_source_by_name(scenes[scene_idx])
    if s then
        obs.obs_frontend_set_current_scene(s)
        obs.obs_source_release(s)
    end

    obs.timer_remove(timer_loop)
    
    -- Tiempos de espera variables (Tiempo en pantalla + 4000ms de Fade)
    if scene_idx == 1 then obs.timer_add(timer_loop, 34000)
    elseif scene_idx == 2 then obs.timer_add(timer_loop, 34000)
    elseif scene_idx == 3 then obs.timer_add(timer_loop, 64000) end
end

function toggle_script(state)
    enabled = state
    obs.timer_remove(timer_loop)
    if enabled then
        scene_idx = 0
        timer_loop()
    end
end

function script_load(settings)
    obs.obs_hotkey_register_frontend("hk_sep_9", "Activar Bucle 9", function(p) if p then toggle_script(not enabled) end end)
end