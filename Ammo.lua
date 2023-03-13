local love = require("love")

function Bullet(x, y)
    return {
        x = x,
        y = y,
        speed = 3,

        draw = function(self)
            love.graphics.setColor(1, 0, 0)
            love.graphics.rectangle("fill", self.x, self.y, 5, 2)
        end,
        checkP = function(self, padCX)
            if self.x > padCX then
                return true
            end
            return false
        end,
        checkC = function(self, padPX)
            if self.x < padPX then
                return true
            end
            return false
        end,
        updateP = function(self, padCX)
            if self.x <= padCX then
                self.x = self.x + 2
            end
        end,

        updateC = function(self, padPX)
            if self.x >= padPX + 10 then
                self.x = self.x - 2
            end
        end
    }
end

function Gun(x1, y1, x2, y2, padX)
    return {
        x1 = x1,
        y1 = y1,
        x2 = x2,
        y2 = y2,
        fire = love.audio.newSource("sound/fire.mp3", "static"),
        padX = padX,
        padC = {1, 1, 1},

        weaponColor = {0, 0, 0},
        score = {
            player = 0,
            cpu = 0
        },
        player = {
            top = {},
            bottom = {}
        },
        cpu = {
            top = {},
            bottom = {}
        },

        isCol = function(self, tab)
            c = 0
            col = {0.698, 0.749, 0.71}
            for i, v in pairs(tab) do
                if v == col[i] then
                    c = c + 1
                end
            end
            if c == #tab then
                return true
            end
            return false
        end,

        loadBullet = function(self, entity)
            if #self[entity].top < 1 then
                table.insert(self[entity].top, Bullet(self.x1, self.y1))
                table.insert(self[entity].bottom, Bullet(self.x2, self.y2))
            end

            local count = 0
            for _, v in pairs(self[entity]) do
                for _, b in pairs(v) do
                    if entity == "player" then
                        if b.x > 200 then
                            count = count + 1
                        end
                    elseif entity == "cpu" then
                        if b.x < 510 then
                            count = count + 1
                        end

                    end

                end
                break
            end
            if count == #self[entity].top then
                self.fire:setVolume(0.1)
                if not self.fire:isPlaying() then
                    love.audio.play(self.fire)
                end
                table.insert(self[entity].top, Bullet(self.x1, self.y1))
                table.insert(self[entity].bottom, Bullet(self.x2, self.y2))
                if self:isCol(self.weaponColor) then
                    self.weaponColor = {1, 1, 0}
                else
                    self.weaponColor = {0.698, 0.749, 0.71}
                end
            end
        end,

        emptyMag = function(self, entity)
            if entity == "player" then

                for _, b in pairs(self[entity].top) do
                    if b.x > self.padX then
                        for i = 1, #self[entity].top do
                            if self[entity].top[i] == b then
                                table.remove(self[entity].top, i)
                                table.remove(self[entity].bottom, i)

                            end
                        end
                    end
                end
            elseif entity == "cpu" then

                for _, b in pairs(self[entity].top) do

                    if b.x < self.padX + 9 then
                        for i = 1, #self[entity].top do
                            if self[entity].top[i] == b then
                                table.remove(self[entity].top, i)
                                table.remove(self[entity].bottom, i)

                            end
                        end
                    end
                end
            end

        end,

        playerGunDraw = function(self)
            for _, v in pairs(self.player) do
                for _, b in pairs(v) do
                    if not b:checkP(self.padX) then
                        b:draw()
                    end

                end
            end
        end,

        cpuGunDraw = function(self)
            for _, v in pairs(self.cpu) do
                for _, b in pairs(v) do
                    if not b:checkC(self.padX) then
                        b:draw()
                    end

                end
            end
        end,

        playerShootBullets = function(self)
            for _, v in pairs(self.player) do
                for _, b in pairs(v) do
                    b:updateP(self.padX)
                end
            end
        end,

        cpuShootBullets = function(self)
            for _, v in pairs(self.cpu) do
                for _, b in pairs(v) do
                    b:updateC(self.padX)
                end
            end
        end,

        isWhite = function(self, tab)
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

        countScoreP = function(self, padX, padY, height)
            for _, v in pairs(self.player) do
                for _, b in pairs(v) do
                    if (b.x >= padX) and (b.y >= padY) and (b.y <= padY + height) then
                        self.score.cpu = self.score.cpu - 0.5
                        if self:isWhite(self.padC) then
                            self.padC = {1, 0, 0}
                        end
                    else
                        self.padC = {1, 1, 1}
                    end
                end
            end
        end,

        countScoreC = function(self, padX, padY, height)
            for _, v in pairs(self.cpu) do
                for _, b in pairs(v) do
                    if (b.x <= padX) and (b.y >= padY) and (b.y <= padY + height) then
                        self.score.player = self.score.player - 0.5
                        if self:isWhite(self.padC) then
                            self.padC = {1, 0, 0}
                        end
                    else
                        self.padC = {1, 1, 1}
                    end
                end
            end
        end,

        updateP = function(self, padX, padY, height)
            self:loadBullet("player")
            self:emptyMag("player")
            self:playerShootBullets()
            self:countScoreP(padX, padY, height)
        end,

        updateCo = function(self, x1, y1, x2, y2)
            self.x1 = x1
            self.y1 = y1
            self.x2 = x2
            self.y2 = y2
        end,

        updateC = function(self, padX, padY, height)
            self:loadBullet("cpu")
            self:emptyMag("cpu")
            self:cpuShootBullets()
            self:countScoreC(padX, padY, height)
        end
    }
end

return Gun
