obs = obslua

-- Variables globales
active_mode = 0 -- 0=OFF, 1=NUM7, 2=NUM8, 3=NUM9
scene_idx = 1
scenes = {"Cámara Izquierda", "Cámara Arriba", "Cámara Abajo"}

-- Motor de Transición: Busca el efecto por su ID de fábrica y le asigna el tiempo
function set_transition(type_id, duration)
    local transitions = obs.obs_frontend_get_transitions()
    local target = nil
    
    -- Escanear la lista interna de OBS para encontrar el Cut o Fade real
    for _, t in ipairs(transitions) do
        local id = obs.obs_source_get_id(t)
        if id == type_id then
            target = t
            break
        end
    end
    
    if target ~= nil then
        obs.obs_frontend_set_current_transition(target)
        if type_id == "fade_transition" then
            obs.obs_frontend_set_current_transition_duration(duration)
        end
    end
    
    obs.source_list_release(transitions)
end

-- Motor de Cambio de Escena: Ejecuta la cámara al aire
function switch_scene()
    local next_scene_name = scenes[scene_idx]
    local source = obs.obs_get_source_by_name(next_scene_name)
    if source ~= nil then
        obs.obs_frontend_set_current_scene(source)
        obs.obs_source_release(source)
    end
end

-- El Bucle Principal: Matemáticas de tiempo exactas
function timer_loop()
    if active_mode == 0 then return end
    
    -- Avanzar a la siguiente cámara
    scene_idx = scene_idx + 1
    if scene_idx > #scenes then scene_idx = 1 end
    
    local timer_ms = 1000
    
    if active_mode == 1 then
        -- NUM7: Solo Cut (0ms) + 1 segundo de espera fija
        set_transition("cut_transition", 0)
        switch_scene()
        timer_ms = 1000
        
    elseif active_mode == 2 then
        -- NUM8: Fade de 1s + 4 segundos de espera fija
        set_transition("fade_transition", 1000)
        switch_scene()
        timer_ms = 5000 -- (1000ms de Fade + 4000ms de espera)
        
    elseif active_mode == 3 then
        -- NUM9: Fade de 4s + Tiempos largos variables
        set_transition("fade_transition", 4000)
        switch_scene()
        
        -- Los tiempos incluyen los 4000ms de transición + el tiempo estático deseado
        if scene_idx == 1 then
            timer_ms = 34000 -- 4s Fade + 30s Izquierda
        elseif scene_idx == 2 then
            timer_ms = 34000 -- 4s Fade + 30s Arriba
        elseif scene_idx == 3 then
            timer_ms = 64000 -- 4s Fade + 60s Abajo
        end
    end
    
    -- Resetear el temporizador con el tiempo calculado
    obs.timer_remove(timer_loop)
    obs.timer_add(timer_loop, timer_ms)
end

-- Iniciador y Controlador de Modos
function start_mode(m)
    if active_mode == m then
        -- Si vuelves a apretar el mismo botón, se apaga
        active_mode = 0
        obs.timer_remove(timer_loop)
    else
        -- Encender un modo nuevo
        active_mode = m
        scene_idx = 1 -- Fuerza a empezar siempre por la Cámara Izquierda
        obs.timer_remove(timer_loop)
        
        local timer_ms = 1000
        
        -- Ejecutar la primera acción al instante
        if active_mode == 1 then
            set_transition("cut_transition", 0)
            switch_scene()
            timer_ms = 1000
        elseif active_mode == 2 then
            set_transition("fade_transition", 1000)
            switch_scene()
            timer_ms = 5000
        elseif active_mode == 3 then
            set_transition("fade_transition", 4000)
            switch_scene()
            timer_ms = 34000 -- Primera cámara (Izquierda): 4s Fade + 30s fija
        end
        
        obs.timer_add(timer_loop, timer_ms)
    end
end

-- Cargar en OBS y registrar Hotkeys
function script_load(settings)
    obs.obs_hotkey_register_frontend("hk_7", "Bucle 7: Cut + 1s espera", function(p) if p then start_mode(1) end end)
    obs.obs_hotkey_register_frontend("hk_8", "Bucle 8: 1s Fade + 4s espera", function(p) if p then start_mode(2) end end)
    obs.obs_hotkey_register_frontend("hk_9", "Bucle 9: 4s Fade + 30/30/60s espera", function(p) if p then start_mode(3) end end)
end