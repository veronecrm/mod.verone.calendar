<?php
    $app->assetter()
        ->load('datetimepicker')
        ->load('mcustomscrollbar')
        ->load([
            'files' => [
                'css' => [ '{ROOT}/modules/Calendar/fullcalendar/fullcalendar.css' ],
                'js'  => [
                    '{ROOT}/modules/Calendar/fullcalendar/fullcalendar.js',
                    '{ROOT}/modules/Calendar/fullcalendar/lang/'.$app->request()->getLocale().'.js'
                ]
            ]
        ]);
?>
<div class="mod-calendar-container">
    <div class="mod-calendar-left">
        <div class="page-header">
            <h1>{{ t('calendarClosestEvents') }}</h1>
        </div>
        <div class="calendar-events-list"></div>
    </div>
    <div class="mod-calendar-right">
        <div class="container-fluid">
            <div class="row">
                <div class="col-md-12">
                    <div class="page-header">
                        <h1 class="calendar-filters">Filtr: <small><i>
                            <label><input type="checkbox" name="filter[]" value="" disabled="disabled" checked="checked" /> {{ t('calendarMyEvents') }}</label>
                            @foreach $eventsGroups
                                <label><input type="checkbox" name="filter[]" value="{{ $item['id'] }}" <?php echo (in_array($item['id'], $filters) ? ' checked="checked"' : ''); ?> /> {{ $item['name'] }}</label>
                            @endforeach
                        </i></small></h1>
                    </div>
                    <div id="calendar"></div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="calendar-event-add" tabindex="-1" role="dialog" aria-labelledby="calendar-event-add-modal-label" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="<?php echo $app->t('close'); ?>"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="calendar-event-add-modal-label">{{ t('calendarAddEvent') }}</h4>
            </div>
            <div class="modal-body">
                <div class="form-group">
                    <label for="event-add-name" class="control-label">{{ t('calendarEventName') }}</label>
                    <input class="form-control required" type="text" id="event-add-name" name="event-add-name" tabindex="1" />
                </div>
                <div class="container-fluid container-modal">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="event-add-start" class="control-label">{{ t('calendarEventStart') }}</label>
                                <div class="input-group date" id="event-add-start-wrap">
                                    <input class="form-control required" type="text" id="event-add-start" name="event-add-start" />
                                    <span class="input-group-addon">
                                        <span class="fa fa-calendar"></span>
                                    </span>
                                </div>
                            </div>
                            <!-- <div class="form-group">
                                <label for="event-add-allday" class="control-label">{{ t('calendarAlldayEvent') }}</label>
                                <select name="event-add-allday" id="event-add-allday" class="form-control">
                                    <option value="0">{{ t('sno') }}</option>
                                    <option value="1">{{ t('syes') }}</option>
                                </select>
                            </div> -->
                            <div class="form-group">
                                <label for="event-add-type" class="control-label">{{ t('calendarEventType') }}</label>
                                <select name="event-add-type" id="event-add-type" class="form-control">
                                    <option value="1">{{ t('calendarMeeting') }}</option>
                                    <option value="2">{{ t('calendarToDo') }}</option>
                                    <option value="0">{{ t('calendarOther') }}</option>
                                </select>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group" id="event-add-end-group">
                                <label for="event-add-end" class="control-label">{{ t('calendarEventEnd') }}</label>
                                <div class="input-group date" id="event-add-end-wrap">
                                    <input class="form-control required" type="text" id="event-add-end" name="event-add-end" />
                                    <span class="input-group-addon">
                                        <span class="fa fa-calendar"></span>
                                    </span>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="event-add-repeat" class="control-label">{{ t('calendarRepeated') }}</label>
                                <select name="event-add-repeat" id="event-add-repeat" class="form-control">
                                    <option value="0"><?php echo $app->t('sno'); ?></option>
                                    <option value="1"><?php echo $app->t('syes'); ?></option>
                                </select>
                            </div>
                            <div class="form-group hidden" id="event-add-repeat-type-group">
                                <label for="event-add-repeat-type" class="control-label">{{ t('calendarRepeatType') }}</label>
                                <select name="event-add-repeat-type" id="event-add-repeat-type" class="form-control">
                                    <option value="1">{{ t('calendarRepeatType1') }}</option>
                                    <option value="2">{{ t('calendarRepeatType2') }}</option>
                                    <option value="3">{{ t('calendarRepeatType3') }}</option>
                                    <option value="4">{{ t('calendarRepeatType4') }}</option>
                                    <option value="5">{{ t('calendarRepeatType5') }}</option>
                                    <option value="6">{{ t('calendarRepeatType6') }}</option>
                                    <option value="7">{{ t('calendarRepeatType7') }}</option>
                                    <option value="8">{{ t('calendarRepeatType8') }}</option>
                                </select>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <label for="event-add-description" class="control-label">{{ t('calendarEventDescription') }}</label>
                    <textarea class="form-control" id="event-add-description" name="event-add-description"></textarea>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">{{ t('close') }}</button>
                <a href="#" class="btn btn-primary">{{ t('save') }}</a>
            </div>
        </div>
    </div>
