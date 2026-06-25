local obs = obslua

-- Nombres exactos de tus escenas en OBS
local scene_atras = "Cámara Abajo" 
local scene_izq = "Cámara Izquierda"
local scene_arriba = "Cámara Arriba"

local is_running = false
local step = 0

function switch_scene(scene_name)
    local source = obs.obs_get_source_by_name(scene_name)
    if source ~= nil then
        obs.obs_frontend_set_current_scene(source)
        obs.obs_source_release(source)
    else
        print("Error: No se encontró la escena '" .. scene_name .. "'")
    end
end

function sequence_step()
    if not is_running then
        return
    end

    -- Limpiamos el timer anterior
    obs.timer_remove(sequence_step)

    if step == 0 then
        switch_scene(scene_atras)
        -- 4000ms de transición + 60000ms de espera en la escena
        obs.timer_add(sequence_step, 64000)
        step = 1
        
    elseif step == 1 then
        switch_scene(scene_izq)
        -- 4000ms de transición + 30000ms de espera en la escena
        obs.timer_add(sequence_step, 34000)
        step = 2
        
    elseif step == 2 then
        switch_scene(scene_arriba)
        -- 4000ms de transición + 30000ms de espera en la escena
        obs.timer_add(sequence_step, 34000)
        step = 0
    end
end

function start_sequence(props, p)
    if not is_running then
        is_running = true
        step = 0
        sequence_step()
        print("Loop started")
    end
    return true
end

function stop_sequence(props, p)
    is_running = false
    obs.timer_remove(sequence_step)
    print("Loop stopped")
    return true
end

function script_properties()
    local props = obs.obs_properties_create()
    obs.obs_properties_add_button(props, "start_btn", "Start Loop", start_sequence)
    obs.obs_properties_add_button(props, "stop_btn", "Stop Loop", stop_sequence)
    return props
end