local love = require("love")

function state()
    return {
        button = {
            w = 100,
            h = 40
        },
        one = {
            x = 315,
            y = 200
        },
        two = {
            x = 315,
            y = 250
        },
        three = {
            x = 315,
            y = 300
        },

        mainMenuDraw = function(self)
            -- 1vs1
            love.graphics.setColor(0, 1, 0)
            love.graphics.rectangle("fill", self.one.x, self.one.y, self.button.w, self.button.h)
            love.graphics.setColor(0, 0, 0)
            love.graphics.print("1 Vs 1", self.one.x + 30, self.one.y + 15)

            -- 1vsCpu
            love.graphics.setColor(0, 1, 0)
            love.graphics.rectangle("fill", self.two.x, self.two.y, self.button.w, self.button.h)
            love.graphics.setColor(0, 0, 0)
            love.graphics.print("1 Vs CPU", self.two.x + 30, self.two.y + 15)

            -- exit
            love.graphics.setColor(0, 1, 0)
            love.graphics.rectangle("fill", self.three.x, self.three.y, self.button.w, self.button.h)
            love.graphics.setColor(0, 0, 0)
            love.graphics.print("Exit", self.three.x + 30, self.three.y + 15)

            -- version
            love.graphics.setColor(0, 0, 1)
            love.graphics.print("Version - 1.0.1", love.graphics.getWidth() - 100, 10)

            -- comment
            love.graphics.setColor(1, 1, 1)
            love.graphics.print("Made With <3 By Vaibhav R Nayak", 10, love.graphics.getHeight() - 20)

        end,

        pauseMenuDraw = function(self)
            -- resume
            love.graphics.setColor(0, 1, 0)
            love.graphics.rectangle("fill", self.one.x, self.one.y, self.button.w, self.button.h)
            love.graphics.setColor(0, 0, 0)
            love.graphics.print("Resume", self.one.x + 30, self.one.y + 15)

            -- restart
            love.graphics.setColor(0, 1, 0)
            love.graphics.rectangle("fill", self.two.x, self.two.y, self.button.w, self.button.h)
            love.graphics.setColor(0, 0, 0)
            love.graphics.print("Restart", self.two.x + 30, self.two.y + 15)

            -- mainMenu
            love.graphics.setColor(0, 1, 0)
            love.graphics.rectangle("fill", self.three.x, self.three.y, self.button.w, self.button.h)
            love.graphics.setColor(0, 0, 0)
            love.graphics.print("Main Menu", self.three.x + 20, self.three.y + 15)
        end,

        gameOverDraw = function(self, str)
            print(str)
            -- restart
            love.graphics.setColor(0, 1, 0)
            love.graphics.rectangle("fill", self.one.x, self.one.y, self.button.w, self.button.h)
            love.graphics.setColor(0, 0, 0)
            love.graphics.print("Restart", self.one.x + 30, self.one.y + 15)

            -- mainMenu
            love.graphics.setColor(0, 1, 0)
            love.graphics.rectangle("fill", self.two.x, self.two.y, self.button.w, self.button.h)
            love.graphics.setColor(0, 0, 0)
            love.graphics.print("Main Menu", self.two.x + 20, self.two.y + 15)

        end,

        oneVsoneF = function(self, x, y)
            if (x >= self.one.x) and (x <= self.one.x + self.button.w) and (y >= self.one.y) and
                (y <= self.one.y + self.button.h) then
                return {
                    running = true,
                    paused = false,
                    mainMenu = false,
                    gameOver = false
                }, "player"
            end
            return nil, nil
        end,

        oneVscpuF = function(self, x, y)
            if (x >= self.two.x) and (x <= self.two.x + self.button.w) and (y >= self.two.y) and
                (y <= self.two.y + self.button.h) then
                return {
                    running = true,
                    paused = false,
                    mainMenu = false,
                    gameOver = false
                }, "cpu"
            end
            return nil, nil
        end,

        exitF = function(self, x, y)
            if (x >= self.three.x) and (x <= self.three.x + self.button.w) and (y >= self.three.y) and
                (y <= self.three.y + self.button.h) then
                os.exit(0)
            end

        end,

        resumeF = function(self, x, y)
            if (x >= self.one.x) and (x <= self.one.x + self.button.w) and (y >= self.one.y) and
                (y <= self.one.y + self.button.h) then
                return {
                    running = true,
                    paused = false,
                    mainMenu = false,
                    gameOver = false
                }
            end
            return nil

        end,

        restartF = function(self, x, y, control, pos)
            if (x >= self[pos].x) and (x <= self[pos].x + self.button.w) and (y >= self[pos].y) and
                (y <= self[pos].y + self.button.h) then
                return {
                    running = true,
                    paused = false,
                    mainMenu = false,
                    gameOver = false
                }, control

            end
            return nil, nil
        end,

        mainMenuF = function(self, x, y, pos)
            if (x >= self[pos].x) and (x <= self[pos].x + self.button.w) and (y >= self[pos].y) and
                (y <= self[pos].y + self.button.h) then
                return {
                    running = false,
                    paused = false,
                    mainMenu = true,
                    gameOver = false
                }
            end
            return nil
        end

    }

end

return state