</div>


<div class="modal fade" id="calendar-event-edit" tabindex="-1" role="dialog" aria-labelledby="calendar-event-edit-modal-label" aria-hidden="true">
    <input type="hidden" id="event-edit-id" name="event-edit-id" />
    <input type="hidden" id="event-edit-group" name="event-edit-group" />
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="<?php echo $app->t('close'); ?>"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="calendar-event-edit-modal-label">Edytuj wydarzenie</h4>
            </div>
            <div class="modal-body">
                <div class="form-group">
                    <label for="event-edit-name" class="control-label">{{ t('calendarEventName') }}</label>
                    <input class="form-control required" type="text" id="event-edit-name" name="event-edit-name" tabindex="1" />
                </div>
                <div class="container-fluid container-modal">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="event-edit-start" class="control-label">{{ t('calendarEventStart') }}</label>
                                <div class="input-group date" id="event-edit-start-wrap">
                                    <input class="form-control required" type="text" id="event-edit-start" name="event-edit-start" tabindex="2" />
                                    <span class="input-group-addon">
                                        <span class="fa fa-calendar"></span>
                                    </span>
                                </div>
                            </div>
                            <!-- <div class="form-group">
                                <label for="event-edit-allday" class="control-label">{{ t('calendarAlldayEvent') }}</label>
                                <select name="event-edit-allday" id="event-edit-allday" class="form-control" tabindex="5">
                                    <option value="0">{{ t('sno') }}</option>
                                    <option value="1">{{ t('syes') }}</option>
                                </select>
                            </div> -->
                            <div class="form-group">
                                <label for="event-edit-type" class="control-label">{{ t('calendarEventType') }}</label>
                                <select name="event-edit-type" id="event-edit-type" class="form-control" tabindex="4">
                                    <option value="1">{{ t('calendarMeeting') }}</option>
                                    <option value="2">{{ t('calendarToDo') }}</option>
                                    <option value="0">{{ t('calendarOther') }}</option>
                                </select>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group" id="event-edit-end-group">
                                <label for="event-edit-end" class="control-label">{{ t('calendarEventEnd') }}</label>
                                <div class="input-group date" id="event-edit-end-wrap">
                                    <input class="form-control required" type="text" id="event-edit-end" name="event-edit-end" tabindex="3" />
                                    <span class="input-group-addon">
                                        <span class="fa fa-calendar"></span>
                                    </span>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="event-edit-repeat" class="control-label">{{ t('calendarRepeated') }}</label>
                                <select name="event-edit-repeat" id="event-edit-repeat" class="form-control">
                                    <option value="0"><?php echo $app->t('sno'); ?></option>
                                    <option value="1"><?php echo $app->t('syes'); ?></option>
                                </select>
                            </div>
                            <div class="form-group hidden" id="event-edit-repeat-type-group">
                                <label for="event-edit-repeat-type" class="control-label">{{ t('calendarRepeatType') }}</label>
                                <select name="event-edit-repeat-type" id="event-edit-repeat-type" class="form-control">
                                    <option value="1">{{ t('calendarRepeatType1') }}</option>
                                    <option value="2">{{ t('calendarRepeatType2') }}</option>
                                    <option value="3">{{ t('calendarRepeatType3') }}</option>
                                    <option value="4">{{ t('calendarRepeatType4') }}</option>
                                    <option value="5">{{ t('calendarRepeatType5') }}</option>
                                    <option value="6">{{ t('calendarRepeatType6') }}</option>
                                    <option value="7">{{ t('calendarRepeatType7') }}</option>
                                    <option value="8">{{ t('calendarRepeatType8') }}</option>
                                </select>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <label for="event-edit-description" class="control-label">Opis wydarzenia</label>
                    <textarea class="form-control" id="event-edit-description" name="event-edit-description"></textarea>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">{{ t('close') }}</button>
                <a href="#" class="btn btn-primary">{{ t('save') }}</a>
            </div>
        </div>
    </div>
