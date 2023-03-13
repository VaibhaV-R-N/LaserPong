local love = require("love")

function healthBar(score)
    return {
        score = score,

        height = 10,
        barP = {
            x = 10,
            y = 10
        },
        barC = {
            x = love.graphics.getWidth() - 10,
            y = 10
        },

        draw = function(self)
            love.graphics.setColor(0, 1, 0)
            if (self.score.player >= 0) and (self.score.cpu >= 0) then
                if self.score.player < 50 then
                    love.graphics.setColor(1, 0, 0)
                end
                love.graphics.rectangle("fill", self.barP.x, self.barP.y, self.score.player, self.height)
                if self.score.cpu < 50 then
                    love.graphics.setColor(1, 0, 0)
                else
                    love.graphics.setColor(0, 1, 0)
                end

                love.graphics.rectangle("fill", self.barC.x, self.barC.y, -self.score.cpu, self.height)

                love.graphics.setColor(1, 1, 1)
                love.graphics.print(math.floor(self.score.player) .. " : " .. math.floor(self.score.cpu),
                    (love.graphics.getWidth() / 2) - 30, 10)
            end

        end,

        update = function(self, score)
            self.score = score
        end
    }
end

return healthBar
