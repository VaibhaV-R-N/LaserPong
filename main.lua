local love = require("love")
local states = require("State")
local pad = require("Pad")
local ball = require("Ball")
local ammo = require("Ammo")
local healthBar = require("HealthBar")

function love.load()
    theme = love.audio.newSource("sound/theme.mp3", "stream")
    theme:setVolume(0.9)
    final = love.audio.newSource("sound/final.mp3", "stream")
    final:setVolume(0.3)
    love.graphics.setBackgroundColor(0, 0, 0)
    padP = pad(20, 210, 10, 60)
    padC = pad(690, 210, 10, 60)
    bolu = ball()
    score = {
        player = 100,
        cpu = 100
    }
    state = {
        running = false,
        paused = false,
        mainMenu = true,
        gameOver = false
    }
    control = "cpu"
    playerAmmo = ammo(padP.padInfo.x + padP.padInfo.width, padP.padInfo.y + 9, padP.padInfo.x + padP.padInfo.width,
        padP.padInfo.y + padP.padInfo.height - 12, padC.padInfo.x + 10)
    cpuAmmo = ammo(padC.padInfo.x - padC.padInfo.width, padC.padInfo.y + 9, padC.padInfo.x - padP.padInfo.width,
        padC.padInfo.y + padC.padInfo.height - 12, padP.padInfo.x)

    healthBars = healthBar(score)
    State = states()
end

function checkGameOver()

    if score.player < 1 or score.cpu < 1 then
        state.gameOver = true
        state.running = false
        if score.player > score.cpu then
            return "player"
        end
        return control == "cpu" and "cpu" or "player2"
    end

end

function init()
    padP = pad(20, 210, 10, 60)
    padC = pad(690, 210, 10, 60)
    bolu = ball()
    score = {
        player = 100,
        cpu = 100
    }
    playerAmmo = ammo(padP.padInfo.x + padP.padInfo.width, padP.padInfo.y + 9, padP.padInfo.x + padP.padInfo.width,
        padP.padInfo.y + padP.padInfo.height - 12, padC.padInfo.x + 10)
    cpuAmmo = ammo(padC.padInfo.x - padC.padInfo.width, padC.padInfo.y + 9, padC.padInfo.x - padP.padInfo.width,
        padC.padInfo.y + padC.padInfo.height - 12, padP.padInfo.x)

    healthBars = healthBar(score)

end
function love.update(dt)
    if not theme:isPlaying() then
        love.audio.play(theme)
    end
    if state.running == true then
        theme:setVolume(0.2)
        padP:updateP()
        padC:updateC(bolu.y, control)

        bolu:updateP(padP.padInfo, padP.parts)
        bolu:updateC(padC.padInfo, padC.parts)

        if (score.player < 50 or score.cpu < 50) then
            love.audio.pause(theme)
            if not final:isPlaying() then
                love.audio.play(final)
            end
            playerAmmo:updateCo(padP.padInfo.x + padP.padInfo.width, padP.padInfo.y + 9,
                padP.padInfo.x + padP.padInfo.width, padP.padInfo.y + padP.padInfo.height - 12)
            cpuAmmo:updateCo(padC.padInfo.x - padC.padInfo.width, padC.padInfo.y + 9,
                padC.padInfo.x - padP.padInfo.width, padC.padInfo.y + padC.padInfo.height - 12)

            playerAmmo:updateP(padC.padInfo.x, padC.padInfo.y, padC.padInfo.height)
            cpuAmmo:updateC(padP.padInfo.x + padP.padInfo.width, padP.padInfo.y, padP.padInfo.height)
            padP:setwc(playerAmmo.weaponColor)
            padC:setwc(cpuAmmo.weaponColor)
            padP:setPadC(playerAmmo.padC)
            padC:setPadC(cpuAmmo.padC)

        end

        padP:setPadC(bolu.padColP)
        padC:setPadC(bolu.padColC)

        score.player = 100 + (cpuAmmo.score.player + bolu.score.player)
        score.cpu = 100 + (playerAmmo.score.cpu + bolu.score.cpu)
        healthBars:update(score)
        checkGameOver()
    end

    if state.mainMenu == true then
        love.audio.pause(final)
        theme:setVolume(0.9)
        if not theme:isPlaying() then
            love.audio.play(theme)
        end
    end

    if state.paused == true then
        love.audio.pause(theme)
        love.audio.pause(final)
    end

    if state.gameOver == true then
        love.audio.pause(theme)
        love.audio.pause(final)
    end

end

function love.mousepressed(x, y, button_, istouch)
    if button_ == 1 then
        if state.mainMenu == true then
            s, c = State:oneVsoneF(x, y)
            if s ~= nil and c ~= nil then
                state = s
                control = c
            end

            s, c = State:oneVscpuF(x, y)
            if s ~= nil and c ~= nil then
                state = s
                control = c
            end

            State:exitF(x, y)
        end

        if state.paused == true then
            s = State:resumeF(x, y)
            if s ~= nil then
                state = s
            end

            s, c = State:restartF(x, y, control, "two")
            if s ~= nil and c ~= nil then
                init()
                state = s

                control = c
            end

            s = State:mainMenuF(x, y, "three")
            if s ~= nill then
                init()
                state = s
            end

        end

        if state.gameOver == true then
            s, c = State:restartF(x, y, control, "one")
            if s ~= nil and c ~= nil then
                init()
                state = s

                control = c
            end

            s = State:mainMenuF(x, y, "two")
            if s ~= nill then
                init()
                state = s
            end
        end
    end
end

function love.keypressed(key)
    if key == "p" then
        state = {
            running = false,
            paused = true,
            mainMenu = false,
            gameOver = false
        }
    end
end

function love.draw()
    if state.running == true then
        padP:draw()
        padC:draw()

        if (score.player < 50 or score.cpu < 50) then
            padP:drawWeapon(padP.padInfo.x + padP.padInfo.width, padP.padInfo.y + 7,
                padP.padInfo.x + padP.padInfo.width, padP.padInfo.y + padP.padInfo.height - 10)

            padC:drawWeapon(padC.padInfo.x - padC.padInfo.width, padC.padInfo.y + 7,
                padC.padInfo.x - padP.padInfo.width, padC.padInfo.y + padC.padInfo.height - 10)
            playerAmmo:playerGunDraw()
            cpuAmmo:cpuGunDraw()
        end

        bolu:draw()

        healthBars:draw()
    end

    if state.mainMenu == true then
        State:mainMenuDraw()
    end

    if state.paused == true then
        State:pauseMenuDraw()
    end

    if state.gameOver == true then
        State:gameOverDraw(checkGameOver())
    end

end
