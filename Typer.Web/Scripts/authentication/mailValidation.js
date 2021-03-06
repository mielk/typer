﻿var validator;

$(document).ready(function () {
    adjustPlaceholder();
    setFocusForMailControl();
    validator = mailValidator();
});


function adjustPlaceholder() {
    $("#account label").css({ 'display': 'block' });
}

function setFocusForMailControl() {
    // ReSharper disable once Html.IdNotResolved
    $('#Email').focus();
}



var mailValidator = function () {

    //For further references.
    var me = this;

    //Control state.
    var isValid = false;
    

    //Confirmation button.
    var btn = $("#btnSend")[0];

    //Container.
    var container = $('#div_mail')[0];
    this.getControl = function(selector) {
        return $(container).find('.' + selector)[0];
    };
    this.isPassword = function () {
        var pswdResetCssClass = "passwordReset";
        return $(container).hasClass(pswdResetCssClass);
    }();

    //E-mail text button.
    // ReSharper disable once Html.IdNotResolved
    var value = $('#Email')[0];

    //Error controls.
    var errorContainer = this.getControl('error');
    var errorContent = this.getControl('error_content');


    this.formatAsValid = function() {
        $(value).
            removeClass('invalid').
            addClass('valid');
        $(errorContainer).css({
            'visibility': 'hidden'
        });
    };

    this.formatAsInvalid = function() {
        $(value).
            removeClass('valid').
            addClass('invalid');
        $(errorContainer).css({
            'visibility': 'visible'
        });
    };


    this._validate = function() {
        var validation = checkMail($(value).val(), this.isPassword);
        if (validation === true) {
            this.formatAsValid();
            isValid = true;
        } else {
            //Add error message.
            this.formatAsInvalid();
            $(errorContent).text(validation);
            isValid = false;
        }

        checkState();

    };


    //Bind change event to value control.
    var timer;
    var valueControl = $(value);
    valueControl.bind({
        'keyup': function () {
            if (timer) {
                clearTimeout(timer);
            }
            timer = setTimeout(function () {
                me._validate();
            }, 150);
        },
        'change': function () {
            me._validate();
        },
        'mouseup': function (e) {
            e.preventDefault();
        }
    });
    valueControl.on({
        'focus': function () {
            this.select();
        }
    });


    function checkState() {
        if (isValid) {
            $(btn).removeAttr('disabled');
        } else {
            $(btn).attr('disabled', 'disabled');
        }
    }


    //Initial validation.
    this._validate();


};



/*
 * Weryfikacja maila.
 */
var mailExists = false;
var mailVerified = false;

function checkMail(mail, isPasswordReset) {

    if (!mail) {
        return window.MessageBundle.get(dict.MailCannotBeEmpty);
    } else if (!my.text.isValidMail(mail)) {
        return window.MessageBundle.get(dict.IllegalMailFormat);
    } else {
        mailAlreadyExists(mail);
        if (mailExists === true) {
            return (isPasswordReset || mailVerified !== true ? true : window.MessageBundle.get(dict.MailAlreadyActivated));
        } else {
            return window.MessageBundle.get(dict.MailDoesntExists);
        }
    }
    
}

function mailAlreadyExists(mail) {
    $.ajax({
        url: "CheckMail",
        type: "post",
        data: JSON.stringify({ mail: mail }),
        contentType: "application/json; charset=utf-8",
        datatype: "json",
        async: false,
        success: function (result) {
            mailExists = (result.IsExisting === true);
            mailVerified = (result.IsVerified === true);
        },
        error: function (msg) {
            alert("[register.js::mailAlreadyExists] " + msg.status + " | " + msg.statusText);
        }
    });

}