// ace?
function SDK(sdk, language, editor) {
    this.sdk = sdk;
    this.editor = editor;
    this.language = language;
    this.gitrev = "2c52446133348428bc000dc673b8367b06c10e3c";
    var thissdk = this;
    var suffixMap = {
        'ruby': '.rb',
        'go': '.go',
        'java': '.java',
        'php': '.php',
        'javascript': '.js',
        'python': '.py',
        'csharp': '.cs'
    }
    this.challengeFile = function (challenge) {
        if (this.language === "java" || this.language === "csharp") {
            challenge = challenge.capitalize().toCamel()
        }
        return challenge + suffixMap[this.language];
    }
    this.sourceLinkURL = function (challenge) {
        return "https://github.com/maxlinc/drg-tests/blob/master/sdks/" + this.sdk + "/challenges/" + this.challengeFile(challenge);
    };
    this.rawSourceURL = function (challenge) {
        // var clientId = "TBD"
        // var secret = "TBD"
        // var auth = "?client_id=" + clientId + "&client_secret=" + secret
        // return "https://api.github.com/repos/maxlinc/drg-tests/contents/sdks/" + this.sdk + "/challenges/" + this.challengeFile(challenge); // + auth;
        return "src/" + this.sdk + "/challenges/" + this.challengeFile(challenge);
    };
    this.annotatedDocumentationURL = function (challenge) {
        var challengeFile = this.challengeFile(challenge);
        var docFile = challengeFile.substr(0, challengeFile.lastIndexOf(".")) + ".html";
        return this.sdk + "/" + docFile;
    };
    this.loadSource = function (challenge) {
        console.log("Loading " + this.rawSourceURL(challenge));
        $.ajax({
            context: this,
            dataType: 'text',
            url: this.rawSourceURL(challenge),
            error: function (jqXHR, textStatus, errorThrown) {
                this.editor.setValue("# Not implemented yet");
            },
            success: function (data, status, jqXHR) {
                // source = atob(data.content.replace(/\s/g, ""));
                source = data;
                this.editor.setValue(source);
            },
            complete: function (jqXHR, textStatus) {
                this.editor.getSession().setMode("ace/mode/" + this.language);
                $("#annotated-nav").html("<a target=\"_blank\" href=\"" + this.annotatedDocumentationURL(challenge) + "\">Annotated</a>");
                $("#github-nav").html("<a target=\"_blank\" href=\"" + this.sourceLinkURL(challenge) + "\">View on GitHub</a>");
            }
        });
    };
}

function setEditorHeight() {
    var lastLine = $("#editor .ace_gutter-cell:last");
    var neededHeight = lastLine.position().top + lastLine.outerHeight();
    $("#editor-mask").height(neededHeight);
}

$(document).ready(function() {
    var editor = ace.edit("editor");
    editor.setTheme("ace/theme/github");
    editor.getSession().setMode("ace/mode/ruby");

    var sdks = {
        'fog': new SDK("fog", "ruby", editor),
        'gophercloud': new SDK("gophercloud", "go", editor),
        'jclouds': new SDK("jclouds", "java", editor),
        'php-opencloud': new SDK("php-opencloud", "php", editor),
        'pkgcloud': new SDK("pkgcloud", "javascript", editor),
        'pyrax': new SDK("pyrax", "python", editor),
        'openstack.net': new SDK("openstack.net", "csharp", editor)
    };

    for (var sdk in sdks) {
        if (sdks.hasOwnProperty(sdk)) {
            $li = $("<li id=\"" + sdk + "_tab\"><a data-toggle=\"tab\" data-sdk=\"" + sdk + "\" href=\"#\">" + sdk + "</a></li>");
            $("#sdk-nav").append($li);
        }
    }

    $(document).on("click", "a[data-sdk]", function (e) {
        var sdk = sdks[$(this).data("sdk")];
        var challenge = $(this).data("challenge");
        var feature_group = $(this).data("feature-group");
        var feature = $(this).data("feature");
        $("#code_modal .modal-title").text(feature);
        $("#sdk-nav li a").data("challenge", challenge);
        $("#sdk-nav li a").data("feature-group", feature_group);
        $("#sdk-nav li a").data("feature", feature);
        $("#sdk-nav li").removeClass("active");
        $("#" + sdk.sdk + "_tab").addClass("active");
        updateSideNav($(this));
        console.log("Loading " + sdk);
        console.log("Challenge " + challenge);
        sdk.loadSource(challenge);
    });
})
