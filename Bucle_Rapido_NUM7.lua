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
        if obs.obs_source_get_id(tr) == "cut_transition" then
            obs.obs_frontend_set_current_transition(tr)
            break
        end
    end
    obs.source_list_release(transitions)

    local s = obs.obs_get_source_by_name(scenes[scene_idx])
    if s then
        obs.obs_frontend_set_current_scene(s)
        obs.obs_source_release(s)
    end
end

function toggle_script(state)
    enabled = state
    obs.timer_remove(timer_loop)
    if enabled then
        scene_idx = 0
        timer_loop() 
        obs.timer_add(timer_loop, 1000)
    end
end

function script_load(settings)
    obs.obs_hotkey_register_frontend("hk_sep_7", "Activar Bucle 7", function(p) if p then toggle_script(not enabled) end end)
end