</div>

<script>
    var selectedEvent = null;
    var convertToMiliseconds = function(date) {
        var datetime = events[i].start.split('T');
        var y = 0, m = 0, d = 0, h = 0, mi = 0, s = 0, ms = 0;

        if(datetime[0])
        {
            var dateSplit = datetime.split('-');

            y = dateSplit[0] || 0;
            m = dateSplit[1] || 0;
            d = dateSplit[2] || 0;
        }

        if(datetime[1])
        {
            var timeSplit = datetime.split(':');

            h = timeSplit[0] || 0;
            mi = timeSplit[1] || 0;
            s = timeSplit[2] || 0;
            ms = timeSplit[3] || 0;
        }

        return (new Date(y, m, d, h, mi, s, ms)).getMilliseconds();
    };

    var isTodayDate = function(microtime) {
        var todayDate = new Date();
        var checkDate = new Date(microtime);

        return todayDate.getFullYear() == checkDate.getFullYear() && todayDate.getDate() == checkDate.getDate() && todayDate.getMonth() == checkDate.getMonth();
    };

    var updateNearlyEvents = function() {
        APP.AJAX.call({
            url : APP.createUrl('Calendar', 'Calendar', 'nearlyEvents'),
            data : {
                filters : filters
            },
            parseResult : false,
            success : function(data) {
                $('.mod-calendar-container .calendar-events-list').html(data);
            }
        });
    };

    var eventRemoveMousemove = function(e) {
        // It don't need to be fast, events will be removed rare.
        var placeholder = $('.event-remove-placeholder');

        if(placeholder.length == 0)
        {
            return;
        }

        var coords = {
            x1: placeholder.offset().left,
            x2: placeholder.offset().left + placeholder.width(),
            y1: placeholder.offset().top,
            y2: placeholder.offset().top + placeholder.height()
        };

        if(e.pageX >= coords.x1 && e.pageX <= coords.x2 && e.pageY >= coords.y1 && e.pageY <= coords.y2)
        {
            placeholder.data('placed', 1).find('i').css('opacity', 1);
        }
        else
        {
            placeholder.data('placed', 0).find('i').css('opacity', 0.3);
        }
    };

    var eventRemoveMouseup = function(e) {
        if($('.event-remove-placeholder').data('placed') == 1)
        {
            $('#calendar').fullCalendar('removeEvents', selectedEvent.id);
            $('#calendar .fc-view-container .fc-view > .fc-event.fc-draggable').remove();
            $('.event-remove-placeholder').remove();
            removeEvent(selectedEvent.id);
        }
    };

    var removeEvent = function(id) {
        $('.calendar-events-list #event-' + id).remove();

        APP.AJAX.call({
            url  : APP.createUrl('Calendar', 'Calendar', 'delete'),
            data : {
                id: id
            }
        });
    };

    var editEvent = function(id, group) {
        var event = findEventInCurrentEvents(id, group);

        if(! event)
        {
            return;
        }

        if(event.onClickRedirect)
        {
            document.location.href = event.onClickRedirect;
            return;
        }

        if(event.editable == true)
        {
            APP.AJAX.call({
                url  : APP.createUrl('Calendar', 'Calendar', 'get'),
                data : {
                    id: id
                },
                success : function(data) {
                    $('#calendar-event-edit').modal();

                    $('#calendar-event-edit #event-edit-id').val(data.id);
                    $('#calendar-event-edit #event-edit-group').val(data.group);
                    $('#calendar-event-edit #event-edit-name').val(data.name);
                    $('#calendar-event-edit #event-edit-description').val(data.description);
                    $('#calendar-event-edit #event-edit-start').val(data.start).trigger('change');
                    $('#calendar-event-edit #event-edit-end').val(data.end).trigger('change');
                    //$('#calendar-event-edit #event-edit-allday').val(data.allday).trigger('change');
                    $('#calendar-event-edit #event-edit-repeat').val(data.repeat).trigger('change');
                    $('#calendar-event-edit #event-edit-repeat-type').val(data.repeatType).trigger('change');
                    $('#calendar-event-edit #event-edit-type').val(data.type).trigger('change');
                }
            });
        }
    };

    var findEventInCurrentEvents = function(id, group) {
        for(var i in currentEvents)
        {
            if(currentEvents[i].group == group && currentEvents[i].id == id)
            {
                return currentEvents[i];
            }
        }

        return null;
    };

    var createEventId = function(event) {
        return 'fc-event-' + (event.group + '-' + event.id).replace(/\./ig, '-');
    }

    var refetchEvents = function() {
        $('#calendar').fullCalendar('refetchEvents');;
    };

    var filters        = '<?php echo implode(',', $filters); ?>';
    var currentEvents  = [];
    var popoverPattern = '<div class="popover top popover-event"><div class="arrow"></div><h3 class="popover-title"></h3><div class="popover-content"><p></p></div></div>';

    $(document).ready(function() {
        $('.mod-calendar-left').mCustomScrollbar({
            theme: 'minimal-dark',
            scrollEasing: 'linear',
            scrollInertia: 0,
            mouseWheel: {
                scrollAmount: 150
            }
        });

        $('#calendar').fullCalendar({
            lang: 'pl',
            header: {
                left: 'prev,next today',
                center: 'title',
                right: 'month,agendaWeek,agendaDay'
            },
            height: 600,
            defaultDate: '<?php echo date('Y-m-d'); ?>',
            buttonIcons: false,
            editable: true,
            eventLimit: 4,
            nextDayThreshold: '00:00:00',
            events: function(start, end, timezone, callback) {
                APP.AJAX.call({
                    url  : APP.createUrl('Calendar', 'Calendar', 'listEvents'),
                    data : {
                        from    : start.unix(),
                        to      : end.unix(),
                        filters : filters
                    },
                    success : function(data) {
                        currentEvents = data;
                        callback(data);
                    }
                });

                updateNearlyEvents();
            },
            eventClick: function(calEvent, jsEvent, view) {
                editEvent(calEvent.id, calEvent.group);
            },
            dayClick: function(date, jsEvent, view) {
                var ex1 = date.format().split('T');
                var res = '';

                // If we have time with day
                if(ex1.length == 2)
                {
                    var ex2 = ex1[1].split(':');

                    res = ex1[0] + ' ' + ex2[0] + ':' + ex2[1];
                }
                // Else we have only day
                else
                {
                    res = ex1[0] + ' 06:00';
                }

                $('#calendar-event-add').modal();
                $('#calendar-event-add #event-add-start').val(res);

                $('#event-add-start').data('DateTimePicker').date(res);
                $('#event-add-end').data('DateTimePicker').date(res);
                $('#calendar-event-add #event-add-name').focus();
            },
            eventDragStart: function(event, jsEvent, ui, view) {
                selectedEvent = event;

                $('#calendar .fc-view-container .fc-view').append('<div class="event-remove-placeholder"><i class="fa fa-trash"></i></div>');

                $('body')
                    .bind('mousemove', eventRemoveMousemove)
                    .bind('mouseup', eventRemoveMouseup);
            },
            eventDragStop: function(event, jsEvent, ui, view) {
                selectedEvent = null;

                $('#calendar .fc-view-container .fc-view .event-remove-placeholder').remove();

                $('body')
                    .unbind('mousemove', eventRemoveMousemove)
                    .unbind('mouseup', eventRemoveMouseup);
            },
            eventDrop: function(event, delta, revertFunc) {
                var data = {};

                data.id     = event.id;
                data.start  = event.start.format('YYYY-MM-DD HH:mm');

                if(event.end)
                {
                    data.end = event.end.format('YYYY-MM-DD HH:mm');
                }
                else
                {
                    data.end = event.start.format('YYYY-MM-DD HH:mm');
                }

                APP.AJAX.call({
                    url  : APP.createUrl('Calendar', 'Calendar', 'update'),
                    data : data,
                    success: function() {
                        refetchEvents();
                    },
                    error: function() {
                        refetchEvents();
                    }
                });
            },
            eventMouseover: function(event, jsEvent, view) {
                if(event.description)
                {
                    var po = $(popoverPattern);
                    po.find('.popover-title').text(event.title);
                    po.find('.popover-content p').html(event.description);

                    po.appendTo('body');

                    var elm = $('#' + createEventId(event));

                    var targetOffset = elm.offset();

                    po.css({
                        left: (elm.outerWidth() / 2) + targetOffset.left - (po.outerWidth() / 2),
                        top : targetOffset.top - po.outerHeight() - 10
                    }).show();

                    event.popover = po;
                }
            },
            eventMouseout: function(event, jsEvent, view) {
                if(event.hasOwnProperty('popover') && event.popover)
                {
                    event.popover.remove();
                    event.popover = null;
                }
            },
            eventRender: function(event, element) {
                element.attr('id', createEventId(event));
            },
            eventResize: function(event, delta, revertFunc) {
                var ex1 = event.end.format().split('T');
                var res = '';

                // If we have time with day
                if(ex1.length == 2)
                {
                    var ex2 = ex1[1].split(':');

                    res = ex1[0] + ' ' + ex2[0] + ':' + ex2[1];
                }
                // Else we have only day
                else
                {
                    res = ex1[0] + ' 06:00';
                }

                APP.AJAX.call({
                url  : APP.createUrl('Calendar', 'Calendar', 'update'),
                data : {
                    id    : event.id,
                    group : event.group,
                    end   : res
                },
                error: function() {
                    revertFunc();
                }
            });
            }
        });

        /**
         * Bind Datepicker and some enhancements.
         */
        $('#event-add-start, #event-add-end, #event-edit-start, #event-edit-end')
            .datetimepicker({format:'YYYY-MM-DD HH:mm', defaultDate:'<?php echo date('Y-m-d'); ?> 06:00'})
            .parent()
            .find('.input-group-addon')
            .click(function() {
                $(this).parent().find('input').trigger('focus');
            });

        /**
         * If event is all day, we turn off end date picker.
         */
        /*$('#event-add-allday').change(function() {
            if($(this).val() == 1)
                $('#event-add-end-group').addClass('hidden');
            else
                $('#event-add-end-group').removeClass('hidden');
        });
        $('#event-edit-allday').change(function() {
            if($(this).val() == 1)
                $('#event-edit-end-group').addClass('hidden');
            else
                $('#event-edit-end-group').removeClass('hidden');
        });*/

        /**
         * If event is repeaded, we show repeat types
         */
        $('#event-add-repeat').change(function() {
            if($(this).val() == 1)
                $('#event-add-repeat-type-group').removeClass('hidden');
            else
                $('#event-add-repeat-type-group').addClass('hidden');
        });
        $('#event-edit-repeat').change(function() {
            if($(this).val() == 1)
                $('#event-edit-repeat-type-group').removeClass('hidden');
            else
                $('#event-edit-repeat-type-group').addClass('hidden');
        });

        /**
         * Add new event.
         */
        $('#calendar-event-add .btn-primary').click(function(e) {
            APP.AJAX.call({
                url  : APP.createUrl('Calendar', 'Calendar', 'save'),
                data : {
                    name      : $('#event-add-name').val(),
                    start     : $('#event-add-start').val(),
                    end       : $('#event-add-end').val(),
                    description : $('#event-add-description').val(),
                    //allday    : $('#event-add-allday').val(),
                    repeat    : $('#event-add-repeat').val(),
                    repeatType: $('#event-add-repeat-type').val(),
                    type      : $('#event-add-type').val(),
                },
                success : function(event) {
                    refetchEvents();
                    $('#calendar-event-add').modal('hide');

                    // Reset form data
                    $('#calendar-event-add input, #calendar-event-add textarea').val('');
                    $('#calendar-event-add #event-add-type').val(1);
                    //$('#calendar-event-add #event-add-allday').val(0).trigger('change');
                    $('#calendar-event-add #event-add-repeat').val(0).trigger('change');
                }
            });

            e.preventDefault();
        });

        /**
         * Update event.
         */
        $('#calendar-event-edit .btn-primary').click(function(e) {
            APP.AJAX.call({
                url  : APP.createUrl('Calendar', 'Calendar', 'update'),
                data : {
                    id        : $('#event-edit-id').val(),
                    group     : $('#event-edit-group').val(),
                    name      : $('#event-edit-name').val(),
                    start     : $('#event-edit-start').val(),
                    end       : $('#event-edit-end').val(),
                    description : $('#event-edit-description').val(),
                    //allday    : $('#event-edit-allday').val(),
                    repeat    : $('#event-edit-repeat').val(),
                    repeatType: $('#event-edit-repeat-type').val(),
                    type      : $('#event-edit-type').val(),
                },
                success : function(event) {
                    $('#calendar-event-edit').modal('hide');

                    // Reset form data
                    $('#calendar-event-edit input, #calendar-event-edit textarea').val('');
                    $('#calendar-event-edit #event-edit-type').val(1);
                    //$('#calendar-event-edit #event-edit-allday').val(0).trigger('change');
                    $('#calendar-event-edit #event-edit-repeat').val(0).trigger('change');
                    refetchEvents();
                }
            });

            e.preventDefault();
        });
        
        $('.mod-calendar-container .calendar-events-list > div .btn-edit').click(function() {
            editEvent($(this).parent().parent().parent().attr('id').split('-')[1]);
        });

        $('.calendar-filters input').change(function() {
            filters = [];

            $('.calendar-filters input').each(function() {
                if($(this).prop('checked'))
                {
                    filters.push($(this).val());
                }
            });

            filters = filters.join(',');

            refetchEvents();

            APP.AJAX.call({
                url: APP.createUrl('Calendar', 'Calendar', 'updateFilters'),
                data: {
                    filters: filters
                }
            });
        });
    });
