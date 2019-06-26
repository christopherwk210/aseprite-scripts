---------------------------
-- Made by Tomie with <3 --
---------------------------

app.transaction(
    function()
        local middleColorRed   = (app.fgColor.red + app.bgColor.red) / 2
        local middleColorGreen = (app.fgColor.green + app.bgColor.green) / 2
        local middleColorBlue  = (app.fgColor.blue + app.bgColor.blue) / 2
        local middleColorAlpha = (app.fgColor.alpha + app.bgColor.alpha) / 2
        local middleColor = Color {
            r=middleColorRed, 
            g=middleColorGreen, 
            b=middleColorBlue, 
            a=middleColorAlpha
        }

        app.fgColor = middleColor
    end
)

app.refresh()
