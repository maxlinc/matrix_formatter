//= require jquery
//= require jquery.stickytableheaders.min
//= require bootstrap
//= require_tree .
// bootstrap-theme?
String.prototype.toCamel = function(){
    return this.replace(/([\-\_][a-z])/g, function($1){return $1.toUpperCase().replace(/[-_]/,'');});
};

String.prototype.capitalize = function() {
    return this.charAt(0).toUpperCase() + this.slice(1)
}

function buildCollapseablePanel(title, href, content) {
    $panel = $("<div class='panel panel-default'>");
    // var href = encodeURIComponent("collapse" + title);
    $panel.wrapInner("<div class='panel-heading'><h4 class='panel-title'></h4></div><div id='" + href + "'' class='panel-collapse collapse'>")
    $panel.find(".panel-heading").wrapInner("<a data-toggle='collapse' data-parent='#accordion' href='#" + href + "'>"+title+"</a>");
    $panel.find("#" + href).wrapInner("<div class='panel-body'>" + content + "</div>");
    return $panel;
};
function updateSideNav(link) {
    $("#accordion").html("");
    var feature_group_name = link.data('feature-group');
    var feature_name = link.data('feature');
    var feature_group = $(".feature_group[data-feature-group='" + feature_group_name + "']");
    var feature = $(".feature[data-feature='" + feature_name + "']");
    feature_group.find("aside").each(function(index) {
        var panel = buildCollapseablePanel($(this).data('label') + ": " + feature_group_name, "fg_aside_" + index, $(this).html());
        $("#accordion").append(panel);
    });
    feature.find("aside").each(function(index) {
        var panel = buildCollapseablePanel($(this).data('label') + ": " + feature_name, "feature_aside_" + index, $(this).html());
        $("#accordion").append(panel);
    });
};

function createModal(btn) {
    var section = $(btn).closest("td").find("span.section_label").text();
    var aside = btn.closest("td").find("aside[data-label='" + btn.text() + "']");
    var label = aside.data("label");
    var title = label + ": " + section;
    console.log("With title " + title);
    modal = $("#modalPlaceHolder");
    modal.find(".modal-title").text(title);
    console.log("And body " + aside.inner_html);
    modal.find(".modal-body").html(aside.html());
    modal.modal();
}

$(document).ready(function () {
    $('.feature_matrix').on("click", ".modal-button", function () {
        console.log("Creating a modal");
        createModal($(this));
    });

    $('.feature_matrix').stickyTableHeaders();

    // Links in notes should open in new tabs.
    $('aside').find('a').attr("target","_blank");

    $('button#test_changes').popover();
});
