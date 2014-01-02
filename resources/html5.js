$(document).ready(function () {
    function showCode() {
        var sourceCodeLink = $(this).data("source-code");
        window.open(sourceCodeLink);
    }

    function createCode() {
        var createCodeLink = $(this).data("source-code");
        // https://github.com/maxlinc/drg-katas/new/master/
        sdk = "jclouds";
        challenge_file = "blah.java";
        window.open("https://github.com/maxlinc/drg-katas/new/master/sdks/" + sdk + "/challenges?filename=" + challenge_file);
    }

    $(".feature_matrix").on("click", "td", function () {
        $(this).find("aside").slideToggle();
    });

    $('.feature_matrix').on("click", ".passed", showCode);
    $('.feature_matrix').on("click", ".failed", showCode);
    $('.feature_matrix').on("click", ".pending", createCode);
});