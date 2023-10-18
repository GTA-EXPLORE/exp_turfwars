var executes = {}
window.addEventListener('message', function (event) {
    try {
        executes[event.data.action](event.data)
    } catch (error) {
        console.log(event.data.action);
        console.log(error);
    }
})

executes["SHOW"] = function(data) {
    $("#overlay").css("background-color", data.color).css("box-shadow", `0 0 50px 10px ${data.color}`).css("opacity","0.15")
}

executes["HIDE"] = function(data) {
    $("#overlay").css("opacity","0.0")
}