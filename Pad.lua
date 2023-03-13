local love = require("love")

function Pad(x, y, w, h, share)
    share = share or h / 3
    return {

        display = {
            w = love.graphics.getWidth(),
            h = love.graphics.getHeight()
        },
        padInfo = {
            width = w or 10,
            height = h or 60,
            x = x or 20,
            y = y or 210,
            share = share
        },

        parts = {
            top = {
                x = x,
                y = y
            },
            middle = {
                x = x,
                y = y + share
            },
            bottom = {
                x = x,
                y = y + (2 * share)
            }
        },

        wc = {0, 0, 0},
        padC = {1, 1, 1},
        speed = 2,

        draw = function(self)
            love.graphics.setColor(self.padC[1], self.padC[2], self.padC[3])
            love.graphics.rectangle("fill", self.padInfo.x, self.padInfo.y, self.padInfo.width, self.padInfo.height)
        end,

        drawWeapon = function(self, x1, y1, x2, y2)

            love.graphics.setColor(self.wc[1], self.wc[2], self.wc[3])
            love.graphics.rectangle("fill", x1, y1, 8, 4)
            love.graphics.rectangle("fill", x2, y2, 8, 4)
        end,

        keyActionP1 = function(self)
            if love.keyboard.isDown("s") then
                if self.padInfo.y + self.padInfo.height < self.display.h then
                    self.padInfo.y = self.padInfo.y + self.speed
                    self:updateParts()
                end
            elseif love.keyboard.isDown("w") then
                if self.padInfo.y > 30 then
                    self.padInfo.y = self.padInfo.y - self.speed
                    self:updateParts()
                end
            end
        end,

        keyActionP2 = function(self)
            if love.keyboard.isDown("down") then
                if self.padInfo.y + self.padInfo.height < self.display.h then
                    self.padInfo.y = self.padInfo.y + self.speed
                    self:updateParts()
                end
            elseif love.keyboard.isDown("up") then
                if self.padInfo.y > 30 then
                    self.padInfo.y = self.padInfo.y - self.speed
                    self:updateParts()
                end
            end
        end,

        setwc = function(self, tab)
            self.wc = tab
        end,

        setPadC = function(self, tab)
            self.padC = tab
        end,

        cpuAutoAction = function(self, ballY)
            if (self.padInfo.y - ballY) <= 0 and (self.padInfo.y + self.padInfo.height) < self.display.h then
                self.padInfo.y = self.padInfo.y + self.speed
            elseif (self.padInfo.y + self.padInfo.height - ballY) >= 0 and (self.padInfo.y) > 30 then
                self.padInfo.y = self.padInfo.y - self.speed
            end
            self:updateParts()
        end,

        updateParts = function(self)
            self.parts.top.x = self.padInfo.x
            self.parts.top.y = self.padInfo.y

            self.parts.middle.x = self.padInfo.x
            self.parts.middle.y = self.padInfo.y + self.padInfo.share

            self.parts.bottom.x = self.padInfo.x
            self.parts.bottom.y = self.padInfo.y + (2 * self.padInfo.share)

        end,

        updateP = function(self)
            self:keyActionP1()

        end,
        updateC = function(self, ballY, control)
            if control == "player" then
                self:keyActionP2()
                return
            end
            self:cpuAutoAction(ballY)

        end

    }
end

return Pad
