$(document).ready(function () {
    // function showCode() {
    //     var sourceCodeLink = $(this).data("link");
    //     window.open(sourceCodeLink);
    // }

    $(".feature_matrix").on("click", "td", function () {
        $(this).find("aside").slideToggle();
    });

    // $('.feature_matrix').on("click", ".passed", showCode);
    // $('.feature_matrix').on("click", ".failed", showCode);
    // $('.feature_matrix').on("click", ".pending", createCode);
});