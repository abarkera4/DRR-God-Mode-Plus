local WriteInfoLogs = false -- Set to true to enable info logging

local function log_info(info_message)
  if WriteInfoLogs then
    log.info("[Chaplain Grimaldus > Infinite Health]: " .. info_message)
  end
end

local hasRunInitially = false
local currentScene = nil

re.on_frame(function()
  local sceneManager = sdk.get_native_singleton("via.SceneManager")
  if not sceneManager then
    log_info("SceneManager not found")
    return
  end

  local scene = sdk.call_native_func(sceneManager, sdk.find_type_definition("via.SceneManager"), "get_CurrentScene")
  if not scene then
    log_info("Current scene not found")
    return
  end


  if currentScene ~= scene then
    hasRunInitially = false
    currentScene = scene
    log_info("Scene has changed, resetting invincibility")
  end

  if not hasRunInitially then
    local playerManager = scene:call("findGameObject(System.String)", "PlayerManager")
    if not playerManager then
      log_info("PlayerManager not found")
      return
    end

    local playerStatusManager = playerManager:call("getComponent(System.Type)",
      sdk.typeof("app.solid.PlayerStatusManager"))
    if not playerStatusManager then
      log_info("PlayerStatusManager not found")
      return
    end

    local playerVitalContr = playerStatusManager:get_field("<PlayerVitalController>k__BackingField")
    if not playerVitalContr then
      log_info("PlayerVitalController not found")
      return
    end

    playerVitalContr:set_Invincible(true)
    hasRunInitially = true
    log_info("Set Invincible")
  end
end)
