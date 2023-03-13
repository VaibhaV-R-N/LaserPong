local love = require("love")

function Ball()

    return {
        padColP = {1, 1, 1},
        padColC = {1, 1, 1},
        radius = 5,
        x = 720 / 2,
        y = math.random(50, 415),
        color = {1, 1, 1},
        speed = 4,
        score = {
            player = 0,
            cpu = 0
        },
        bounce = love.audio.newSource("sound/bounce.mp3", "static"),

        display = {
            w = love.graphics.getWidth(),
            h = love.graphics.getHeight()
        },

        state = {
            player = {
                contact = false,
                top = false,
                middle = false,
                bottom = false
            },
            cpu = {
                contact = false,
                top = false,
                middle = false,
                bottom = false
            },
            wall = {
                top = false,
                bottom = false
            }
        },

        setFalsePad = function(self, entity, tab)

            for _, v in pairs(tab) do
                self.state[entity][v] = false
            end
        end,

        setFalseWall = function(self, tab)
            for _, v in pairs(tab) do
                self.state.wall[v] = false
            end
        end,

        setEntityContact = function(self, one, two)
            self.state[one].contact = true
            self.state[two].contact = false
        end,

        setWallCollision = function(self)
            if (self.y <= 30) then
                self.state.wall.top = true
                self.state.wall.bottom = false
                self:setFalsePad("player", {"top", "middle", "bottom"})
                self:setFalsePad("cpu", {"top", "middle", "bottom"})

            end
            if (self.y >= self.display.h) then
                self.state.wall.bottom = true
                self.state.wall.top = false
                self:setFalsePad("player", {"top", "middle", "bottom"})
                self:setFalsePad("cpu", {"top", "middle", "bottom"})
            end
        end,

        wallCollisionP = function(self)
            math.randomseed(os.time())

            self:setWallCollision()

            if self.state.wall.top == true and self.state.player.contact == true then
                self.speed = math.random(2, self.speed)
                self.x = self.x + self.speed
                self.y = self.y + self.speed
            elseif self.state.wall.bottom == true and self.state.player.contact == true then
                self.speed = math.random(2, self.speed)
                self.x = self.x + self.speed
                self.y = self.y - self.speed
            end

        end,

        wallCollisionC = function(self)

            math.randomseed(os.time())

            self:setWallCollision()

            if self.state.wall.top == true and self.state.cpu.contact == true then
                self.speed = math.random(2, self.speed)
                self.x = self.x - self.speed
                self.y = self.y + self.speed
            elseif self.state.wall.bottom == true and self.state.cpu.contact == true then
                self.speed = math.random(2, self.speed)
                self.x = self.x - self.speed
                self.y = self.y - self.speed
            end
        end,

        isCol = function(self, tab)
            c = 0
            for _, v in pairs(tab) do
                if v == 1 then
                    c = c + 1
                end
            end
            if c == #tab then
                return true
            end
            return false
        end,

        padCollisonP = function(self, padInfo, parts)
            if not (self.state.player.contact or self.state.cpu.contact) then
                self.x = self.x - self.speed
            end

            -- For Player

            if self.x <= padInfo.x + padInfo.width and self.y >= padInfo.y and self.y <= padInfo.y + padInfo.height then
                if not self.bounce:isPlaying() then
                    love.audio.play(self.bounce)
                end
                if self:isCol(self.padColP) then
                    -- self.padCol = {0.678, 0.847, 0.902}
                    self.padColP = {0, 0, 0}
                end
            else
                self.padColP = {1, 1, 1}
            end

            if (self.x <= padInfo.x + padInfo.width) and (self.y >= parts.top.y) and (self.y <= parts.middle.y) then
                self:setEntityContact("player", "cpu")
                self.state.player.top = true
                self:setFalsePad("player", {"middle", "bottom"})
                self:setFalsePad("cpu", {"middle", "bottom", "top"})
                self:setFalseWall({"top", "bottom"})
            end

            if (self.x <= padInfo.x + padInfo.width) and (self.y > parts.middle.y) and (self.y < parts.bottom.y) then
                self:setEntityContact("player", "cpu")
                self.state.player.middle = true
                self:setFalsePad("player", {"top", "bottom"})
                self:setFalsePad("cpu", {"middle", "bottom", "top"})
                self:setFalseWall({"top", "bottom"})

            end

            if (self.x <= padInfo.x + padInfo.width) and (self.y >= parts.bottom.y) and
                (self.y <= (parts.bottom.y + padInfo.share)) then
                self:setEntityContact("player", "cpu")
                self.state.player.bottom = true
                self:setFalsePad("player", {"middle", "top"})
                self:setFalsePad("cpu", {"middle", "bottom", "top"})
                self:setFalseWall({"top", "bottom"})

            end

            if (self.state.player.contact == true) and (self.state.player.top == true) then
                self.speed = math.random(2, self.speed)
                self.x = self.x + self.speed
                self.speed = math.random(2, self.speed)
                self.y = self.y - self.speed
            elseif (self.state.player.contact == true) and (self.state.player.middle == true) then
                self.speed = math.random(2, self.speed)
                self.x = self.x + self.speed
            elseif (self.state.player.contact == true) and (self.state.player.bottom == true) then
                self.speed = math.random(2, self.speed)
                self.x = self.x + self.speed
                self.speed = math.random(2, self.speed)
                self.y = self.y + self.speed
            end

        end,

        padCollisonC = function(self, padInfo, parts)
            -- For CPU
            if self.x + self.radius >= padInfo.x and self.y >= padInfo.y and self.y <= padInfo.y + padInfo.height then
                if not self.bounce:isPlaying() then
                    love.audio.play(self.bounce)
                end
                if self:isCol(self.padColC) then
                    self.padColC = {0, 0, 0}
                    -- self.padCol = {0.678, 0.847, 0.902}
                end
            else
                self.padColC = {1, 1, 1}
            end

            if (self.x + self.radius >= padInfo.x) and (self.y >= parts.top.y) and (self.y <= parts.middle.y) then
                self:setEntityContact("cpu", "player")
                self.state.cpu.top = true
                self:setFalsePad("cpu", {"middle", "bottom"})
                self:setFalsePad("player", {"top", "middle", "bottom"})
                self:setFalseWall({"top", "bottom"})
            end

            if (self.x + self.radius >= padInfo.x) and (self.y > parts.middle.y) and (self.y < parts.bottom.y) then
                self:setEntityContact("cpu", "player")
                self.state.cpu.middle = true
                self:setFalsePad("cpu", {"top", "bottom"})
                self:setFalsePad("player", {"top", "middle", "bottom"})
                self:setFalseWall({"top", "bottom"})
            end

            if (self.x + self.radius >= padInfo.x) and (self.y >= parts.bottom.y) and
                (self.y <= (parts.bottom.y + padInfo.share)) then
                self:setEntityContact("cpu", "player")
                self.state.cpu.bottom = true
                self:setFalsePad("cpu", {"middle", "top"})
                self:setFalsePad("player", {"top", "middle", "bottom"})
                self:setFalseWall({"top", "bottom"})
            end

            if (self.state.cpu.contact == true) and (self.state.cpu.top == true) then
                self.speed = math.random(2, self.speed)
                self.x = self.x - self.speed
                self.y = self.y - self.speed
            elseif (self.state.cpu.contact == true) and (self.state.cpu.middle == true) then
                self.speed = math.random(2, self.speed)
                self.x = self.x - self.speed
            elseif (self.state.cpu.contact == true) and (self.state.cpu.bottom == true) then
                self.speed = math.random(2, self.speed)
                self.x = self.x - self.speed
                self.y = self.y + self.speed
            end
        end,

        pointsAndGameOver = function(self)
            if self.x <= 0 then
                self.score.player = self.score.player - 5
                self.x = self.display.w / 2
                self.y = math.random(20, 415)
                for _, v in pairs({"player", "cpu"}) do
                    self.state[v].contact = false
                end
            end
            if self.x >= self.display.w then
                self.score.cpu = self.score.cpu - 5
                self.x = self.display.w / 2
                self.y = math.random(20, 415)
                for _, v in pairs({"player", "cpu"}) do
                    self.state[v].contact = false
                end
            end

        end,

        updateP = function(self, padInfo, parts)
            self:padCollisonP(padInfo, parts)
            self:wallCollisionP()
            self:pointsAndGameOver()
        end,

        updateC = function(self, padInfo, parts)
            self:padCollisonC(padInfo, parts)
            self:wallCollisionC()
            self:pointsAndGameOver()
        end,

        draw = function(self)
            love.graphics.setColor(self.color[1], self.color[2], self.color[3])
            love.graphics.rectangle("fill", self.x, self.y, self.radius, self.radius)
        end
    }
end

return Ball
