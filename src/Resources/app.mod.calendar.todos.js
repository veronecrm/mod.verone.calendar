/**
 * Verone CRM | http://www.veronecrm.com
 *
 * @copyright  Copyright (C) 2015 Adam Banaszkiewicz
 * @license    GNU General Public License version 3; see license.txt
 */

var APP_CalendarQuickView = new APP.factory.plugin('CalendarQuickView');
// Main function
APP_CalendarQuickView.domReady = function() {
    $('.mod-calendar-quickview-show').click(function() {
        $('.mod-calendar-quickview-show .fa').addClass('fa-spin');
        APP.CalendarQuickView.buildModal();
        return false;
    });

    /**
     * On Homepage we default shows modal with Planned-Today list.
     */
    if(APP.system.routing.isRoute('Home', 'Home', 'index'))
    {
        //$('.mod-calendar-quickview-show').trigger('click');
    }

    APP.CalendarQuickView.Todos.bindEvents();
};

APP_CalendarQuickView.buildModal = function() {
    $('#mod-calendar-quickview-modal').remove();

    $.ajax({
        type     : "GET",
        url      : APP.createUrl('Calendar', 'QuickView', 'modal'),
        success : function(msg) {
            $('body').append('<div class="modal fade" id="mod-calendar-quickview-modal" tabindex="-1" role="dialog" aria-labelledby="mod-calendar-quickview-modal-label" aria-hidden="true">' + msg + '</div>');
            APP.CalendarQuickView.showModal();
            APP.CalendarQuickView.Todos.bindEvents();
            $('.mod-calendar-quickview-show .fa').removeClass('fa-spin');
        },
        error:    function(error) {
            APP.FluidNotification.open(error, 'error');
            $('.mod-calendar-quickview-show .fa').removeClass('fa-spin');
        }
    });

    return false;
};

APP_CalendarQuickView.showModal = function() {
    $('#mod-calendar-quickview-modal').modal('show');
};

APP_CalendarQuickView.Todos = {};
APP_CalendarQuickView.Todos.events = {};
APP_CalendarQuickView.Todos.events.remove = function(id, elementToRemove) {
    // Remove item from HTML
    $('.todo-list .item[data-id=' + elementToRemove.attr('data-id') + ']').remove();

    // Remove item from Database
    $.ajax({
        type     : "GET",
        url      : APP.createUrl('Calendar', 'Todo', 'delete', { 'id' : id }),
        success : function(msg) {
            var result = jQuery.parseJSON(msg);

            APP.FluidNotification.open(result.message, result.status);
        },
        error:    function(error) {
            APP.FluidNotification.open(error, 'error');
        }
    });
};

APP_CalendarQuickView.Todos.events.toggleDone = function(id, elementToToggle) {
    var number      = parseInt($('.mod-calendar-quickview-show .badge').text());
    var element     = $('.todo-list .item[data-id=' + elementToToggle.attr('data-id') + ']');
    var input       = element.find('input');

    /**
     * We check input only for the changed element becouse the changed element is the main,
     * and relatively to this one, we change other elements on page.
     */
    if(elementToToggle.find('input')[0].checked)
    {
        number--

        element.addClass('done');
        for(var i in input)
        {
            input[i].checked = true;
        }
    }
    else
    {
        number++;

        element.removeClass('done');
        for(var i in input)
        {
            input[i].checked = false;
        }
    }

    $('.mod-calendar-quickview-show .badge').text(number).css('display', ( number <= 0 ? 'none' : 'block' ));
    $('#widget-calendar-todos .widget-head span').text(number);

    // Check note as Done.
    $.ajax({
        type     : "GET",
        url      : APP.createUrl('Calendar', 'Todo', 'doneToggle', { 'id' : id }),
        success : function(msg) {
            var result = jQuery.parseJSON(msg);

            APP.FluidNotification.open(result.message, result.status);
        },
        error:    function(error) {
            APP.FluidNotification.open(error, 'error');
        }
    });
};

APP_CalendarQuickView.Todos.bindEvents = function() {
    /**
     * Remove note from list.
     */
    $('.todo-list .item .fa-remove').not('.binded').addClass('binded').click(function() {
        APP.CalendarQuickView.Todos.events.remove($(this).closest('.item').data('id'), $(this).closest('.item'));
    });

    /**
     * Check note as Done.
     */
    $('.todo-list input').not('.binded').addClass('binded').change(function() {
        APP.CalendarQuickView.Todos.events.toggleDone($(this).closest('.item').data('id'), $(this).closest('.item'));
    });
};

// Registering plugin
APP.plugin.register(APP_CalendarQuickView);