</script>

@section('body.bottom')
<style>
    .calendar-filters label {display:inline-block;}
    .calendar-filters label:before {content:" ";display:inline-block;width:5px;}

    .popover-event {position:fixed;display:block;}

    #page-wrapper {background-color:#fff;overflow:visible;}
    .mod-calendar-container {position:relative;width:100%;}
    .mod-calendar-container .mod-calendar-left {position:fixed;top:50px;z-index:1;bottom:50px;width:400px;}
    .mod-calendar-container .mod-calendar-left h1 {padding-left:10px;}
    .mod-calendar-container .mod-calendar-right {padding-left:400px;}

    .event-remove-placeholder {width:300px;height:140px;display:block;position:fixed;z-index:1;left:50%;top:50px;margin-left:-150px;background-color:#fff;border:1px solid #ddd;text-align:center;line-height:140px;-webkit-box-shadow:0px 0px 3px 0px rgba(0, 0, 0, 0.18);-moz-box-shadow:0px 0px 3px 0px rgba(0, 0, 0, 0.18);box-shadow:0px 0px 3px 0px rgba(0, 0, 0, 0.18);}
    .event-remove-placeholder i {font-size:130px;opacity:0.5;color:#888;text-align:center;line-height:140px;width:100%;height:140px;}

    .mod-calendar-container .calendar-events-list > div .btn-edit {display:none;float:right;}
    .mod-calendar-container .calendar-events-list > div .btn-edit:hover {cursor:pointer;}
    .mod-calendar-container .calendar-events-list > div:hover .btn-edit {display:block;}

    .fc-event {background-color:#0088CC;font-size:11px;}
    .fc-day-grid-event {padding:3px 5px;}
    .fc-unthemed th,
    .fc-unthemed td,
    .fc-unthemed thead,
    .fc-unthemed tbody,
    .fc-unthemed .fc-divider,
    .fc-unthemed .fc-row,
    .fc-unthemed .fc-popover {border-color:#F1F1F1}

    .fc-basic-view td.fc-day-number {border-bottom:1px solid #fafafa !important;}
    .fc-row.fc-widget-header {border-bottom:1px solid #bbb !important;}

    .fc-slats tr td.fc-widget-content {border-top:1px solid #fafafa !important;}
    .fc-slats tr.fc-minor td.fc-widget-content {border:none !important;}
    .fc-view-container {border:1px solid #ccc !important;}
    .fc button {background:#fff;}
    .fc td,
    .fc th {border-width:0px !important;}
    #calendar h2 {font-size:20px;text-transform:uppercase;line-height:35px;}
    #calendar .fc-day {border:1px solid #bbb !important;}
    #calendar th.fc-day-header {text-transform:uppercase;font-weight:400;font-size:14px;color:#000;padding:3px 0;}
    #external-events {padding-top:50px;}
    #external-events .fc-event {color:#fff;text-decoration:none;padding:5px;margin-bottom:10px;cursor:all-scroll;border:none;}

    @media only screen and (max-width:992px) {
        .mod-calendar-container .mod-calendar-left {position:static;width:100%;display:none;}
        .mod-calendar-container .mod-calendar-right {padding-left:0;}
    }

    @media only screen and (max-width:767px) {

    }
</style>
@endsection
