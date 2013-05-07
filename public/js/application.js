// Some general UI pack related JS

$(function () {
    $('ul.contributors').each(function() {
        var $this  = $(this),
            url    = $this.data('stream'),
            source = new EventSource(url)

        source.addEventListener('update', function (e) {
            var data = JSON.parse(e.data)
            $this.html('')
            $.each(data, function (index, contributor) {
                console.log(contributor)
                var $contributor = $('<li />')
                $contributor.html("<h1 class='pull-right'>" + contributor.contributions + " Contributions</h1>" +
                    "<img class='avatar' src='" + contributor.author.avatar_url + "' />" +
                    "<h3><a href='#'>@" + contributor.author.login + "</a></h3>")
                $this.append($contributor)
            });
        });

        source.addEventListener('complete', function (e) {
            source.close()
        });
    })
});

$(function () {
    // Custom selects
    $("select").dropkick();
});

$(document).ready(function() {
    // Todo list
    $(".todo li").click(function() {
        $(this).toggleClass("todo-done");
    });

    // Init tooltips
    $("[data-toggle=tooltip]").tooltip("show");

    // Init tags input
    $("#tagsinput").tagsInput();

    // Init jQuery UI slider
    $("#slider").slider({
        min: 1,
        max: 5,
        value: 2,
        orientation: "horizontal",
        range: "min",
    });

    // JS input/textarea placeholder
    $("input, textarea").placeholder();

    // Make pagination demo work
    $(".pagination a").click(function() {
        if (!$(this).parent().hasClass("previous") && !$(this).parent().hasClass("next")) {
            $(this).parent().siblings("li").removeClass("active");
            $(this).parent().addClass("active");
        }
    });

    $(".btn-group a").click(function() {
        $(this).siblings().removeClass("active");
        $(this).addClass("active");
    });

    // Disable link click not scroll top
    $("a[href='#']").click(function() {
        return false
    });

});

